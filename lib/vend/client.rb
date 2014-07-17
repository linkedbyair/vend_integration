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

    def send_customer(payload)
      customer_hash   = Vend::CustomerBuilder.build_customer(self, payload)

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
        products << {
            :id                 => product['id'],
            'name'              => product['name'],
            'source_id'         =>  product['source_id'],
            'sku'               => product['sku'],
            'description'       => product['description'],
            'price'             => product['price'],
            'permalink'         => product['handle'],
            'meta_keywords'     => product['tags'],
            'updated_at'        => product['updated_at'],
            'taxons'            => [
              [
                'Brands',
                product['brand_name']
              ]
            ],
            'images'=> [
              {
                'url'=> product['image']
              }
            ]
          }

      end
      products
    end

    def get_inventories(poll_inventory_timestamp)
      response  = retrieve_products(poll_inventory_timestamp)

      inventories = []
      (response['products'] || []).each_with_index.map do |product, i|
        product['inventory'].each do | inventory |
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
      response  = retrieve_customers(poll_customer_timestamp, nil)

      customers = []
      (response['customers'] || []).each_with_index.map do |customer, i|
        customers << {
          :id         => customer['id'],
          'firstname' => first_name(customer['name']),
          'lastname'  => last_name(customer['name']),
          'email'     => customer['email'],
          'shipping_address'=> {
            'address1' => customer['physical_address1'],
            'address2' => customer['physical_address2'],
            'zipcode'  => customer['physical_postcode'],
            'city'     => customer['physical_city'],
            'state'    => customer['physical_state'],
            'country'  => customer['physical_country_id'],
            'phone'    =>  customer['phone']
          },
          'billing_address'=> {
            'address1' => customer['postal_address1'],
            'address2' => customer['postal_address2'],
            'zipcode'  => customer['postal_postcode'],
            'city'     => customer['postal_city'],
            'state'    => customer['postal_state'],
            'country'  => customer['postal_country_id'],
            'phone'    =>  customer['phone']
          }
        }
      end
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
        orders << Vend::OrderBuilder.parse_order(order)
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

    def retrieve_customers(poll_customer_timestamp, email)
      options = {
        headers: headers,
        basic_auth: auth,
      }
      options[:query] = {} if poll_customer_timestamp || email
      options[:query][:since] = poll_customer_timestamp if poll_customer_timestamp
      options[:query][:email] = email if email

      response = self.class.get('/customers', options)
      validate_response(response)
    end

    def retrieve_products(poll_product_timestamp)
      options = {
        headers: headers,
        basic_auth: auth
      }
      options[:query] = {since: poll_product_timestamp} if poll_product_timestamp

      response = self.class.get('/products', options)

      validate_response(response)
    end

    private

    def validate_response(response)
      raise VendEndpointError, response if Vend::ErrorParser.response_has_errors?(response)
      response
    end

    def first_name(name)
      name.split(' ')[0]
    end

    def last_name(name)
      name.split(' ').drop(1).join(' ')
    end
  end
end
