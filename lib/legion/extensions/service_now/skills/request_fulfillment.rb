# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Skills
        class RequestFulfillment < Legion::LLM::Skills::Base
          skill_name 'servicenow:request_fulfillment'
          namespace  'servicenow'
          description 'Guides through ServiceNow service request fulfillment (RITM workflow)'
          trigger :on_demand
          trigger_words 'RITM', 'request item', 'fulfillment', 'REQ', 'service request fulfillment'

          steps :review_request,
                :assign_fulfiller,
                :fulfill_request,
                :confirm_completion,
                :complete

          def review_request(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Reviewing service request details and variables.',
              metadata: { step: 'review_request' }
            )
          end

          def assign_fulfiller(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Assigning request to appropriate fulfillment group.',
              metadata: { step: 'assign_fulfiller' },
              gate:     :confirm
            )
          end

          def fulfill_request(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Fulfilling the request and updating work notes.',
              metadata: { step: 'fulfill_request' }
            )
          end

          def confirm_completion(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Confirming completion with requester.',
              metadata: { step: 'confirm_completion' },
              gate:     :confirm
            )
          end

          def complete(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Request fulfillment workflow complete.',
              metadata: { step: 'complete' }
            )
          end
        end
      end
    end
  end
end
