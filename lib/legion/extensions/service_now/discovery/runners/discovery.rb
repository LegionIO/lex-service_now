# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Discovery
        module Runners
          module Discovery
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_discovery_schedules(sysparm_limit: 100, sysparm_offset: 0,
                                         sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/discovery_schedule', params, **)
              { schedules: resp.body['result'] }
            end

            def get_discovery_schedule(sys_id:, **)
              resp = get("/api/now/table/discovery_schedule/#{sys_id}", {}, **)
              { schedule: resp.body['result'] }
            end

            def trigger_discovery(schedule_sys_id:, **)
              body = { schedule_sys_id: schedule_sys_id }
              resp = post('/api/now/table/discovery_log', body, **)
              { result: resp.body['result'] }
            end

            def list_discovery_logs(sysparm_limit: 100, sysparm_offset: 0,
                                    sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/discovery_log', params, **)
              { logs: resp.body['result'] }
            end

            def list_discovered_devices(sysparm_limit: 100, sysparm_offset: 0,
                                        sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/cmdb_ci', params, **)
              { devices: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
