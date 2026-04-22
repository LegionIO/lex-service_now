# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module License
        module Runners
          module License
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_licenses(sysparm_limit: 100, sysparm_offset: 0, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              resp = connection(**).get('/api/now/table/license_agreement', params)
              { licenses: resp.body['result'] }
            end

            def get_license(sys_id:, **)
              resp = connection(**).get("/api/now/table/license_agreement/#{sys_id}")
              { license: resp.body['result'] }
            end

            def list_license_allocations(license_sys_id: nil, sysparm_limit: 100, **)
              params = { sysparm_limit: sysparm_limit }
              params[:sysparm_query] = "license_agreement=#{license_sys_id}" if license_sys_id
              resp = connection(**).get('/api/now/table/license_allocation', params)
              { allocations: resp.body['result'] }
            end

            def list_installed_software(sysparm_limit: 100, sysparm_offset: 0,
                                        sysparm_query: nil, **)
              params = { sysparm_limit: sysparm_limit, sysparm_offset: sysparm_offset }
              params[:sysparm_query] = sysparm_query if sysparm_query
              resp = connection(**).get('/api/now/table/cmdb_sam_sw_install', params)
              { installations: resp.body['result'] }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
