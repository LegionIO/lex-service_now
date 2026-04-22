# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Skills
        class ServiceCatalog < Legion::LLM::Skills::Base
          skill_name 'servicenow:service_catalog'
          namespace  'servicenow'
          description 'Guides through ServiceNow service catalog browsing and request ordering'
          trigger :on_demand
          trigger_words 'catalog', 'service request', 'order', 'request item', 'service catalog'

          steps :browse_catalog,
                :select_item,
                :configure_request,
                :submit_order,
                :complete

          def browse_catalog(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Browsing ServiceNow service catalog.',
              metadata: { step: 'browse_catalog' }
            )
          end

          def select_item(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Which catalog item would you like to request?',
              metadata: { step: 'select_item' },
              gate:     :confirm
            )
          end

          def configure_request(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Configuring request variables and quantity.',
              metadata: { step: 'configure_request' },
              gate:     :confirm
            )
          end

          def submit_order(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Submitting service catalog order.',
              metadata: { step: 'submit_order' }
            )
          end

          def complete(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Service catalog request submitted.',
              metadata: { step: 'complete' }
            )
          end
        end
      end
    end
  end
end
