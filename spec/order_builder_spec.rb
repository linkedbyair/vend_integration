require 'spec_helper'

describe Vend::OrderBuilder do
  let(:vend_order) { {
        'id'             => '0003cb52-84a3-898c-753e-4405f830f20e',
        'register_id'    => '6e1c67ff-80e4-11df-b0bf-4040f540b50a',
        'market_id'      => '1',
        'customer_id'    => '6e1dee9f-80e4-11df-b0bf-4040f540b50a',
        'customer_name'  => ' ',
        'user_id'        => '631dee9f-90e4-11df-b0bf-4320f540b50a',
        'user_name'      => 'admin',
        'sale_date'      => '2010-09-03 15=>10=>30',
        'total_price'    => '2737.78',
        'total_tax'      => '342.22',
        'tax_name'       => 'NZ GST',
        'note'           => '',
        'status'         => 'CLOSED',
        'short_code'     => 'zegf8',
        'invoice_number' => '263',
        'register_sale_products'=> [
        {
            'id'                                 => '64579cea-3494-2938-85a1-7649df52fb5b',
            'product_id'                         => '4182142c-990e-11df-a4b4-4040f540b50a',
            'name'                               => 'iPhone 4 16GB',
            'quantity'                           => '1',
            'price'                              => '960.00',
            'tax'                                => '120.00',
            'tax_id'                             => '53b3501c-887c-102d-8a4b-a9cf13f17faa',
            'tax_rate'                           => '0.150000',
            'tax_total'                          => '120',
            'price_total'                        => '960',
            'display_retail_price_tax_inclusive' => '1'
        },
        {
            'id'                                 => 'c64ca2f6-a6c2-e17f-4b28-d29c4c615a97',
            'product_id'                         => 'd1fe690c-990d-11df-a4b4-4040f540b50a',
            'name'                               => 'iPad 3G 64GB',
            'quantity'                           => '1',
            'price'                              => '1777.78',
            'tax'                                => '222.22',
            'tax_id'                             => '53b3501c-887c-102d-8a4b-a9cf13f17faa',
            'tax_rate'                           => '0.150000',
            'tax_total'                          => '222.22',
            'price_total'                        => '1777.78',
            'display_retail_price_tax_inclusive' => '1',
            'attributes' => [
                {
                    'name'  => 'line_note',
                    'value' => 'This is a line item note for a single product'
                }
            ]
        }],
        'totals'=> {
            'total_tax'     => '342.22',
            'total_price'   => '2737.78',
            'total_payment' => '3080',
            'total_to_pay'  => '0'
        },
        'register_sale_payments'=> [
        {
            'id'                       => '43058027-a5cd-995f-b57e-a73219e3ac6c',
            'payment_type_id'          => '3',
            'retailer_payment_type_id' => 'a689e6de-80e4-11df-b0bf-4040f540b50a',
            'name'                     => 'Credit Card',
            'amount'                   => '3080.00'
        }],
        'taxes'=> [
        {
            'id'   => '53b3501c-887c-102d-8a4b-a9cf13f17faa',
            'tax'  => 342.22,
            'name' => 'NZ GST',
            'rate' => 0.15
        }]
    } }

    let(:spree_order) {{
        'id'        => 'R154085346205228',
        'status'    => 'complete',
        'channel'   => 'spree',
        'email'     => 'paco+1@spreecommerce.com',
        'currency'  => 'USD',
        'placed_on' => '2014-02-03T17=>29=>15.219Z',
        'totals'=> {
          'item'       => 200,
          'adjustment' => 20,
          'tax'        => 10,
          'shipping'   => 10,
          'payment'    => 220,
          'order'      => 220
        },
        'line_items'=> [
          {
            'product_id' => '32a98839-08f5-11e4-a0f5-b8ca3a64f8f4',
            'name'       => 'Spree T-Shirt',
            'quantity'   => 2,
            'price'      => 100
          }
        ],
        'adjustments'=> [
          {
            'name'  => 'Tax',
            'value' => 10
          },
          {
            'name'  => 'Shipping',
            'value' => 5
          },
          {
            'name'  => 'Shipping',
            'value' => 5
          }
        ],
        'shipping_address'=> {
          'firstname' => 'Joe',
          'lastname'  => 'Smith',
          'address1'  => '1234 Awesome Street',
          'address2'  => '',
          'zipcode'   => '90210',
          'city'      => 'Hollywood',
          'state'     => 'California',
          'country'   => 'US',
          'phone'     => '0000000000'
        },
        'billing_address'=> {
          'firstname' => 'Joe',
          'lastname'  => 'Smith',
          'address1'  => '1234 Awesome Street',
          'address2'  => '',
          'zipcode'   => '90210',
          'city'      => 'Hollywood',
          'state'     => 'California',
          'country'   => 'US',
          'phone'     => '0000000000'
        },
        'payments'=> [
          {
            'number'         => 63,
            'status'         => 'completed',
            'amount'         => 220,
            'payment_method' => 'Credit Card'
          }
        ]
      }}

    let(:client) { double('client', :register_id => '53b3501c-887c-102d-8a4b-a9cf13f17faa',
                                    :retrieve_customers => {'customers' => [ { 'id' => '53b3501c-887c-102d-8a4b-a9cf13f17faa' } ] },
                                    :payment_type_id => '64579cea-3494-2938-85a1-7649df52fb5b',
                                    :get_shipping_product => '64579cea-3494-2938-85a1-7649df52fb5b',
                                    :get_discount_product => '64579cea-3494-2938-85a1-7649df52fb5b') }

  describe '.parse_order' do
    it 'complete order' do
      order_hash = Vend::OrderBuilder.parse_order(vend_order, client)
      expect(order_hash.has_key?('line_items')).to be
    end
  end

  describe '.order_placed' do
    it 'complete order' do
      # Vend::OrderBuilder.any_instance.stub(:customer => '53b3501c-887c-102d-8a4b-a9cf13f17faa')
      order_hash = Vend::OrderBuilder.order_placed(client, spree_order)

      expect(order_hash.has_key?('register_sale_products')).to be
    end
  end
end
