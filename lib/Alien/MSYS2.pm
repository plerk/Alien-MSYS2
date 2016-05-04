package Alien::MSYS2;

use strict;
use warnings;
use 5.008001;
use Config;

# ABSTRACT: Tools required for autogen scripts in Windows (MSYS2)
# VERSION

=head1 CONSTRUCTOR

=head2 new

 my $alien = Alien::MSYS2->new;

You can create an instance of L<Alien::MSYS2>, which you can use to call
its methods.  All of the methods for this class can also be called as
class methods, so usually you do not need to do this.

=cut

sub new
{
  my($class) = @_;
  bless {}, $class;
}

=head1 METHODS

=head2 install_type

 my $type = Alien::MSYS2->install_type;

Returns the install type for MSYS.  This will be either the string "system"
or "share" indicating respectively either a system or a share install.

=cut

sub install_type
{
  # TODO: support for probing for system msys2
  "share";
}

=head2 msys2_root

 my $dir = Alien::MSYS2->msys2_root

Returns the root of the MSYS2 install.

=cut

sub msys2_root
{
  $_ = __FILE__;
  s{(MSYS2).pm}{.$1.devshare};
  my $share = -e $_
    ? do {
      require File::Basename;
      require File::Spec;
      # TODO: squeeze out the updirs
      File::Spec->rel2abs(File::Spec->catdir(File::Basename::dirname("lib/Alien/MSYS2.pm"), File::Spec->updir, File::Spec->updir, "share"));
    }
    : do {
      require File::ShareDir;
      File::ShareDir::dist_dir('Alien-MSYS2');
    };

  File::Spec->catdir($share, $Config{ptrsize} == 8 ? 'msys64' : 'msys32');
}

=head2 bin_dir

 my @dir = Alien::MSYS2->bin_dir;

Returns a list of directories that need to be added to the C<PATH> in order for
C<MSYS2> to operate.  Note that if C<MSYS2> is I<already> in the C<PATH>, this
will return an I<empty> list.

=cut

sub bin_dir
{
  my($class) = @_;
  $class->install_type eq 'system' ? () : do {
    require File::Spec;
    (File::Spec->catdir( $class->msys2_root, qw( usr bin ) ));
  };
}

=head2 cflags

provided for L<Alien::Base> compatibility.  Does not do anything useful.

=head2 dynamic_libs

provided for L<Alien::Base> compatibility.  Does not do anything useful.

=head2 libs

provided for L<Alien::Base> compatibility.  Does not do anything useful.

=cut

sub cflags { '' }
sub libs   { '' }
sub dynamic_libs { () }

1;
