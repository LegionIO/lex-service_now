# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module KnowledgeFeedback
        module Runners
          module KnowledgeFeedback
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_knowledge_feedback(sysparm_limit: 100, sysparm_offset: 0,
                                        article: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = "article=#{article}" if article
              resp = get('/api/now/table/kb_feedback', params, **)
              { feedback: resp.body['result'] }
            end

            def get_knowledge_feedback(sys_id:, **)
              resp = get("/api/now/table/kb_feedback/#{sys_id}", {}, **)
              { feedback: resp.body['result'] }
            end

            def create_knowledge_feedback(article:, rating:, comments: nil, **)
              body = { article: article, rating: rating }
              body[:comments] = comments if comments
              resp = post('/api/now/table/kb_feedback', body, **)
              { feedback: resp.body['result'] }
            end

            def list_knowledge_views(article: nil, sysparm_limit: 100, **)
              params = { sysparm_limit: sysparm_limit }
              params[:sysparm_query] = "article=#{article}" if article
              resp = get('/api/now/table/kb_view', params, **)
              { views: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
