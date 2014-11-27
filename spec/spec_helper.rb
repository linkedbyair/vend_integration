require 'rubygems'
require 'bundler'
require 'sinatra'
require 'dotenv'

Dotenv.load
Bundler.require(:default, :test)

require 'simplecov'
SimpleCov.start

require File.join(File.dirname(__FILE__), '..', 'vend_endpoint.rb')

Dir['./spec/support/**/*.rb'].each &method(:require)

Sinatra::Base.environment = 'test'

def app
  VendEndpoint
end

#ENV['ENDPOINT_KEY'] = '6a204bd89f3c8348afd5c77c717a097a'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock

  c.filter_sensitive_data("spree")            { ENV["VEND_SITE_ID"] }
  c.filter_sensitive_data("user@example.com") { ENV["VEND_USER"].gsub('+','%2B').gsub('@','%40') }
  c.filter_sensitive_data("123")              { ENV["VEND_PASSWORD"] }
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.include Rack::Test::Methods
  config.order = 'random'
end
