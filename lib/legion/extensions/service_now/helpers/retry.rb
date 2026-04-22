# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Helpers
        module Retry
          MAX_RETRIES = 3
          BASE_DELAY  = 1.0

          def with_retry(max_retries: MAX_RETRIES)
            attempts = 0
            begin
              attempts += 1
              yield
            rescue Errors::RateLimitError => e
              raise e if attempts >= max_retries

              sleep(BASE_DELAY * (2**(attempts - 1)))
              retry
            rescue Errors::ServerError => e
              raise e if attempts >= max_retries

              sleep(BASE_DELAY)
              retry
            end
          end
        end
      end
    end
  end
end
