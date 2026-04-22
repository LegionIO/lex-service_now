# lex-service_now: ServiceNow Integration for LegionIO

**Repository Level 3 Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-other/CLAUDE.md`
- **Grandparent**: `/Users/miverso2/rubymine/legion/CLAUDE.md`

## Purpose

Comprehensive Legion Extension connecting LegionIO to ServiceNow via REST APIs. Covers **66 domains** and **346 methods** spanning ITSM, ITOM, ITAM, HR, Security, GRC, CSM, DevOps, and platform administration.

**Version**: 0.3.0
**GitHub**: https://github.com/LegionIO/lex-service_now
**License**: MIT

## Architecture

```
Legion::Extensions::ServiceNow
+-- Errors                              # AuthenticationError, AuthorizationError,
|                                       # NotFoundError, UnprocessableError,
|                                       # RateLimitError, ServerError
+-- Helpers/
|   +-- Client          # connection() with OAuth2→Bearer→Basic fallback
|   |                   # handle_response() raises typed errors on non-2xx
|   +-- Pagination      # paginate(method, **opts) auto-fetches all pages
|   +-- Retry           # with_retry(max_retries:) retries on rate limit/server errors
+-- ITSM/
|   +-- Change          (14) — normal/emergency/standard + change_tasks/conflicts/approvals
|   +-- Incident         (6) — CRUD + resolve
|   +-- Problem          (6) — CRUD + close
|   +-- Request          (6) — sc_request + sc_req_item
|   +-- Approval         (5) — approve/reject + list_for_record
|   +-- Task             (5) — CRUD + add_work_note
|   +-- Sla              (5) — definitions + task SLAs
|   +-- CatalogTask       (4) — sc_task list/get/update/close
+-- CMDB/
|   +-- Cmdb::Instance   (7) — CI CRUD + relationships
|   +-- Cmdb::Meta        (2) — hierarchy + class metadata
|   +-- CiRelationship    (5) — cmdb_rel_type + cmdb_rel_ci
|   +-- CmdbHealth        (4) — duplicates, stale CIs, health dashboard
+-- ServiceCatalog/
|   +-- ServiceCatalog   (11) — catalogs/items/cart/order
|   +-- CatalogVariable   (5) — item_option_new CRUD
+-- Knowledge/
|   +-- Knowledge         (5) — article CRUD
|   +-- KnowledgeBase     (6) — kb_knowledge_base CRUD + categories
|   +-- KnowledgeFeedback (4) — feedback + views
+-- UserManagement/
|   +-- User              (7) — CRUD + lookup_by_username/email
|   +-- UserGroup         (9) — CRUD + member management
|   +-- Account           (4) — account CRUD
+-- Organization/
|   +-- Location          (5) — cmn_location CRUD
|   +-- Department        (5) — cmn_department CRUD
|   +-- Company           (5) — core_company CRUD
|   +-- CostCenter        (5) — cmn_cost_center CRUD
|   +-- Vendor            (5) — vendor-filtered company records
+-- Assets/
|   +-- Asset             (6) — alm_asset CRUD + hardware
|   +-- Contract          (5) — ast_contract CRUD
|   +-- License           (4) — agreements + allocations + installed software
+-- Security/
|   +-- SecurityIncident  (5) — sn_si_incident CRUD
|   +-- AccessControl     (5) — sys_security_acl CRUD
|   +-- Grc               (7) — risks + controls + audits + policies
+-- HR/
|   +-- HrCase            (5) — sn_hr_core_case CRUD
+-- CustomerService/
|   +-- Csm               (6) — customer cases + contacts
+-- ProjectRelease/
|   +-- Project           (6) — pm_project CRUD + tasks
|   +-- Release           (5) — rm_release CRUD
+-- PlatformAdmin/
|   +-- SystemProperty    (6) — sys_properties CRUD
|   +-- UpdateSet         (6) — CRUD + list changes
|   +-- ScriptInclude     (5) — sys_script_include CRUD
|   +-- BusinessRule      (5) — sys_script CRUD
|   +-- ScriptAction      (5) — sysevent_script_action CRUD
|   +-- ScheduledJob      (5) — sysauto_script CRUD
|   +-- UiPolicy          (5) — sys_ui_policy CRUD
|   +-- UiAction          (5) — sys_ui_action CRUD
|   +-- Workflow          (6) — wf_workflow + contexts
|   +-- Flow              (6) — sn_fd flows + subflows
|   +-- Audit             (3) — sys_audit + field changes
|   +-- DeprecationLog    (4) — upgrade history + deprecation log
+-- ITOM/
|   +-- Discovery         (5) — schedules/logs/devices
|   +-- MidServer         (5) — ecc_agent CRUD + capabilities
|   +-- Event             (3) — sysevent CRUD
+-- Analytics/
|   +-- PerformanceAnalytics (5) — widgets/scorecards/indicators
|   +-- Metric             (4) — definitions + instances
+-- Comms/
|   +-- Notification       (5) — sysevent_email_action CRUD
|   +-- EmailLog           (3) — sys_email list/get/list_for_record
+-- FieldService/
|   +-- WorkOrder          (6) — wm_order CRUD + tasks + close
|   +-- OnCall             (5) — schedules + members + who_is_on_call
+-- PlatformModules/
|   +-- ServicePortal      (6) — portals/pages/widgets
|   +-- IntegrationHub     (5) — spokes/connections/credentials
+-- Utilities/
|   +-- Table              (5) — generic CRUD on any table
|   +-- ImportSet          (2) — /api/now/import
|   +-- Aggregate          (1) — stats queries on any table
|   +-- Attachment         (5) — upload/download files
|   +-- Survey             (5) — assessments + instances + responses
|   +-- Tag                (7) — label + label_entry CRUD
|   +-- Currency           (3) — fx_currency + fx_rate
|   +-- Calendar           (6) — cmn_schedule CRUD + entries
+-- Skills/ (loaded only if legion-llm available)
|   +-- Incident, ChangeRequest, CmdbQuery, Knowledge, ServiceCatalog
|   +-- ProblemManagement, RequestFulfillment, ApprovalWorkflow
|   +-- AssetManagement, SecurityIncidentResponse
+-- Client                 # includes all 66 runners + helpers
```

## Known Method Name Notes

- Change runner task methods are named `list_change_tasks`, `create_change_task`, `update_change_task`, `delete_change_task` to avoid collision with the generic Task runner's `list_tasks`/`update_task`.

## Authentication

Priority order (most secure wins):
1. **OAuth2** — `client_id` + `client_secret` → `/oauth_token.do` → memoized in `@fetch_oauth2_token`
2. **Bearer** — `token` → `Authorization: Bearer <token>`
3. **Basic Auth** — `username` + `password`

URL defaults to `Legion::Settings[:service_now][:url]`, overridable per call or `Client.new`.

## Helpers

### Pagination
```ruby
all = client.paginate(:list_incidents, sysparm_query: 'state=1')
```

### Retry
```ruby
client.with_retry(max_retries: 3) { client.create_incident(...) }
```
Retries on `RateLimitError` (exponential backoff) and `ServerError`. Does not retry auth errors.

### Error Handling
`handle_response` is called automatically; raises typed `Errors::*` on non-2xx. Errors carry `.status` and `.detail`.

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
| `legion-logging >= 1.3.2` | Logging |
| `legion-cache >= 1.3.11` | Caching |
| `legion-crypt >= 1.4.9` | Credential encryption |
| `legion-data >= 1.4.17` | ORM |
| `legion-json >= 1.2.1` | JSON helpers |
| `legion-transport >= 1.3.9` | AMQP transport |

`legion-llm` is optional — skills load only if defined.

## Development

```bash
bundle install
bundle exec rspec          # 372 examples, 0 failures
bundle exec rubocop        # 0 offenses
```

---

**Maintained By**: Matthew Iverson (@Esity)
