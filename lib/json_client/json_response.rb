module JsonClient

  class JsonResponse

    def self.to_handle results
      return SuccessfulJsonResponse.from_http_response(results) if results.code == '200'
      FailedJsonResponse.from_http_response(results)
    end

    def be_handled_by a_response_handler
      fail 'Subclass responsibility'
    end

  end

end

require 'json_client/successful_json_response'
require 'json_client/failed_json_response'