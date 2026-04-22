# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Task
        module Runners
          module Task
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_tasks(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil,
                           sysparm_fields: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query]  = sysparm_query if sysparm_query
              params[:sysparm_fields] = sysparm_fields if sysparm_fields
              resp = connection(**).get('/api/now/table/task', params)
              { tasks: resp.body['result'] }
            end

            def get_task(sys_id:, **)
              resp = connection(**).get("/api/now/table/task/#{sys_id}")
              { task: resp.body['result'] }
            end

            def update_task(sys_id:, state: nil, assigned_to: nil, assignment_group: nil,
                            short_description: nil, work_notes: nil, **)
              body = {}
              body[:state]             = state if state
              body[:assigned_to]       = assigned_to if assigned_to
              body[:assignment_group]  = assignment_group if assignment_group
              body[:short_description] = short_description if short_description
              body[:work_notes]        = work_notes if work_notes
              resp = connection(**).patch("/api/now/table/task/#{sys_id}", body)
              { task: resp.body['result'] }
            end

            def close_task(sys_id:, close_notes:, **)
              body = { state: '3', close_notes: close_notes }
              resp = connection(**).patch("/api/now/table/task/#{sys_id}", body)
              { task: resp.body['result'] }
            end

            def add_work_note(sys_id:, work_notes:, **)
              body = { work_notes: work_notes }
              resp = connection(**).patch("/api/now/table/task/#{sys_id}", body)
              { task: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
