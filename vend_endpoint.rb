require 'sinatra'
require 'endpoint_base'

Dir['./lib/**/*.rb'].each &method(:require)

class VendEndpoint < EndpointBase::Sinatra::Base
  set :logging, true

  Honeybadger.configure do |config|
    config.api_key = ENV['HONEYBADGER_KEY']
    config.environment_name = ENV['RACK_ENV']
  end

  post '/send_sms' do
    body    = @payload['sms']['message']
    phone   = @payload['sms']['phone']
    from    = @payload['sms']['from']

    message = Message.new(@config, body, phone, from)
    message.deliver

    result 200, %{SMS "#{body}" sent to #{phone}}
  end
end
