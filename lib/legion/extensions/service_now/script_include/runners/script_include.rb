# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module ScriptInclude
        module Runners
          module ScriptInclude
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_script_includes(sysparm_limit: 100, sysparm_offset: 0,
                                     sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/sys_script_include', params, **)
              { script_includes: resp.body['result'] }
            end

            def get_script_include(sys_id:, **)
              resp = get("/api/now/table/sys_script_include/#{sys_id}", {}, **)
              { script_include: resp.body['result'] }
            end

            def create_script_include(name:, script:, description: nil,
                                      active: true, client_callable: false, **)
              body = { name: name, script: script, active: active,
                       client_callable: client_callable }
              body[:description] = description if description
              resp = post('/api/now/table/sys_script_include', body, **)
              { script_include: resp.body['result'] }
            end

            def update_script_include(sys_id:, script: nil, active: nil,
                                      description: nil, **)
              body = {}
              body[:script]      = script if script
              body[:active]      = active unless active.nil?
              body[:description] = description if description
              resp = patch("/api/now/table/sys_script_include/#{sys_id}", body, **)
              { script_include: resp.body['result'] }
            end

            def delete_script_include(sys_id:, **)
              resp = delete("/api/now/table/sys_script_include/#{sys_id}", **)
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
