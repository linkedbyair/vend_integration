require 'sinatra'
require 'endpoint_base'

Dir[File.dirname(__FILE__) + '/lib/**/*.rb'].each &method(:require)

class VendEndpoint < EndpointBase::Sinatra::Base
  set :logging, true

  Honeybadger.configure do |config|
    config.api_key = ENV['HONEYBADGER_KEY']
    config.environment_name = ENV['RACK_ENV']
  end

  post %r{(add_order|update_order)$} do
    begin
      client                      = Vend::Client.new(@config['vend_site_id'], @config['vend_personal_token'])
      @payload[:order][:register] = @config['vend_register']
      response                    = client.send_order(@payload[:order])
      code                        = 200
      set_summary "The order #{@payload[:order][:id]} was sent to Vend POS."
    rescue VendEndpointError => e
      code = 500
      set_summary "Validation error has ocurred: #{e.message}"
    rescue => e
      code = 500
      error_notification(e)
    end

    process_result code
  end

  post '/get_orders' do
    begin
      client = Vend::Client.new(@config['vend_site_id'], @config['vend_personal_token'])
      orders = client.get_orders(@config['vend_poll_order_timestamp'])

      orders.each do |order|
        add_object "order", order
      end

      add_parameter 'vend_poll_order_timestamp', Time.now.utc.iso8601

      code = 200
      set_summary "#{orders.size} orders were retrieved from Vend POS." if orders.any?
    rescue VendEndpointError => e
      code = 500
      set_summary "Validation error has ocurred: #{e.message}"
    rescue => e
      code = 500
      error_notification(e)
    end

    process_result code
  end

  post '/get_products' do
    begin
      client = Vend::Client.new(@config['vend_site_id'], @config['vend_personal_token'])
      products = client.get_products(@config['vend_poll_product_timestamp'])

      products.each do |product|
        add_object "product", product
      end

      add_parameter 'vend_poll_product_timestamp', Time.now.utc.iso8601

      code = 200
      set_summary "#{products.size} products were retrieved from Vend POS." if products.any?
    rescue VendEndpointError => e
      code = 500
      set_summary "Validation error has ocurred: #{e.message}"
    rescue => e
      code = 500
      error_notification(e)
    end

    process_result code
  end

  post '/get_inventory' do
    begin
      client = Vend::Client.new(@config['vend_site_id'], @config['vend_personal_token'])
      inventories = client.get_inventories(@config['vend_poll_inventory_timestamp'])

      inventories.each do |inventory|
        add_object "inventory", inventory
      end

      add_parameter 'vend_poll_inventory_timestamp', Time.now.utc.iso8601

      code = 200
      set_summary "#{inventories.size} inventories were retrieved from Vend POS." if inventories.any?
    rescue VendEndpointError => e
      code = 500
      set_summary "Validation error has ocurred: #{e.message}"
    rescue => e
      code = 500
      error_notification(e)
    end

    process_result code
  end

  def client
    @client ||= Vend::Client.new(@config['vend_site_id'], @config['vend_personal_token']) 
  end

  post '/get_purchase_orders' do
    code = 500

    begin
      purchase_orders = client.get_purchase_orders(since: @payload['last_poll'])

      purchase_orders.each do |purchase_order|
        add_object "purchase_order", purchase_order
      end

      code = 200
    rescue VendEndpointError => e
      set_summary "Validation error has ocurred: #{e.message}"
    rescue => e
      error_notification(e)
    end

    process_result code
  end

  post '/get_customers' do
    begin
      client    = Vend::Client.new(@config['vend_site_id'], @config['vend_personal_token'])
      customers = client.get_customers(@config['vend_poll_customer_timestamp'])

      customers.each do |customer|
        add_object "customer", customer
      end

      add_parameter 'vend_poll_customer_timestamp', Time.now.utc.iso8601

      code = 200
      set_summary "#{customers.size} customers were retrieved from Vend POS." if customers.any?
    rescue VendEndpointError => e
      code = 500
      set_summary "Validation error has ocurred: #{e.message}"
    rescue => e
      code = 500
      error_notification(e)
    end

    process_result code
  end

  post %r{(add_customer|update_customer)$} do
    begin
      client   = Vend::Client.new(@config['vend_site_id'], @config['vend_personal_token'])
      if request.fullpath.match /add_customer/
        response = client.send_new_customer(@payload[:customer])
      else
        response = client.send_update_customer(@payload[:customer])
      end
      code     = 200
      set_summary "The customer #{@payload[:customer][:firstname]} #{@payload[:customer][:lastname]} was sent to Vend POS."
    rescue VendEndpointError => e
      code = 500
      set_summary "Validation error has ocurred: #{e.message}"
    rescue => e
      code = 500
      error_notification(e)
    end

    process_result code
  end

  post %r{(add_product|update_product)$} do
    begin
      client   = Vend::Client.new(@config['vend_site_id'], @config['vend_personal_token'])
      if request.fullpath.match /add_product/
        @payload[:product]['source_id'] = ( @payload[:product].has_key?('source_id') ? @payload[:product]['source_id'] : @payload[:product]['id'] )
        @payload[:product].delete('id')
      end
      @payload[:product]['variants'].each do |variant|
        product = @payload[:product].dup
        product.merge!(variant)
        response = client.send_product(product)
      end

      code     = 200
      set_summary "The product #{@payload[:product][:name]} #{@payload[:product][:name]} was sent to Vend POS."
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
