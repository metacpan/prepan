# How to setup local development environment

You need to do three steps to develop PrePAN; setup local database, setup config file and install dependency.

## Clone this repository

```sh
$ git clone git://github.com/CPAN-API/prepan.git
$ cd prepan
```

## Execute script/setup.sh

Please run below code at PrePAN root directory to build local environment.

```sh
$ script/setup.sh
```

This command execute following:

- Install [Carton](https://metacpan.org/pod/Carton) to manage moudle dependency, if carton doesn't exist
- Install perl module dependency by carton
- setup db for local development and test
- copy development config: local/development.eg.pl -> local/development.pl

## Setup OAuth

PrePAN uses Twitter and GitHub OAuth, so you must setup OAuth config.

I describes how to setup for twitter.

### Create a new Twitter Application

You can create a new twitter application from https://dev.twitter.com/apps .

1. Press "Create a new application" button
2. Input Application Details, an example is following
  - Name: hogehoge prepan local
  - Description: prepan local development for hogehoge
  - Website: http://local.prepan.org/
  - Callback URL: http://local.prepan.org/auth/twitter/callback (callback URL must be input to notice twitter that this application is used by browser)
3. Press "Create your Twitter application" button

Next, you must change settings,

1. Press "Settings" tab
2. Change "Application Type"
  - Access: Read and Write
  - Check the box about "Allow this application to be used to Sign in with Twitter"
3. Save settings

Then, you can use this application to develop prepan.

### Write OAuth config on config/development.pl

After create a twitter application, you must write OAuth config on config/development.pl.  Open config/development.pl and write consumer key and consumer secret.

Example:
```Perl
    Auth => {
        Twitter => {
            consumer_key       => 'abcdefghijk', # your twitter consumer key
            consumer_secret    => 'consumersecrettttt', # your twitter consumer secret
            callback_fail_path => '/auth/twitter/failed',
        },
    },
```


# How to start local server
You can use plackup command to start local server.  Please run below at PrePAN root directory.

```sh
$ carton exec -- plackup
```

You can access http://localhost:5000/ . Enjoy Hacking!!

## Local test setting

Run below command if you want to run tests.

```sh
$ carton exec -- prove -v t/**/*.t
```

## Update dependency

Edit cpanfile and run following commands if you want to update dependency.

```sh
$ carton install
$ git add cpanfile cpanfile.snapshot
$ git commit
```

## Contact

You can ask [@prepanorg](http://twitter.com/prepanorg/) or [@shiba_yu36](http://twitter.com/shiba_yu36/) if you have a question.
