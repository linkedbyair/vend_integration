module Vend
  module PollClient
    def poll(method)
      case method
      when Hash
        method, path = [method.keys.first, method.values.last]
      else
        method, path = [method, method]
      end

      define_method "get_#{method}" do |options|
        since = options[:since]
        options = { headers: headers, query: { after: since.to_i } }
        response = self.class.get("/2.0/#{path}", options)
        validate_response response
        response
      end
    end
  end
end
