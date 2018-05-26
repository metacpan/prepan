#!/usr/bin/env perl
use strict;
use warnings;
use utf8;

use lib 'lib';
use feature qw(say);

use Getopt::Long;
use JSON;
use LWP::UserAgent;

use PrePAN::Model;

GetOptions("exec" => \my $exec);

my $oauths = model->search('oauth', { service => 'github' })->all;
print scalar @$oauths;

for my $oauth (@$oauths) {
    my $original = $oauth->info->original;
    my $next = {
        %$original,
        email => '',
    };
    say '========================';
    say 'before: ' . encode_json($original);
    say 'after:  ' . encode_json($next);
    if ($exec) {
        $oauth->update({ info => $next });
    }
}
