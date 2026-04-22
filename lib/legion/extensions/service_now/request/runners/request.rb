# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Request
        module Runners
          module Request
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_requests(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil,
                              sysparm_fields: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query]  = sysparm_query if sysparm_query
              params[:sysparm_fields] = sysparm_fields if sysparm_fields
              resp = get('/api/now/table/sc_request', params, **)
              { requests: resp.body['result'] }
            end

            def get_request(sys_id:, **)
              resp = get("/api/now/table/sc_request/#{sys_id}", {}, **)
              { request: resp.body['result'] }
            end

            def update_request(sys_id:, state: nil, stage: nil, special_instructions: nil, **)
              body = {}
              body[:state]                = state if state
              body[:stage]                = stage if stage
              body[:special_instructions] = special_instructions if special_instructions
              resp = patch("/api/now/table/sc_request/#{sys_id}", body, **)
              { request: resp.body['result'] }
            end

            def list_request_items(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/sc_req_item', params, **)
              { request_items: resp.body['result'] }
            end

            def get_request_item(sys_id:, **)
              resp = get("/api/now/table/sc_req_item/#{sys_id}", {}, **)
              { request_item: resp.body['result'] }
            end

            def update_request_item(sys_id:, state: nil, stage: nil, assigned_to: nil, **)
              body = {}
              body[:state]       = state if state
              body[:stage]       = stage if stage
              body[:assigned_to] = assigned_to if assigned_to
              resp = patch("/api/now/table/sc_req_item/#{sys_id}", body, **)
              { request_item: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
