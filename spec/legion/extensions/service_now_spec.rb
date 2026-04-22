# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Legion::Extensions::ServiceNow do
  it 'is defined' do
    expect(described_class).to be_a(Module)
  end

  describe Legion::Extensions::ServiceNow::Client do
    let(:client) do
      described_class.new(
        url:      'https://test.service-now.com',
        username: 'admin',
        password: 'secret'
      )
    end

    it 'instantiates with credentials' do
      expect(client).to be_a(described_class)
    end

    it 'stores opts compactly without nil values' do
      expect(client.opts[:url]).to eq('https://test.service-now.com')
      expect(client.opts[:username]).to eq('admin')
      expect(client.opts.keys).not_to include(:client_id)
      expect(client.opts.keys).not_to include(:token)
    end

    it 'instantiates with OAuth2 credentials' do
      c = described_class.new(
        url: 'https://test.service-now.com', client_id: 'cid', client_secret: 'csecret'
      )
      expect(c.opts[:client_id]).to eq('cid')
      expect(c.opts[:client_secret]).to eq('csecret')
    end

    it 'instantiates with bearer token' do
      c = described_class.new(url: 'https://test.service-now.com', token: 'tok')
      expect(c.opts[:token]).to eq('tok')
    end

    # ITSM
    it 'includes Change runner' do
      expect(client).to respond_to(:list_changes)
      expect(client).to respond_to(:create_normal)
      expect(client).to respond_to(:create_emergency)
      expect(client).to respond_to(:create_standard)
      expect(client).to respond_to(:get_change)
      expect(client).to respond_to(:update_change)
      expect(client).to respond_to(:delete_change)
      expect(client).to respond_to(:list_change_tasks)
      expect(client).to respond_to(:create_change_task)
      expect(client).to respond_to(:update_change_task)
      expect(client).to respond_to(:delete_change_task)
      expect(client).to respond_to(:get_conflicts)
      expect(client).to respond_to(:calculate_conflicts)
      expect(client).to respond_to(:get_approvals)
    end

    it 'includes Incident runner' do
      expect(client).to respond_to(:list_incidents)
      expect(client).to respond_to(:get_incident)
      expect(client).to respond_to(:create_incident)
      expect(client).to respond_to(:update_incident)
      expect(client).to respond_to(:resolve_incident)
      expect(client).to respond_to(:delete_incident)
    end

    it 'includes Problem runner' do
      expect(client).to respond_to(:list_problems)
      expect(client).to respond_to(:get_problem)
      expect(client).to respond_to(:create_problem)
      expect(client).to respond_to(:update_problem)
      expect(client).to respond_to(:close_problem)
      expect(client).to respond_to(:delete_problem)
    end

    it 'includes Request runner' do
      expect(client).to respond_to(:list_requests)
      expect(client).to respond_to(:get_request)
      expect(client).to respond_to(:update_request)
      expect(client).to respond_to(:list_request_items)
      expect(client).to respond_to(:get_request_item)
      expect(client).to respond_to(:update_request_item)
    end

    it 'includes Approval runner' do
      expect(client).to respond_to(:list_approvals)
      expect(client).to respond_to(:get_approval)
      expect(client).to respond_to(:approve)
      expect(client).to respond_to(:reject)
      expect(client).to respond_to(:list_approvals_for_record)
    end

    it 'includes Task runner' do
      expect(client).to respond_to(:list_tasks)
      expect(client).to respond_to(:get_task)
      expect(client).to respond_to(:update_task)
      expect(client).to respond_to(:close_task)
      expect(client).to respond_to(:add_work_note)
    end

    it 'includes SLA runner' do
      expect(client).to respond_to(:list_sla_definitions)
      expect(client).to respond_to(:get_sla_definition)
      expect(client).to respond_to(:list_task_slas)
      expect(client).to respond_to(:get_task_sla)
      expect(client).to respond_to(:pause_task_sla)
    end

    # CMDB
    it 'includes CMDB Instance runner' do
      expect(client).to respond_to(:list_cis)
      expect(client).to respond_to(:create_ci)
      expect(client).to respond_to(:get_ci)
      expect(client).to respond_to(:update_ci)
      expect(client).to respond_to(:delete_ci)
      expect(client).to respond_to(:get_relationships)
      expect(client).to respond_to(:create_relationship)
    end

    it 'includes CMDB Meta runner' do
      expect(client).to respond_to(:get_hierarchy)
      expect(client).to respond_to(:get_class_meta)
    end

    # Service Catalog
    it 'includes Service Catalog runner' do
      expect(client).to respond_to(:list_catalogs)
      expect(client).to respond_to(:get_catalog)
      expect(client).to respond_to(:get_category)
      expect(client).to respond_to(:list_items)
      expect(client).to respond_to(:get_item)
      expect(client).to respond_to(:get_item_variables)
      expect(client).to respond_to(:order_now)
      expect(client).to respond_to(:add_to_cart)
      expect(client).to respond_to(:get_cart)
      expect(client).to respond_to(:checkout_cart)
      expect(client).to respond_to(:delete_cart)
    end

    it 'includes CatalogVariable runner' do
      expect(client).to respond_to(:list_catalog_variables)
      expect(client).to respond_to(:get_catalog_variable)
      expect(client).to respond_to(:create_catalog_variable)
      expect(client).to respond_to(:update_catalog_variable)
      expect(client).to respond_to(:delete_catalog_variable)
    end

    # Knowledge
    it 'includes Knowledge runner' do
      expect(client).to respond_to(:list_articles)
      expect(client).to respond_to(:get_article)
      expect(client).to respond_to(:create_article)
      expect(client).to respond_to(:update_article)
      expect(client).to respond_to(:delete_article)
    end

    # User Management
    it 'includes User runner' do
      expect(client).to respond_to(:list_users)
      expect(client).to respond_to(:get_user)
      expect(client).to respond_to(:get_user_by_username)
      expect(client).to respond_to(:get_user_by_email)
      expect(client).to respond_to(:create_user)
      expect(client).to respond_to(:update_user)
      expect(client).to respond_to(:delete_user)
    end

    it 'includes UserGroup runner' do
      expect(client).to respond_to(:list_groups)
      expect(client).to respond_to(:get_group)
      expect(client).to respond_to(:get_group_by_name)
      expect(client).to respond_to(:create_group)
      expect(client).to respond_to(:update_group)
      expect(client).to respond_to(:delete_group)
      expect(client).to respond_to(:list_group_members)
      expect(client).to respond_to(:add_group_member)
      expect(client).to respond_to(:remove_group_member)
    end

    it 'includes Account runner' do
      expect(client).to respond_to(:list_accounts)
      expect(client).to respond_to(:get_account)
      expect(client).to respond_to(:create_account)
      expect(client).to respond_to(:update_account)
    end

    # Assets & Contracts
    it 'includes Asset runner' do
      expect(client).to respond_to(:list_assets)
      expect(client).to respond_to(:get_asset)
      expect(client).to respond_to(:create_asset)
      expect(client).to respond_to(:update_asset)
      expect(client).to respond_to(:delete_asset)
      expect(client).to respond_to(:list_hardware)
    end

    it 'includes Contract runner' do
      expect(client).to respond_to(:list_contracts)
      expect(client).to respond_to(:get_contract)
      expect(client).to respond_to(:create_contract)
      expect(client).to respond_to(:update_contract)
      expect(client).to respond_to(:delete_contract)
    end

    # Organization
    it 'includes Location runner' do
      expect(client).to respond_to(:list_locations)
      expect(client).to respond_to(:get_location)
      expect(client).to respond_to(:create_location)
      expect(client).to respond_to(:update_location)
      expect(client).to respond_to(:delete_location)
    end

    it 'includes Department runner' do
      expect(client).to respond_to(:list_departments)
      expect(client).to respond_to(:get_department)
      expect(client).to respond_to(:create_department)
      expect(client).to respond_to(:update_department)
      expect(client).to respond_to(:delete_department)
    end

    it 'includes Company runner' do
      expect(client).to respond_to(:list_companies)
      expect(client).to respond_to(:get_company)
      expect(client).to respond_to(:create_company)
      expect(client).to respond_to(:update_company)
      expect(client).to respond_to(:delete_company)
    end

    it 'includes CostCenter runner' do
      expect(client).to respond_to(:list_cost_centers)
      expect(client).to respond_to(:get_cost_center)
      expect(client).to respond_to(:create_cost_center)
      expect(client).to respond_to(:update_cost_center)
      expect(client).to respond_to(:delete_cost_center)
    end

    # Project & Release
    it 'includes Project runner' do
      expect(client).to respond_to(:list_projects)
      expect(client).to respond_to(:get_project)
      expect(client).to respond_to(:create_project)
      expect(client).to respond_to(:update_project)
      expect(client).to respond_to(:delete_project)
      expect(client).to respond_to(:list_project_tasks)
    end

    it 'includes Release runner' do
      expect(client).to respond_to(:list_releases)
      expect(client).to respond_to(:get_release)
      expect(client).to respond_to(:create_release)
      expect(client).to respond_to(:update_release)
      expect(client).to respond_to(:delete_release)
    end

    # Security & HR
    it 'includes SecurityIncident runner' do
      expect(client).to respond_to(:list_security_incidents)
      expect(client).to respond_to(:get_security_incident)
      expect(client).to respond_to(:create_security_incident)
      expect(client).to respond_to(:update_security_incident)
      expect(client).to respond_to(:close_security_incident)
    end

    it 'includes HrCase runner' do
      expect(client).to respond_to(:list_hr_cases)
      expect(client).to respond_to(:get_hr_case)
      expect(client).to respond_to(:create_hr_case)
      expect(client).to respond_to(:update_hr_case)
      expect(client).to respond_to(:close_hr_case)
    end

    # Platform Admin
    it 'includes SystemProperty runner' do
      expect(client).to respond_to(:list_properties)
      expect(client).to respond_to(:get_property)
      expect(client).to respond_to(:get_property_by_name)
      expect(client).to respond_to(:create_property)
      expect(client).to respond_to(:update_property)
      expect(client).to respond_to(:delete_property)
    end

    it 'includes UpdateSet runner' do
      expect(client).to respond_to(:list_update_sets)
      expect(client).to respond_to(:get_update_set)
      expect(client).to respond_to(:create_update_set)
      expect(client).to respond_to(:update_update_set)
      expect(client).to respond_to(:delete_update_set)
      expect(client).to respond_to(:list_update_set_changes)
    end

    it 'includes ScriptInclude runner' do
      expect(client).to respond_to(:list_script_includes)
      expect(client).to respond_to(:get_script_include)
      expect(client).to respond_to(:create_script_include)
      expect(client).to respond_to(:update_script_include)
      expect(client).to respond_to(:delete_script_include)
    end

    it 'includes BusinessRule runner' do
      expect(client).to respond_to(:list_business_rules)
      expect(client).to respond_to(:get_business_rule)
      expect(client).to respond_to(:create_business_rule)
      expect(client).to respond_to(:update_business_rule)
      expect(client).to respond_to(:delete_business_rule)
    end

    it 'includes ScheduledJob runner' do
      expect(client).to respond_to(:list_scheduled_jobs)
      expect(client).to respond_to(:get_scheduled_job)
      expect(client).to respond_to(:create_scheduled_job)
      expect(client).to respond_to(:update_scheduled_job)
      expect(client).to respond_to(:delete_scheduled_job)
    end

    it 'includes Workflow runner' do
      expect(client).to respond_to(:list_workflows)
      expect(client).to respond_to(:get_workflow)
      expect(client).to respond_to(:list_workflow_contexts)
      expect(client).to respond_to(:get_workflow_context)
      expect(client).to respond_to(:list_workflow_contexts_for_record)
      expect(client).to respond_to(:cancel_workflow_context)
    end

    it 'includes Flow runner' do
      expect(client).to respond_to(:list_flows)
      expect(client).to respond_to(:get_flow)
      expect(client).to respond_to(:execute_flow)
      expect(client).to respond_to(:get_flow_execution)
      expect(client).to respond_to(:list_subflows)
      expect(client).to respond_to(:execute_subflow)
    end

    it 'includes Audit runner' do
      expect(client).to respond_to(:list_audit_records)
      expect(client).to respond_to(:get_audit_record)
      expect(client).to respond_to(:list_field_changes)
    end

    # ITOM
    it 'includes Discovery runner' do
      expect(client).to respond_to(:list_discovery_schedules)
      expect(client).to respond_to(:get_discovery_schedule)
      expect(client).to respond_to(:trigger_discovery)
      expect(client).to respond_to(:list_discovery_logs)
      expect(client).to respond_to(:list_discovered_devices)
    end

    it 'includes MidServer runner' do
      expect(client).to respond_to(:list_mid_servers)
      expect(client).to respond_to(:get_mid_server)
      expect(client).to respond_to(:get_mid_server_by_name)
      expect(client).to respond_to(:update_mid_server)
      expect(client).to respond_to(:list_mid_server_capabilities)
    end

    it 'includes Event runner' do
      expect(client).to respond_to(:create_event)
      expect(client).to respond_to(:list_events)
      expect(client).to respond_to(:get_event)
    end

    # Analytics
    it 'includes PerformanceAnalytics runner' do
      expect(client).to respond_to(:get_widget_data)
      expect(client).to respond_to(:list_widgets)
      expect(client).to respond_to(:get_scorecard)
      expect(client).to respond_to(:list_indicators)
      expect(client).to respond_to(:list_breakdowns)
    end

    # Communications
    it 'includes Notification runner' do
      expect(client).to respond_to(:list_notifications)
      expect(client).to respond_to(:get_notification)
      expect(client).to respond_to(:create_notification)
      expect(client).to respond_to(:update_notification)
      expect(client).to respond_to(:delete_notification)
    end

    it 'includes EmailLog runner' do
      expect(client).to respond_to(:list_email_logs)
      expect(client).to respond_to(:get_email_log)
      expect(client).to respond_to(:list_email_logs_for_record)
    end

    # Field Service
    it 'includes WorkOrder runner' do
      expect(client).to respond_to(:list_work_orders)
      expect(client).to respond_to(:get_work_order)
      expect(client).to respond_to(:create_work_order)
      expect(client).to respond_to(:update_work_order)
      expect(client).to respond_to(:close_work_order)
      expect(client).to respond_to(:list_work_order_tasks)
    end

    it 'includes OnCall runner' do
      expect(client).to respond_to(:list_on_call_schedules)
      expect(client).to respond_to(:get_on_call_schedule)
      expect(client).to respond_to(:list_on_call_members)
      expect(client).to respond_to(:get_current_on_call)
      expect(client).to respond_to(:list_escalation_policies)
    end

    # Utilities
    it 'includes Table runner' do
      expect(client).to respond_to(:table_list)
      expect(client).to respond_to(:table_get)
      expect(client).to respond_to(:table_create)
      expect(client).to respond_to(:table_update)
      expect(client).to respond_to(:table_delete)
    end

    it 'includes ImportSet runner' do
      expect(client).to respond_to(:import)
      expect(client).to respond_to(:import_multiple)
    end

    it 'includes Aggregate runner' do
      expect(client).to respond_to(:aggregate)
    end

    it 'includes Attachment runner' do
      expect(client).to respond_to(:list_attachments)
      expect(client).to respond_to(:get_attachment)
      expect(client).to respond_to(:get_attachment_file)
      expect(client).to respond_to(:upload_attachment)
      expect(client).to respond_to(:delete_attachment)
    end

    it 'includes Survey runner' do
      expect(client).to respond_to(:list_surveys)
      expect(client).to respond_to(:get_survey)
      expect(client).to respond_to(:list_survey_instances)
      expect(client).to respond_to(:get_survey_instance)
      expect(client).to respond_to(:list_survey_responses)
    end
  end
end
