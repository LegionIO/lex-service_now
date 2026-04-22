# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module BusinessRule
        module Runners
          module BusinessRule
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_business_rules(sysparm_limit: 100, sysparm_offset: 0,
                                    sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/sys_script', params)
              { business_rules: resp.body['result'] }
            end

            def get_business_rule(sys_id:, **)
              resp = connection(**).get("/api/now/table/sys_script/#{sys_id}")
              { business_rule: resp.body['result'] }
            end

            def create_business_rule(name:, collection:, script:, when_to_run: 'before',
                                     action_insert: false, action_update: false,
                                     action_delete: false, active: true, **)
              body = {
                name:          name,
                collection:    collection,
                script:        script,
                when:          when_to_run,
                action_insert: action_insert,
                action_update: action_update,
                action_delete: action_delete,
                active:        active
              }
              resp = connection(**).post('/api/now/table/sys_script', body)
              { business_rule: resp.body['result'] }
            end

            def update_business_rule(sys_id:, script: nil, active: nil,
                                     name: nil, **)
              body = {}
              body[:script] = script if script
              body[:active] = active unless active.nil?
              body[:name]   = name if name
              resp = connection(**).patch("/api/now/table/sys_script/#{sys_id}", body)
              { business_rule: resp.body['result'] }
            end

            def delete_business_rule(sys_id:, **)
              resp = connection(**).delete("/api/now/table/sys_script/#{sys_id}")
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
