# frozen_string_literal: true

require 'faraday'

module Legion
  module Extensions
    module ServiceNow
      module Helpers
        module Client
          def connection(url: nil, client_id: nil, client_secret: nil,
                         token: nil, username: nil, password: nil, **)
            base_url = url || Legion::Settings[:service_now][:url]
            Faraday.new(url: base_url) do |conn|
              conn.request :json
              conn.response :json, content_type: /\bjson$/
              if client_id && client_secret
                conn.headers['Authorization'] = "Bearer #{fetch_oauth2_token(base_url, client_id, client_secret)}"
              elsif token
                conn.headers['Authorization'] = "Bearer #{token}"
              elsif username && password
                conn.request :authorization, :basic, username, password
              end
              conn.adapter Faraday.default_adapter
            end
          end

          def fetch_oauth2_token(base_url, client_id, client_secret)
            @fetch_oauth2_token ||= begin
              resp = Faraday.new(url: base_url) do |conn|
                conn.request :url_encoded
                conn.response :json, content_type: /\bjson$/
                conn.adapter Faraday.default_adapter
              end.post('/oauth_token.do', {
                         grant_type:    'client_credentials',
                         client_id:     client_id,
                         client_secret: client_secret
                       })
              resp.body['access_token']
            end
          end
        end
      end
    end
  end
end
