# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Sla
        module Runners
          module Sla
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_sla_definitions(sysparm_limit: 100, sysparm_offset: 0,
                                     sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/contract_sla', params)
              { sla_definitions: resp.body['result'] }
            end

            def get_sla_definition(sys_id:, **)
              resp = connection(**).get("/api/now/table/contract_sla/#{sys_id}")
              { sla_definition: resp.body['result'] }
            end

            def list_task_slas(sysparm_limit: 100, sysparm_offset: 0,
                               sysparm_query: nil, task_sys_id: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = task_sys_id ? "task=#{task_sys_id}" : sysparm_query if task_sys_id || sysparm_query
              resp = connection(**).get('/api/now/table/task_sla', params)
              { task_slas: resp.body['result'] }
            end

            def get_task_sla(sys_id:, **)
              resp = connection(**).get("/api/now/table/task_sla/#{sys_id}")
              { task_sla: resp.body['result'] }
            end

            def pause_task_sla(sys_id:, **)
              resp = connection(**).patch("/api/now/table/task_sla/#{sys_id}", { stage: 'paused' })
              { task_sla: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
