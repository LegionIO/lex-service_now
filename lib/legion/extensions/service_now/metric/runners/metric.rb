# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Metric
        module Runners
          module Metric
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_metric_definitions(sysparm_limit: 100, sysparm_offset: 0,
                                        sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/metric_definition', params)
              { metric_definitions: resp.body['result'] }
            end

            def get_metric_definition(sys_id:, **)
              resp = connection(**).get("/api/now/table/metric_definition/#{sys_id}")
              { metric_definition: resp.body['result'] }
            end

            def list_metric_instances(metric_sys_id: nil, table: nil,
                                      sysparm_limit: 100, sysparm_offset: 0, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              query_parts = []
              query_parts << "metric_definition=#{metric_sys_id}" if metric_sys_id
              query_parts << "table=#{table}" if table
              params[:sysparm_query] = query_parts.join('^') unless query_parts.empty?
              resp = connection(**).get('/api/now/table/metric_instance', params)
              { metric_instances: resp.body['result'] }
            end

            def get_metric_instance(sys_id:, **)
              resp = connection(**).get("/api/now/table/metric_instance/#{sys_id}")
              { metric_instance: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
