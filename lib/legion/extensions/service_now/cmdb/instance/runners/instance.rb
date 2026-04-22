# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Cmdb
        module Instance
          module Runners
            module Instance
              include Legion::Extensions::ServiceNow::Helpers::Client

              def list_cis(class_name:, sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
                params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
                params[:sysparm_query] = sysparm_query if sysparm_query
                resp = connection(**).get("/api/now/cmdb/instance/#{class_name}", params)
                { records: resp.body['result']['records'] }
              end

              def create_ci(class_name:, name: nil, ip_address: nil, os: nil, **)
                body = {}
                body[:name]       = name if name
                body[:ip_address] = ip_address if ip_address
                body[:os]         = os if os
                resp = connection(**).post("/api/now/cmdb/instance/#{class_name}", body)
                { record: resp.body['result']['record'] }
              end

              def get_ci(class_name:, sys_id:, **)
                resp = connection(**).get("/api/now/cmdb/instance/#{class_name}/#{sys_id}")
                { record: resp.body['result']['record'] }
              end

              def update_ci(class_name:, sys_id:, name: nil, ip_address: nil, os: nil, location: nil, **)
                body = {}
                body[:name]       = name if name
                body[:ip_address] = ip_address if ip_address
                body[:os]         = os if os
                body[:location]   = location if location
                resp = connection(**).patch("/api/now/cmdb/instance/#{class_name}/#{sys_id}", body)
                { record: resp.body['result']['record'] }
              end

              def delete_ci(class_name:, sys_id:, **)
                resp = connection(**).delete("/api/now/cmdb/instance/#{class_name}/#{sys_id}")
                { deleted: resp.status == 204, sys_id: sys_id }
              end

              def get_relationships(class_name:, sys_id:, **)
                resp = connection(**).get("/api/now/cmdb/instance/#{class_name}/#{sys_id}/relationships")
                { relationships: resp.body['result'] }
              end

              def create_relationship(class_name:, sys_id:, target_id:, relationship_type:, **)
                body = { target_id: target_id, relationship_type: relationship_type }
                resp = connection(**).post("/api/now/cmdb/instance/#{class_name}/#{sys_id}/relationships", body)
                { relationship: resp.body['result'] }
              end

              include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                          Legion::Extensions::Helpers.const_defined?(:Lex, false)
            end
          end
        end
      end
    end
  end
end
