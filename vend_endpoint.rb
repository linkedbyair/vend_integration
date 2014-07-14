require 'sinatra'
require 'endpoint_base'

Dir['./lib/**/*.rb'].each &method(:require)

class VendEndpoint < EndpointBase::Sinatra::Base
  set :logging, true

  Honeybadger.configure do |config|
    config.api_key = ENV['HONEYBADGER_KEY']
    config.environment_name = ENV['RACK_ENV']
  end

  post '/add_order' do
    begin
      client = Vend::Client.new(@payload['parameters']['site_id'], @payload['parameters']['vend_user'], @payload['parameters']['vend_password'])
      response = client.send_new_order(@payload[:order])
      code = 200
      set_summary "The order #{@payload[:order][:number]} was sent to Vend POS."
    rescue VendEndpointError => e
      code = 500
      set_summary "Validation error has ocurred: #{e.message}"
    rescue => e
      code = 500
      error_notification(e)
    end

    process_result code
  end

  def error_notification(error)
    log_exception(error)
    set_summary "A Vend POS Endpoint error has ocurred: #{error.message}"
  end

end
