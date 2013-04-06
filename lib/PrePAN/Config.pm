package PrePAN::Config;
use strict;
use warnings;

use PrePAN::Util;
use Config::ENV PREPAN_ENV => default => 'development';

common {
    title => 'PrePAN',
};

config production  => {
    eval { load root->file('local/production.pl')->stringify  }
};

config development => {
    eval { load root->file('local/development.pl')->stringify }
};

config test        => {
    parent 'development',

    dsn      => 'dbi:mysql:dbname=prepan_test;host=localhost',
    username => 'root',
    password => '',

    Qudo => {
        databases => [+{
            dsn      => 'dbi:mysql:qudo_test;host=localhost',
            username => 'root',
            password => '',
        }],
        default_hooks => ['Qudo::Hook::Serialize::JSON'],
        workers           => [
            'PrePAN::Worker::Twitter::PrePAN',
        ],
        work_delay        => 5,
        max_workers       => 1,
        min_spare_workers => 1,
    },
};

!!1;
