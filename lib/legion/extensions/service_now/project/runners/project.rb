# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Project
        module Runners
          module Project
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_projects(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/pm_project', params)
              { projects: resp.body['result'] }
            end

            def get_project(sys_id:, **)
              resp = connection(**).get("/api/now/table/pm_project/#{sys_id}")
              { project: resp.body['result'] }
            end

            def create_project(name:, short_description: nil, manager: nil,
                               start_date: nil, end_date: nil, state: nil, **)
              body = { name: name }
              body[:short_description] = short_description if short_description
              body[:manager]           = manager if manager
              body[:start_date]        = start_date if start_date
              body[:end_date]          = end_date if end_date
              body[:state]             = state if state
              resp = connection(**).post('/api/now/table/pm_project', body)
              { project: resp.body['result'] }
            end

            def update_project(sys_id:, name: nil, state: nil, percent_complete: nil,
                               manager: nil, **)
              body = {}
              body[:name]             = name if name
              body[:state]            = state if state
              body[:percent_complete] = percent_complete if percent_complete
              body[:manager]          = manager if manager
              resp = connection(**).patch("/api/now/table/pm_project/#{sys_id}", body)
              { project: resp.body['result'] }
            end

            def delete_project(sys_id:, **)
              resp = connection(**).delete("/api/now/table/pm_project/#{sys_id}")
              { deleted: resp.status == 204, sys_id: sys_id }
            end

            def list_project_tasks(project_sys_id:, sysparm_limit: 100, **)
              params = {
                sysparm_query: "parent=#{project_sys_id}",
                sysparm_limit: sysparm_limit
              }
              resp = connection(**).get('/api/now/table/pm_project_task', params)
              { project_tasks: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
