# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module ScriptAction
        module Runners
          module ScriptAction
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_script_actions(sysparm_limit: 100, sysparm_offset: 0,
                                    sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/sysevent_script_action', params)
              { script_actions: resp.body['result'] }
            end

            def get_script_action(sys_id:, **)
              resp = connection(**).get("/api/now/table/sysevent_script_action/#{sys_id}")
              { script_action: resp.body['result'] }
            end

            def create_script_action(name:, event_name:, script:, active: true, **)
              body = { name: name, event_name: event_name, script: script, active: active }
              resp = connection(**).post('/api/now/table/sysevent_script_action', body)
              { script_action: resp.body['result'] }
            end

            def update_script_action(sys_id:, script: nil, active: nil, **)
              body = {}
              body[:script] = script if script
              body[:active] = active unless active.nil?
              resp = connection(**).patch("/api/now/table/sysevent_script_action/#{sys_id}", body)
              { script_action: resp.body['result'] }
            end

            def delete_script_action(sys_id:, **)
              resp = connection(**).delete("/api/now/table/sysevent_script_action/#{sys_id}")
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
