use strict;
use warnings;
use Config;
use 5.008001;
use Config;
use HTTP::Tiny;
use Archive::Extract;
use File::Basename qw( dirname );
use File::Spec;
use File::Path qw( rmtree mkpath );
use JSON::PP qw( encode_json );

my $arch = $Config{ptrsize} == 8 ? 'x86_64' : 'i686';
my $root = ($ARGV[0]||'') eq '--blib' ? File::Spec->catdir(qw( blib lib auto share dist Alien-MSYS2 )) : File::Spec->rel2abs(dirname( __FILE__ ));

if($^O eq 'msys' && -f "/mingw32_shell.bat")
{
  write_config(
    install_type => 'system',
    msys2_root   => '/',
    probe        => 'msys2 native',
  );
  exit;
}

eval {

  # TRY to find MSYS2 using short cuts that are usually installed by the GUI installer
  # ways that searching for existing MSYS2 install can fail:
  # 1. ALIEN_FORCE or ALIEN_INSTALL_TYPE specify a share install (see Alien::Base documentation)
  # 2. No Win32 (ie not MSWin32 or cygwin)
  # 3. Win32::Shortcut is not installed
  # 4. MSYS2 is not already installed, or there are no short cuts for it in the CURRENT user

  die "force" if $ENV{ALIEN_FORCE} || ($ENV{ALIEN_INSTALL_TYPE}||'system') ne 'system';
  
  require Win32;
  require Win32::Shortcut;
  
  my $path = File::Spec->catdir( Win32::GetFolderPath( Win32::CSIDL_PROGRAMS() ), $Config{ptrsize} == 8 ? 'MSYS2 64bit' : 'MSYS2 32bit' );
  die "no $path" unless -d $path;

  $path = find($path);
  
  if($path)
  {
    write_config(
      install_type => 'system',
      msys2_root   => $path,
      probe        => 'shortcut',
    );
    exit;
  }
  
  sub find
  {
    my $path = shift;

    my $short = Win32::Shortcut->new;
    my $dh;
    opendir $dh, $path;
    foreach my $link_name (readdir $dh)
    {
      next if -d $link_name;
      my $link_path = File::Spec->catfile($path, $link_name);
      $short->Load($link_path) || next;
      my $bat = (split /\s+/, $short->{Arguments})[-1];
      next unless -f $bat;
      if($bat =~ /^(.*)[\\\/]mingw32_shell\.bat$/)
      {
        close $dh;
        return $1;
      }
    }

    closedir $dh;
  
    return;
  }
};

my $dest = File::Spec->catdir($root, $Config{ptrsize} == 8 ? 'msys64' : 'msys32');

my $filename = "msys2-$arch-latest.tar.xz";

unless(-r $filename)
{
  my $url = "http://repo.msys2.org/distrib/$filename";
  print "Download $url\n";
  my $http_response = HTTP::Tiny->new->get($url);

  die "@{[ $http_response->{status} ]} @{[ $http_response->{reason} ]} on $url"
    unless $http_response->{success};

  my $fh;
  open($fh, '>', "$filename.tmp") 
    || die "unable to open $filename.tmp $!";
  print($fh $http_response->{content}) 
    || die "unable to write to $filename.tmp $!";
  close($fh) 
    || die "unable to close $filename.tmp $!";
  rename("$filename.tmp" => $filename)
    || die "unable to rename $filename.tmp => $filename";
}

unless(-d $dest)
{
  my $ae = Archive::Extract->new( archive => $filename );
  print "Extract  $filename => $root\n";
  $ae->extract( to => $root ) || do{
    rmtree( $dest, 0, 0 );
    die "error extracting: @{[ $ae->error ]}";
  };
  write_config(
    install_type => 'share',
    probe        => 'share',
  );
}

sub write_config
{
  my %config = @_;
  $config{msys2_root} =~ s{\\}{/}g if defined $config{msys2_root};
  $config{ptrsize} = $Config{ptrsize};
  mkpath $root, 0, 0755;  
  my $filename = File::Spec->catfile($root, 'alien_msys2.json');
  open my $fh, '>', $filename;
  print $fh encode_json(\%config);
  close $fh;
}
