package PrePAN::Worker::Sendmail;
use strict;
use warnings;

use parent qw(Qudo::Worker);

use PrePAN::Email;
use PrePAN::View;

sub work {
    my ($self , $job) = @_;

    my $arg      = $job->arg;
    my $to       = $arg->{to};
    my $subject  = $arg->{subject};
    my $template = $arg->{template};

    my $view = PrePAN::View->new;
    my $body = $view->render("mail/$template.tt", {});

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
