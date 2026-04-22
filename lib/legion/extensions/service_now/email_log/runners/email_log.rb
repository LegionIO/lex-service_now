# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module EmailLog
        module Runners
          module EmailLog
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_email_logs(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/sys_email', params)
              { email_logs: resp.body['result'] }
            end

            def get_email_log(sys_id:, **)
              resp = connection(**).get("/api/now/table/sys_email/#{sys_id}")
              { email_log: resp.body['result'] }
            end

            def list_email_logs_for_record(target_table:, target_sys_id:,
                                           sysparm_limit: 100, **)
              query = "target_table=#{target_table}^target_sys_id=#{target_sys_id}"
              params = { sysparm_query: query, sysparm_limit: sysparm_limit }
              resp = connection(**).get('/api/now/table/sys_email', params)
              { email_logs: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
