#
# This file is part of Dist-Zilla-PluginBundle-Git-CheckFor
#
# This software is Copyright (c) 2012 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package Dist::Zilla::Role::Git::Repo::More;
{
  $Dist::Zilla::Role::Git::Repo::More::VERSION = '0.004';
}

# ABSTRACT: Check your repo for fixup! and squash! before release

use Moose::Role;
use namespace::autoclean;
use MooseX::AttributeShortcuts;

use Git::Wrapper;

with
    'Dist::Zilla::Role::Git::Repo',
    ;

has _repo => (is => 'lazy', isa => 'Git::Wrapper');

sub _build__repo { Git::Wrapper->new(shift->repo_root) }

!!42;



=pod

=encoding utf-8

=head1 NAME

Dist::Zilla::Role::Git::Repo::More - Check your repo for fixup! and squash! before release

=head1 VERSION

This document describes version 0.004 of Dist::Zilla::Role::Git::Repo::More - released May 04, 2012 as part of Dist-Zilla-PluginBundle-Git-CheckFor.

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Dist::Zilla::PluginBundle::Git::CheckFor|Dist::Zilla::PluginBundle::Git::CheckFor>

=item *

L<Dist::Zilla>

=back

=head1 SOURCE

The development version is on github at L<http://github.com/RsrchBoy/dist-zilla-pluginbundle-git-checkfor>
and may be cloned from L<git://github.com/RsrchBoy/dist-zilla-pluginbundle-git-checkfor.git>

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
https://github.com/RsrchBoy/dist-zilla-pluginbundle-git-checkfor/issues

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Chris Weyl <cweyl@alumni.drew.edu>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Chris Weyl.

This is free software, licensed under:

  The GNU Lesser General Public License, Version 2.1, February 1999

=cut


__END__


