# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Problem
        module Runners
          module Problem
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_problems(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil,
                              sysparm_fields: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query]  = sysparm_query if sysparm_query
              params[:sysparm_fields] = sysparm_fields if sysparm_fields
              resp = get('/api/now/table/problem', params, **)
              { problems: resp.body['result'] }
            end

            def get_problem(sys_id:, sysparm_fields: nil, **)
              params = {}
              params[:sysparm_fields] = sysparm_fields if sysparm_fields
              resp = get("/api/now/table/problem/#{sys_id}", params, **)
              { problem: resp.body['result'] }
            end

            def create_problem(short_description:, assignment_group: nil, assigned_to: nil,
                               description: nil, category: nil, subcategory: nil, **)
              body = { short_description: short_description }
              body[:assignment_group] = assignment_group if assignment_group
              body[:assigned_to]      = assigned_to if assigned_to
              body[:description]      = description if description
              body[:category]         = category if category
              body[:subcategory]      = subcategory if subcategory
              resp = post('/api/now/table/problem', body, **)
              { problem: resp.body['result'] }
            end

            def update_problem(sys_id:, short_description: nil, state: nil,
                               known_error: nil, workaround: nil, fix_notes: nil,
                               assignment_group: nil, assigned_to: nil, **)
              body = {}
              body[:short_description] = short_description if short_description
              body[:state]             = state if state
              body[:known_error]       = known_error unless known_error.nil?
              body[:workaround]        = workaround if workaround
              body[:fix_notes]         = fix_notes if fix_notes
              body[:assignment_group]  = assignment_group if assignment_group
              body[:assigned_to]       = assigned_to if assigned_to
              resp = patch("/api/now/table/problem/#{sys_id}", body, **)
              { problem: resp.body['result'] }
            end

            def close_problem(sys_id:, fix_notes:, cause_notes: nil, **)
              body = { state: '107', fix_notes: fix_notes }
              body[:cause_notes] = cause_notes if cause_notes
              resp = patch("/api/now/table/problem/#{sys_id}", body, **)
              { problem: resp.body['result'] }
            end

            def delete_problem(sys_id:, **)
              resp = delete("/api/now/table/problem/#{sys_id}", **)
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
