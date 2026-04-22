# lex-service_now

A LegionIO extension connecting Legion to ServiceNow via REST APIs. Covers **66 domains** and **345 methods** spanning ITSM, ITOM, ITAM, HR, Security, GRC, CSM, DevOps, and platform administration.

## Installation

```ruby
gem 'lex-service_now'
```

## Configuration

```json
{
  "service_now": {
    "url": "https://your-instance.service-now.com",
    "username": "svc_account",
    "password": "secret"
  }
}
```

OAuth2 and Bearer token are also supported — the most secure credentials provided win (OAuth2 > Bearer > Basic Auth).

## Usage

```ruby
client = Legion::Extensions::ServiceNow::Client.new(
  url: 'https://your-instance.service-now.com',
  username: 'admin',
  password: 'secret'
)

# ITSM
client.list_incidents(sysparm_query: 'state=1^priority=1', sysparm_limit: 10)
client.create_incident(short_description: 'Production down', urgency: '1', impact: '1')
client.resolve_incident(sys_id: 'abc', close_code: 'Solved (Permanently)', close_notes: 'Fixed')

# Change
client.create_normal(short_description: 'Deploy v2.0')
client.get_approvals(id: 'CHG0012345')

# CMDB
client.list_cis(class_name: 'cmdb_ci_server', sysparm_query: 'operational_status=1')
client.get_relationships(class_name: 'cmdb_ci_server', sys_id: 'srv001')

# Generic table escape hatch
client.table_list(table_name: 'u_custom_table', sysparm_query: 'active=true')
client.table_create(table_name: 'u_custom_table', name: 'New Record', u_field: 'value')

# Pagination helper — automatically fetches all pages
all_incidents = client.paginate(:list_incidents, sysparm_query: 'state=1')

# Retry helper — retries on rate limits and server errors
client.with_retry(max_retries: 3) { client.create_incident(short_description: 'Issue') }

# Error handling
begin
  client.get_incident(sys_id: 'nonexistent')
rescue Legion::Extensions::ServiceNow::Errors::NotFoundError => e
  puts "Not found: #{e.message} (status: #{e.status})"
end
```

## Supported Domains (66 total)

### ITSM
| Domain | Methods | Notes |
|--------|---------|-------|
| Change | 14 | normal/emergency/standard + change_tasks/conflicts/approvals |
| Incident | 6 | CRUD + resolve |
| Problem | 6 | CRUD + close |
| Request/RITM | 6 | sc_request + sc_req_item |
| Approval | 5 | approve/reject + list_for_record |
| Task | 5 | CRUD + add_work_note |
| SLA | 5 | definitions + task SLAs |
| CatalogTask | 4 | sc_task list/get/update/close |

### CMDB & Discovery
| Domain | Methods | Notes |
|--------|---------|-------|
| CMDB Instance | 7 | CI CRUD + relationships |
| CMDB Meta | 2 | hierarchy + class metadata |
| CiRelationship | 5 | cmdb_rel_type + cmdb_rel_ci |
| CmdbHealth | 4 | duplicates, stale CIs, health dashboard |
| Discovery | 5 | schedules/logs/devices |
| MID Server | 5 | ecc_agent CRUD + capabilities |

### Service Catalog
| Domain | Methods | Notes |
|--------|---------|-------|
| Service Catalog | 11 | catalogs/items/cart/order |
| Catalog Variable | 5 | item_option_new CRUD |

### Knowledge
| Domain | Methods | Notes |
|--------|---------|-------|
| Knowledge | 5 | article CRUD |
| Knowledge Base | 6 | kb_knowledge_base CRUD + categories |
| Knowledge Feedback | 4 | feedback + views |

### User & Organization
| Domain | Methods | Notes |
|--------|---------|-------|
| User | 7 | CRUD + lookup_by_username/email |
| UserGroup | 9 | CRUD + member management |
| Account | 4 | account CRUD |
| Location | 5 | cmn_location CRUD |
| Department | 5 | cmn_department CRUD |
| Company | 5 | core_company CRUD |
| Cost Center | 5 | cmn_cost_center CRUD |
| Vendor | 5 | vendor-filtered company records |

### Asset & Contract Management
| Domain | Methods | Notes |
|--------|---------|-------|
| Asset | 6 | alm_asset CRUD + hardware |
| Contract | 5 | ast_contract CRUD |
| License | 4 | agreements + allocations + installed software |

### Security & Compliance
| Domain | Methods | Notes |
|--------|---------|-------|
| Security Incident | 5 | sn_si_incident CRUD |
| Access Control | 5 | sys_security_acl CRUD |
| GRC | 7 | risks + controls + audits + policies |

