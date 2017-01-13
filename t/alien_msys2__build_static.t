use strict;
use warnings;
use Test2::Bundle::Extended;
use Alien::MSYS2;
use Test::Alien;
use lib 't/lib';
use MyTest;
use File::Spec;
use Env qw( @PATH );

skip_all 'only tested on MSWin32' unless $^O eq 'MSWin32';

unshift @PATH, Alien::MSYS2->bin_dir;

my_extract_dontpanic(qw( t tmp static ));

my $prefix = File::Spec->rel2abs(File::Spec->catdir(File::Spec->updir, 'prefix'));
$prefix =~ s{\\}{/}g;

run_ok(['sh', 'configure', '--disable-shared', "--prefix=$prefix"])
  ->success
  ->note;

run_ok(['make'])
  ->success
  ->note;

run_ok(['make', 'check'])
  ->success
  ->note;

run_ok(['make', 'install'])
  ->success
  ->note;

my $bin = File::Spec->catdir($prefix, 'bin');
unshift @PATH, $bin;

run_ok(['dontpanic'])
  ->success
  ->note
  ->out_like(qr{the answer to life the universe and everything is 42});

my_cleanup;

done_testing;
