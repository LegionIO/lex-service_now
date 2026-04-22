# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Change
        module Runners
          module Change
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_changes(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/sn_chg_rest/change', params)
              { changes: resp.body['result'] }
            end

            def create_normal(short_description:, description: nil, assignment_group: nil,
                              start_date: nil, end_date: nil, **)
              body = { short_description: short_description }
              body[:description]      = description if description
              body[:assignment_group] = assignment_group if assignment_group
              body[:start_date]       = start_date if start_date
              body[:end_date]         = end_date if end_date
              resp = connection(**).post('/api/sn_chg_rest/change/normal', body)
              { change: resp.body['result'] }
            end

            def create_emergency(short_description:, description: nil, assignment_group: nil, **)
              body = { short_description: short_description }
              body[:description]      = description if description
              body[:assignment_group] = assignment_group if assignment_group
              resp = connection(**).post('/api/sn_chg_rest/change/emergency', body)
              { change: resp.body['result'] }
            end

            def create_standard(short_description:, description: nil, assignment_group: nil, **)
              body = { short_description: short_description }
              body[:description]      = description if description
              body[:assignment_group] = assignment_group if assignment_group
              resp = connection(**).post('/api/sn_chg_rest/change/standard', body)
              { change: resp.body['result'] }
            end

            def get_change(id:, **)
              resp = connection(**).get("/api/sn_chg_rest/change/#{id}")
              { change: resp.body['result'] }
            end

            def update_change(id:, short_description: nil, description: nil, state: nil,
                              assignment_group: nil, start_date: nil, end_date: nil, **)
              body = {}
              body[:short_description] = short_description if short_description
              body[:description]       = description if description
              body[:state]             = state if state
              body[:assignment_group]  = assignment_group if assignment_group
              body[:start_date]        = start_date if start_date
              body[:end_date]          = end_date if end_date
              resp = connection(**).patch("/api/sn_chg_rest/change/#{id}", body)
              { change: resp.body['result'] }
            end

            def delete_change(id:, **)
              resp = connection(**).delete("/api/sn_chg_rest/change/#{id}")
              { deleted: resp.status == 204, id: id }
            end

            def list_change_tasks(id:, **)
              resp = connection(**).get("/api/sn_chg_rest/change/#{id}/task")
              { tasks: resp.body['result'] }
            end

            def create_change_task(id:, short_description:, **)
              body = { short_description: short_description }
              resp = connection(**).post("/api/sn_chg_rest/change/#{id}/task", body)
              { task: resp.body['result'] }
            end

            def update_change_task(id:, task_id:, short_description: nil, state: nil, assigned_to: nil, **)
              body = {}
              body[:short_description] = short_description if short_description
              body[:state]             = state if state
              body[:assigned_to]       = assigned_to if assigned_to
              resp = connection(**).patch("/api/sn_chg_rest/change/#{id}/task/#{task_id}", body)
              { task: resp.body['result'] }
            end

            def delete_change_task(id:, task_id:, **)
              resp = connection(**).delete("/api/sn_chg_rest/change/#{id}/task/#{task_id}")
              { deleted: resp.status == 204, task_id: task_id }
            end

            def get_conflicts(id:, **)
              resp = connection(**).get("/api/sn_chg_rest/change/#{id}/conflict")
              { conflicts: resp.body['result'] }
            end

            def calculate_conflicts(id:, **)
              resp = connection(**).post("/api/sn_chg_rest/change/#{id}/conflict", {})
              { conflicts: resp.body['result'] }
            end

            def get_approvals(id:, **)
              resp = connection(**).get("/api/sn_chg_rest/change/#{id}/approvals")
              { approvals: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
