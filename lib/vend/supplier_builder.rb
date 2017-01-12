module Vend
  class SupplierBuilder
    class << self
      def build(client, payload)
        payload.slice(:name)
      end
    end
  end
end
