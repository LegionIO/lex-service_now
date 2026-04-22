# frozen_string_literal: true

require 'faraday/multipart'

module Legion
  module Extensions
    module ServiceNow
      module Attachment
        module Runners
          module Attachment
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_attachments(table_name: nil, table_sys_id: nil, sysparm_limit: 100,
                                 sysparm_offset: 0, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = "table_name=#{table_name}^table_sys_id=#{table_sys_id}" if table_name && table_sys_id
              resp = get('/api/now/attachment', params, **)
              { attachments: resp.body['result'] }
            end

            def get_attachment(sys_id:, **)
              resp = get("/api/now/attachment/#{sys_id}", {}, **)
              { attachment: resp.body['result'] }
            end

            def get_attachment_file(sys_id:, **)
              resp = get("/api/now/attachment/#{sys_id}/file", {}, **)
              { content: resp.body, status: resp.status }
            end

            def upload_attachment(table_name:, table_sys_id:, file_name:, content_type:, content:, **)
              upload_conn = upload_connection(**)
              resp = upload_conn.post('/api/now/attachment/file') do |req|
                req.params['table_name']   = table_name
                req.params['table_sys_id'] = table_sys_id
                req.params['file_name']    = file_name
                req.headers['Content-Type'] = content_type
                req.body = content
              end
              { attachment: resp.body['result'] }
            end

            def delete_attachment(sys_id:, **)
              resp = delete("/api/now/attachment/#{sys_id}", **)
              { deleted: resp.status == 204, sys_id: sys_id }
            end

            private

            def upload_connection(url: nil, client_id: nil, client_secret: nil,
                                  token: nil, username: nil, password: nil, **)
              base_url = url || Legion::Settings[:service_now][:url]
              Faraday.new(url: base_url) do |conn|
                conn.request :multipart
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

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
