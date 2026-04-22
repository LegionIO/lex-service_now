# Changelog

## [0.3.0] - 2026-04-22

### Added
- Tag runner (7 methods) — label + label_entry CRUD, tag/untag records
- Metric runner (4 methods) — metric_definition + metric_instance
- Currency runner (3 methods) — fx_currency + fx_rate
- Calendar runner (6 methods) — cmn_schedule CRUD + entries
- KnowledgeFeedback runner (4 methods) — kb_feedback + kb_view
- License runner (4 methods) — license_agreement + allocations + installed software
- DeprecationLog runner (4 methods) — upgrade history + deprecation log
- CmdbHealth runner (4 methods) — duplicate CIs, stale CIs, health dashboard
- ServicePortal runner (6 methods) — portals, pages, widgets
- GRC runner (7 methods) — risks, controls, audits, policies
- CSM runner (6 methods) — customer service cases and contacts
- IntegrationHub runner (5 methods) — spokes, action types, connections, credentials
- Vendor runner (5 methods) — vendor-filtered company records
- CiRelationship runner (5 methods) — cmdb_rel_type + cmdb_rel_ci
- ScriptAction runner (5 methods) — sysevent_script_action CRUD
- UiPolicy runner (5 methods) — sys_ui_policy CRUD
- UiAction runner (5 methods) — sys_ui_action CRUD
- AccessControl runner (5 methods) — sys_security_acl CRUD
- CatalogTask runner (4 methods) — sc_task list/get/update/close
- KnowledgeBase runner (6 methods) — kb_knowledge_base CRUD + categories
- Helpers::Pagination — auto-fetches all pages for any list method
- Helpers::Retry — retries on RateLimitError/ServerError with exponential backoff
- Helpers::Client#handle_response — raises typed errors on non-2xx responses
- Errors module — AuthenticationError, AuthorizationError, NotFoundError,
  UnprocessableError, RateLimitError, ServerError

### Fixed
- Table runner: table_create/table_update no longer leak auth kwargs into request body
- Change runner: task methods renamed to list_change_tasks/create_change_task/
  update_change_task/delete_change_task to avoid collision with Task runner

## [0.2.0] - 2026-04-22

### Added
- Incident, Problem, Attachment, Table, Aggregate, User, UserGroup runners
- Request/RITM, Approval, Task, SLA, ImportSet, Event runners
- PerformanceAnalytics, Flow/Subflow runners
- Notification, EmailLog, Audit, SystemProperty runners
- Asset, Location, Department, Company, CostCenter runners
- Project, Release, SecurityIncident, HrCase runners
- UpdateSet, ScriptInclude, BusinessRule, ScheduledJob runners
- OnCall, Survey, Contract, WorkOrder, Discovery, MidServer runners
- CatalogVariable, Workflow runners
- 10 LLM skills

## [0.1.0] - 2026-04-22

### Added
- Initial release with Change, CMDB Instance/Meta, Knowledge, Service Catalog, Account
