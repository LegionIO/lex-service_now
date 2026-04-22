# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Flow
        module Runners
          module Flow
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_flows(sysparm_limit: 100, sysparm_offset: 0, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              resp = get('/api/sn_fd/flow', params, **)
              { flows: resp.body['result'] }
            end

            def get_flow(sys_id:, **)
              resp = get("/api/sn_fd/flow/#{sys_id}", {}, **)
              { flow: resp.body['result'] }
            end

            def execute_flow(sys_id:, inputs: {}, **)
              body = { inputs: inputs }
              resp = post("/api/sn_fd/flow/#{sys_id}/execute", body, **)
              { execution: resp.body['result'] }
            end

            def get_flow_execution(execution_id:, **)
              resp = get("/api/sn_fd/flow_execution/#{execution_id}", {}, **)
              { execution: resp.body['result'] }
            end

            def list_subflows(sysparm_limit: 100, sysparm_offset: 0, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              resp = get('/api/sn_fd/subflow', params, **)
              { subflows: resp.body['result'] }
            end

            def execute_subflow(sys_id:, inputs: {}, **)
              body = { inputs: inputs }
              resp = post("/api/sn_fd/subflow/#{sys_id}/execute", body, **)
              { execution: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
