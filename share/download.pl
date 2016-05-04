use strict;
use warnings;
use Config;
use 5.008001;
use Config;
use HTTP::Tiny;
use Archive::Extract;
use File::Basename qw( dirname );
use File::Spec;
use File::Path qw( rmtree );

my $arch = $Config{ptrsize} == 8 ? 'x86_64' : 'i686';
my $root = ($ARGV[0]||'') eq '--blib' ? File::Spec->catdir(qw( blib lib auto share dist Alien-MSYS2 )) : File::Spec->rel2abs(dirname( __FILE__ ));
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
}
