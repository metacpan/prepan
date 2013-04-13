package PrePAN::Notify;
use strict;
use warnings;

sub notify_comment {
    my ($class, $user, $args) = @_;

    my $subject_user = $args->{subject_user};
    my $module       = $args->{module};
    my $review       = $args->{review};

    $class->_notify($user, {
        subject_id => $review->is_public ? $subject_user->short_id : undef,
        object_id  => $module->short_id,
        verb       => 'comment',
        info       => {
            content => $review->comment,
            created => $review->created.q(),
        },
    });
}

sub notify_vote {
    my ($class, $user, $args) = @_;

    my $subject_user = $args->{subject_user};
    my $module       = $args->{module};
    my $vote         = $args->{vote};

    $class->_notify($user, {
        subject_id => $subject_user->short_id,
        object_id  => $module->short_id,
        verb       => 'vote',
        info       => {
            created => $vote->created.q(),
        },
    });
}

sub _notify {
    my ($class, $user, $entry) = @_;

    my $timeline = $user->timeline;
    $timeline->add($entry);

    $user->update({ unread_count => $user->unread_count + 1 });
}

1;
