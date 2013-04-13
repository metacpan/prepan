package t::PrePAN::Email;
use Project::Libs;

use Test::PrePAN;

sub _use : Test(1) {
    use_ok "PrePAN::Email";
}

__PACKAGE__->runtests;

!!1;
