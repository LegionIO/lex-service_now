# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module PerformanceAnalytics
        module Runners
          module PerformanceAnalytics
            include Legion::Extensions::ServiceNow::Helpers::Client

            def get_widget_data(widget_sys_id:, sysparm_uuid: nil, **)
              params = {}
              params[:sysparm_uuid] = sysparm_uuid if sysparm_uuid
              resp = connection(**).get("/api/now/pa/widgets/#{widget_sys_id}", params)
              { widget: resp.body['result'] }
            end

            def list_widgets(sysparm_limit: 100, sysparm_offset: 0, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              resp = connection(**).get('/api/now/pa/widgets', params)
              { widgets: resp.body['result'] }
            end

            def get_scorecard(indicator_sys_id:, sysparm_breakdown: nil,
                              sysparm_include_scores: true, sysparm_per_page: 10, **)
              params = { sysparm_include_scores: sysparm_include_scores,
                         sysparm_per_page:       sysparm_per_page }
              params[:sysparm_breakdown] = sysparm_breakdown if sysparm_breakdown
              resp = connection(**).get("/api/now/pa/scorecards/#{indicator_sys_id}", params)
              { scorecard: resp.body['result'] }
            end

            def list_indicators(sysparm_limit: 100, sysparm_offset: 0, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              resp = connection(**).get('/api/now/pa/indicators', params)
              { indicators: resp.body['result'] }
            end

            def list_breakdowns(**)
              resp = connection(**).get('/api/now/pa/breakdowns')
              { breakdowns: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
