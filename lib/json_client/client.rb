require 'json_client/json_response'
require 'net/http'

module JsonClient

  class Client

    def self.default
      self.new Net::HTTP
    end

    def initialize an_http_client
      @http_client = an_http_client
    end

    def fetch_results_from a_request_url
      http_response = fetch_http_response_from a_request_url

      response = build_json_response_from http_response

      response.be_handled_by self
    end

    def handle_successful_response a_response
      a_response
    end

    def handle_failed_response a_response
      fail a_response.error_message
    end

    protected

    def fetch_http_response_from an_url
      @http_client.get an_url
    end

    def build_json_response_from an_http_response
      JsonClient::JsonResponse.to_handle an_http_response
    end

  end

end


