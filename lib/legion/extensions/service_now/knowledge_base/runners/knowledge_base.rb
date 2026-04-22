# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module KnowledgeBase
        module Runners
          module KnowledgeBase
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_knowledge_bases(sysparm_limit: 100, sysparm_offset: 0,
                                     sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/kb_knowledge_base', params, **)
              { knowledge_bases: resp.body['result'] }
            end

            def get_knowledge_base(sys_id:, **)
              resp = get("/api/now/table/kb_knowledge_base/#{sys_id}", {}, **)
              { knowledge_base: resp.body['result'] }
            end

            def create_knowledge_base(title:, description: nil, owner: nil,
                                      active: true, **)
              body = { title: title, active: active }
              body[:description] = description if description
              body[:owner]       = owner if owner
              resp = post('/api/now/table/kb_knowledge_base', body, **)
              { knowledge_base: resp.body['result'] }
            end

            def update_knowledge_base(sys_id:, title: nil, description: nil,
                                      active: nil, **)
              body = {}
              body[:title]       = title if title
              body[:description] = description if description
              body[:active]      = active unless active.nil?
              resp = patch("/api/now/table/kb_knowledge_base/#{sys_id}", body, **)
              { knowledge_base: resp.body['result'] }
            end

            def delete_knowledge_base(sys_id:, **)
              resp = delete("/api/now/table/kb_knowledge_base/#{sys_id}", **)
              { deleted: resp.status == 204, sys_id: sys_id }
            end

            def list_kb_categories(knowledge_base_sys_id:, sysparm_limit: 100, **)
              params = {
                sysparm_query: "kb_knowledge_base=#{knowledge_base_sys_id}",
                sysparm_limit: sysparm_limit
              }
              resp = get('/api/now/table/kb_category', params, **)
              { categories: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
