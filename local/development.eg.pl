return +{
    dsn      => 'dbi:mysql:dbname=prepan;host=localhost',
    username => 'root',
    password => '',

    send_mail => 0,

    email => {
        host => 'localhost',
        port => 25,
        ssl  => 0,
        username => '',
        password => '',
    },

    redis    => {
        server => 'localhost:6379',
    },

    Auth => {
        Twitter => {
            consumer_key       => 'XXXXXXXXXXXXXXX', # your twitter consumer key
            consumer_secret    => 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', # your twitter consumer secret
            callback_fail_path => '/auth/twitter/failed',
        },
        Github => {
            client_id          => 'XXXXXXXXXXXXXXX', # your github client id
            client_secret      => 'XXXXXXXXXXXXXXXXXXXXXXXXX', # your github client secret
            callback_fail_path => '/auth/github/failed',
        },
    },

    Qudo => {
        databases => [+{
            dsn      => 'dbi:mysql:qudo',
            username => 'root',
            password => '',
        }],
        default_hooks => ['Qudo::Hook::Serialize::JSON'],
        workers           => [
            'PrePAN::Worker::Twitter::PrePAN',
            'PrePAN::Worker::Sendmail',
        ],
        work_delay        => 5,
        max_workers       => 3,
        min_spare_workers => 3,
    },
};
