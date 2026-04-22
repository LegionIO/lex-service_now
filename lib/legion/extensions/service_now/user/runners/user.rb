# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module User
        module Runners
          module User
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_users(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil,
                           sysparm_fields: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query]  = sysparm_query if sysparm_query
              params[:sysparm_fields] = sysparm_fields if sysparm_fields
              resp = get('/api/now/table/sys_user', params, **)
              { users: resp.body['result'] }
            end

            def get_user(sys_id:, **)
              resp = get("/api/now/table/sys_user/#{sys_id}", {}, **)
              { user: resp.body['result'] }
            end

            def get_user_by_username(user_name:, **)
              params = { sysparm_query: "user_name=#{user_name}", sysparm_limit: 1 }
              resp = get('/api/now/table/sys_user', params, **)
              { user: resp.body['result']&.first }
            end

            def get_user_by_email(email:, **)
              params = { sysparm_query: "email=#{email}", sysparm_limit: 1 }
              resp = get('/api/now/table/sys_user', params, **)
              { user: resp.body['result']&.first }
            end

            def create_user(user_name:, first_name: nil, last_name: nil, email: nil,
                            title: nil, department: nil, **)
              body = { user_name: user_name }
              body[:first_name]  = first_name if first_name
              body[:last_name]   = last_name if last_name
              body[:email]       = email if email
              body[:title]       = title if title
              body[:department]  = department if department
              resp = post('/api/now/table/sys_user', body, **)
              { user: resp.body['result'] }
            end

            def update_user(sys_id:, first_name: nil, last_name: nil, email: nil,
                            title: nil, department: nil, active: nil, **)
              body = {}
              body[:first_name]  = first_name if first_name
              body[:last_name]   = last_name if last_name
              body[:email]       = email if email
              body[:title]       = title if title
              body[:department]  = department if department
              body[:active]      = active unless active.nil?
              resp = patch("/api/now/table/sys_user/#{sys_id}", body, **)
              { user: resp.body['result'] }
            end

            def delete_user(sys_id:, **)
              resp = delete("/api/now/table/sys_user/#{sys_id}", **)
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
