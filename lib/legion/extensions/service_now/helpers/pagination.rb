# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Helpers
        module Pagination
          def paginate(method_name, **opts)
            results = []
            offset = 0
            limit = opts.fetch(:sysparm_limit, 100)

            loop do
              response = public_send(method_name, **opts, sysparm_limit: limit, sysparm_offset: offset)
              key = response.keys.first
              batch = response[key]
              break if batch.nil? || batch.empty?

              results.concat(batch)
              break if batch.size < limit

              offset += limit
            end

            results
          end
        end
      end
    end
  end
end
