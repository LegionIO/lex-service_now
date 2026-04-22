# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module SystemProperty
        module Runners
          module SystemProperty
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_properties(sysparm_limit: 100, sysparm_offset: 0,
                                sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/sys_properties', params, **)
              { properties: resp.body['result'] }
            end

            def get_property(sys_id:, **)
              resp = get("/api/now/table/sys_properties/#{sys_id}", {}, **)
              { property: resp.body['result'] }
            end

            def get_property_by_name(name:, **)
              params = { sysparm_query: "name=#{name}", sysparm_limit: 1 }
              resp = get('/api/now/table/sys_properties', params, **)
              { property: resp.body['result']&.first }
            end

            def create_property(name:, value:, description: nil, type: 'string', **)
              body = { name: name, value: value, type: type }
              body[:description] = description if description
              resp = post('/api/now/table/sys_properties', body, **)
              { property: resp.body['result'] }
            end

            def update_property(sys_id:, value:, **)
              resp = patch("/api/now/table/sys_properties/#{sys_id}", { value: value }, **)
              { property: resp.body['result'] }
            end

            def delete_property(sys_id:, **)
              resp = delete("/api/now/table/sys_properties/#{sys_id}", **)
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
