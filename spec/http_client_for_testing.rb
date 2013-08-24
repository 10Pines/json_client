require 'rspec/mocks'

class HttpClientForTesting

  include RSpec::Mocks::ExampleMethods

  def initialize
    @fake_responses = {}
  end

  def get an_url
    validate_response_simulated_for an_url

    @fake_responses[an_url].call
  end

  def simulate_url_failure an_url, an_error
    @fake_responses[an_url] = lambda{ fail an_error }
  end

  def simulate_url_response_for an_url, a_response_body
    @fake_responses[an_url] = lambda{ successful_http_response a_response_body }
  end

  def simulate_failed_http_response_for an_url, a_response_body
    @fake_responses[an_url] = lambda{ failed_http_response a_response_body }
  end

  def successful_http_response a_response_body
    build_http_response a_response_body, '200'
  end

  def failed_http_response(a_response_body)
    build_http_response a_response_body, '400'
  end

  def build_http_response a_response_body, an_http_status_code
    double :body => a_response_body, :code => an_http_status_code
  end

  def validate_response_simulated_for an_url
    return if @fake_responses.has_key?(an_url)

    fail "Dude, you forgot to simulate a response for #{an_url}"
  end

end