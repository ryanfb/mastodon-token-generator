# mastodon-token-generator

# **WARNING: THIS SCRIPT MAY BE BUSTED, BECAUSE OAUTH IS HELL. [SEE THIS ISSUE](https://github.com/ryanfb/mastodon-token-generator/issues/1) IF YOU HAVE ANY IDEA WHY OR HOW TO HELP.**

In the meantime, I suggest you use [Darius Kazemi's handy web form for registering a Mastodon App](https://tinysubversions.com/notes/mastodon-bot/index.html) instead.

This is a command-line interactive Ruby script designed to help making generating apps/bots for the [Mastodon Social Network](https://github.com/tootsuite/mastodon) easier.

It will prompt you for your app's name and other settings, create an app on the Mastodon instance you specify, and then persist the client id and secret as well as other config values to a configuration YAML file.

It will then prompt you for a username/password for a user on the specified Mastodon instance and go through the OAuth flow to obtain an access token, and persist that to the configuration YAML file as well.

## Usage

This script uses [bundler](http://bundler.io/) for dependency management.

    bundle exec ./mastodon-token-generator.rb [optional configuration YAML filename, defaults to .secrets.yml]
