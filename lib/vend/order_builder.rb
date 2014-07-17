module Vend
  class OrderBuilder
    class << self
      def order_placed(client, payload)
        hash = {
            'register_id'            => payload['register'],
            'customer_id'            => customer(client, payload),
            'sale_date'              => payload['placed_on'],
            'total_price'            => payload['totals']['item'].to_f,
            'total_tax'              => payload['totals']['tax'].to_f,
            'tax_name'               => nil,
            'status'                 => payload['status'],
            'invoice_number'         => payload['line_items'][0]['product_id'],
            'note'                   => nil,
            'register_sale_products' => products_of_order(client, payload),
            'register_sale_payments' =>  payments(client, payload)
        }
        hash[:id] = payload['id'] if payload.has_key?('id')
        hash
      end


      def products_of_order(client, payload)
        (payload['line_items'] || []).each_with_index.map do |line_item, i|
          {
            'product_id' => line_item['product_id'].to_s,
            'quantity'   => line_item['quantity'],
            'price'      => line_item['price'].to_f,
            'attributes' => [
                    {
                        'name'  => 'line_note',
                        'value' => line_item['name']
                    }]
          }
        end
      end

      def payments(client, payload)
        (payload['payments'] || []).each_with_index.map do |payment, i|
          {
            'retailer_payment_type_id'=> client.payment_type_id(payment['payment_method']),
            'payment_date'=> payload['placed_on'],
            'amount'=> payment['amount'].to_f
          }
        end
      end

      def parse_order(vend_order)
        {
            :id              => vend_order['id'],
            'customer_id'    => vend_order['customer_id'],
            'register_id'    => vend_order['register_id'],
            'status'         => vend_order['status'],
            'invoice_number' => vend_order['invoice_number'],
            'placed_on'      => vend_order['sale_date'],
            'updated_at'     => vend_order['updated_at'],
            'totals'=> {
              'item'    => vend_order['totals']['total_price'],
              'tax'     => vend_order['total_tax'],
              'payment' => vend_order['totals']['total_payment'],
            },
            'line_items'  => parse_items(vend_order),
            'adjustments' => parse_adjustments(vend_order),
            'payments'    => parse_payments(vend_order)
        }
      end

      private

      def parse_items(vend_order)
        (vend_order['register_sale_products'] || []).each_with_index.map do |line_item, i|
          {
            'id'         => line_item['id'],
            'product_id' => line_item['product_id'],
            'name'       => line_item['name'],
            'quantity'   => line_item['quantity'].to_f,
            'price'      => line_item['price'].to_f
          }
        end
      end

      def parse_adjustments(vend_order)
        (vend_order['taxes'] || []).each_with_index.map do |tax, i|
            {
              'id'    => tax['id'],
              'name'  => tax['name'],
              'value' => tax['rate']
            }
        end
      end

      def parse_payments(vend_order)
        (vend_order['register_sale_payments'] || []).each_with_index.map do |payment, i|
          {
            'id'             => payment['id'],
            'number'         => payment['payment_type_id'],
            'amount'         => payment['amount'].to_f,
            'payment_method' => payment['name']
          }
        end
      end

      def customer(client, payload)
        customer = client.customer_by_email(payload['email'])

        if customer['customers'][0].nil?
          customer = client.send_customer(build_customer_based_on_order(payload))
          customer['customer']['id']
        else
          customer['customers'][0]['id']
        end
      end

      def build_customer_based_on_order(payload)
        {
          'firstname'        => payload['billing_address']['firstname'],
          'lastname'         => payload['billing_address']['lastname'],
          'email'            => payload['email'],
          'shipping_address' => payload['shipping_address'],
          'billing_address'  => payload['billing_address']
        }
      end
    end
  end
end
