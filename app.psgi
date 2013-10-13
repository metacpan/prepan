BEGIN {
    $ENV{PREPAN_ENV} ||= ($ENV{PLACK_ENV} || '') eq 'production' ?
        'production' : 'development';
}

use strict;
use warnings;

use DBI;
use Plack::Builder;
use Plack::Session::Store::DBI;
use Plack::Session::State::Cookie;
use Log::Dispatch;

use FindBin;
use lib "$FindBin::Bin/lib";
use lib glob "$FindBin::Bin/modules/*/lib";

use PrePAN;
use PrePAN::Web;
use PrePAN::Config;
use PrePAN::Util qw(root);

my $access_logger = Log::Dispatch->new(
    outputs => [
        [
            'File',
            min_level => 'debug',
            max_level => 'debug',
            filename  => $ENV{PREPAN_ACCESSLOG} || 'logs/access.log',
            mode      => '>>',
        ],
    ],
);

builder {
    enable 'Plack::Middleware::XFramework',
        framework => 'Amon2';

    enable 'Plack::Middleware::ReverseProxy';

    enable 'Plack::Middleware::AxsLog',
        ltsv          => 1,
        response_time => 1,
        logger        => sub { $access_logger->debug(@_) };

    enable "Plack::Middleware::HTTPExceptions";

    enable 'Plack::Middleware::Session',
        state => Plack::Session::State::Cookie->new(
            session_key => 'prepan',
            expires     => time() + (60 * 60 * 24 * 30),
        ),
        store => Plack::Session::Store::DBI->new(
            get_dbh => sub {
                DBI->connect(
                    map { PrePAN::Config->param($_) } qw(dsn username password)
                ) or die $DBI::errstr;
            }
        );

    # TODO: serve them via nginx
    enable 'Plack::Middleware::Static',
        path => qr{^/css|images|js|misc/},
        root => root->subdir('public');

    enable 'Plack::Middleware::Static',
        path => qr{^(?:/robots\.txt|/favicon.ico)$},
        root => root->subdir('public');

    PrePAN::Web->to_app;
};
