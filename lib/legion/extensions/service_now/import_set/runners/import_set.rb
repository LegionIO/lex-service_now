# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module ImportSet
        module Runners
          module ImportSet
            include Legion::Extensions::ServiceNow::Helpers::Client

            def import(table_name:, payload:, **)
              resp = connection(**).post("/api/now/import/#{table_name}", payload)
              { result: resp.body['result'] }
            end

            def import_multiple(table_name:, records:, **)
              results = records.map do |record|
                resp = connection(**).post("/api/now/import/#{table_name}", record)
                resp.body['result']
              end
              { results: results }
            end

            include Legion::Extensions::Helpers::Lex if Legion::Extensions.const_defined?(:Helpers, false) &&
                                                        Legion::Extensions::Helpers.const_defined?(:Lex, false)
          end
        end
      end
    end
  end
end
