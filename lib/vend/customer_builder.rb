module Vend
  class CustomerBuilder
    class << self
      def build_customer(client, payload)
        hash = {

          'first_name'          => payload['firstname'],
          'last_name'           => payload['lastname'],
          'email'               => payload['email'],
          'phone'               => payload['billing_address']['phone'],
          'physical_address1'   => payload['shipping_address']['address1'],
          'physical_address2'   => payload['shipping_address']['address2'],
          'physical_postcode'   => payload['shipping_address']['zipcode'],
          'physical_city'       => payload['shipping_address']['city'],
          'physical_state'      => payload['shipping_address']['state'],
          'physical_country_id' => payload['shipping_address']['country'],
          'postal_address1'     => payload['billing_address']['address1'],
          'postal_address2'     => payload['billing_address']['address2'],
          'postal_postcode'     => payload['billing_address']['zipcode'],
          'postal_city'         => payload['billing_address']['city'],
          'postal_state'        => payload['billing_address']['state'],
          'postal_country_id'   => payload['billing_address']['country']
        }

        hash[:id] = payload['id'] if payload.has_key?('id')
        hash
      end
    end
  end
end
