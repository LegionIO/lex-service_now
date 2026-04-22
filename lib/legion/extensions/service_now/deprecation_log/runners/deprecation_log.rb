# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module DeprecationLog
        module Runners
          module DeprecationLog
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_upgrade_logs(sysparm_limit: 100, sysparm_offset: 0, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              resp = get('/api/now/table/sys_upgrade_history', params, **)
              { upgrade_logs: resp.body['result'] }
            end

            def get_upgrade_log(sys_id:, **)
              resp = get("/api/now/table/sys_upgrade_history/#{sys_id}", {}, **)
              { upgrade_log: resp.body['result'] }
            end

            def list_upgrade_skips(sysparm_limit: 100, **)
              params = { sysparm_limit: sysparm_limit }
              resp = get('/api/now/table/sys_upgrade_skip', params, **)
              { upgrade_skips: resp.body['result'] }
            end

            def list_deprecation_entries(sysparm_limit: 100, sysparm_offset: 0,
                                         sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/sys_deprecation_log', params, **)
              { deprecation_entries: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
