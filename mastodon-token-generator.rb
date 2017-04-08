#!/usr/bin/env ruby

require 'mastodon'
require 'highline'
require 'yaml'
require 'oauth2'
require 'pp'

config_yaml = (ARGV.length == 1) ? ARGV[0] : '.secrets.yml'

cli = HighLine.new

config = {}

if File.exist?(config_yaml)
  config = YAML.load_file(config_yaml)
end

unless config.has_key?(:app_name)
  config[:app_name] = cli.ask("App name: ")
  config[:redirect_uri] = cli.ask("App redirect URI (optional): ") { |q| q.default = "urn:ietf:wg:oauth:2.0:oob" }
  config[:website] = cli.ask("App website (optional): ") { |q| q.default = nil }
  config[:scopes] = []
  %w{read write follow}.each do |scope|
    if cli.agree "App requires #{scope} scope? [y/n] "
      config[:scopes] << scope
    end
  end
end

unless config.has_key?(:mastodon_instance)
  config[:mastodon_instance] = cli.ask("Mastodon instance domain (e.g. https://mastodon.social): ").chomp('/')
end

mastodon_client = Mastodon::REST::Client.new(base_url: config[:mastodon_instance])

unless (config.has_key?(:client_id) && config.has_key?(:client_secret))
  mastodon_app = mastodon_client.create_app(config[:app_name], config[:redirect_uri], config[:scopes].join(' '), config[:website])
  config[:client_id] = mastodon_app.client_id
  config[:client_secret] = mastodon_app.client_secret
  pp config
  File.open(config_yaml,'w') do |f|
    f.write(YAML.dump(config))
  end
  $stderr.puts "Initial config written to #{config_yaml}"
end

oauth_client = OAuth2::Client.new(config[:client_id], config[:client_secret], :site => config[:mastodon_instance])

$stderr.puts "Authenticating app with OAuth flow to a Mastodon account in order to obtain an OAuth access token. Username and password will not be stored."

username = cli.ask("Mastodon account username (email address): ")
password = cli.ask("Mastodon account password: ") { |q| q.echo = "x" }

config[:access_token] = oauth_client.password.get_token(username, password).token
pp config[:access_token]
File.open(config_yaml,'w') do |f|
  f.write(YAML.dump(config))
end
$stderr.puts "Access token written to #{config_yaml}"
