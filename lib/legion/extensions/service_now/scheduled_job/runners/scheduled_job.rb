# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module ScheduledJob
        module Runners
          module ScheduledJob
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_scheduled_jobs(sysparm_limit: 100, sysparm_offset: 0,
                                    sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/sysauto_script', params, **)
              { scheduled_jobs: resp.body['result'] }
            end

            def get_scheduled_job(sys_id:, **)
              resp = get("/api/now/table/sysauto_script/#{sys_id}", {}, **)
              { scheduled_job: resp.body['result'] }
            end

            def create_scheduled_job(name:, script:, run_type: 'periodically',
                                     run_period: nil, active: true, **)
              body = { name: name, script: script, run_type: run_type, active: active }
              body[:run_period] = run_period if run_period
              resp = post('/api/now/table/sysauto_script', body, **)
              { scheduled_job: resp.body['result'] }
            end

            def update_scheduled_job(sys_id:, script: nil, active: nil,
                                     run_period: nil, **)
              body = {}
              body[:script]     = script if script
              body[:active]     = active unless active.nil?
              body[:run_period] = run_period if run_period
              resp = patch("/api/now/table/sysauto_script/#{sys_id}", body, **)
              { scheduled_job: resp.body['result'] }
            end

            def delete_scheduled_job(sys_id:, **)
              resp = delete("/api/now/table/sysauto_script/#{sys_id}", **)
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
