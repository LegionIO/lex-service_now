# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module MidServer
        module Runners
          module MidServer
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_mid_servers(sysparm_limit: 100, sysparm_offset: 0,
                                 sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/ecc_agent', params, **)
              { mid_servers: resp.body['result'] }
            end

            def get_mid_server(sys_id:, **)
              resp = get("/api/now/table/ecc_agent/#{sys_id}", {}, **)
              { mid_server: resp.body['result'] }
            end

            def get_mid_server_by_name(name:, **)
              params = { sysparm_query: "name=#{name}", sysparm_limit: 1 }
              resp = get('/api/now/table/ecc_agent', params, **)
              { mid_server: resp.body['result']&.first }
            end

            def update_mid_server(sys_id:, status: nil, validated: nil, **)
              body = {}
              body[:status]    = status if status
              body[:validated] = validated unless validated.nil?
              resp = patch("/api/now/table/ecc_agent/#{sys_id}", body, **)
              { mid_server: resp.body['result'] }
            end

            def list_mid_server_capabilities(mid_server_sys_id:, **)
              params = {
                sysparm_query: "agent=#{mid_server_sys_id}",
                sysparm_limit: 100
              }
              resp = get('/api/now/table/ecc_agent_capability_m2m', params, **)
              { capabilities: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
