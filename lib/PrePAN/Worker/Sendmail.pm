package PrePAN::Worker::Sendmail;
use strict;
use warnings;

use parent qw(Qudo::Worker);

use PrePAN::Email;

sub work {
    my ($self , $job) = @_;

    my $arg = $job->arg;
    my $to      = $arg->{to};
    my $subject = $arg->{subject};
    my $body    = $arg->{body};

    PrePAN::Email->send({
        to      => $to,
        subject => $subject,
        body    => $body,
    });

    $job->completed();                  # or $job->abort
}

sub max_retries { 2 }

sub retry_delay { 10 }

1;
