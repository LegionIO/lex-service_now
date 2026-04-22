# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module UpdateSet
        module Runners
          module UpdateSet
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_update_sets(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/sys_update_set', params, **)
              { update_sets: resp.body['result'] }
            end

            def get_update_set(sys_id:, **)
              resp = get("/api/now/table/sys_update_set/#{sys_id}", {}, **)
              { update_set: resp.body['result'] }
            end

            def create_update_set(name:, description: nil, release_date: nil, **)
              body = { name: name }
              body[:description]  = description if description
              body[:release_date] = release_date if release_date
              resp = post('/api/now/table/sys_update_set', body, **)
              { update_set: resp.body['result'] }
            end

            def update_update_set(sys_id:, name: nil, state: nil, description: nil, **)
              body = {}
              body[:name]        = name if name
              body[:state]       = state if state
              body[:description] = description if description
              resp = patch("/api/now/table/sys_update_set/#{sys_id}", body, **)
              { update_set: resp.body['result'] }
            end

            def delete_update_set(sys_id:, **)
              resp = delete("/api/now/table/sys_update_set/#{sys_id}", **)
              { deleted: resp.status == 204, sys_id: sys_id }
            end

            def list_update_set_changes(update_set_sys_id:, sysparm_limit: 100, **)
              params = {
                sysparm_query: "update_set=#{update_set_sys_id}",
                sysparm_limit: sysparm_limit
              }
              resp = get('/api/now/table/sys_update_xml', params, **)
              { changes: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
