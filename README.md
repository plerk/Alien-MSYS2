# Alien::MSYS2 [![Build Status](https://secure.travis-ci.org/plicease/Alien-MSYS2.png)](http://travis-ci.org/plicease/Alien-MSYS2) [![Build status](https://ci.appveyor.com/api/projects/status/xow1db4mtk6m7v0m/branch/master?svg=true)](https://ci.appveyor.com/project/plicease/Alien-MSYS2/branch/master)

Tools required for autogen scripts in Windows (MSYS2)

# CONSTRUCTOR

## new

    my $alien = Alien::MSYS2->new;

You can create an instance of [Alien::MSYS2](https://metacpan.org/pod/Alien::MSYS2), which you can use to call
its methods.  All of the methods for this class can also be called as
class methods, so usually you do not need to do this.

# METHODS

## install\_type

    my $type = Alien::MSYS2->install_type;

Returns the install type for MSYS.  This will be either the string "system"
or "share" indicating respectively either a system or a share install.

## msys2\_root

    my $dir = Alien::MSYS2->msys2_root

Returns the root of the MSYS2 install.

## bin\_dir

    my @dir = Alien::MSYS2->bin_dir;

Returns a list of directories that need to be added to the `PATH` in order for
`MSYS2` to operate.  Note that if `MSYS2` is _already_ in the `PATH`, this
will return an _empty_ list.

## cflags

provided for [Alien::Base](https://metacpan.org/pod/Alien::Base) compatibility.  Does not do anything useful.

## dynamic\_libs

provided for [Alien::Base](https://metacpan.org/pod/Alien::Base) compatibility.  Does not do anything useful.

## libs

provided for [Alien::Base](https://metacpan.org/pod/Alien::Base) compatibility.  Does not do anything useful.

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
