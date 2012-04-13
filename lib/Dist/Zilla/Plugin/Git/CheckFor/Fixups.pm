#
# This file is part of Dist-Zilla-PluginBundle-Git-CheckFor
#
# This software is Copyright (c) 2012 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
package Dist::Zilla::Plugin::Git::CheckFor::Fixups;
{
  $Dist::Zilla::Plugin::Git::CheckFor::Fixups::VERSION = '0.002';
}

# ABSTRACT: Check your repo for fixup! and squash! before release

use Moose;
use namespace::autoclean;
use MooseX::AttributeShortcuts;

# we depend on functionality first present in 1.120370
use Dist::Zilla::Plugin::Git::NextVersion 1.120370 ();
use List::Util 'first';
use Git::Wrapper;

# debugging...
#use Smart::Comments;

with
    'Dist::Zilla::Role::BeforeRelease',
    'Dist::Zilla::Role::Git::Repo::More',
    ;

has _next_version_plugin => (

    is      => 'lazy',
    isa     => 'Dist::Zilla::Plugin::Git::NextVersion',
    handles => [ 'last_version' ],
);

sub _build__next_version_plugin {
    my $self = shift @_;

    return
        first { $_->isa('Dist::Zilla::Plugin::Git::NextVersion') }
        @{ $self->zilla->plugins_with(-VersionProvider) }
        ;
}

sub before_release {
    my $self = shift @_;

    my $repo     = $self->_repo;
    my $last_ver = $self->last_version;

    ### $last_ver
    my $log_opts = { pretty => 'oneline', 'abbrev-commit' => 1 };
    my @logs
        = defined $last_ver
        ? $self->_repo->log($log_opts, "$last_ver..HEAD")
        : $self->_repo->log($log_opts)
        ;

    my $_checker = sub {
        my $lookfor = shift;

        return
            map  { $_ =~ s/\n.*$//; $_          }
            map  { $_->id . ': ' . $_->message  }
            grep { $_->message =~ /^$lookfor! / }
            @logs;
    };

    ### @logs
    my @fixups   = $_checker->('fixup');
    my @squashes = $_checker->('squash');

    if (@fixups || @squashes) {

        $self->log_fatal(
            "Aborting release; found squash or fixup commits:\n\n"
            . join("\n", @fixups)
            . join("\n", @squashes)
            );
    }

    $self->log('No fixup or squash commits found; OK to release');
    return;
}


__PACKAGE__->meta->make_immutable;

!!42;



=pod

=encoding utf-8

=head1 NAME

Dist::Zilla::Plugin::Git::CheckFor::Fixups - Check your repo for fixup! and squash! before release

=head1 VERSION

This document describes version 0.002 of Dist::Zilla::Plugin::Git::CheckFor::Fixups - released April 13, 2012 as part of Dist-Zilla-PluginBundle-Git-CheckFor.

=head1 SYNOPSIS

    ; in dist.ini -- note we depend on Git::NextVersion for versioning info
    [Git::NextVersion]
    [Git::CheckFor::Fixups]

=head1 DESCRIPTION

This is a simple L<Dist::Zilla> plugin to check that since the last release,
you have no fixup or squash commits remaining in your history.  The presence
of these commits is almost certainly an oversight, so if any are found the
release is aborted.

Note that we do not check for the presence of such commits in the history of
older releases; having a fixup commit in the history is embarrassing, but not
so much so as rebasing to resolve a blemish in the deep, dark, sordid past of
the project.

=for Pod::Coverage before_release

=head1 WHAT'S A FIXUP OR SQUASH COMMIT?

A squash or fixup commit is one with a commit message formatted in such a
manner that C<git rebase --autosquash> will recognize it; namely:

A fixup commit has a commit message beginning with 'fixup! '

A squash commit has a commit message beginning with 'squash! '

=head1 SEE ALSO

Please see those modules/websites for more information related to this module.

=over 4

=item *

L<Dist::Zilla::PluginBundle::Git::CheckFor|Dist::Zilla::PluginBundle::Git::CheckFor>

=item *

L<Dist::Zilla>

=item *

L<Dist::Zilla::Plugin::Git::NextVersion>

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


