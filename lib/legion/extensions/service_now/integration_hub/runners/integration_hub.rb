# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module IntegrationHub
        module Runners
          module IntegrationHub
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_spokes(sysparm_limit: 100, sysparm_offset: 0, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              resp = get('/api/now/table/sys_hub_action_type_definition', params, **)
              { spokes: resp.body['result'] }
            end

            def list_action_types(sysparm_limit: 100, sysparm_offset: 0,
                                  sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/sys_hub_action_type_definition', params, **)
              { action_types: resp.body['result'] }
            end

            def list_connections(sysparm_limit: 100, sysparm_offset: 0, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              resp = get('/api/now/table/sys_connection', params, **)
              { connections: resp.body['result'] }
            end

            def get_connection(sys_id:, **)
              resp = get("/api/now/table/sys_connection/#{sys_id}", {}, **)
              { connection: resp.body['result'] }
            end

            def list_credentials(sysparm_limit: 100, sysparm_offset: 0, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              resp = get('/api/now/table/discovery_credential', params, **)
              { credentials: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
