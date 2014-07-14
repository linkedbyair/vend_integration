module Vend
  class Client
    include ::HTTParty

    attr_reader :site_id, :headers, :auth

    def initialize(site_id, user, password)
      @auth = {:username => user, :password => password}
      @site_id      = site_id
      @headers      = { "Content-Type" => "application/json", "Accept" => "application/json" }

      self.class.base_uri "https://#{site_id}.vendhq.com/api/"
    end

    def send_new_order(payload)
      order_placed_hash   = Vend::OrderBuilder.order_placed(self, payload)

      options = {
        headers: headers,
        basic_auth: auth,
        body: order_placed_hash.to_json
      }

      response = self.class.post('/register_sales', options)
      validate_response(response)
    end

    def customer_by_email(email)
      options = {
        headers: headers,
        basic_auth: auth,
        query: {email: email}
      }

      response = self.class.get('/customers', options)
      validate_response(response)
      response
    end

    def payment_type_id(payment_method)
      return @payments[payment_method] if @payments

      options = {
        headers: headers,
        basic_auth: auth
      }

      response = self.class.get('/payment_types', options)
      validate_response(response)
      @payments = {}
      (response['payment_types'] || []).each_with_index.map do |payment_type, i|
        @payments[payment_type['name']] = payment_type['id']
      end
      @payments[payment_method]
    end

    def product_id(product_id)
      return @products[product_id] if @products

      options = {
        headers: headers,
        basic_auth: auth
      }

      response = self.class.get('/products', options)
      validate_response(response)

      @products = {}
      (response['products'] || []).each_with_index.map do |product, i|
        @products[product['handle']] = product['id']
      end
      @products[product_id]
    end

    private

    def validate_response(response)
      raise VendEndpointError, response if Vend::ErrorParser.response_has_errors?(response)
      true
    end
  end
end
