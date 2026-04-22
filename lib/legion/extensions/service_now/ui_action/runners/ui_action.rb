# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module UiAction
        module Runners
          module UiAction
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_ui_actions(sysparm_limit: 100, sysparm_offset: 0,
                                sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/sys_ui_action', params, **)
              { ui_actions: resp.body['result'] }
            end

            def get_ui_action(sys_id:, **)
              resp = get("/api/now/table/sys_ui_action/#{sys_id}", {}, **)
              { ui_action: resp.body['result'] }
            end

            def create_ui_action(name:, table:, script:, action_type: 'button',
                                 active: true, **)
              body = { name: name, table: table, script: script,
                       action_type: action_type, active: active }
              resp = post('/api/now/table/sys_ui_action', body, **)
              { ui_action: resp.body['result'] }
            end

            def update_ui_action(sys_id:, script: nil, active: nil, name: nil, **)
              body = {}
              body[:script] = script if script
              body[:active] = active unless active.nil?
              body[:name]   = name if name
              resp = patch("/api/now/table/sys_ui_action/#{sys_id}", body, **)
              { ui_action: resp.body['result'] }
            end

            def delete_ui_action(sys_id:, **)
              resp = delete("/api/now/table/sys_ui_action/#{sys_id}", **)
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
