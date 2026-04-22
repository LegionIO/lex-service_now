# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Approval
        module Runners
          module Approval
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_approvals(sysparm_limit: 100, sysparm_offset: 0, sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/sysapproval_approver', params)
              { approvals: resp.body['result'] }
            end

            def get_approval(sys_id:, **)
              resp = connection(**).get("/api/now/table/sysapproval_approver/#{sys_id}")
              { approval: resp.body['result'] }
            end

            def approve(sys_id:, comments: nil, **)
              body = { state: 'approved' }
              body[:comments] = comments if comments
              resp = connection(**).patch("/api/now/table/sysapproval_approver/#{sys_id}", body)
              { approval: resp.body['result'] }
            end

            def reject(sys_id:, comments: nil, **)
              body = { state: 'rejected' }
              body[:comments] = comments if comments
              resp = connection(**).patch("/api/now/table/sysapproval_approver/#{sys_id}", body)
              { approval: resp.body['result'] }
            end

            def list_approvals_for_record(document_id:, **)
              params = { sysparm_query: "document_id=#{document_id}", sysparm_limit: 100 }
              resp = connection(**).get('/api/now/table/sysapproval_approver', params)
              { approvals: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
