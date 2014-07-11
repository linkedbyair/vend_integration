module Vend
  class ErrorParser
    def self.batch_response_has_errors?(response)
      response.any? do |r|
        r.last[0].has_key?('errors')
      end
    end

    def self.response_has_errors?(response)
      response.code == 400 || response.has_key?('errors')
    end
  end
end
