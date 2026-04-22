# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module UiPolicy
        module Runners
          module UiPolicy
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_ui_policies(sysparm_limit: 100, sysparm_offset: 0,
                                 sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/sys_ui_policy', params, **)
              { ui_policies: resp.body['result'] }
            end

            def get_ui_policy(sys_id:, **)
              resp = get("/api/now/table/sys_ui_policy/#{sys_id}", {}, **)
              { ui_policy: resp.body['result'] }
            end

            def create_ui_policy(table:, short_description:, script: nil, active: true, **)
              body = { table: table, short_description: short_description, active: active }
              body[:script] = script if script
              resp = post('/api/now/table/sys_ui_policy', body, **)
              { ui_policy: resp.body['result'] }
            end

            def update_ui_policy(sys_id:, active: nil, script: nil, **)
              body = {}
              body[:active] = active unless active.nil?
              body[:script] = script if script
              resp = patch("/api/now/table/sys_ui_policy/#{sys_id}", body, **)
              { ui_policy: resp.body['result'] }
            end

            def delete_ui_policy(sys_id:, **)
              resp = delete("/api/now/table/sys_ui_policy/#{sys_id}", **)
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
