# Impac! Light

A light Rails App of Maestrano Impac!™.

This project was bootstraped from the (https://github.com/heroku/ruby-getting-started) project. 

[![Build Status](https://travis-ci.org/z0rn/impac-light.svg?branch=master)](https://travis-ci.org/z0rn/impac-light)

### Installation

create a `local_env.yml` file in `/config` from the `local_env.yml.sample`

### Windows

- Make sure ton install the 2.2.3 version (not 64) (http://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.2.3.exe)
- install rails `gem install rails`
- Follow what is on (https://devcenter.heroku.com/articles/getting-started-with-ruby#introduction) in particular please execute 
```sh
$ gem install puma -v'2.9.1' -- --with-opt-dir=c:\openssl
```
- you may have to install the development kit (http://rubyinstaller.org/downloads/) (https://github.com/oneclick/rubyinstaller/wiki/Development-Kit)

## Running Locally

```sh
$ git clone https://github.com/z0rn/impac-light.git
$ cd ruby-getting-started
$ bundle install
$ bundle exec rake
$ bundle exec puma -C config/puma.rb
```

and if you have trouble with nokogiri, follow this [post](http://stackoverflow.com/a/31161208/1107536).
- uninstall the nokogiri gem (you'll need to confirm because many gems depend on it)
- download the nokogiri gem compiled on ruby 2.2 by Paul Grant (kudos for him) here: https://github.com/paulgrant999/ruby-2.2.2-nokogiri-1.6.6.2-x86-x64-mingw32.gem
- installed the local gem ( gem install --local path/to/gem ) 32 bit version (in my case)

Your app should now be running on [localhost:3000](http://localhost:3000/).

## Running tests

```sh
$ rake tests
```

## Deploying to Heroku

```sh
$ heroku create
$ heroku config:set CONNEC_ENDPOINT=https://api-connec.maestrano.com/api/v2
$ git push heroku master
$ heroku open
```