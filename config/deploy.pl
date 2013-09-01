#!/usr/bin/env perl

use strict;
use warnings;
use Cinnamon::DSL;

set application => 'prepan';
set repository  => 'git://github.com/CPAN-API/prepan.git';
set user        => 'deployer';

role development => [qw(local.prepan.org)], {
    deploy_to          => '/var/www/prepan',
    branch             => sub {
        my $branch = qx{git symbolic-ref --short HEAD};
        chomp $branch;
        return "origin/$branch";
    },
    service_web_dir    => '/service/web',
    service_worker_dir => '/service/worker',
    perl_dir           => '/usr/local/perl-prepan',
    daemontools_prefix => 'development',
};

role production => [qw(app-3.us-west-1 app-4.us-west-1)], {
    deploy_to          => '/var/www/prepan',
    branch             => 'origin/master',
    service_web_dir    => '/service/web',
    service_worker_dir => '/service/worker',
    perl_dir           => '/usr/local/perl-prepan',
    daemontools_prefix => 'production',
};

role "production-standby" => [qw(app-1.us-west-1 app-2.us-west-1)], {
    deploy_to          => '/var/www/prepan',
    branch             => 'origin/master',
    service_web_dir    => '/service/web',
    service_worker_dir => '/service/worker',
    perl_dir           => '/usr/local/perl-prepan',
    daemontools_prefix => 'production',
};

task deploy => {
    setup => {
        dir => sub {
            my ($host, @args) = @_;
            my $repository = get('repository');
            my $deploy_to  = get('deploy_to');
            my $branch     = get('branch');

            remote {
                run "git clone $repository $deploy_to && cd $deploy_to && git checkout -q $branch";
            } $host;
        },

        app => sub {
            my ($host, @args) = @_;
            my $deploy_to = get('deploy_to');
            my $prefix    = get('daemontools_prefix');

            remote {
                for my $service (qw(web worker)) {
                    my $service_dir = get("service_${service}_dir");

                    run "ln -sf $deploy_to/bin/$prefix.$service.run.sh $service_dir/run";
                    run "ln -sf $deploy_to/bin/$prefix.$service.log.run.sh $service_dir/log/run";
                }
            } $host;
        },

        db => sub {
            my ($host, @args) = @_;
            my $deploy_to = get('deploy_to');
            my $perl_dir = get('perl_dir');
            remote {
                run "export PATH=$perl_dir/bin:\$PATH && cd $deploy_to && ./script/setup.sh";
            } $host;
        },
    },

    config => sub {
        my ($host, @args) = @_;
        my $user      = get('user');
        my $deploy_to = get('deploy_to');

        run "scp", "local/development.pl", "$user\@$host:$deploy_to/local/development.pl";
        run "scp", "local/production.pl",  "$user\@$host:$deploy_to/local/production.pl";
    },

    update => sub {
        my ($host, @args) = @_;
        my $deploy_to = get('deploy_to');
        my $branch    = get('branch');
        my $perl_dir  = get('perl_dir');

        remote {
            run "export PATH=$perl_dir/bin:\$PATH && cd $deploy_to && git checkout . && git fetch origin && git checkout -q $branch && git submodule update --init && carton install --deployment";
        } $host;
    },
};

for my $service (qw(web worker)) {
    task $service => {
        start => sub {
            my ($host, @args) = @_;
            my $service = get("service_${service}_dir");

            remote {
                sudo "svc -u $service";
            } $host;
        },

        stop => sub {
            my ($host, @args) = @_;
            my $service = get("service_${service}_dir");

            remote {
                sudo "svc -d $service";
            } $host;
        },

        restart => sub {
            my ($host, @args) = @_;
            my $service = get("service_${service}_dir");

            remote {
                sudo "svc -t $service";
            } $host;
        },

        status => sub {
            my ($host, @args) = @_;
            my $service = get("service_${service}_dir");

            remote {
                sudo "svstat $service";
            } $host;
        },
    };
}
