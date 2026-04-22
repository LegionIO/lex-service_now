# lex-service_now: ServiceNow Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-other/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Comprehensive Legion Extension connecting LegionIO to ServiceNow via REST APIs. Covers 46 domains spanning ITSM, ITOM, ITAM, HR, Security, DevOps, and platform administration.

**Version**: 0.2.0
**GitHub**: https://github.com/LegionIO/lex-service_now
**License**: MIT

## Architecture

```
Legion::Extensions::ServiceNow
+-- Helpers/
|   +-- Client             # connection() with OAuth2→Bearer→Basic auth priority fallback
+-- ITSM/
|   +-- Change::Runners::Change          (14 methods) — normal/emergency/standard + tasks/conflicts/approvals
|   +-- Incident::Runners::Incident      (6 methods)  — CRUD + resolve
|   +-- Problem::Runners::Problem        (6 methods)  — CRUD + close
|   +-- Request::Runners::Request        (6 methods)  — sc_request + sc_req_item
|   +-- Approval::Runners::Approval      (5 methods)  — approve/reject + list_for_record
|   +-- Task::Runners::Task              (5 methods)  — CRUD + add_work_note
|   +-- Sla::Runners::Sla               (5 methods)  — definitions + task SLAs
+-- CMDB/
|   +-- Cmdb::Instance::Runners::Instance  (7 methods)  — CI CRUD + relationships
|   +-- Cmdb::Meta::Runners::Meta          (2 methods)  — hierarchy + class metadata
+-- Knowledge/
|   +-- Knowledge::Runners::Knowledge      (5 methods)  — article CRUD
+-- ServiceCatalog/
|   +-- ServiceCatalog::Runners::ServiceCatalog  (11 methods) — catalogs/items/cart/order
|   +-- CatalogVariable::Runners::CatalogVariable (5 methods) — item variables CRUD
+-- User Management/
|   +-- User::Runners::User              (7 methods)  — CRUD + lookup_by_username/email
|   +-- UserGroup::Runners::UserGroup    (9 methods)  — CRUD + member management
|   +-- Account::Runners::Account        (4 methods)  — core account CRUD
+-- Assets/
|   +-- Asset::Runners::Asset            (6 methods)  — alm_asset CRUD + hardware
|   +-- Contract::Runners::Contract      (5 methods)  — ast_contract CRUD
+-- Organization/
|   +-- Location::Runners::Location      (5 methods)  — cmn_location CRUD
|   +-- Department::Runners::Department  (5 methods)  — cmn_department CRUD
|   +-- Company::Runners::Company        (5 methods)  — core_company CRUD
|   +-- CostCenter::Runners::CostCenter  (5 methods)  — cmn_cost_center CRUD
+-- Project & Release/
|   +-- Project::Runners::Project        (6 methods)  — pm_project CRUD + tasks
|   +-- Release::Runners::Release        (5 methods)  — rm_release CRUD
+-- Security/
|   +-- SecurityIncident::Runners::SecurityIncident  (5 methods) — sn_si_incident CRUD
+-- HR/
|   +-- HrCase::Runners::HrCase          (5 methods)  — sn_hr_core_case CRUD
+-- Platform Admin/
|   +-- SystemProperty::Runners::SystemProperty  (6 methods) — sys_properties CRUD
|   +-- UpdateSet::Runners::UpdateSet    (6 methods)  — CRUD + list changes
|   +-- ScriptInclude::Runners::ScriptInclude  (5 methods)  — sys_script_include CRUD
|   +-- BusinessRule::Runners::BusinessRule    (5 methods)  — sys_script CRUD
|   +-- ScheduledJob::Runners::ScheduledJob    (5 methods)  — sysauto_script CRUD
|   +-- Workflow::Runners::Workflow       (6 methods)  — wf_workflow + contexts
|   +-- Flow::Runners::Flow              (6 methods)  — sn_fd flow execute + subflows
|   +-- Audit::Runners::Audit            (3 methods)  — sys_audit + field changes
+-- ITOM/
|   +-- Discovery::Runners::Discovery    (5 methods)  — schedules/logs/devices
|   +-- MidServer::Runners::MidServer    (5 methods)  — ecc_agent CRUD + capabilities
|   +-- Event::Runners::Event            (3 methods)  — sysevent CRUD
+-- Analytics/
|   +-- PerformanceAnalytics::Runners::PerformanceAnalytics  (5 methods) — widgets/scorecards/indicators
|   +-- Aggregate::Runners::Aggregate    (1 method)   — stats queries on any table
+-- Comms/
|   +-- Notification::Runners::Notification  (5 methods) — sysevent_email_action CRUD
|   +-- EmailLog::Runners::EmailLog      (3 methods)  — sys_email list/get/list_for_record
+-- Field Service/
|   +-- WorkOrder::Runners::WorkOrder    (6 methods)  — wm_order CRUD + tasks + close
|   +-- OnCall::Runners::OnCall          (5 methods)  — cmn_rota + members + who_is_on_call
+-- Utilities/
|   +-- Table::Runners::Table            (5 methods)  — generic CRUD on any table
|   +-- ImportSet::Runners::ImportSet    (2 methods)  — /api/now/import
|   +-- Survey::Runners::Survey          (5 methods)  — assessments + instances + responses
+-- Skills/ (loaded only if legion-llm available)
|   +-- Incident, ChangeRequest, CmdbQuery, Knowledge, ServiceCatalog
|   +-- ProblemManagement, RequestFulfillment, ApprovalWorkflow
|   +-- AssetManagement, SecurityIncidentResponse
+-- Client                 # Standalone client class including all 46 runners
```

