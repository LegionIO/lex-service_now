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

          def handle_response(resp)
            case resp.status
            when 200, 201, 202, 204
              resp
            when 401
              raise Errors::AuthenticationError.new(error_message(resp), status: 401, detail: resp.body)
            when 403
              raise Errors::AuthorizationError.new(error_message(resp), status: 403, detail: resp.body)
            when 404
              raise Errors::NotFoundError.new(error_message(resp), status: 404, detail: resp.body)
            when 422
              raise Errors::UnprocessableError.new(error_message(resp), status: 422, detail: resp.body)
            when 429
              raise Errors::RateLimitError.new(error_message(resp), status: 429, detail: resp.body)
            when 500..599
              raise Errors::ServerError.new(error_message(resp), status: resp.status, detail: resp.body)
            else
              raise Errors::ServiceNowError.new(error_message(resp), status: resp.status, detail: resp.body)
            end
          end

          private

          def error_message(resp)
            body = resp.body
            return "ServiceNow error (#{resp.status})" unless body.is_a?(Hash)

            msg = body.dig('error', 'message') || body.dig('error', 'detail') ||
                  body['error'] || body['message'] || "ServiceNow error (#{resp.status})"
            msg.to_s
          end
        end
      end
    end
  end
end
