# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Grc
        module Runners
          module Grc
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_risks(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/sn_risk_risk', params)
              { risks: resp.body['result'] }
            end

            def get_risk(sys_id:, **)
              resp = connection(**).get("/api/now/table/sn_risk_risk/#{sys_id}")
              { risk: resp.body['result'] }
            end

            def list_controls(sysparm_limit: 100, sysparm_offset: 0,
                              sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/sn_compliance_control', params)
              { controls: resp.body['result'] }
            end

            def get_control(sys_id:, **)
              resp = connection(**).get("/api/now/table/sn_compliance_control/#{sys_id}")
              { control: resp.body['result'] }
            end

            def list_audits(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/sn_audit_engagement', params)
              { audits: resp.body['result'] }
            end

            def get_audit(sys_id:, **)
              resp = connection(**).get("/api/now/table/sn_audit_engagement/#{sys_id}")
              { audit: resp.body['result'] }
            end

            def list_policies(sysparm_limit: 100, sysparm_offset: 0, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              resp = connection(**).get('/api/now/table/sn_policy_m2m_policy_exception', params)
              { policies: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
