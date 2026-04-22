# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module UserGroup
        module Runners
          module UserGroup
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_groups(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/sys_user_group', params, **)
              { groups: resp.body['result'] }
            end

            def get_group(sys_id:, **)
              resp = get("/api/now/table/sys_user_group/#{sys_id}", {}, **)
              { group: resp.body['result'] }
            end

            def get_group_by_name(name:, **)
              params = { sysparm_query: "name=#{name}", sysparm_limit: 1 }
              resp = get('/api/now/table/sys_user_group', params, **)
              { group: resp.body['result']&.first }
            end

            def create_group(name:, description: nil, manager: nil, email: nil, **)
              body = { name: name }
              body[:description] = description if description
              body[:manager]     = manager if manager
              body[:email]       = email if email
              resp = post('/api/now/table/sys_user_group', body, **)
              { group: resp.body['result'] }
            end

            def update_group(sys_id:, name: nil, description: nil, manager: nil, **)
              body = {}
              body[:name]        = name if name
              body[:description] = description if description
              body[:manager]     = manager if manager
              resp = patch("/api/now/table/sys_user_group/#{sys_id}", body, **)
              { group: resp.body['result'] }
            end

            def delete_group(sys_id:, **)
              resp = delete("/api/now/table/sys_user_group/#{sys_id}", **)
              { deleted: resp.status == 204, sys_id: sys_id }
            end

            def list_group_members(group_sys_id:, sysparm_limit: 100, **)
              params = {
                sysparm_query: "group=#{group_sys_id}",
                sysparm_limit: sysparm_limit
              }
              resp = get('/api/now/table/sys_user_grmember', params, **)
              { members: resp.body['result'] }
            end

            def add_group_member(group_sys_id:, user_sys_id:, **)
              body = { group: group_sys_id, user: user_sys_id }
              resp = post('/api/now/table/sys_user_grmember', body, **)
              { member: resp.body['result'] }
            end

            def remove_group_member(membership_sys_id:, **)
              resp = delete("/api/now/table/sys_user_grmember/#{membership_sys_id}", **)
              { deleted: resp.status == 204, sys_id: membership_sys_id }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
