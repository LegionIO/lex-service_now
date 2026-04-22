# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module CatalogVariable
        module Runners
          module CatalogVariable
            include Legion::Extensions::ServiceNow::Helpers::Client

            def list_catalog_variables(cat_item_sys_id:, sysparm_limit: 100, **)
              params = {
                sysparm_query: "cat_item=#{cat_item_sys_id}",
                sysparm_limit: sysparm_limit
              }
              resp = get('/api/now/table/item_option_new', params, **)
              { variables: resp.body['result'] }
            end

            def get_catalog_variable(sys_id:, **)
              resp = get("/api/now/table/item_option_new/#{sys_id}", {}, **)
              { variable: resp.body['result'] }
            end

            def create_catalog_variable(cat_item:, name:, question_text:,
                                        type: '6', mandatory: false, **)
              body = {
                cat_item:      cat_item,
                name:          name,
                question_text: question_text,
                type:          type,
                mandatory:     mandatory
              }
              resp = post('/api/now/table/item_option_new', body, **)
              { variable: resp.body['result'] }
            end

            def update_catalog_variable(sys_id:, question_text: nil, mandatory: nil,
                                        active: nil, **)
              body = {}
              body[:question_text] = question_text if question_text
              body[:mandatory]     = mandatory unless mandatory.nil?
              body[:active]        = active unless active.nil?
              resp = patch("/api/now/table/item_option_new/#{sys_id}", body, **)
              { variable: resp.body['result'] }
            end

            def delete_catalog_variable(sys_id:, **)
              resp = delete("/api/now/table/item_option_new/#{sys_id}", **)
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
