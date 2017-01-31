require 'sinatra'
require 'endpoint_base'

Dir[File.dirname(__FILE__) + '/lib/**/*.rb'].each &method(:require)

class VendEndpoint < EndpointBase::Sinatra::Base
  extend GetObjectsEndpoint
  set :logging, true
  attr_reader :payload

  def add_object(key, value)
    case value
    when Hash
      super key, value.merge(channel: 'Vend')
    else
      super
    end
  end

  get_endpoint :outlet
  get_endpoint :product
  get_endpoint :purchase_order
  get_endpoint :vendor

  post '/get_purchase_order' do
    begin
      code = 200
      response = client.get_purchase_order(consignment_id: payload['purchase_order']['id'])
      set_summary "Retrieved Consignment #{response.dig 'data', 'id'} purchase order from Vend"
      add_object :purchase_order, response['data']
    rescue VendEndpointError => e
      code = 500
      set_summary "Validation error has ocurred: #{e.message}"
    rescue => e
      code = 500
      error_notification(e)
    end

    process_result code
  end

  post '/add_purchase_order' do
    begin
      response = client.send_purchase_order(@payload[:purchase_order])
      code = 200
      add_object "purchase_order", Vend::PurchaseOrderBuilder.new(response.to_h, client).to_hash
      set_summary "Added purchase order #{response["name"]} to Vend"
    rescue VendEndpointError => e
      code = 500
      set_summary "Validation error has ocurred: #{e.message}"
    rescue => e
      code = 500
      error_notification(e)
    end

    process_result code
  end

  post '/add_vendor' do
    begin
      response = client.send_supplier(@payload[:vendor])
      add_object "vendor", response.as_json
      set_summary "Added vendor #{response["name"]} to Vend"
      code = 200
    rescue VendEndpointError => e
      code = 500
      set_summary "Validation error has ocurred: #{e.message}"
    rescue => e
      code = 500
      error_notification(e)
    end

    process_result code
  end
=begin

  Honeybadger.configure do |config|
    config.api_key = ENV['HONEYBADGER_KEY']
    config.environment_name = ENV['RACK_ENV']
  end

  post %r{(add_order|update_order)$} do
    begin
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

  def self.get_endpoint(name, method, path = nil)
    post (path || "/get_#{name.pluralize}") do
      begin
        timestamp = "vend_poll_#{name}_timestamp"
        since = @config[timestamp] || (@payload['last_poll'] && Time.at(@payload['last_poll']).utc.iso8601)
        objects = client.send("get_#{name.pluralize}", since)

        objects.each do |object|
          add_object name, object
        end

        add_value name.pluralize, [] if objects.count < 1

        add_parameter timestamp, Time.now.utc.iso8601

        code = 200
        set_summary "#{objects.size} #{name.pluralize(objects.size)} retrieved from Vend POS." if objects.any?
      rescue VendEndpointError => e
        code = 500
        set_summary "Validation error has ocurred: #{e.message}"
      rescue => e
        code = 500
        error_notification(e)
      end

      process_result code
    end
  end

  get_endpoint "customers", :get_customers
  get_endpoint "inventory", :get_inventory, "/get_inventory"
  get_endpoint "orders", :get_orders
  get_endpoint "outlets", :get_outlets
  get_endpoint "products", :get_products
  get_endpoint "purchase_orders", :get_purchase_orders

  post "/get_pending_purchase_order" do
    name = "purchase_orders"
    begin
      objects = client.get_pending_purchase_order(@payload['pending_purchase_order']['vend_id'])

      objects.each do |object|
        add_object "pending_purchase_order", object
      end

      add_value "pending_purchase_orders", [] if objects.count < 1

      code = 200
      set_summary "#{objects.size} #{name.pluralize(objects.size)} retrieved from Vend POS." if objects.any?
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
=end

  def error_notification(error)
    log_exception(error)
    set_summary "A Vend POS Endpoint error has ocurred: #{error.message}"
  end

   def client
     @client ||= Vend::Client.new(ENV.fetch('VEND_SITE_ID'), ENV.fetch('VEND_PERSONAL_TOKEN'))
   end
end
