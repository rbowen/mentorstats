use 5.034001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
## Please see file perltidy.ERR
## Please see file perltidy.ERR
WriteMakefile(
    NAME => 'MentorStats',
    VERSION_FROM => 'lib/MentorStats.pm', # finds $VERSION, requires EU::MM from perl >= 5.5
    PREREQ_PM    => {},                   # e.g., Module::Name => 1.1
    ABSTRACT_FROM => 'lib/MentorStats.pm',    # retrieve abstract from module
    AUTHOR        => 'Bowen <rcbowen@p1s.plx.sd.apple.com>',
    LICENSE       => 'apache',
    EXE_FILES     => [
        qw(
          bin/mentorstats
          bin/addmentee
          bin/editmentee
        )
    ],

    #Value must be from legacy list of licenses here
    #https://metacpan.org/pod/Module::Build::API
);
