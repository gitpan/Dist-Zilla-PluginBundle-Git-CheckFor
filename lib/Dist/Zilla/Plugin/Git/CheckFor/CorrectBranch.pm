#
# This file is part of Dist-Zilla-PluginBundle-Git-CheckFor
#
# This software is Copyright (c) 2012 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package Dist::Zilla::Plugin::Git::CheckFor::CorrectBranch;
{
  $Dist::Zilla::Plugin::Git::CheckFor::CorrectBranch::VERSION = '0.002';
}

# ABSTRACT: Check that you're on the correct branch before release

use Moose;
use namespace::autoclean;

use Git::Wrapper;

with
    'Dist::Zilla::Role::BeforeRelease',
    'Dist::Zilla::Role::Git::Repo::More',
    ;

has release_branch => (is => 'ro', isa => 'Str', default => 'master');

sub current_branch {
    my $self = shift @_;

    my ($branch) = map { /^\*\s+(.+)/ ? $1 : () } $self->_repo->branch;
    return $branch;
}

sub before_release {
    my $self = shift @_;

    my $cbranch = $self->current_branch;
    my $rbranch = $self->release_branch;

    my $fatal_msg
        = !$cbranch                 ? 'Cannot determine current branch!'
        : $cbranch eq '(no branch)' ? 'You do not appear to be on any branch.  This is almost certainly an error.'
        : $cbranch ne $rbranch      ? "Your current branch ($cbranch) is not the release branch ($rbranch)"
        :                             undef
        ;

    $self->log_fatal($fatal_msg) if $fatal_msg;

    # if we're here, we're good
    $self->log("Current branch ($cbranch) and release branch match ($rbranch)");
    return;
}

__PACKAGE__->meta->make_immutable;

!!42;



=pod

=encoding utf-8

=head1 NAME

Dist::Zilla::Plugin::Git::CheckFor::CorrectBranch - Check that you're on the correct branch before release

=head1 VERSION

This document describes version 0.002 of Dist::Zilla::Plugin::Git::CheckFor::CorrectBranch - released April 13, 2012 as part of Dist-Zilla-PluginBundle-Git-CheckFor.

=head1 SYNOPSIS

    ; in dist.ini
    [Git::CheckFor::CorrectBranch]
    ; release_branch defaults to 'master'
    ;release_branch = master

    # on branch topic/geewhiz...
    $ dzil release # ABENDs!

    # ...and on branch master
    $ dzil release # succeeds

=head1 DESCRIPTION

This is a simple L<Dist::Zilla> plugin to check that you are on the correct
branch before allowing a release...  Its reason for existance is to prevent
accidental releases being cut from topic branches: which are in general not
unrecoverable, but annoying, messy, and (sometimes) embarrassing.

=for Pod::Coverage current_branch before_release

=head1 OPTIONS

=head2 release_branch

This is the name of the branch it is legal to release from: it defaults to
'master'.

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Dist::Zilla::PluginBundle::Git::CheckFor|Dist::Zilla::PluginBundle::Git::CheckFor>

=item *

L<Dist::Zilla>

=item *

L<Dist::Zilla::Plugin::Git>

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


