[![Build Status](https://travis-ci.org/CPAN-API/prepan.png?branch=master)](https://travis-ci.org/CPAN-API/prepan)

# How to setup local development environment

You need to complete several steps below to get yourself ready to develop PrePAN;

1. Cloning this repository
2. Bootstrapping
3. OAuth setup

## Clone this repository

```sh
$ git clone git://github.com/CPAN-API/prepan.git
$ cd prepan
```

## Bootstrapping with `script/setup.sh`

Run `script/setup.sh` at the PrePAN root directory to bootstrap your environment.

```sh
$ script/setup.sh
```

This command does following things:

- Installs [Carton](https://metacpan.org/pod/Carton) to manage moudle dependency, if it's not installed
- Installs preerequisite modules using `carton` command
- Sets up databases for development and test
- Generates a configuration file from `local/development.eg.pl` to `local/development.pl`

## OAuth setup

PrePAN uses Twitter and GitHub to authenticate users. You have to, at first, create a new Twitter application.

### Create a new Twitter Application

You can create a new Twitter application on [https://dev.twitter.com/apps](https://dev.twitter.com/apps).

1. Press "Create a new application" button
2. Input some information for your application, for example:
  - Name: hogehoge prepan local
  - Description: prepan local development for hogehoge
  - Website: http://local.prepan.org/
  - Callback URL: http://local.prepan.org/auth/twitter/callback (a callback URL must be set to authenticate users via browser)
3. Press "Create your Twitter application" button

Next, you need to change settings for the app:

1. Press "Settings" tab
2. Change "Application Type" to:
  - Access: Read and Write
  - Check the box about "Allow this application to be used to Sign in with Twitter"
3. Save settings

Then, you can use this application to develop PrePAN.

### Add OAuth config into config/development.pl

After create a twitter application, you need to add an OAuth config into `config/development.pl`.

Open `config/development.pl` and add a consumer key and a consumer secret for your application.

Example:

```Perl
    Auth => {
        Twitter => {
            consumer_key       => 'abcdefghijk',          # your twitter consumer key
            consumer_secret    => 'consumersecrettttt',   # your twitter consumer secret
            callback_fail_path => '/auth/twitter/failed',
        },
    },
```


# How to start local server

Execute the command below at PrePAN root directory:

```sh
$ carton exec -- plackup
```

You can access [http://localhost:5000/](http://localhost:5000/). Enjoy Hacking!!

## Local test setting

Run below command if you want to run tests.

```sh
$ carton exec -- prove -v t/**/*.t
```

## Update dependency

Edit `cpanfile` and run following commands if you want to update dependency:

```sh
$ carton install
$ git add cpanfile cpanfile.snapshot
$ git commit
```

## Contact

You can ask [@prepanorg](http://twitter.com/prepanorg/) or [@shiba_yu36](http://twitter.com/shiba_yu36/) if you have a question.
