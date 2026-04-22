# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Calendar
        module Runners
          module Calendar
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_schedules(sysparm_limit: 100, sysparm_offset: 0,
                               sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/cmn_schedule', params, **)
              { schedules: resp.body['result'] }
            end

            def get_schedule(sys_id:, **)
              resp = get("/api/now/table/cmn_schedule/#{sys_id}", {}, **)
              { schedule: resp.body['result'] }
            end

            def create_schedule(name:, type: 'include', time_zone: nil, **)
              body = { name: name, type: type }
              body[:time_zone] = time_zone if time_zone
              resp = post('/api/now/table/cmn_schedule', body, **)
              { schedule: resp.body['result'] }
            end

            def update_schedule(sys_id:, name: nil, time_zone: nil, **)
              body = {}
              body[:name]      = name if name
              body[:time_zone] = time_zone if time_zone
              resp = patch("/api/now/table/cmn_schedule/#{sys_id}", body, **)
              { schedule: resp.body['result'] }
            end

            def delete_schedule(sys_id:, **)
              resp = delete("/api/now/table/cmn_schedule/#{sys_id}", **)
              { deleted: resp.status == 204, sys_id: sys_id }
            end

            def list_schedule_entries(schedule_sys_id:, sysparm_limit: 100, **)
              params = {
                sysparm_query: "schedule=#{schedule_sys_id}",
                sysparm_limit: sysparm_limit
              }
              resp = get('/api/now/table/cmn_schedule_span', params, **)
              { entries: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
