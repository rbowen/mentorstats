package MentorStats;

use 5;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);
our $VERSION = '0.31';
our $DATA = "/Users/rcbowen/Dropbox/mentoring";
our $DOMAIN = 'amazon.com';

# Yes, I know. But I don't care.
our @EXPORT = qw(
    getproject getdev $DATA $DOMAIN
);

1;

# Read project info from YAML
sub getproject {
    my $project = shift;
    my $pdir = $DATA . '/projects';

    # Slurp
    my $f = $DATA . '/projects/' . $project . '.yml';
    my $p = YAML::Tiny->read( $f );
    return $p->[0];
}

# Read dev info from YAML
sub getdev {
    my $devname = shift;
    my $f = $DATA . '/devs/' . $devname . '.yml';
    return 0 unless -e $f;
    my $d = YAML::Tiny->read($f);
    return $d->[0];
}

=head1 NAME

MentorStats - Perl extension generating mentee statistics on AWS
contributors to Apache Software Foundation projects

=head1 SYNOPSIS

  use MentorStats;
  my $project = getproject( 'iceberg' );
  my $dev = getdev( 'rcbowen' );

=head1 DESCRIPTION

Common functions for Rich's mentor tracking scripts

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2025 by Rich Bowen

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.34.1 or,
at your option, any later version of Perl 5 you may have available.

=cut

