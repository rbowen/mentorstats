# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl MentorStats.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More tests => 7;
BEGIN { use_ok('MentorStats') };

use_ok('YAML::Tiny');

ok( -e $DATA, 'Data directory exists');
ok( -e "$DATA/devs", 'Devs directory exists');
ok( -e "$DATA/projects", 'Projects directory exists');

ok( my $d = getdev('rbowen'), "Can fetch a person");
ok( my $p = getproject('iceberg'), "Can fetch a project");

