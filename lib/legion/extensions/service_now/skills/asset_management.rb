# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      module Skills
        class AssetManagement < Legion::LLM::Skills::Base
          skill_name 'servicenow:asset_management'
          namespace  'servicenow'
          description 'Guides through ServiceNow asset lifecycle management'
          trigger :on_demand
          trigger_words 'asset', 'hardware', 'inventory', 'ALM', 'asset lifecycle', 'serial number'

          steps :identify_asset,
                :review_asset_details,
                :update_asset_state,
                :complete

          def identify_asset(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Identifying asset by serial number, tag, or CI record.',
              metadata: { step: 'identify_asset' },
              gate:     :confirm
            )
          end

          def review_asset_details(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Reviewing asset details: model, assignee, location, and lifecycle state.',
              metadata: { step: 'review_asset_details' }
            )
          end

          def update_asset_state(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Updating asset state, assignment, or location.',
              metadata: { step: 'update_asset_state' },
              gate:     :confirm
            )
          end

          def complete(context: {}) # rubocop:disable Lint/UnusedMethodArgument
            Legion::LLM::Skills::StepResult.new(
              inject:   'Asset management workflow complete.',
              metadata: { step: 'complete' }
            )
          end
        end
      end
    end
  end
end
