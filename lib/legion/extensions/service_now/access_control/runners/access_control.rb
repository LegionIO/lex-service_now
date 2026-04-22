# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module AccessControl
        module Runners
          module AccessControl
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_acls(sysparm_limit: 100, sysparm_offset: 0,
                          sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/sys_security_acl', params)
              { acls: resp.body['result'] }
            end

            def get_acl(sys_id:, **)
              resp = connection(**).get("/api/now/table/sys_security_acl/#{sys_id}")
              { acl: resp.body['result'] }
            end

            def create_acl(name:, type:, operation:, active: true,
                           script: nil, condition: nil, **)
              body = { name: name, type: type, operation: operation, active: active }
              body[:script]    = script if script
              body[:condition] = condition if condition
              resp = connection(**).post('/api/now/table/sys_security_acl', body)
              { acl: resp.body['result'] }
            end

            def update_acl(sys_id:, active: nil, script: nil, condition: nil, **)
              body = {}
              body[:active]    = active unless active.nil?
              body[:script]    = script if script
              body[:condition] = condition if condition
              resp = connection(**).patch("/api/now/table/sys_security_acl/#{sys_id}", body)
              { acl: resp.body['result'] }
            end

            def delete_acl(sys_id:, **)
              resp = connection(**).delete("/api/now/table/sys_security_acl/#{sys_id}")
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
