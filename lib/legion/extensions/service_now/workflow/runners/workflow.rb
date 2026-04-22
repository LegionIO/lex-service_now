# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Workflow
        module Runners
          module Workflow
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_workflows(sysparm_limit: 100, sysparm_offset: 0,
                               sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/wf_workflow', params, **)
              { workflows: resp.body['result'] }
            end

            def get_workflow(sys_id:, **)
              resp = get("/api/now/table/wf_workflow/#{sys_id}", {}, **)
              { workflow: resp.body['result'] }
            end

            def list_workflow_contexts(sysparm_limit: 100, sysparm_offset: 0,
                                       sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/wf_context', params, **)
              { contexts: resp.body['result'] }
            end

            def get_workflow_context(sys_id:, **)
              resp = get("/api/now/table/wf_context/#{sys_id}", {}, **)
              { context: resp.body['result'] }
            end

            def list_workflow_contexts_for_record(table:, sys_id:, **)
              params = {
                sysparm_query: "table_name=#{table}^id=#{sys_id}",
                sysparm_limit: 100
              }
              resp = get('/api/now/table/wf_context', params, **)
              { contexts: resp.body['result'] }
            end

            def cancel_workflow_context(sys_id:, **)
              body = { state: 'cancelled' }
              resp = patch("/api/now/table/wf_context/#{sys_id}", body, **)
              { context: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
