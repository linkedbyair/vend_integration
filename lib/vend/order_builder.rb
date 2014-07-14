module Vend
  class OrderBuilder
    class << self
      def order_placed(client, payload)
        {
            "register_id" => payload['id'],
            "customer_id" => customer(client, payload['email']),
            "sale_date"=> payload['placed_on'],
            "user_name"=> "admin",
            "total_price"=> payload['totals']['item'].to_f,
            "total_tax"=> payload['totals']['tax'].to_f,
            "tax_name"=> nil,
            "status"=> payload['status'],
            "invoice_number"=> payload['line_items'][0]['product_id'],
            "note"=> nil,
            "register_sale_products"=> products_of_order(client, payload),
            "register_sale_payments"=>  payments(client, payload)
        }
      end


      def products_of_order(client, payload)
        (payload['line_items'] || []).each_with_index.map do |line_item, i|
          {
            "product_id"=> product(client, line_item['product_id'].to_s),
            "quantity"=> line_item['quantity'],
            "price"=> line_item['price'].to_f,
            "attributes" => [
                    {
                        "name"  => "line_note",
                        "value" => line_item['name']
                    }]
          }
        end

      end

      def payments(client, payload)
        (payload['payments'] || []).each_with_index.map do |payment, i|
          {
            "retailer_payment_type_id"=> client.payment_type_id(payment['payment_method']),
            "payment_date"=> payload['placed_on'],
            "amount"=> payment['amount'].to_f
          }
        end
      end

      private

      def customer(client, email)
        customer = client.customer_by_email(email)
        raise "There is no customer with this email: #{email}" if customer['customers'][0].nil?
        customer['customers'][0]['id']
      end

      def product(client, product_id)
        product = client.product_id(product_id)
        raise "There is no product with this source_id: #{product_id}" if product.nil?
        product['id']
      end

    end
  end
end
