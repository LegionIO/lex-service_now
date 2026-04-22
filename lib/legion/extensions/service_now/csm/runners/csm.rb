# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Csm
        module Runners
          module Csm
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_csm_cases(sysparm_limit: 100, sysparm_offset: 0,
                               sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/sn_customerservice_case', params)
              { cases: resp.body['result'] }
            end

            def get_csm_case(sys_id:, **)
              resp = connection(**).get("/api/now/table/sn_customerservice_case/#{sys_id}")
              { csm_case: resp.body['result'] }
            end

            def create_csm_case(subject:, account: nil, contact: nil,
                                priority: '4', description: nil, **)
              body = { subject: subject, priority: priority }
              body[:account]     = account if account
              body[:contact]     = contact if contact
              body[:description] = description if description
              resp = connection(**).post('/api/now/table/sn_customerservice_case', body)
              { csm_case: resp.body['result'] }
            end

            def update_csm_case(sys_id:, state: nil, assigned_to: nil,
                                resolution_notes: nil, **)
              body = {}
              body[:state]            = state if state
              body[:assigned_to]      = assigned_to if assigned_to
              body[:resolution_notes] = resolution_notes if resolution_notes
              resp = connection(**).patch("/api/now/table/sn_customerservice_case/#{sys_id}", body)
              { csm_case: resp.body['result'] }
            end

            def list_contacts(sysparm_limit: 100, sysparm_offset: 0,
                              account: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = "account=#{account}" if account
              resp = connection(**).get('/api/now/table/customer_contact', params)
              { contacts: resp.body['result'] }
            end

            def get_contact(sys_id:, **)
              resp = connection(**).get("/api/now/table/customer_contact/#{sys_id}")
              { contact: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
