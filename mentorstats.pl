#!perl
use 5;
use warnings;
use YAML::Tiny;
use LWP::UserAgent;
use JSON;
use Data::Dumper;
use Pithub::PullRequests;
our $DATA = "/Users/rcbowen/Dropbox/mentoring";

my $proj = shift || help();

my $ua = LWP::UserAgent->new;
# $ua->ssl_opts(
# SSL_verify_mode => IO::Socket::SSL::SSL_VERIFY_NONE, 
# verify_hostname => 0
# );

my $project = fetchproject( $proj );
print $project->{name} . "\n";

# Only do this once, filter per contributor
my $p   = Pithub::PullRequests->new;
my $prs = $p->list(
    user => 'apache',
    repo => $project->{repo},
    state => 'open',
);
my $allprs = JSON->new->decode( $prs->response()->{_content} );

my @devs =  @{$project->{devs}};
my @lists = @{$project->{lists}};

foreach my $dev (@devs) {

    my $d = getdev($dev);

    unless ( $d->{name} ) {
        warn "Data missing for $dev\n";
        next;
    }

    print "\n============\n" . $d->{name} . "\n\n";

    # Count posts to the various mailing lists
    foreach my $list (@lists) {
        my $mlurl = "https://lists.apache.org/api/stats.lua?list="
          . $list
          . "&domain="
          . $project->{domain}
          . ".apache.org&header_from="
          . $d->{email};

        my $req = HTTP::Request->new( GET => $mlurl );
        my $res = $ua->request($req);

        # check the outcome
        if ( $res->is_success ) {
            my $content = $res->decoded_content;
            my $stats   = JSON->new->decode($content);

            # Have they ever posted to this list?
            if ( %{ $stats->{active_months} } ) {

                print $list . '@' . $project->{domain} . ".apache.org:\n";
                foreach my $k ( sort ( keys %{ $stats->{active_months} } ) ) {
                    print $k . ": " . $stats->{active_months}->{$k} . "\n";
                }
            }
        } else {
            warn "Error: " . $res->status_line . "\n";
        }

    }

    # Next, see what their GitHub stats look like
    my @myprs;
    foreach my $pull ( @{$allprs} ) {
        if ( $pull->{head}->{user}->{login} eq $d->{githubid} ) {
            push @myprs, $pull;
        }
    }

    # Only display this section if there are any.
    if (@myprs) {
        print "\nOpen PRs:\n";
        foreach my $pull (@myprs) {
            print $pull->{html_url} . " (" . $pull->{created_at} . ")\n";
        }
    }
}

# Read project info from YAML
sub fetchproject {
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

    my $ddir = $DATA . '/devs';
    opendir ( DIR, $ddir ) or die "Could not open $ddir\n";

    my $f = $DATA . '/devs/' . $devname . '.yml';
    my $d = YAML::Tiny->read($f);
    return $d->[0];
}

sub help {
    print <<'ENDEND';
For ASF projects, for a specified list of developers,
displays their activity on mailing lists, and open PRs.

ENDEND

    print "\nData is stored in $DATA\n";

    print "Usage: $0 project_name\n\n";
    print "Available projects:\n";

    my $pdir = $DATA . '/projects';
    opendir ( DIR, $pdir ) or die "Could not open $pdir\n";

    while ( my $projfile = readdir(DIR) ) {
        next unless $projfile =~ m/\.yml$/;
        $projfile =~ s/\.yml//;
        print "* " .$projfile."\n";
    }
    print "\n";
    exit();
}

