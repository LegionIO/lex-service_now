# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module HrCase
        module Runners
          module HrCase
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_hr_cases(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/sn_hr_core_case', params)
              { hr_cases: resp.body['result'] }
            end

            def get_hr_case(sys_id:, **)
              resp = connection(**).get("/api/now/table/sn_hr_core_case/#{sys_id}")
              { hr_case: resp.body['result'] }
            end

            def create_hr_case(subject:, opened_for:, hr_service: nil,
                               description: nil, **)
              body = { subject: subject, opened_for: opened_for }
              body[:hr_service]  = hr_service if hr_service
              body[:description] = description if description
              resp = connection(**).post('/api/now/table/sn_hr_core_case', body)
              { hr_case: resp.body['result'] }
            end

            def update_hr_case(sys_id:, state: nil, assignment_group: nil,
                               assigned_to: nil, **)
              body = {}
              body[:state]            = state if state
              body[:assignment_group] = assignment_group if assignment_group
              body[:assigned_to]      = assigned_to if assigned_to
              resp = connection(**).patch("/api/now/table/sn_hr_core_case/#{sys_id}", body)
              { hr_case: resp.body['result'] }
            end

            def close_hr_case(sys_id:, close_notes:, **)
              body = { state: 'closed', close_notes: close_notes }
              resp = connection(**).patch("/api/now/table/sn_hr_core_case/#{sys_id}", body)
              { hr_case: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
