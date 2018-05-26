#!/usr/bin/env perl
use strict;
use warnings;

use Getopt::Long;
use JSON;
use LWP::UserAgent;

use PrePAN::Model;

GetOptions("dry-run" => \my $dry_run);

my $ua     = LWP::UserAgent->new;
my $oauths = model->search('oauth', { service => 'github' })->all;

for my $oauth (@$oauths) {
    my $access_token = $oauth->access_token;
    my $res  = $ua->get("https://api.github.com/user?oauth_token=${access_token}");
    my $data = decode_json($res->decoded_content);
    my $info = {
        id          => $data->{id},
        login       => $data->{login},
        gravatar_id => $data->{gravatar_id},
        email       => '',
    };

    if ($dry_run) {
        print STDERR encode_json($info), "\n";
    }
    else {
        $oauth->update({ info => $info });
    }
}
