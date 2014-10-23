#
# This file is part of Dist-Zilla-PluginBundle-Git-CheckFor
#
# This software is Copyright (c) 2012 by Chris Weyl.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
use strict;
use warnings;

use autodie 'system';
use IPC::System::Simple (); # for autodie && prereqs

use File::chdir;
use Path::Class;

use Test::DZil;

sub make_test_repo {
    my @commands = @_;

    my $tempdir = tempdir;
    my $repo_root = dir($tempdir)->absolute;
    note "Repo being created at $repo_root";
    local $CWD = "$repo_root";

    unshift @commands, 'git init'
        unless $commands[0] =~ /git init/;

    system "($_) 2> /dev/null > /dev/null" for @commands;

    return $repo_root;
}

sub _ack {
    my ($fn, $text, $msg) = @_;
    $text ||= 'whee';
    $msg  ||= 'ack';

    return (
        qq{echo "$text" >> $fn},
        qq{git add $fn && git commit -m '$msg'},
    );
}


sub prep_for_testing {
    # repo_init, plugin_list
    my %opts = @_;

    # make some basic commits, branch...
    my ($repo_root) = make_test_repo(@{$opts{repo_init}});

    my @dist_ini = @{$opts{plugin_list}};
    unshift @dist_ini, $opts{core_args} if $opts{core_args};

    # ...then create a Builder and check for exception
    my $tzil = Builder->from_config(
        { dist_root => "$repo_root" },
        {
            add_files => {
                'source/dist.ini' => simple_ini(@dist_ini),
            },
        },
    );

    return ($tzil, $repo_root);
}

# blatantly stolen from Dist-Zilla-Plugin-CheckPrereqsIndexed-0.008/t/basic.t
# Write the log messages as diagnostics:
sub diag_log
{
  my $tzil = shift;

  # Output nothing if all tests passed:
  my $all_passed = shift;
  $all_passed &&= $_ for @_;

  return if $all_passed;

  diag(map { "$_\n" } @{ $tzil->log_messages });
}

!!42;
