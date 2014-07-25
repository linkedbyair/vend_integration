require 'spec_helper'

describe Vend::CustomerBuilder do
  let(:customer_with_id) { {
      'id'        => 'a123771197',
      'firstname' => 'Brian XX',
      'lastname'  => 'Smith',
      'email'     => 'spree@example.com',
      'shipping_address'=> {
        'address1' => '1234 Awesome Street',
        'address2' => '',
        'zipcode'  => '90210',
        'city'     => 'Hollywood',
        'state'    => 'California',
        'country'  => 'US',
        'phone'    => '0000000000'
      },
      'billing_address'=> {
        'address1' => '1234 Awesome Street',
        'address2' => '',
        'zipcode'  => '90210',
        'city'     => 'Hollywood',
        'state'    => 'California',
        'country'  => 'US',
        'phone'    => '0000000000'
      }
    } }

  let(:customer_without_id) { {
      'firstname' => 'Brian XX',
      'lastname'  => 'Smith',
      'email'     => 'spree@example.com',
      'shipping_address'=> {
        'address1' => '1234 Awesome Street',
        'address2' => '',
        'zipcode'  => '90210',
        'city'     => 'Hollywood',
        'state'    => 'California',
        'country'  => 'US',
        'phone'    => '0000000000'
      },
      'billing_address'=> {
        'address1' => '1234 Awesome Street',
        'address2' => '',
        'zipcode'  => '90210',
        'city'     => 'Hollywood',
        'state'    => 'California',
        'country'  => 'US',
        'phone'    => '0000000000'
      }
    } }

  let(:client) { double('client', :register_id => '53b3501c-887c-102d-8a4b-a9cf13f17faa',
                                  :retrieve_customers => {'customers' => [ { 'id' => '53b3501c-887c-102d-8a4b-a9cf13f17faa' } ] },
                                  :payment_type_id => '64579cea-3494-2938-85a1-7649df52fb5b',
                                  :get_shipping_product => '64579cea-3494-2938-85a1-7649df52fb5b',
                                  :get_discount_product => '64579cea-3494-2938-85a1-7649df52fb5b') }

  describe '.build_customer' do

    it 'create customer to add' do
      customer_hash = Vend::CustomerBuilder.build_new_customer(client, customer_without_id)
      expect(customer_hash.has_key?(:id)).not_to be
    end

    it 'create customer to update' do
      customer_hash = Vend::CustomerBuilder.build_update_customer(client, customer_with_id)
      expect(customer_hash.has_key?(:id)).to be true
    end

  end
end
