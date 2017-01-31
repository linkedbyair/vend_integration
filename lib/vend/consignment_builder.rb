
module Vend
  ConsignmentBuilder = Struct.new(:client, :payload) do
    def to_hash
      {
        name: "[#{payload['id']}] #{payload['name']}".squish,
        reference: payload["id"],
        alt_po_number: payload["id"],
        due_at: payload["due_date"],
        outlet_id: payload["location_id"],
        supplier_id: payload["supplier_id"],
        type: "SUPPLIER",
        status: payload['status']
      }
    end

    class << self
      def build(payload, client)
        new(payload, client).to_hash
      end
    end
  end
end
