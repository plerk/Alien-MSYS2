# Alien::MSYS2 [![Build Status](https://secure.travis-ci.org/plicease/Alien-MSYS2.png)](http://travis-ci.org/plicease/Alien-MSYS2) [![Build status](https://ci.appveyor.com/api/projects/status/xow1db4mtk6m7v0m/branch/master?svg=true)](https://ci.appveyor.com/project/plicease/Alien-MSYS2/branch/master)

Tools required for autogen scripts in Windows (MSYS2)

# SYNOPSIS

    use Alien::MSYS2;
    my $root = Alien::MSYS2->msys2_root;

# DESCRIPTION

**Please note** that this module is somewhat experimental.  I do not intend
on intentionally making breaking changes, but because of the maturity of
this module it may be unavoidable.  If you need something more battle tested
you should try [Alien::MSYS](https://metacpan.org/pod/Alien::MSYS) instead.

This [Alien](https://metacpan.org/pod/Alien) module provides the [MSYS2](https://msys2.github.io/) tools,
which are useful for building many open source packages on the Microsoft
Windows platform.  When this module is installed, it will generally look
for an existing `MSYS2` install, if it is available, and if not it will
attempt to download it from the internet and install it to a share directory
so that it can be used by other Perl modules.

Here is how the detection logic works:

- check for user override for download

    If the `ALIEN_FORCE` environment variable is set to true, or if
    `ALIEN_INSTALL_TYPE` is set to `share`, then [Alien::MSYS2](https://metacpan.org/pod/Alien::MSYS2) will not
    probe your system for an existing `MSYS2` install, and instead download
    it from the internet.

- check for user override for system

    If the `ALIEN_MSYS2_ROOT` variable is set, [Alien::MSYS2](https://metacpan.org/pod/Alien::MSYS2) will check if
    that is the location of `MSYS2` and use it.

- check registry

    If [Alien::MSYS2](https://metacpan.org/pod/Alien::MSYS2) can find the uninstall registry key for `MSYS2` it will
    use this.  Typically if you installed `MSYS2` using the GUI installer, and
    haven't moved it since this should work.

- check shortcuts

    If [Alien::MSYS2](https://metacpan.org/pod/Alien::MSYS2) can find appropriate start menu shortcuts that point to
    a valid `MSYS2` install, then it will use that.

- check that download is acceptable fallback

    If `ALIEN_INSTALL_TYPE` is not set to `system`, then [Alien::MSYS2](https://metacpan.org/pod/Alien::MSYS2) will
    download `MSYS` from the internet.  If it is set to `system` and none of
    the other methods above succeeded, the install for [Alien::MSYS2](https://metacpan.org/pod/Alien::MSYS2) will fail.

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

# SEE ALSO

- [Alien](https://metacpan.org/pod/Alien)

    Manifesto for the [Alien](https://metacpan.org/pod/Alien) concept.

- [ALien::MSYS](https://metacpan.org/pod/ALien::MSYS)

    `MSYS` is a project with a similar name and feature set to `MSYS2`, but despite the name they
    are different projects, not different versions of the same project.  [Alien::MSYS](https://metacpan.org/pod/Alien::MSYS) provides
    `MSYS`.

- [Alien::Base](https://metacpan.org/pod/Alien::Base)

    base class useful for writing [Alien](https://metacpan.org/pod/Alien) modules.

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
