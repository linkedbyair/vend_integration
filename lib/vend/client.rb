module Vend
  class Client
    include ::HTTParty

    attr_reader :site_id, :headers, :auth

    def initialize(site_id, user, password)
      @auth    = {:username => user, :password => password}
      @site_id = site_id
      @headers = { "Content-Type" => "application/json", "Accept" => "application/json" }

      self.class.base_uri "https://#{site_id}.vendhq.com/api/"
    end

    def send_order(payload)
      order_placed_hash   = Vend::OrderBuilder.order_placed(self, payload)

      options = {
        headers: headers,
        basic_auth: auth,
        body: order_placed_hash.to_json
      }

      response = self.class.post('/register_sales', options)
      validate_response(response)
    end

    def send_new_customer(payload)
      customer_hash   = Vend::CustomerBuilder.build_new_customer(self, payload)
      send_customer(customer_hash)
    end

    def send_update_customer(payload)
      customer_hash   = Vend::CustomerBuilder.build_new_customer(self, payload)
      send_customer(customer_hash)
    end

    def send_customer(customer_hash)
      options = {
        headers: headers,
        basic_auth: auth,
        body: customer_hash.to_json
      }

      response = self.class.post('/customers', options)
      validate_response(response)
    end

    def get_products(poll_product_timestamp)
      response  = retrieve_products(poll_product_timestamp)
      products = []
      (response['products'] || []).each_with_index.map do |product, i|
        hash = {
            :id                 => product['id'],
            'name'              => product['name'].split("/")[0],
            'source_id'         => product['source_id'],
            'sku'               => product['sku'],
            'description'       => product['description'],
            'price'             => product['price'],
            'permalink'         => product['sku'],
            'meta_keywords'     => product['tags'],
            'updated_at'        => product['updated_at'],
            'images'=> [
              {
                'url'=> product['image']
              }
            ]
          }
          hash['taxons'] = [['Brands', product['brand_name']]] if product['brand_name'] && ! product['brand_name'].empty?
          products << hash
      end
      products
    end

    def get_inventories(poll_inventory_timestamp)
      response  = retrieve_products(poll_inventory_timestamp)

      inventories = []
      (response['products'] || []).each_with_index.map do |product, i|
        (product['inventory'] || []).each do | inventory |
          inventories << {
            :id          => inventory['outlet_id'],
            "location"   => inventory['outlet_name'],
            "product_id" => product['id'],
            "quantity"   => inventory['count']
          }
        end
      end
      inventories
    end

    def get_customers(poll_customer_timestamp)
      customers      = []
      has_more_pages = false
      page           = 1

      begin
        response  = retrieve_customers(poll_customer_timestamp, nil, nil, page)

        (response['customers'] || []).each_with_index.map do |customer, i|
          customers << Vend::CustomerBuilder.parse_customer(customer)
        end

        page           = page + 1 if response.has_key?('pagination')
        has_more_pages = response.has_key?('pagination')
        has_more_pages = page <= response['pagination']['pages'] if response.has_key?('pagination')
      end while has_more_pages

      customers
    end

    def get_orders(poll_order_timestamp)
      options = {
        headers: headers,
        basic_auth: auth
      }
      options[:query] = {since: poll_order_timestamp} if poll_order_timestamp

      response = self.class.get('/register_sales', options)
      validate_response(response)

      orders = []
      (response['register_sales'] || []).each_with_index.map do |order, i|
        orders << Vend::OrderBuilder.parse_order(order, self)
      end
      orders
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

      response = retrieve_products
      @products = {}
      (response['products'] || []).each_with_index.map do |product, i|
        @products[product['handle']] = product['id']
      end
      @products[product_id]
    end

    def register_id(register_name)
      return @registers[register_name] if @registers

      options = {
        headers: headers,
        basic_auth: auth
      }

      response = self.class.get('/registers', options)
      validate_response(response)
      @registers = {}
      (response['registers'] || []).each_with_index.map do |register, i|
        @registers[register['name']] = register['id']
      end
      @registers[register_name]
    end

    def retrieve_customers(poll_customer_timestamp, email, id, page=1)
      options = {
        headers: headers,
        basic_auth: auth,
      }
      options[:query]         = {} if poll_customer_timestamp || email || id
      options[:query][:since] = poll_customer_timestamp if poll_customer_timestamp
      options[:query][:email] = email if email
      options[:query][:id]    = id if id

      response = self.class.get('/customers', options)
      validate_response(response)
    end

    def retrieve_products(poll_product_timestamp)
      options = {
        headers: headers,
        basic_auth: auth,
        query: { page_size: 100 }
      }
      options[:query][:since]= poll_product_timestamp if poll_product_timestamp
      products = { 'products'=>[] }
      begin

        response = self.class.get('/products', options)
        validate_response(response)

        products['products'] = products['products'].concat(response['products'])

        if response.has_key?('pagination') && response['pagination']['page'] < response['pagination']['pages']
          options[:query][:page]= response['pagination']['page']+1
          has_more_pages = true
        else
          has_more_pages = false
        end

      end while has_more_pages
      products
    end

    def get_discount_product
      unless @discount_product
        options = {
          headers: headers,
          basic_auth: auth,
          query: {handle: 'vend-discount', sku: 'vend-discount'}
        }
        response = self.class.get('/products', options)

        validate_response(response)
        @discount_product =  response['products'][0]['id']
      end
      @discount_product
    end

    def get_shipping_product
      unless @shipping_product
        options = {
          headers: headers,
          basic_auth: auth,
          query: {handle: 'shipping', sku: 'shipping'}
        }
        response = self.class.get('/products', options)

        validate_response(response)
        @shipping_product =  response['products'][0]['id'] if ! response['products'][0].nil?
      end
      @shipping_product
    end

    private

    def validate_response(response)
      raise VendEndpointError, response if Vend::ErrorParser.response_has_errors?(response)
      response
    end

  end
end
