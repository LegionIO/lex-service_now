# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Aggregate
        module Runners
          module Aggregate
            include Legion::Extensions::ServiceNow::Helpers::Client

            def aggregate(table_name:, sysparm_count: nil, sysparm_sum_fields: nil,
                          sysparm_avg_fields: nil, sysparm_min_fields: nil,
                          sysparm_max_fields: nil, sysparm_query: nil,
                          sysparm_group_by: nil, sysparm_having: nil, **)
              params = {}
              params[:sysparm_count]       = sysparm_count unless sysparm_count.nil?
              params[:sysparm_sum_fields]  = sysparm_sum_fields if sysparm_sum_fields
              params[:sysparm_avg_fields]  = sysparm_avg_fields if sysparm_avg_fields
              params[:sysparm_min_fields]  = sysparm_min_fields if sysparm_min_fields
              params[:sysparm_max_fields]  = sysparm_max_fields if sysparm_max_fields
              params[:sysparm_query]       = sysparm_query if sysparm_query
              params[:sysparm_group_by]    = sysparm_group_by if sysparm_group_by
              params[:sysparm_having]      = sysparm_having if sysparm_having
              resp = connection(**).get("/api/now/stats/#{table_name}", params)
              { stats: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
