# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module CatalogTask
        module Runners
          module CatalogTask
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_catalog_tasks(sysparm_limit: 100, sysparm_offset: 0,
                                   sysparm_query: nil, request_item: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              if request_item
                params[:sysparm_query] = "request_item=#{request_item}"
              elsif sysparm_query
                params[:sysparm_query] = sysparm_query
              end
              resp = get('/api/now/table/sc_task', params, **)
              { catalog_tasks: resp.body['result'] }
            end

            def get_catalog_task(sys_id:, **)
              resp = get("/api/now/table/sc_task/#{sys_id}", {}, **)
              { catalog_task: resp.body['result'] }
            end

            def update_catalog_task(sys_id:, state: nil, assigned_to: nil,
                                    work_notes: nil, **)
              body = {}
              body[:state]       = state if state
              body[:assigned_to] = assigned_to if assigned_to
              body[:work_notes]  = work_notes if work_notes
              resp = patch("/api/now/table/sc_task/#{sys_id}", body, **)
              { catalog_task: resp.body['result'] }
            end

            def close_catalog_task(sys_id:, close_notes:, **)
              body = { state: '3', close_notes: close_notes }
              resp = patch("/api/now/table/sc_task/#{sys_id}", body, **)
              { catalog_task: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
