# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Legion::Extensions::ServiceNow do
  it 'is defined' do
    expect(described_class).to be_a(Module)
  end

  describe Legion::Extensions::ServiceNow::Client do
    let(:client) do
      described_class.new(url: 'https://test.service-now.com', username: 'admin', password: 'secret')
    end

    it 'instantiates with credentials' do
      expect(client).to be_a(described_class)
    end

    it 'instantiates with OAuth2' do
      c = described_class.new(url: 'https://test.service-now.com', client_id: 'id', client_secret: 'sec')
      expect(c.opts[:client_id]).to eq('id')
    end

    it 'instantiates with bearer token' do
      c = described_class.new(url: 'https://test.service-now.com', token: 'tok')
      expect(c.opts[:token]).to eq('tok')
    end

    it 'stores opts compactly without nil values' do
      expect(client.opts[:url]).to eq('https://test.service-now.com')
      expect(client.opts.keys).not_to include(:client_id)
      expect(client.opts.keys).not_to include(:token)
    end

    it 'includes Pagination helper' do
      expect(client).to respond_to(:paginate)
    end

    it 'includes Retry helper' do
      expect(client).to respond_to(:with_retry)
    end

    it 'includes error handling' do
      expect(client).to respond_to(:handle_response)
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
      expect(client).to respond_to(:create_incident)
      expect(client).to respond_to(:resolve_incident)
      expect(client).to respond_to(:delete_incident)
    end

    it 'includes Problem runner' do
      expect(client).to respond_to(:list_problems)
      expect(client).to respond_to(:create_problem)
      expect(client).to respond_to(:close_problem)
      expect(client).to respond_to(:delete_problem)
    end

    it 'includes Request runner' do
      expect(client).to respond_to(:list_requests)
      expect(client).to respond_to(:list_request_items)
      expect(client).to respond_to(:update_request_item)
    end

    it 'includes Approval runner' do
      expect(client).to respond_to(:list_approvals)
      expect(client).to respond_to(:approve)
      expect(client).to respond_to(:reject)
      expect(client).to respond_to(:list_approvals_for_record)
    end

    it 'includes Task runner' do
      expect(client).to respond_to(:list_tasks)
      expect(client).to respond_to(:close_task)
      expect(client).to respond_to(:add_work_note)
    end

    it 'includes SLA runner' do
      expect(client).to respond_to(:list_sla_definitions)
      expect(client).to respond_to(:list_task_slas)
      expect(client).to respond_to(:pause_task_sla)
    end

    # CMDB
    it 'includes CMDB Instance runner' do
      expect(client).to respond_to(:list_cis)
      expect(client).to respond_to(:create_ci)
      expect(client).to respond_to(:get_relationships)
      expect(client).to respond_to(:create_relationship)
    end

    it 'includes CMDB Meta runner' do
      expect(client).to respond_to(:get_hierarchy)
      expect(client).to respond_to(:get_class_meta)
    end

    it 'includes CiRelationship runner' do
      expect(client).to respond_to(:list_relationship_types)
      expect(client).to respond_to(:list_ci_relationships)
      expect(client).to respond_to(:create_ci_relationship)
    end

    it 'includes CmdbHealth runner' do
      expect(client).to respond_to(:get_cmdb_health_dashboard)
      expect(client).to respond_to(:list_duplicate_cis)
      expect(client).to respond_to(:list_stale_cis)
    end

    # Service Catalog
    it 'includes ServiceCatalog runner' do
      expect(client).to respond_to(:list_catalogs)
      expect(client).to respond_to(:order_now)
      expect(client).to respond_to(:checkout_cart)
    end

    it 'includes CatalogVariable runner' do
      expect(client).to respond_to(:list_catalog_variables)
      expect(client).to respond_to(:create_catalog_variable)
    end

    it 'includes CatalogTask runner' do
      expect(client).to respond_to(:list_catalog_tasks)
      expect(client).to respond_to(:close_catalog_task)
    end

    # Knowledge
    it 'includes Knowledge runner' do
      expect(client).to respond_to(:list_articles)
      expect(client).to respond_to(:create_article)
    end

    it 'includes KnowledgeBase runner' do
      expect(client).to respond_to(:list_knowledge_bases)
      expect(client).to respond_to(:list_kb_categories)
    end

    it 'includes KnowledgeFeedback runner' do
      expect(client).to respond_to(:list_knowledge_feedback)
      expect(client).to respond_to(:create_knowledge_feedback)
      expect(client).to respond_to(:list_knowledge_views)
    end

    # User Management
    it 'includes User runner' do
      expect(client).to respond_to(:list_users)
      expect(client).to respond_to(:get_user_by_username)
      expect(client).to respond_to(:get_user_by_email)
    end

    it 'includes UserGroup runner' do
      expect(client).to respond_to(:list_groups)
      expect(client).to respond_to(:list_group_members)
      expect(client).to respond_to(:add_group_member)
      expect(client).to respond_to(:remove_group_member)
    end

    it 'includes Account runner' do
      expect(client).to respond_to(:list_accounts)
      expect(client).to respond_to(:create_account)
    end

    # Assets & Contracts
    it 'includes Asset runner' do
      expect(client).to respond_to(:list_assets)
      expect(client).to respond_to(:list_hardware)
    end

    it 'includes Contract runner' do
      expect(client).to respond_to(:list_contracts)
      expect(client).to respond_to(:create_contract)
    end

    it 'includes License runner' do
      expect(client).to respond_to(:list_licenses)
      expect(client).to respond_to(:list_license_allocations)
      expect(client).to respond_to(:list_installed_software)
    end

    it 'includes Vendor runner' do
      expect(client).to respond_to(:list_vendors)
      expect(client).to respond_to(:create_vendor)
    end

    # Organization
    it 'includes Location runner' do
      expect(client).to respond_to(:list_locations)
      expect(client).to respond_to(:create_location)
    end

    it 'includes Department runner' do
      expect(client).to respond_to(:list_departments)
      expect(client).to respond_to(:create_department)
    end

    it 'includes Company runner' do
      expect(client).to respond_to(:list_companies)
      expect(client).to respond_to(:create_company)
    end

    it 'includes CostCenter runner' do
      expect(client).to respond_to(:list_cost_centers)
      expect(client).to respond_to(:create_cost_center)
    end

    # Project & Release
    it 'includes Project runner' do
      expect(client).to respond_to(:list_projects)
      expect(client).to respond_to(:list_project_tasks)
    end

    it 'includes Release runner' do
      expect(client).to respond_to(:list_releases)
      expect(client).to respond_to(:create_release)
    end

    # Security & HR
    it 'includes SecurityIncident runner' do
      expect(client).to respond_to(:list_security_incidents)
      expect(client).to respond_to(:create_security_incident)
      expect(client).to respond_to(:close_security_incident)
    end

    it 'includes HrCase runner' do
      expect(client).to respond_to(:list_hr_cases)
      expect(client).to respond_to(:create_hr_case)
      expect(client).to respond_to(:close_hr_case)
    end

    it 'includes AccessControl runner' do
      expect(client).to respond_to(:list_acls)
      expect(client).to respond_to(:create_acl)
    end

    # Platform Admin
    it 'includes SystemProperty runner' do
      expect(client).to respond_to(:list_properties)
      expect(client).to respond_to(:get_property_by_name)
      expect(client).to respond_to(:update_property)
    end

    it 'includes UpdateSet runner' do
      expect(client).to respond_to(:list_update_sets)
      expect(client).to respond_to(:list_update_set_changes)
    end

    it 'includes ScriptInclude runner' do
      expect(client).to respond_to(:list_script_includes)
      expect(client).to respond_to(:create_script_include)
    end

    it 'includes BusinessRule runner' do
      expect(client).to respond_to(:list_business_rules)
      expect(client).to respond_to(:create_business_rule)
    end

    it 'includes ScriptAction runner' do
      expect(client).to respond_to(:list_script_actions)
      expect(client).to respond_to(:create_script_action)
    end

    it 'includes ScheduledJob runner' do
      expect(client).to respond_to(:list_scheduled_jobs)
      expect(client).to respond_to(:create_scheduled_job)
    end

    it 'includes UiPolicy runner' do
      expect(client).to respond_to(:list_ui_policies)
      expect(client).to respond_to(:create_ui_policy)
    end

    it 'includes UiAction runner' do
      expect(client).to respond_to(:list_ui_actions)
      expect(client).to respond_to(:create_ui_action)
    end

    it 'includes Workflow runner' do
      expect(client).to respond_to(:list_workflows)
      expect(client).to respond_to(:list_workflow_contexts)
      expect(client).to respond_to(:cancel_workflow_context)
    end

    it 'includes Flow runner' do
      expect(client).to respond_to(:list_flows)
      expect(client).to respond_to(:execute_flow)
      expect(client).to respond_to(:list_subflows)
    end

    it 'includes Audit runner' do
      expect(client).to respond_to(:list_audit_records)
      expect(client).to respond_to(:list_field_changes)
    end

    it 'includes UpdateSet DeprecationLog runner' do
      expect(client).to respond_to(:list_upgrade_logs)
      expect(client).to respond_to(:list_deprecation_entries)
    end

    # ITOM
    it 'includes Discovery runner' do
      expect(client).to respond_to(:list_discovery_schedules)
      expect(client).to respond_to(:trigger_discovery)
      expect(client).to respond_to(:list_discovered_devices)
    end

    it 'includes MidServer runner' do
      expect(client).to respond_to(:list_mid_servers)
      expect(client).to respond_to(:get_mid_server_by_name)
      expect(client).to respond_to(:list_mid_server_capabilities)
    end

    it 'includes Event runner' do
      expect(client).to respond_to(:create_event)
      expect(client).to respond_to(:list_events)
    end

    # Analytics
    it 'includes PerformanceAnalytics runner' do
      expect(client).to respond_to(:list_widgets)
      expect(client).to respond_to(:get_scorecard)
      expect(client).to respond_to(:list_indicators)
    end

    it 'includes Metric runner' do
      expect(client).to respond_to(:list_metric_definitions)
      expect(client).to respond_to(:list_metric_instances)
    end

    # Communications
    it 'includes Notification runner' do
      expect(client).to respond_to(:list_notifications)
      expect(client).to respond_to(:create_notification)
    end

    it 'includes EmailLog runner' do
      expect(client).to respond_to(:list_email_logs)
      expect(client).to respond_to(:list_email_logs_for_record)
    end

    # Field Service
    it 'includes WorkOrder runner' do
      expect(client).to respond_to(:list_work_orders)
      expect(client).to respond_to(:close_work_order)
      expect(client).to respond_to(:list_work_order_tasks)
    end

    it 'includes OnCall runner' do
      expect(client).to respond_to(:list_on_call_schedules)
      expect(client).to respond_to(:get_current_on_call)
    end

    # Utilities
    it 'includes Table runner' do
      expect(client).to respond_to(:table_list)
      expect(client).to respond_to(:table_create)
      expect(client).to respond_to(:table_update)
    end

    it 'includes Aggregate runner' do
      expect(client).to respond_to(:aggregate)
    end

    it 'includes Attachment runner' do
      expect(client).to respond_to(:list_attachments)
      expect(client).to respond_to(:upload_attachment)
    end

    it 'includes ImportSet runner' do
      expect(client).to respond_to(:import)
      expect(client).to respond_to(:import_multiple)
    end

    it 'includes Survey runner' do
      expect(client).to respond_to(:list_surveys)
      expect(client).to respond_to(:list_survey_instances)
      expect(client).to respond_to(:list_survey_responses)
    end

    it 'includes Tag runner' do
      expect(client).to respond_to(:list_tags)
      expect(client).to respond_to(:add_tag_to_record)
      expect(client).to respond_to(:remove_tag_from_record)
    end

    it 'includes Currency runner' do
      expect(client).to respond_to(:list_currencies)
      expect(client).to respond_to(:list_exchange_rates)
    end

    it 'includes Calendar runner' do
      expect(client).to respond_to(:list_schedules)
      expect(client).to respond_to(:list_schedule_entries)
    end

    # Platform Modules
    it 'includes ServicePortal runner' do
      expect(client).to respond_to(:list_portals)
      expect(client).to respond_to(:list_portal_pages)
      expect(client).to respond_to(:list_portal_widgets)
    end

    it 'includes GRC runner' do
      expect(client).to respond_to(:list_risks)
      expect(client).to respond_to(:list_controls)
      expect(client).to respond_to(:list_audits)
    end

    it 'includes CSM runner' do
      expect(client).to respond_to(:list_csm_cases)
      expect(client).to respond_to(:create_csm_case)
      expect(client).to respond_to(:list_contacts)
    end

    it 'includes IntegrationHub runner' do
      expect(client).to respond_to(:list_connections)
      expect(client).to respond_to(:list_credentials)
    end
  end
end
