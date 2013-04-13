package t::PrePAN::App::Module;
use Project::Libs;
use Test::PrePAN::Model;

use PrePAN::App::Module;

use String::Random;

sub _create_no_user : Test(1) {
    my $self = shift;
    my $app = PrePAN::App::Module->new;

    my $module = $app->create;
    ok !$module;
}

sub _create_by_invalid_data : Test(10) {
    my $self = shift;
    my $user = $self->create_test_user;
    my $module;

    # name is null
    my $app = PrePAN::App::Module->new;
    $app->user($user);
    $module = $app->create;
    ok !$module;
    ok $app->validator->is_error('name');

    # name is too long
    $app = PrePAN::App::Module->new;
    $app->user($user);
    $app->name(String::Random->new->randregex('[a-z]{300}'));
    $module = $app->create;
    ok !$module;
    ok $app->validator->is_error('name');

    # name is like Acme::*
    $app = PrePAN::App::Module->new;
    $app->user($user);
    $app->name('Acme::' . time);
    $module = $app->create;
    ok !$module;
    ok $app->validator->is_error('name');

    # url is invalid
    $app = PrePAN::App::Module->new;
    $app->user($user);
    $app->name(String::Random->new->randregex('[a-z]{20}'));
    $app->url('aiueo');
    $module = $app->create;
    ok !$module;
    ok $app->validator->is_error('url');

    # summary is too long
    $app = PrePAN::App::Module->new;
    $app->user($user);
    $app->name(String::Random->new->randregex('[a-z]{20}'));
    $app->summary(String::Random->new->randregex('[a-z]{300}'));
    $module = $app->create;
    ok !$module;
    ok $app->validator->is_error('summary');
}

sub _create : Test(4) {
    my $self = shift;
    my $user = $self->create_test_user;
    my $module;

    # name is null
    my $app = PrePAN::App::Module->new;
    $app->user($user);
    my $name = String::Random->new->randregex('[a-z]{20}');
    $app->name($name);
    $module = $app->create;
    ok $module;
    is $module->name, $name;
    is $module->status, 'in review';
    is $module->user_id, $user->id;
}

sub post_review : Tests {
    my $self  = shift;
    my $module_user = $self->create_test_user;
    my $module = $self->create_test_module(user_id => $module_user->id);

    my $review_user = $self->create_test_user;
    my $app = PrePAN::App::Module->new;
    $app->user($review_user);
    $app->module($module);
    $app->comment('review comment');

    note "check review is valid";
    my $review = $app->post_review;
    is $review->comment, 'review comment';
    is $review->user_id, $review_user->id;
    is $review->module_id, $module->id;
    is $review->anonymouse, 0;

    $module = $module->refetch;
    is $module->review_count, 1, "review count";

    is $module_user->timeline->count, 1, "notify module user";
    is $review_user->timeline->count, 0, "not notify review user";
}

sub vote : Tests {
    my $self  = shift;
    my $module_user = $self->create_test_user;
    my $module = $self->create_test_module(user_id => $module_user->id);

    my $vote_user = $self->create_test_user;
    my $app = PrePAN::App::Module->new;
    $app->user($vote_user);
    $app->module($module);

    note "check vote is valid";
    my $vote = $app->vote;
    is $vote->module_id, $module->id;
    is $vote->user_id, $vote_user->id;

    is $module_user->timeline->count, 1, "notify module user";
    is $vote_user->timeline->count, 0, "not notify vote user";
}

__PACKAGE__->runtests;

!!1;
