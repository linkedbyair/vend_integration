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

  describe '.build_customer' do

    it 'create customer to add' do
      customer_hash = Vend::CustomerBuilder.build_customer(nil, customer_without_id)
      expect(customer_hash.has_key?(:id)).not_to be
    end

    it 'create customer to update' do
      customer_hash = Vend::CustomerBuilder.build_customer(nil, customer_with_id)
      expect(customer_hash.has_key?(:id)).to be true
    end

  end
end
