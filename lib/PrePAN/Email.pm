package PrePAN::Email;
use strict;
use warnings;

use PrePAN::Config;

use Email::Sender::Simple;
use Email::Simple;
use Email::Simple::Creator;

sub send {
    my ($class, $args) = @_;

    return unless PrePAN::Config->param('sendmail');

    my $email = Email::Simple->create(
        header => [
            To      => $args->{to},
            From    => 'noreply@prepan.org',
            Subject => $args->{subject},
        ],
        body => $args->{body},
    );
    Email::Sender::Simple->send($email);
}

1;
