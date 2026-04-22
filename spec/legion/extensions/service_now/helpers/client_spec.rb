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
end
