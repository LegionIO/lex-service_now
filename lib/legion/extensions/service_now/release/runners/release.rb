# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Release
        module Runners
          module Release
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_releases(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/rm_release', params, **)
              { releases: resp.body['result'] }
            end

            def get_release(sys_id:, **)
              resp = get("/api/now/table/rm_release/#{sys_id}", {}, **)
              { release: resp.body['result'] }
            end

            def create_release(name:, short_description: nil, state: nil,
                               planned_start: nil, planned_end: nil, **)
              body = { name: name }
              body[:short_description] = short_description if short_description
              body[:state]             = state if state
              body[:planned_start]     = planned_start if planned_start
              body[:planned_end]       = planned_end if planned_end
              resp = post('/api/now/table/rm_release', body, **)
              { release: resp.body['result'] }
            end

            def update_release(sys_id:, name: nil, state: nil, **)
              body = {}
              body[:name]  = name if name
              body[:state] = state if state
              resp = patch("/api/now/table/rm_release/#{sys_id}", body, **)
              { release: resp.body['result'] }
            end

            def delete_release(sys_id:, **)
              resp = delete("/api/now/table/rm_release/#{sys_id}", **)
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
