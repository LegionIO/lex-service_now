# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module CiRelationship
        module Runners
          module CiRelationship
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_relationship_types(sysparm_limit: 100, sysparm_offset: 0, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              resp = get('/api/now/table/cmdb_rel_type', params, **)
              { relationship_types: resp.body['result'] }
            end

            def get_relationship_type(sys_id:, **)
              resp = get("/api/now/table/cmdb_rel_type/#{sys_id}", {}, **)
              { relationship_type: resp.body['result'] }
            end

            def list_ci_relationships(sysparm_limit: 100, sysparm_offset: 0,
                                      parent: nil, child: nil, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              query_parts = []
              query_parts << "parent=#{parent}" if parent
              query_parts << "child=#{child}" if child
              query_parts << sysparm_query if sysparm_query
              params[:sysparm_query] = query_parts.join('^') unless query_parts.empty?
              resp = get('/api/now/table/cmdb_rel_ci', params, **)
              { relationships: resp.body['result'] }
            end

            def create_ci_relationship(parent:, child:, type:, **)
              body = { parent: parent, child: child, type: type }
              resp = post('/api/now/table/cmdb_rel_ci', body, **)
              { relationship: resp.body['result'] }
            end

            def delete_ci_relationship(sys_id:, **)
              resp = delete("/api/now/table/cmdb_rel_ci/#{sys_id}", **)
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
