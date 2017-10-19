
module Vend
  class OutletBuilder
    attr_reader :payload

    def initialize(payload)
      @payload = payload
    end

    def to_hash
      {
        channel: 'Vend',
        id: payload['id'],
        name: payload['name']
      }
    end

    class << self
      def parse_outlet(payload)
        new(payload).to_hash
      end
    end
  end
end