## Authentication

`Helpers::Client#connection` selects auth priority order (most secure first):
1. **OAuth2** — `client_id` + `client_secret` → client credentials grant → `/oauth_token.do`, token memoized in `@fetch_oauth2_token`
2. **Bearer** — `token` → `Authorization: Bearer <token>`
3. **Basic Auth** — `username` + `password` → HTTP Basic

Instance URL defaults to `Legion::Settings[:service_now][:url]`, overridable per `Client.new` or per call.

## Standalone Client

```ruby
client = Legion::Extensions::ServiceNow::Client.new(
  url: 'https://your-instance.service-now.com',
  username: 'svc_account',
  password: 'secret'
)

# Or with OAuth2
client = Legion::Extensions::ServiceNow::Client.new(
  url: 'https://your-instance.service-now.com',
  client_id: 'abc',
  client_secret: 'xyz'
)

client.list_incidents(sysparm_query: 'state=1', sysparm_limit: 50)
client.create_change(short_description: 'Deploy v2.0')
client.get_ci(class_name: 'cmdb_ci_server', sys_id: 'abc123')
```

## Settings

```json
{
  "service_now": {
    "url": "https://your-instance.service-now.com",
    "username": null,
    "password": null,
    "token": null,
    "client_id": null,
    "client_secret": null
  }
}
```

## Dependencies

| Gem | Purpose |
|-----|---------|
| `faraday >= 2.0` | HTTP client |
| `faraday-multipart >= 1.0` | Multipart upload for attachments |
| `legion-settings >= 1.3.14` | Settings/config |
| `legion-logging >= 1.3.2` | Structured logging |
| `legion-cache >= 1.3.11` | Caching |
| `legion-crypt >= 1.4.9` | Credential encryption |
| `legion-data >= 1.4.17` | ORM |
| `legion-json >= 1.2.1` | JSON helpers |
| `legion-transport >= 1.3.9` | AMQP transport |

`legion-llm` is an optional soft dependency — skills load only if defined.

## Development

```bash
bundle install
bundle exec rspec          # 217+ examples, 0 failures
bundle exec rubocop        # 0 offenses
```

---

**Maintained By**: Matthew Iverson (@Esity)
