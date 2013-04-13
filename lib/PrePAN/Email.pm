package PrePAN::Email;
use strict;
use warnings;

use PrePAN::Config;

use Email::Sender::Simple;
use Email::Sender::Transport::SMTP;
use Email::Simple;
use Email::Simple::Creator;

sub send {
    my ($class, $args) = @_;

    return unless PrePAN::Config->param('send_mail');

    my $email_config = PrePAN::Config->param('email');

    my $email = Email::Simple->create(
        header => [
            To      => $args->{to},
            From    => 'noreply@prepan.org',
            Subject => $args->{subject},
        ],
        body => $args->{body},
        transport => Email::Sender::Transport::SMTP->new({
            host          => $email_config->{host},
            port          => $email_config->{port},
            ssl           => $email_config->{ssl},
            sasl_username => $email_config->{username},
            sasl_password => $email_config->{password},
        }),
    );
    Email::Sender::Simple->send($email);
}

1;
