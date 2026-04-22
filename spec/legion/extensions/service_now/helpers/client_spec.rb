# frozen_string_literal: true

require 'spec_helper'
require 'support/runner_test_harness'

RSpec.describe Legion::Extensions::ServiceNow::Helpers::Client do
  let(:obj) { Object.new.extend(described_class) }

  describe '#connection' do
    it 'returns a Faraday connection' do
      conn = obj.connection(url: 'https://test.service-now.com', username: 'u', password: 'p')
      expect(conn).to be_a(Faraday::Connection)
    end

    it 'uses Basic Auth when username and password provided' do
      conn = obj.connection(url: 'https://test.service-now.com', username: 'admin', password: 'pass')
      builder_handlers = conn.builder.handlers.map(&:name)
      expect(builder_handlers).to include('Faraday::Request::Authorization')
    end

    it 'uses Bearer when token provided' do
      conn = obj.connection(url: 'https://test.service-now.com', token: 'mytoken')
      expect(conn.headers['Authorization']).to eq('Bearer mytoken')
    end

    it 'prefers Bearer over Basic when both provided' do
      conn = obj.connection(url: 'https://test.service-now.com', token: 'mytoken',
                            username: 'admin', password: 'pass')
      expect(conn.headers['Authorization']).to eq('Bearer mytoken')
    end

    it 'prefers OAuth2 over Bearer when client_id and client_secret provided' do
      allow(obj).to receive(:fetch_oauth2_token).and_return('oauth-token')
      conn = obj.connection(url: 'https://test.service-now.com',
                            client_id: 'id', client_secret: 'secret',
                            token: 'fallback')
      expect(conn.headers['Authorization']).to eq('Bearer oauth-token')
    end
  end

  describe '#handle_response' do
    def mock_resp(status, body = {})
      double('response', status: status, body: body)
    end

    it 'returns response on 200' do
      resp = mock_resp(200, { 'result' => [] })
      expect(obj.handle_response(resp)).to eq(resp)
    end

    it 'returns response on 201' do
      resp = mock_resp(201, { 'result' => {} })
      expect(obj.handle_response(resp)).to eq(resp)
    end

    it 'returns response on 204' do
      resp = mock_resp(204, nil)
      expect(obj.handle_response(resp)).to eq(resp)
    end

    it 'raises AuthenticationError on 401' do
      resp = mock_resp(401, { 'error' => { 'message' => 'Not authenticated' } })
      expect { obj.handle_response(resp) }.to raise_error(Legion::Extensions::ServiceNow::Errors::AuthenticationError)
    end

    it 'raises AuthorizationError on 403' do
      resp = mock_resp(403, { 'error' => { 'message' => 'Forbidden' } })
      expect { obj.handle_response(resp) }.to raise_error(Legion::Extensions::ServiceNow::Errors::AuthorizationError)
    end

    it 'raises NotFoundError on 404' do
      resp = mock_resp(404, { 'error' => { 'message' => 'Not found' } })
      expect { obj.handle_response(resp) }.to raise_error(Legion::Extensions::ServiceNow::Errors::NotFoundError)
    end

    it 'raises UnprocessableError on 422' do
      resp = mock_resp(422, { 'error' => { 'message' => 'Invalid' } })
      expect { obj.handle_response(resp) }.to raise_error(Legion::Extensions::ServiceNow::Errors::UnprocessableError)
    end

    it 'raises RateLimitError on 429' do
      resp = mock_resp(429, { 'error' => { 'message' => 'Too many requests' } })
      expect { obj.handle_response(resp) }.to raise_error(Legion::Extensions::ServiceNow::Errors::RateLimitError)
    end

    it 'raises ServerError on 500' do
      resp = mock_resp(500, { 'error' => { 'message' => 'Internal server error' } })
      expect { obj.handle_response(resp) }.to raise_error(Legion::Extensions::ServiceNow::Errors::ServerError)
    end

    it 'raises ServerError on 503' do
      resp = mock_resp(503, { 'error' => { 'message' => 'Service unavailable' } })
      expect { obj.handle_response(resp) }.to raise_error(Legion::Extensions::ServiceNow::Errors::ServerError)
    end

    it 'includes status in the error' do
      resp = mock_resp(404, { 'error' => { 'message' => 'Record not found' } })
      begin
        obj.handle_response(resp)
      rescue Legion::Extensions::ServiceNow::Errors::NotFoundError => e
        expect(e.status).to eq(404)
        expect(e.message).to eq('Record not found')
      end
    end

    it 'handles non-hash body gracefully' do
      resp = mock_resp(500, 'Internal Server Error')
      expect { obj.handle_response(resp) }.to raise_error(Legion::Extensions::ServiceNow::Errors::ServerError) do |e|
        expect(e.message).to match(/ServiceNow error/)
      end
    end
  end
end
