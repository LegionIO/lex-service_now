# lex-service_now

A LegionIO extension connecting Legion to ServiceNow via REST APIs. Covers 46 domains spanning ITSM, ITOM, ITAM, HR, Security, DevOps, and platform administration.

## Installation

Add to your Gemfile:

```ruby
gem 'lex-service_now'
```

## Configuration

Set credentials via Legion settings (`~/.legionio/settings/service_now.json`):

```json
{
  "service_now": {
    "url": "https://your-instance.service-now.com",
    "username": "svc_account",
    "password": "secret"
  }
}
```

OAuth2 and Bearer token auth are also supported — the most secure credentials provided are used automatically (OAuth2 > Bearer > Basic Auth).

## Usage

### Standalone Client

```ruby
require 'legion/extensions/service_now'

client = Legion::Extensions::ServiceNow::Client.new(
  url: 'https://your-instance.service-now.com',
  username: 'admin',
  password: 'secret'
)

# Incidents
client.list_incidents(sysparm_query: 'state=1^priority=1', sysparm_limit: 10)
client.create_incident(short_description: 'Production server down', urgency: '1', impact: '1')
client.resolve_incident(sys_id: 'abc123', close_code: 'Solved (Permanently)', close_notes: 'Fixed')

# Change Management
client.create_normal(short_description: 'Deploy app v2.0', assignment_group: 'CAB Approval')
client.get_change(id: 'CHG0012345')
client.get_approvals(id: 'CHG0012345')

# CMDB
client.list_cis(class_name: 'cmdb_ci_server', sysparm_query: 'operational_status=1')
client.get_relationships(class_name: 'cmdb_ci_server', sys_id: 'srv001')

# Service Catalog
client.list_items(catalog_id: 'cat1')
client.order_now(sys_id: 'item_id', quantity: 1, variables: { justification: 'Project work' })

# Users & Groups
client.get_user_by_email(email: 'jdoe@company.com')
client.list_group_members(group_sys_id: 'network_team_id')

# Generic Table API (escape hatch for any table)
client.table_list(table_name: 'u_custom_table', sysparm_query: 'active=true')
```

## Supported Domains

### ITSM
| Domain | Methods | Table |
|--------|---------|-------|
| Change | 14 | `sn_chg_rest` API |
| Incident | 6 | `incident` |
| Problem | 6 | `problem` |
| Request/RITM | 6 | `sc_request`, `sc_req_item` |
| Approval | 5 | `sysapproval_approver` |
| Task | 5 | `task` |
| SLA | 5 | `contract_sla`, `task_sla` |

### CMDB & Discovery
| Domain | Methods | Table |
|--------|---------|-------|
| CMDB Instance | 7 | `/api/now/cmdb/instance` |
| CMDB Meta | 2 | `/api/now/doc/meta` |
| Discovery | 5 | `discovery_schedule`, `discovery_log` |
| MID Server | 5 | `ecc_agent` |

### Service Catalog
| Domain | Methods | Table |
|--------|---------|-------|
| Service Catalog | 11 | `/api/sn_sc/servicecatalog` |
| Catalog Variable | 5 | `item_option_new` |

### Knowledge & Content
| Domain | Methods | Table |
|--------|---------|-------|
| Knowledge | 5 | `/api/sn_km_api/knowledge` |
| Survey | 5 | `survey`, `asmt_assessment_instance` |

### User & Organization
| Domain | Methods | Table |
|--------|---------|-------|
| User | 7 | `sys_user` |
| UserGroup | 9 | `sys_user_group`, `sys_user_grmember` |
| Account | 4 | `account` |
| Location | 5 | `cmn_location` |
| Department | 5 | `cmn_department` |
| Company | 5 | `core_company` |
| Cost Center | 5 | `cmn_cost_center` |

### Asset & Contract Management
| Domain | Methods | Table |
|--------|---------|-------|
| Asset | 6 | `alm_asset`, `alm_hardware` |
| Contract | 5 | `ast_contract` |

### Security
| Domain | Methods | Table |
|--------|---------|-------|
| Security Incident | 5 | `sn_si_incident` |

### HR
| Domain | Methods | Table |
|--------|---------|-------|
| HR Case | 5 | `sn_hr_core_case` |

### Project & Release
| Domain | Methods | Table |
|--------|---------|-------|
| Project | 6 | `pm_project`, `pm_project_task` |
| Release | 5 | `rm_release` |

### Platform Administration
| Domain | Methods | Table |
|--------|---------|-------|
| System Property | 6 | `sys_properties` |
| Update Set | 6 | `sys_update_set`, `sys_update_xml` |
| Script Include | 5 | `sys_script_include` |
| Business Rule | 5 | `sys_script` |
| Scheduled Job | 5 | `sysauto_script` |
| Workflow | 6 | `wf_workflow`, `wf_context` |
| Flow/Subflow | 6 | `/api/sn_fd` |
| Audit | 3 | `sys_audit` |

### ITOM & Monitoring
| Domain | Methods | Table |
|--------|---------|-------|
| Event | 3 | `sysevent` |
| Performance Analytics | 5 | `/api/now/pa` |

### Communications
| Domain | Methods | Table |
|--------|---------|-------|
| Notification | 5 | `sysevent_email_action` |
| Email Log | 3 | `sys_email` |

### Field Service
| Domain | Methods | Table |
|--------|---------|-------|
| Work Order | 6 | `wm_order`, `wm_task` |
| On-Call | 5 | `cmn_rota`, `cmn_rota_member` |

### Utilities
| Domain | Methods | Table |
|--------|---------|-------|
| Table (generic) | 5 | Any table via `/api/now/table/{table}` |
| Import Set | 2 | `/api/now/import` |
| Aggregate | 1 | `/api/now/stats/{table}` |
| Attachment | 5 | `/api/now/attachment` |

## LLM Skills

When `legion-llm` is available, 10 workflow skills are registered automatically:

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
| `servicenow:asset_management` | asset, hardware, inventory, ALM |
| `servicenow:security_incident_response` | SIR, security incident, breach |

## Development

```bash
bundle install
bundle exec rspec        # 217 examples, 0 failures
bundle exec rubocop      # 0 offenses
```

## License

MIT — see [LICENSE](LICENSE).
