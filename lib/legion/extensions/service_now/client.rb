# frozen_string_literal: true

module Legion
  module Extensions
    module ServiceNow
      class Client
        include Helpers::Client
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