### HR & Customer Service
| Domain | Methods | Notes |
|--------|---------|-------|
| HR Case | 5 | sn_hr_core_case CRUD |
| CSM | 6 | customer cases + contacts |

### Project & Release
| Domain | Methods | Notes |
|--------|---------|-------|
| Project | 6 | pm_project CRUD + tasks |
| Release | 5 | rm_release CRUD |

### Platform Administration
| Domain | Methods | Notes |
|--------|---------|-------|
| System Property | 6 | sys_properties CRUD |
| Update Set | 6 | CRUD + list changes |
| Script Include | 5 | sys_script_include CRUD |
| Business Rule | 5 | sys_script CRUD |
| Script Action | 5 | sysevent_script_action CRUD |
| Scheduled Job | 5 | sysauto_script CRUD |
| UI Policy | 5 | sys_ui_policy CRUD |
| UI Action | 5 | sys_ui_action CRUD |
| Workflow | 6 | wf_workflow + contexts |
| Flow/Subflow | 6 | sn_fd flows + execution |
| Audit | 3 | sys_audit + field changes |
| Deprecation Log | 4 | upgrade history + deprecations |

### ITOM & Monitoring
| Domain | Methods | Notes |
|--------|---------|-------|
| Event | 3 | sysevent CRUD |
| Performance Analytics | 5 | widgets/scorecards/indicators |
| Metric | 4 | definitions + instances |

### Communications
| Domain | Methods | Notes |
|--------|---------|-------|
| Notification | 5 | sysevent_email_action CRUD |
| Email Log | 3 | sys_email list/get/list_for_record |

### Field Service
| Domain | Methods | Notes |
|--------|---------|-------|
| Work Order | 6 | wm_order CRUD + tasks + close |
| On-Call | 5 | schedules + members + who_is_on_call |

### Platform Modules
| Domain | Methods | Notes |
|--------|---------|-------|
| Service Portal | 6 | portals/pages/widgets |
| Integration Hub | 5 | spokes/connections/credentials |

### Utilities & Reference
| Domain | Methods | Notes |
|--------|---------|-------|
| Table (generic) | 5 | Any table via /api/now/table/{table} |
| Import Set | 2 | /api/now/import |
| Aggregate | 1 | count/sum/avg/min/max on any table |
| Attachment | 5 | upload/download files |
| Survey | 5 | assessments + instances + responses |
| Tag | 7 | label + label_entry CRUD |
| Currency | 3 | fx_currency + fx_rate |
| Calendar | 6 | cmn_schedule CRUD + entries |

## Helpers

### Pagination
```ruby
all_results = client.paginate(:list_incidents, sysparm_query: 'state=1')
```
Automatically iterates through all pages.

### Retry
```ruby
client.with_retry(max_retries: 3) { client.create_incident(...) }
```
Retries on `RateLimitError` (exponential backoff) and `ServerError`. Raises immediately on auth errors.

### Error Handling
```ruby
rescue Legion::Extensions::ServiceNow::Errors::AuthenticationError => e  # 401
rescue Legion::Extensions::ServiceNow::Errors::AuthorizationError => e   # 403
rescue Legion::Extensions::ServiceNow::Errors::NotFoundError => e        # 404
rescue Legion::Extensions::ServiceNow::Errors::UnprocessableError => e   # 422
rescue Legion::Extensions::ServiceNow::Errors::RateLimitError => e       # 429
rescue Legion::Extensions::ServiceNow::Errors::ServerError => e          # 5xx
rescue Legion::Extensions::ServiceNow::Errors::ServiceNowError => e      # all others
```

## LLM Skills (10 total)

Registered automatically when `legion-llm` is available:

| Skill | Trigger Words |
|-------|--------------|
| `servicenow:incident` | incident, INC, outage, p1, sev1 |
| `servicenow:change_request` | CHG, RFC, change request, CAB |
| `servicenow:cmdb_query` | CMDB, CI, configuration item |
| `servicenow:knowledge` | KB, knowledge base, article |
| `servicenow:service_catalog` | catalog, service request, order |
| `servicenow:problem_management` | PRB, problem, root cause, RCA |
| `servicenow:request_fulfillment` | RITM, request item, fulfillment |
| `servicenow:approval_workflow` | approval, approve, reject |
| `servicenow:asset_management` | asset, hardware, inventory |
| `servicenow:security_incident_response` | SIR, security incident, breach |

## Development

```bash
bundle install
bundle exec rspec        # 372 examples, 0 failures
bundle exec rubocop      # 0 offenses
```

## License

MIT
