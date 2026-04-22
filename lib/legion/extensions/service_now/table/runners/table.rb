# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Table
        module Runners
          module Table
            include Legion::Extensions::ServiceNow::Helpers::Client

            def table_list(table_name:, sysparm_limit: 100, sysparm_offset: 0,
                           sysparm_query: nil, sysparm_fields: nil,
                           sysparm_display_value: nil, sysparm_exclude_reference_link: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query]                   = sysparm_query if sysparm_query
              params[:sysparm_fields]                  = sysparm_fields if sysparm_fields
              params[:sysparm_display_value]           = sysparm_display_value unless sysparm_display_value.nil?
              params[:sysparm_exclude_reference_link]  = sysparm_exclude_reference_link unless sysparm_exclude_reference_link.nil?
              resp = get("/api/now/table/#{table_name}", params, **)
              { records: resp.body['result'] }
            end

            def table_get(table_name:, sys_id:, sysparm_fields: nil,
                          sysparm_display_value: nil, **)
              params = {}
              params[:sysparm_fields]        = sysparm_fields if sysparm_fields
              params[:sysparm_display_value] = sysparm_display_value unless sysparm_display_value.nil?
              resp = get("/api/now/table/#{table_name}/#{sys_id}", params, **)
              { record: resp.body['result'] }
            end

            def table_create(table_name:, **fields)
              body = fields.except(:url, :client_id, :client_secret, :token, :username, :password)
              resp = connection(**fields).post("/api/now/table/#{table_name}", body)
              { record: resp.body['result'] }
            end

            def table_update(table_name:, sys_id:, **fields)
              body = fields.except(:url, :client_id, :client_secret, :token, :username, :password, :sys_id)
              resp = connection(**fields).patch("/api/now/table/#{table_name}/#{sys_id}", body)
              { record: resp.body['result'] }
            end

            def table_delete(table_name:, sys_id:, **)
              resp = delete("/api/now/table/#{table_name}/#{sys_id}", **)
              { deleted: resp.status == 204, sys_id: sys_id }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
