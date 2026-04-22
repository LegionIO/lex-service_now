# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      class Client
        include Helpers::Client
        include Helpers::Pagination
        include Helpers::Retry
        include Change::Runners::Change
        include Cmdb::Instance::Runners::Instance
        include Cmdb::Meta::Runners::Meta
        include Knowledge::Runners::Knowledge
        include ServiceCatalog::Runners::ServiceCatalog
        include Account::Runners::Account
        include Incident::Runners::Incident
        include Problem::Runners::Problem
        include Attachment::Runners::Attachment
        include Table::Runners::Table
        include Aggregate::Runners::Aggregate
        include User::Runners::User
        include UserGroup::Runners::UserGroup
        include Request::Runners::Request
        include Approval::Runners::Approval
        include Task::Runners::Task
        include Sla::Runners::Sla
        include ImportSet::Runners::ImportSet
        include Event::Runners::Event
        include PerformanceAnalytics::Runners::PerformanceAnalytics
        include Flow::Runners::Flow
        include Notification::Runners::Notification
        include EmailLog::Runners::EmailLog
        include Audit::Runners::Audit
        include SystemProperty::Runners::SystemProperty
        include Asset::Runners::Asset
        include Location::Runners::Location
        include Department::Runners::Department
        include Company::Runners::Company
        include Project::Runners::Project
        include Release::Runners::Release
        include HrCase::Runners::HrCase
        include SecurityIncident::Runners::SecurityIncident
        include UpdateSet::Runners::UpdateSet
        include ScriptInclude::Runners::ScriptInclude
        include BusinessRule::Runners::BusinessRule
        include ScheduledJob::Runners::ScheduledJob
        include OnCall::Runners::OnCall
        include Survey::Runners::Survey
        include Contract::Runners::Contract
        include CostCenter::Runners::CostCenter
        include WorkOrder::Runners::WorkOrder
        include Discovery::Runners::Discovery
        include MidServer::Runners::MidServer
        include CatalogVariable::Runners::CatalogVariable
        include Workflow::Runners::Workflow
        include Vendor::Runners::Vendor
        include CiRelationship::Runners::CiRelationship
        include ScriptAction::Runners::ScriptAction
        include UiPolicy::Runners::UiPolicy
        include UiAction::Runners::UiAction
        include AccessControl::Runners::AccessControl
        include CatalogTask::Runners::CatalogTask
        include KnowledgeBase::Runners::KnowledgeBase
        include Tag::Runners::Tag
        include Metric::Runners::Metric
        include Currency::Runners::Currency
        include Calendar::Runners::Calendar
        include KnowledgeFeedback::Runners::KnowledgeFeedback
        include License::Runners::License
        include DeprecationLog::Runners::DeprecationLog
        include CmdbHealth::Runners::CmdbHealth
        include ServicePortal::Runners::ServicePortal
        include Grc::Runners::Grc
        include Csm::Runners::Csm
        include IntegrationHub::Runners::IntegrationHub

        attr_reader :opts

        def initialize(url: nil, client_id: nil, client_secret: nil,
                       token: nil, username: nil, password: nil, **extra)
          @opts = {
            url:           url,
            client_id:     client_id,
            client_secret: client_secret,
            token:         token,
            username:      username,
            password:      password,
            **extra
          }.compact
        end

        def connection(**override)
          super(**@opts, **override)
        end
      end
    end
  end
end
