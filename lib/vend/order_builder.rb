module Vend
  class OrderBuilder
    class << self
      def order_placed(payload)
        {
            "register_id" => payload['id'],
            "customer_id" => customer_by_email(payload['email']),
            "sale_date"=> payload['placed_on'],
            "user_name"=> "admin",
            "total_price"=> payload['totals']['item'].to_f,
            "total_tax"=> payload['totals']['tax'].to_f,
            "tax_name"=> "NZ GST",
            "status"=> "CLOSED",
            "invoice_number"=> payload['line_items'][0]['product_id'],
            "note"=> null,
            "register_sale_products"=> products_of_order(payload),
            "register_sale_payments"=>  payments(payload)
        }
      end

      def products_of_order(payload)
        (payload['line_items'] || []).each_with_index.map do |line_item, i|
          {
            "product_id"=> line_item['product_id'].to_s,
            "quantity"=> line_item['quantity'],
            "price"=> ine_item['price'].to_f,
            "attributes" => [
                    {
                        "name"  => "line_note",
                        "value" => line_item['name']
                    }]
          }
        end

      end

      def payments(payload)
        (payload['payments'] || []).each_with_index.map do |payment, i|
          {
            "retailer_payment_type_id"=> payment_type_id(payment['payment_method']),
            "payment_date"=> payload['placed_on'],
            "amount"=> payment['amount'].to_f
          }
        end
      end

    end
  end
end
