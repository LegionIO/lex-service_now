# Changelog

## [0.2.0] - 2026-04-22

### Added
- Incident runner (6 methods)
- Problem runner (6 methods)
- Attachment runner (5 methods) with multipart upload support
- Table runner (5 methods) — generic CRUD escape hatch for any table
- Aggregate runner (1 method) — stats/count/sum/avg queries
- User runner (7 methods) including lookup by username and email
- UserGroup runner (9 methods) including member management
- Request/RITM runner (6 methods)
- Approval runner (5 methods) — approve, reject, list_for_record
- Task runner (5 methods) including add_work_note
- SLA runner (5 methods) — definitions and task SLA tracking
- ImportSet runner (2 methods)
- Event runner (3 methods)
- PerformanceAnalytics runner (5 methods) — widgets, scorecards, indicators
- Flow/Subflow runner (6 methods)
- Notification runner (5 methods)
- EmailLog runner (3 methods)
- Audit runner (3 methods) — field change history
- SystemProperty runner (6 methods)
- Asset runner (6 methods) including hardware
- Location runner (5 methods)
- Department runner (5 methods)
- Company runner (5 methods)
- Project runner (6 methods) including project tasks
- Release runner (5 methods)
- HrCase runner (5 methods)
- SecurityIncident runner (5 methods)
- UpdateSet runner (6 methods) including change listing
- ScriptInclude runner (5 methods)
- BusinessRule runner (5 methods)
- ScheduledJob runner (5 methods)
- OnCall runner (5 methods) — schedules, members, who_is_on_call
- Survey runner (5 methods) — instances and responses
- Contract runner (5 methods)
- CostCenter runner (5 methods)
- WorkOrder runner (6 methods) including tasks
- Discovery runner (5 methods)
- MidServer runner (5 methods)
- CatalogVariable runner (5 methods)
- Workflow runner (6 methods) — contexts and cancellation
- 10 LLM skills: Incident, ChangeRequest, CmdbQuery, Knowledge, ServiceCatalog, ProblemManagement, RequestFulfillment, ApprovalWorkflow, AssetManagement, SecurityIncidentResponse

## [0.1.0] - 2026-04-22

### Added
- Initial release
- Change Management API (14 methods)
- CMDB Instance API (7 methods)
- CMDB Meta API (2 methods)
- Knowledge API (5 methods)
- Service Catalog API (11 methods)
- Account API (4 methods)
- LLM skill triggers for Incident, ChangeRequest, CmdbQuery, Knowledge, ServiceCatalog
