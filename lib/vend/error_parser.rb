module Vend
  class ErrorParser
    def self.response_has_errors?(response)
      response.code == 400 || response.has_key?('status')
    end
  end
end
