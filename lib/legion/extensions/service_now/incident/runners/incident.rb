# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Incident
        module Runners
          module Incident
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_incidents(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil,
                               sysparm_fields: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query]  = sysparm_query if sysparm_query
              params[:sysparm_fields] = sysparm_fields if sysparm_fields
              resp = connection(**).get('/api/now/table/incident', params)
              { incidents: resp.body['result'] }
            end

            def get_incident(sys_id:, sysparm_fields: nil, **)
              params = {}
              params[:sysparm_fields] = sysparm_fields if sysparm_fields
              resp = connection(**).get("/api/now/table/incident/#{sys_id}", params)
              { incident: resp.body['result'] }
            end

            def create_incident(short_description:, urgency: nil, impact: nil, category: nil,
                                subcategory: nil, assignment_group: nil, assigned_to: nil,
                                description: nil, caller_id: nil, **)
              body = { short_description: short_description }
              body[:urgency]          = urgency if urgency
              body[:impact]           = impact if impact
              body[:category]         = category if category
              body[:subcategory]      = subcategory if subcategory
              body[:assignment_group] = assignment_group if assignment_group
              body[:assigned_to]      = assigned_to if assigned_to
              body[:description]      = description if description
              body[:caller_id]        = caller_id if caller_id
              resp = connection(**).post('/api/now/table/incident', body)
              { incident: resp.body['result'] }
            end

            def update_incident(sys_id:, short_description: nil, urgency: nil, impact: nil,
                                state: nil, close_code: nil, close_notes: nil,
                                assignment_group: nil, assigned_to: nil, **)
              body = {}
              body[:short_description] = short_description if short_description
              body[:urgency]           = urgency if urgency
              body[:impact]            = impact if impact
              body[:state]             = state if state
              body[:close_code]        = close_code if close_code
              body[:close_notes]       = close_notes if close_notes
              body[:assignment_group]  = assignment_group if assignment_group
              body[:assigned_to]       = assigned_to if assigned_to
              resp = connection(**).patch("/api/now/table/incident/#{sys_id}", body)
              { incident: resp.body['result'] }
            end

            def resolve_incident(sys_id:, close_code:, close_notes:, **)
              body = { state: '6', close_code: close_code, close_notes: close_notes }
              resp = connection(**).patch("/api/now/table/incident/#{sys_id}", body)
              { incident: resp.body['result'] }
            end

            def delete_incident(sys_id:, **)
              resp = connection(**).delete("/api/now/table/incident/#{sys_id}")
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
