require 'json'

module JsonClient

  class SuccessfulJsonResponse < JsonResponse

    def self.from_http_response an_http_response
      results = JSON.parse an_http_response.body
      self.new results
    end

    attr_reader :results

    def initialize results
      @results = results
    end

    def be_handled_by a_response_handler
      a_response_handler.handle_successful_response self
    end

  end

end