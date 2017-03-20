
module Vend
  class PurchaseOrderBuilder
    attr_reader :payload, :client

    def initialize(payload, client)
      
      @payload = payload
      @client = client
    end

    def to_hash
      payload.merge(
        channel: 'Vend'
      )
    end

    def location
      
      client.find_outlet_by_id(payload["outlet_id"])
    end

    def source_location
      client.find_outlet_by_id(payload["source_outlet_id"])
    end

    def vendor
      contact = supplier["contact"] || {}
      {
        vendorid: supplier["id"],
        name: supplier["name"],
        address1: contact["postal_address1"],
        address2: contact["postal_address2"],
        city: [contact["postal_suburb"], contact["postal_city"]].reject(&:blank?).compact.join(", "),
        contact: [contact["first_name"], contact["last_name"]].compact.join(" "),
        email: contact["email"],
        state: contact["postal_state"],
        country: contact["postal_country_id"]
      }
    end

    def supplier
      @supplier ||= client.find_supplier_by_id(payload["supplier_id"])
    end

    def line_items
      Array(payload["products"]).each_with_index.map do |product, index|
        {
          line_number: index,
          itemno: sku(product["product_id"]),
          description: product["name"],
          quantity: product["count"],
          unit_price: product["cost"]
        }
      end
    end

    def sku(product_id)
      client.find_product_by_id(product_id)["sku"]
    end

    class << self
      def build(payload, client)
        new(payload, client).to_hash
      end
    end
  end
end
