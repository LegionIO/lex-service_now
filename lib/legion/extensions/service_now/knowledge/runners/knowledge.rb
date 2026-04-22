# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Knowledge
        module Runners
          module Knowledge
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_articles(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/sn_km_api/knowledge', params)
              { articles: resp.body['result'] }
            end

            def get_article(sys_id:, **)
              resp = connection(**).get("/api/sn_km_api/knowledge/#{sys_id}")
              { article: resp.body['result'] }
            end

            def create_article(short_description:, text: nil, knowledge_base: nil, **)
              body = { short_description: short_description }
              body[:text]           = text if text
              body[:knowledge_base] = knowledge_base if knowledge_base
              resp = connection(**).post('/api/sn_km_api/knowledge', body)
              { article: resp.body['result'] }
            end

            def update_article(sys_id:, short_description: nil, text: nil, **)
              body = {}
              body[:short_description] = short_description if short_description
              body[:text]              = text if text
              resp = connection(**).patch("/api/sn_km_api/knowledge/#{sys_id}", body)
              { article: resp.body['result'] }
            end

            def delete_article(sys_id:, **)
              resp = connection(**).delete("/api/sn_km_api/knowledge/#{sys_id}")
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
