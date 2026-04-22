# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module WorkOrder
        module Runners
          module WorkOrder
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_work_orders(sysparm_limit: 100, sysparm_offset: 0,
                                 sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/wm_order', params)
              { work_orders: resp.body['result'] }
            end

            def get_work_order(sys_id:, **)
              resp = connection(**).get("/api/now/table/wm_order/#{sys_id}")
              { work_order: resp.body['result'] }
            end

            def create_work_order(short_description:, requested_by: nil,
                                  assignment_group: nil, description: nil, **)
              body = { short_description: short_description }
              body[:requested_by]     = requested_by if requested_by
              body[:assignment_group] = assignment_group if assignment_group
              body[:description]      = description if description
              resp = connection(**).post('/api/now/table/wm_order', body)
              { work_order: resp.body['result'] }
            end

            def update_work_order(sys_id:, state: nil, assigned_to: nil,
                                  work_notes: nil, **)
              body = {}
              body[:state]       = state if state
              body[:assigned_to] = assigned_to if assigned_to
              body[:work_notes]  = work_notes if work_notes
              resp = connection(**).patch("/api/now/table/wm_order/#{sys_id}", body)
              { work_order: resp.body['result'] }
            end

            def close_work_order(sys_id:, close_notes:, **)
              body = { state: 'closed_complete', close_notes: close_notes }
              resp = connection(**).patch("/api/now/table/wm_order/#{sys_id}", body)
              { work_order: resp.body['result'] }
            end

            def list_work_order_tasks(work_order_sys_id:, sysparm_limit: 100, **)
              params = {
                sysparm_query: "order=#{work_order_sys_id}",
                sysparm_limit: sysparm_limit
              }
              resp = connection(**).get('/api/now/table/wm_task', params)
              { work_order_tasks: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
