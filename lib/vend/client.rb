module Vend
  class Client
    include HTTParty

    attr_reader :site_id, :headers, :auth

    def initialize(site_id, user, password)
      @auth = {:username => user, :password => password}
      @site_id      = site_id
      @headers      = { "Content-Type" => "application/json", "Accept" => "application/json" }

      self.class.base_uri "https://#{site_id}.vendhq.com/api/"
    end

    def send_new_order(payload)
      order_placed_hash   = Vend::OrderBuilder.order_placed(payload)

      options = {
        headers: headers,
        basic_auth: auth,
        body: order_placed_hash.to_json
      }

      response = self.class.post('/batch', options)
      validate_batch_response(response)
    end

    private

    def validate_response(response)
      raise VendEndpointError, response if Vend::ErrorParser.response_has_errors?(response)
      true
    end
  end
end
