# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Skills
        class ApprovalWorkflow < Legion::LLM::Skills::Base
          skill_name 'servicenow:approval_workflow'
          namespace  'servicenow'
          description 'Guides through reviewing and acting on ServiceNow approval requests'
          trigger :on_demand
          trigger_words 'approval', 'approve', 'reject', 'pending approval', 'awaiting approval'

          steps :gather_approval_details,
                :assess_request,
                :make_decision,
                :complete

          def gather_approval_details(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Gathering pending approval details and associated record.',
              metadata: { step: 'gather_approval_details' }
            )
          end

          def assess_request(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Assessing the approval request against policy and risk.',
              metadata: { step: 'assess_request' }
            )
          end

          def make_decision(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Approving or rejecting the request with comments.',
              metadata: { step: 'make_decision' },
              gate:     :confirm
            )
          end

          def complete(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Approval workflow complete.',
              metadata: { step: 'complete' }
            )
          end
        end
      end
    end
  end
end
