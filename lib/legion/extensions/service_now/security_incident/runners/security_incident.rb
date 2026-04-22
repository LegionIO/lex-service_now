# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module SecurityIncident
        module Runners
          module SecurityIncident
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_security_incidents(sysparm_limit: 100, sysparm_offset: 0,
                                        sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = get('/api/now/table/sn_si_incident', params, **)
              { security_incidents: resp.body['result'] }
            end

            def get_security_incident(sys_id:, **)
              resp = get("/api/now/table/sn_si_incident/#{sys_id}", {}, **)
              { security_incident: resp.body['result'] }
            end

            def create_security_incident(short_description:, severity: '3',
                                         category: nil, subcategory: nil,
                                         assignment_group: nil, **)
              body = { short_description: short_description, severity: severity }
              body[:category]         = category if category
              body[:subcategory]      = subcategory if subcategory
              body[:assignment_group] = assignment_group if assignment_group
              resp = post('/api/now/table/sn_si_incident', body, **)
              { security_incident: resp.body['result'] }
            end

            def update_security_incident(sys_id:, state: nil, severity: nil,
                                         assigned_to: nil, **)
              body = {}
              body[:state]       = state if state
              body[:severity]    = severity if severity
              body[:assigned_to] = assigned_to if assigned_to
              resp = patch("/api/now/table/sn_si_incident/#{sys_id}", body, **)
              { security_incident: resp.body['result'] }
            end

            def close_security_incident(sys_id:, close_notes:, **)
              body = { state: 'closed', close_notes: close_notes }
              resp = patch("/api/now/table/sn_si_incident/#{sys_id}", body, **)
              { security_incident: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
