package PrePAN::Worker::Sendmail;
use strict;
use warnings;

use parent qw(Qudo::Worker);

use PrePAN::Email;
use PrePAN::View;
use PrePAN::Model;

sub work {
    my ($self , $job) = @_;

    my $arg      = $job->arg;
    my $to       = $arg->{to};
    my $subject  = $arg->{subject};
    my $template = $arg->{template};

    my $receiver = model->single(
        user => { id => $arg->{receiver_id} },
    );
    my $subject_user = model->single(
        user => { id => $arg->{subject_user_id} },
    );
    my $review = model->single(
        review => { id => $arg->{review_id} },
    );
    my $module = model->single(
        review => { id => $arg->{module_id} },
    );

    my $view = PrePAN::View->new;
    my $body = $view->render("mail/$template.tt", {
        receiver     => $receiver,
        subject_user => $subject_user,
        review       => $review,
        module       => $module,
    });

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
