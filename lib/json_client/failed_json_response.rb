module JsonClient

  class FailedJsonResponse < JsonResponse

    def self.from_http_response an_http_response
      self.new an_http_response.body
    end

    attr_reader :error_message

    def initialize an_error_message
      @error_message = an_error_message
    end

    def be_handled_by a_response_handler
      a_response_handler.handle_failed_response self
    end

  end

end