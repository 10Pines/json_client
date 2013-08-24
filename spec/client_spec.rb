require 'spec_helper'

describe JsonClient::Client do

  let(:http_client) { HttpClientForTesting.new }
  let(:request_url) { 'http://foo.com' }
  let(:client) { JsonClient::Client.new http_client }

  describe :fetch_results_from do

    context 'when the response body is a json object' do

      context 'when the json object does not have keys' do

        it 'returns an empty result' do
          http_client.simulate_url_response_for request_url, '{}'

          response = client.fetch_results_from request_url

          response.results.should be_empty
        end

      end

      context 'when the json object has at least one key' do

        it 'returns an object with the key-value pairs present in the response body as result' do
          http_client.simulate_url_response_for request_url, '{"first_name":"John","last_name":"Doe"}'

          response = client.fetch_results_from request_url

          response.results.should have(2).items
          response.results['first_name'].should == 'John'
          response.results['last_name'].should == 'Doe'
        end

      end

    end

    context 'when the response body is a json array' do

      context 'when the array is empty' do

        it 'returns an empty result' do
          http_client.simulate_url_response_for request_url, '[]'

          response = client.fetch_results_from request_url

          response.results.should be_empty
        end

      end

      context 'when the array is not empty' do

        it 'returns a collection with the items present in the response body as result' do
          http_client.simulate_url_response_for request_url, '[1]'

          response = client.fetch_results_from request_url

          response.results.should have(1).item
          response.results.first.should == 1
        end

      end

    end

    context 'when the response is not successful' do

      it 'raises a RuntimeError with response body as error message' do
        error_message = "Houston, we've had a problem"
        http_client.simulate_failed_http_response_for(request_url, error_message)

        expect{ client.fetch_results_from request_url }.to raise_error(RuntimeError, error_message)
      end

    end

    context 'when sending the request fails' do

      it 'throws the exception raised while sending the request' do
        exception = RuntimeError.new "Houston, we've had a problem"
        http_client.simulate_url_failure(request_url, exception)

        expect { client.fetch_results_from request_url }.to raise_error(exception)
      end

    end

    context 'when the response body is not a valid json string' do

      it 'raises a JSON::ParserError error' do
        http_client.simulate_url_response_for request_url, 'foo'

        expect { client.fetch_results_from request_url }.to raise_error(JSON::ParserError)
      end

    end

  end

end
