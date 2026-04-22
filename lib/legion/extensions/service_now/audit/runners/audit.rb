# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Audit
        module Runners
          module Audit
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_audit_records(sysparm_limit: 100, sysparm_offset: 0,
                                   sysparm_query: nil, tablename: nil,
                                   documentkey: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              if tablename && documentkey
                params[:sysparm_query] = "tablename=#{tablename}^documentkey=#{documentkey}"
              elsif sysparm_query
                params[:sysparm_query] = sysparm_query
              end
              resp = connection(**).get('/api/now/table/sys_audit', params)
              { audit_records: resp.body['result'] }
            end

            def get_audit_record(sys_id:, **)
              resp = connection(**).get("/api/now/table/sys_audit/#{sys_id}")
              { audit_record: resp.body['result'] }
            end

            def list_field_changes(tablename:, documentkey:, fieldname: nil,
                                   sysparm_limit: 100, **)
              query = "tablename=#{tablename}^documentkey=#{documentkey}"
              query += "^fieldname=#{fieldname}" if fieldname
              params = { sysparm_query: query, sysparm_limit: sysparm_limit }
              resp = connection(**).get('/api/now/table/sys_audit', params)
              { field_changes: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
