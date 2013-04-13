package t::PrePAN::Notify;
use Project::Libs;

use Test::PrePAN;
use Test::PrePAN::Model;

use PrePAN::Notify;

sub notify_comment : Tests {
    my $self    =  shift;
    my $user    =  $self->create_test_user;
    my $module  =  $self->create_test_module(
        user_id => $user->short_id,
    );
    my $subject_user = $self->create_test_user;
    my $review = $self->create_test_review(module_id => $module->id);

    PrePAN::Notify->notify_comment($user, {
        subject_user => $subject_user,
        module       => $module,
        review       => $review,
    });

    $user = $user->refetch;
    is $user->unread_count, 1;

    my $timeline = $user->timeline;
    is $timeline->count, 1;

    my @entries = $timeline->entries(0, 0);

    is        scalar(@entries), 1;
    is_deeply $entries[0]->as_serializable, {
        subject_id => $subject_user->short_id,
        object_id  => $module->short_id,
        verb       => 'comment',
        info       => {
            content => $review->comment,
            created => $review->created.q(),
        },
    };
}

sub notify_vote : Tests {
    my $self    =  shift;
    my $user    =  $self->create_test_user;
    my $module  =  $self->create_test_module(
        user_id => $user->short_id,
    );
    my $vote_user = $self->create_test_user;
    my $vote = $self->create_test_vote(module_id => $module->id);

    PrePAN::Notify->notify_vote($user, {
        subject_user => $vote_user,
        module       => $module,
        vote         => $vote,
    });

    $user = $user->refetch;
    is $user->unread_count, 1;

    my $timeline = $user->timeline;
    is $timeline->count, 1;

    my @entries = $timeline->entries(0, 0);

    is        scalar(@entries), 1;
    is_deeply $entries[0]->as_serializable, {
        subject_id => $vote_user->short_id,
        object_id  => $module->short_id,
        verb       => 'vote',
        info       => {
            created => $vote->created.q(),
        },
    };
}

sub _notify : Tests {
    my $self = shift;
    my $user = $self->create_test_user;
    my $module   = $self->create_test_module(
        user_id => $user->short_id,
    );
    my $entry = {
        subject_id => $user->short_id,
        object_id  => $module->short_id,
        verb       => 'review',
        info       => {},
    };

    PrePAN::Notify->_notify($user, $entry);

    $user = $user->refetch;
    is $user->unread_count, 1;

    my $timeline = $user->timeline;
    is $timeline->count, 1;

    my @entries = $timeline->entries(0, 0);

    is        scalar(@entries), 1;
    isa_ok    $entries[0], 'PrePAN::Timeline::Entry';
    is_deeply $entries[0]->as_serializable, $entry;
}

__PACKAGE__->runtests;

!!1;
