package PrePAN::Twitter;
use strict;
use warnings;
use parent qw(Net::Twitter::Lite::WithAPIv1_1);

use PrePAN::Config;

my $config = PrePAN::Config->current->{Auth}{Twitter};

sub new {
    my $class = shift;
    $class->SUPER::new(
        consumer_key    => $config->{consumer_key},
        consumer_secret => $config->{consumer_secret},
        ssl             => 1,
        @_,
    );
}

!!1;
