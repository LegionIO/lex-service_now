# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module OnCall
        module Runners
          module OnCall
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_on_call_schedules(sysparm_limit: 100, sysparm_offset: 0,
                                       sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/cmn_rota', params)
              { schedules: resp.body['result'] }
            end

            def get_on_call_schedule(sys_id:, **)
              resp = connection(**).get("/api/now/table/cmn_rota/#{sys_id}")
              { schedule: resp.body['result'] }
            end

            def list_on_call_members(rota_sys_id:, sysparm_limit: 100, **)
              params = {
                sysparm_query: "rota=#{rota_sys_id}",
                sysparm_limit: sysparm_limit
              }
              resp = connection(**).get('/api/now/table/cmn_rota_member', params)
              { members: resp.body['result'] }
            end

            def get_current_on_call(group_sys_id:, **)
              params = { sysparm_query: "group=#{group_sys_id}", sysparm_limit: 1 }
              resp = connection(**).get('/api/now/on_call_rota/whoisoncall', params)
              { on_call: resp.body['result'] }
            end

            def list_escalation_policies(sysparm_limit: 100, sysparm_offset: 0, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              resp = connection(**).get('/api/now/table/cmn_rota_escalation', params)
              { escalation_policies: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
