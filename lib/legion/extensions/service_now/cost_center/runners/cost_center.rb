# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module CostCenter
        module Runners
          module CostCenter
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_cost_centers(sysparm_limit: 100, sysparm_offset: 0,
                                  sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/cmn_cost_center', params, **)
              { cost_centers: resp.body['result'] }
            end

            def get_cost_center(sys_id:, **)
              resp = get("/api/now/table/cmn_cost_center/#{sys_id}", {}, **)
              { cost_center: resp.body['result'] }
            end

            def create_cost_center(name:, manager: nil, department: nil, **)
              body = { name: name }
              body[:manager]    = manager if manager
              body[:department] = department if department
              resp = post('/api/now/table/cmn_cost_center', body, **)
              { cost_center: resp.body['result'] }
            end

            def update_cost_center(sys_id:, name: nil, manager: nil, **)
              body = {}
              body[:name]    = name if name
              body[:manager] = manager if manager
              resp = patch("/api/now/table/cmn_cost_center/#{sys_id}", body, **)
              { cost_center: resp.body['result'] }
            end

            def delete_cost_center(sys_id:, **)
              resp = delete("/api/now/table/cmn_cost_center/#{sys_id}", **)
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
