# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module CmdbHealth
        module Runners
          module CmdbHealth
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_health_rules(sysparm_limit: 100, sysparm_offset: 0, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              resp = get('/api/now/table/sa_m2m_suggested_relationship', params, **)
              { health_rules: resp.body['result'] }
            end

            def get_cmdb_health_dashboard(**)
              resp = get('/api/now/cmdb/health_dashboard', {}, **)
              { dashboard: resp.body['result'] }
            end

            def list_duplicate_cis(class_name:, sysparm_limit: 100, **)
              params = {
                sysparm_query: "sys_class_name=#{class_name}",
                sysparm_limit: sysparm_limit
              }
              resp = get('/api/now/table/cmdb_duplicate', params, **)
              { duplicates: resp.body['result'] }
            end

            def list_stale_cis(class_name:, days_since_discovery: 30, **)
              cutoff = (::Time.now - (days_since_discovery * 86_400)).strftime('%Y-%m-%d %H:%M:%S')
              params = {
                sysparm_query: "sys_class_name=#{class_name}^last_discovered<#{cutoff}",
                sysparm_limit: 100
              }
              resp = get('/api/now/table/cmdb_ci', params, **)
              { stale_cis: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
