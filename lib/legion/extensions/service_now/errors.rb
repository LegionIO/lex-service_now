# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Errors
        class ServiceNowError < StandardError
          attr_reader :status, :detail

          def initialize(message, status: nil, detail: nil)
            super(message)
            @status = status
            @detail = detail
          end
        end

        class AuthenticationError < ServiceNowError; end
        class AuthorizationError < ServiceNowError; end
        class NotFoundError < ServiceNowError; end
        class UnprocessableError < ServiceNowError; end
        class RateLimitError < ServiceNowError; end
        class ServerError < ServiceNowError; end
      end
    end
  end
end
