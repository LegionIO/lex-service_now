# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Department
        module Runners
          module Department
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_departments(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/cmn_department', params, **)
              { departments: resp.body['result'] }
            end

            def get_department(sys_id:, **)
              resp = get("/api/now/table/cmn_department/#{sys_id}", {}, **)
              { department: resp.body['result'] }
            end

            def create_department(name:, description: nil, parent: nil,
                                  head_count: nil, cost_center: nil, **)
              body = { name: name }
              body[:description]  = description if description
              body[:parent]       = parent if parent
              body[:head_count]   = head_count if head_count
              body[:cost_center]  = cost_center if cost_center
              resp = post('/api/now/table/cmn_department', body, **)
              { department: resp.body['result'] }
            end

            def update_department(sys_id:, name: nil, description: nil,
                                  head_count: nil, **)
              body = {}
              body[:name]        = name if name
              body[:description] = description if description
              body[:head_count]  = head_count if head_count
              resp = patch("/api/now/table/cmn_department/#{sys_id}", body, **)
              { department: resp.body['result'] }
            end

            def delete_department(sys_id:, **)
              resp = delete("/api/now/table/cmn_department/#{sys_id}", **)
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
