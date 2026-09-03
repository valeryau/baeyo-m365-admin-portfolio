# Module 07 — Service Operations, Intake and Workflow Automation

## Change record

| Item | Value |
|---|---|
| Change reference | CHG-0008 |
| Completion date | 2026-08-30 |
| Tenant | Baeyo Digital Microsoft 365 tenant |
| Environment | Baeyo Digital (default) |
| Licence | Microsoft 365 Business Premium |
| Operational account | daily-user@baeyodigital.example |
| Administrative account | tenant-admin |
| Implementation status | Completed and validated |
| Evidence status | Approved |
| Public sanitization date | 2026-09-03 |

## Objective

Implement a production-capable client-enquiry intake workflow using existing Microsoft 365 services.

The workflow:

- Collects external client enquiries.
- Creates a controlled SharePoint lead record.
- Generates a unique lead reference.
- Sends a confirmation from the Baeyo Digital shared mailbox.
- Notifies the operational owner in Microsoft Teams.
- Creates a Planner follow-up task.
- Updates the SharePoint record with the generated reference and Planner task ID.
- Sends an internal alert if the final SharePoint update fails, is skipped or times out.

## Scope

The implementation covers initial client enquiry intake and follow-up preparation only.

It does not include:

- Lead qualification automation.
- Proposal generation.
- Client onboarding.
- Project-folder creation.
- Delivery checklists.
- Welcome communications.
- Invoicing or payment processing.
- Automatic status progression after `New`.
- AI, premium connectors, custom connectors or third-party services.

These later-stage activities remain separate operational processes.

## Governance and inherited controls

The implementation inherits the governance established in Modules 00–06.

| Control | Applied configuration |
|---|---|
| DLP policy | DLP-BAEYO-Baseline |
| Environment | Existing default environment |
| Connector classification | Approved Business connectors |
| Premium connectors | None |
| Custom connectors | None |
| AI services | None |
| Additional environment | None |
| Power Platform solution | Not introduced |
| Service identity | Existing operational account and connections |

Approved connectors used:

- Microsoft Forms
- SharePoint
- Office 365 Outlook
- Microsoft Teams
- Microsoft Planner

## Implemented resources

| Service | Resource |
|---|---|
| Microsoft Forms | BAEYO Client Enquiry Form |
| SharePoint site | BAEYO Digital Operations |
| SharePoint list | BAEYO Leads |
| Power Automate flow | BAEYO - Enquiry - Client Intake |
| Teams channel | BAEYO Digital Operations → Client Delivery |
| Planner plan | BAEYO Lead Follow-ups |
| Planner bucket | Follow-up Required |
| Shared mailbox | info@baeyodigital.com |

Existing Microsoft 365 resources were reused to avoid unnecessary duplication.

## Microsoft Forms configuration

### Form

`BAEYO Client Enquiry Form`

The form is group-owned under BAEYO Digital Operations.

### Response configuration

- Anyone can respond.
- Accept responses is enabled.
- Authentication is not required.
- All four questions are required.

### Questions

| Order | Question | Type |
|---:|---|---|
| 1 | Full Name | Text |
| 2 | Email Address | Text |
| 3 | Service Interested In | Choice |
| 4 | Message | Long text |

### Service choices

1. CV & Portfolio Website
2. Small Business Website
3. Landing Page
4. Booking / Service Website
5. Website Care & Maintenance
6. Other / Not sure

Only services that Baeyo Digital can operationally deliver are included.

Because this is a group-owned form, its identifier was entered manually in the Forms connector. Microsoft documents that group forms do not appear in the connector dropdown and require manual Form ID entry. [Microsoft Forms connector documentation](https://learn.microsoft.com/en-us/connectors/microsoftforms/)

The raw Form ID is intentionally excluded from documentation and retained evidence.

## SharePoint lead register

### List

`BAEYO Leads`, located on the `BAEYO Digital Operations` SharePoint site.

The built-in SharePoint `Title` column was renamed to `Full Name`. It was not duplicated with a separate column.

### Schema

| Display name | SharePoint type | Purpose |
|---|---|---|
| Full Name | Single line of text; renamed Title | Client or contact name |
| Lead Reference | Single line of text | Generated reference such as LEAD-0005 |
| Email Address | Single line of text | Client contact address |
| Service Interested In | Choice | Requested service |
| Message | Multiple lines of text | Enquiry details |
| Status | Choice | Lead lifecycle stage |
| Lead Owner | Person or Group | Operational owner |
| Follow-up Due | Date and time | Follow-up deadline |
| Planner Task ID | Single line of text | Related Planner task identifier |
| Form Response ID | Single line of text | Source Forms response identifier |

### Status lifecycle

- New
- Contacted
- Qualified
- Proposal Sent
- Won
- Lost

`New` is assigned automatically during intake. Later status changes are performed manually as the lead progresses.

## Planner configuration

| Setting | Value |
|---|---|
| Plan | BAEYO Lead Follow-ups |
| Plan type | Basic |
| Bucket | Follow-up Required |
| Teams location | BAEYO Digital Operations → General |
| Assigned owner | Valery – Baeyo Digital |
| Due date | Two calendar days after form processing |

The standard Planner connector supports Basic plans, matching the implemented configuration. [Microsoft Planner connector documentation](https://learn.microsoft.com/en-us/connectors/planner/)

## Power Automate workflow

### Flow

`BAEYO - Enquiry - Client Intake`

The flow is enabled and operates in the Baeyo Digital default Power Platform environment.

### Processing sequence

| Order | Action | Configuration and result |
|---:|---|---|
| 1 | When a new response is submitted | Triggers from BAEYO Client Enquiry Form |
| 2 | Get response details | Retrieves the four submitted answers |
| 3 | Compose — calculated follow-up date | Calculates a date two calendar days after processing |
| 4 | Create item | Creates the initial BAEYO Leads record with status New |
| 5 | Compose 1 — generated lead reference | Generates the formatted reference from the SharePoint item ID |
| 6 | Send an email from a shared mailbox (V2) | Sends the client confirmation from info@baeyodigital.com |
| 7 | Post message in a chat or channel | Posts an operational notification to Client Delivery |
| 8 | Create a task | Creates the Planner follow-up task |
| 9 | Update item | Updates the same lead record with the reference and Planner task ID |
| 10 | Send an email (V2) | Sends an internal failure alert only when Update item fails, is skipped or times out |

### Follow-up date expression

```text
addDays(utcNow(), 2)
```

The calculation uses two calendar days based on the flow's UTC processing time.

### Lead-reference expression

```text
concat('LEAD-', formatNumber(outputs('Create_item')?['body/ID'], '0000'))
```

The reference uses the numeric SharePoint item ID, producing values such as:

```text
LEAD-0005
```

Deleted test records may create gaps in the numbering. References remain unique and are not expected to be consecutive.

## SharePoint action mappings

### Create item

| SharePoint field | Source |
|---|---|
| Full Name / Title | Forms Full Name |
| Email Address | Forms Email Address |
| Service Interested In | Forms Service Interested In |
| Message | Forms Message |
| Status | New |
| Lead Owner Claims | Fixed operational-owner claim |
| Follow-up Due | Calculated follow-up date |
| Form Response ID | Forms Response ID |

### Update item

The `Id` input uses the numeric SharePoint item ID returned by `Create item`. It does not use the generated `LEAD-0005` text reference.

| SharePoint field | Source |
|---|---|
| Id | Numeric ID from Create item |
| Full Name / Title | Value from Create item |
| Email Address | Value from Create item |
| Service Interested In | Value from Create item |
| Message | Value from Create item |
| Lead Reference | Generated lead-reference output |
| Status | New |
| Lead Owner Claims | Fixed operational-owner claim |
| Follow-up Due | Calculated follow-up date |
| Planner Task ID | ID returned by Create a task |
| Form Response ID | Forms Response ID |

## Operational owner configuration

The current workflow has one operational owner:

```text
i:0#.f|membership|daily-user@baeyodigital.example
```

This is the SharePoint claims value used to populate `Lead Owner`.

The fixed value is intentional for the current single-user operating model. It is a documented dependency rather than an undisclosed assumption.

If the operational owner changes, review and update:

- SharePoint `Lead Owner Claims`.
- Planner task assignee.
- Internal failure-alert recipient.
- Flow ownership and co-ownership.
- Connector connections.
- Shared-mailbox permissions.
- Team, channel, plan and SharePoint permissions.

## Client confirmation

The confirmation is sent from `info@baeyodigital.com`.

### Subject

```text
We received your enquiry — [Lead Reference]
```

### Message

```text
Hello [Full Name],

Thank you for contacting Baeyo Digital about [Service Interested In].

We received your enquiry. Reference: [Lead Reference].

We will review and contact you shortly.

Regards,
Baeyo Digital
Be seen. Be trusted. Be reachable.
```

## Teams notification

The flow posts to:

`BAEYO Digital Operations → Client Delivery`

The notification includes:

- Lead reference.
- Full name.
- Requested service.
- Status.
- Follow-up due date.

The client's email address and full enquiry message are excluded from the Teams notification to reduce unnecessary distribution of submitted information.

## Planner follow-up task

The task title uses:

```text
Follow up: [Full Name] — [Lead Reference]
```

The task is:

- Created in `BAEYO Lead Follow-ups`.
- Placed in `Follow-up Required`.
- Assigned to the operational owner.
- Given the calculated follow-up due date.
- Linked back to the SharePoint record through its stored Planner Task ID.

## Failure handling

The final internal `Send an email (V2)` action is configured relative to `Update item`.

| Run-after status | Selected |
|---|---|
| Is successful | No |
| Has timed out | Yes |
| Is skipped | Yes |
| Has failed | Yes |

During a successful workflow run, the failure-notification action is skipped. This is expected and confirms that the failure branch did not execute.

The failure email identifies:

- Flow name.
- Form response ID.
- Detection timestamp.
- Required operational review of the run history.

## Validation and troubleshooting

### Initial manual test timeout

The first manual test timed out because no new Forms response was submitted while Power Automate was waiting for the trigger.

The trigger was confirmed to require an actual new form submission.

### Initial Update item failure

The first triggered run failed because the `Update item` action received a formatted lead reference such as `LEAD-0001` in its required numeric `Id` field.

The action was corrected to use the numeric item ID from `Create item`.

### Field-mapping correction

Subsequent validation identified incorrect mappings where:

- Full Name was blank.
- Email Address contained the submitted name.
- Message contained the email address.
- Lead Owner was blank.

Both SharePoint actions were corrected to use the intended fields.

### Failure-branch correction

The internal failure email initially ran after a successful update. Its Run After settings were corrected so that it now runs only after timeout, skipped or failed outcomes.

### Final results

- Flow checker: 0 errors.
- Flow checker: 0 warnings.
- Fresh Forms-triggered run: succeeded.
- Automatic test using previous trigger data: succeeded.
- Client confirmation: received.
- Teams notification: created.
- Planner follow-up task: created.
- SharePoint record: completed with reference and Planner task ID.
- Failure-alert action: correctly skipped during successful processing.
- Final retained synthetic reference: `LEAD-0005`.

## Test-data cleanup

Obsolete synthetic SharePoint records and Planner tasks created during troubleshooting were removed.

The final retained validation objects are:

- SharePoint lead: `LEAD-0005`
- Matching Planner follow-up task
- Corresponding test confirmation and operational notification evidence

The retained entry is clearly synthetic and contains no real customer data.

## Security and privacy considerations

- No real customer information is included in retained evidence.
- Raw Microsoft Forms response contents are not retained as evidence.
- Email addresses, internal identifiers and task IDs are redacted where not required.
- The form accepts anonymous external responses because it is a public client-enquiry form.
- Submitted email addresses are user-provided and are not independently verified.
- The Teams notification contains only the operationally necessary summary.
- Full enquiry content remains in the controlled SharePoint list.
- Only standard connectors approved under the inherited DLP baseline are used.
- No credentials, tokens, raw Form IDs or connection secrets are documented.

## Operational limitations

- The public form relies on respondents entering a valid email address.
- Duplicate enquiries are not detected automatically.
- Follow-up is calculated as two calendar days, not two business days.
- The calculation is based on UTC.
- Teams may display the due value in raw ISO/UTC format.
- The current owner is fixed for the single-user operating model.
- Status changes after `New` are manual.
- Group-owned Forms require manual Form ID configuration in the connector.
- Deleted test records can create gaps in lead-reference numbering.
- Later-stage proposal, onboarding, delivery and billing workflows are outside this module.

## Recovery and maintenance

If the workflow stops operating:

1. Confirm that the flow remains enabled.
2. Review Power Automate run history.
3. Identify the first failed or skipped operational action.
4. Confirm that the Forms, SharePoint, Outlook, Teams and Planner connections remain valid.
5. Verify access to the group-owned form.
6. Verify shared-mailbox Send As or Send on Behalf permission.
7. Verify SharePoint list permissions and required columns.
8. Verify Team, channel, Planner plan and bucket availability.
9. Reconfirm the operational owner's membership claims and Planner assignment.
10. Submit a synthetic enquiry and validate the complete result.

The Power Automate designer supports configuring action dependencies and run-after behaviour used by the failure branch. [Power Automate cloud-flow designer](https://learn.microsoft.com/en-us/power-automate/flows-designer)

## Rollback

If the implementation must be withdrawn:

1. Turn off `BAEYO - Enquiry - Client Intake`.
2. Preserve its run history for investigation.
3. Stop distributing the external form link.
4. Disable form responses if required.
5. Remove only synthetic test records and tasks.
6. Retain legitimate business records for operational and compliance review.
7. Document the reason for rollback under CHG-0008.
8. Restore service only after connections, mappings and permissions have been revalidated.

## Evidence register

| ID | Evidence | Repository path | Status |
|---|---|---|---|
| E07-01 | Flow validation, ownership, connections and run history | [View evidence](../assets/screenshots/07-automations/07-01-flow-validation-ownership-and-history.png) | Approved |
| E07-02 | Successful run with normal actions succeeded and failure action skipped | [View evidence](../assets/screenshots/07-automations/07-02-successful-run-action-statuses.png) | Approved |
| E07-03 | Final sanitized LEAD-0005 SharePoint record | [View evidence](../assets/screenshots/07-automations/07-03-leads-record-final-state.png) | Approved |
| E07-04 | Client confirmation email for LEAD-0005 | [View evidence](../assets/screenshots/07-automations/07-04-client-confirmation-email.png) | Approved |
| E07-05 | Final Forms questions, service choices and public-response configuration | [View evidence](../assets/screenshots/07-automations/07-05-form-final-configuration.png) | Approved |
| E07-06 | Teams operational-owner notification for LEAD-0005 | [View evidence](../assets/screenshots/07-automations/07-06-teams-owner-notification.png) | Approved |
| E07-07 | Planner follow-up task for LEAD-0005 | [View evidence](../assets/screenshots/07-automations/07-07-planner-follow-up-task.png) | Approved |
| E07-08 | Failure-alert Run After configuration | [View evidence](../assets/screenshots/07-automations/07-08-failure-run-after-configuration.png) | Approved |

## Handover result

CHG-0008 delivered a validated Microsoft 365 client-enquiry intake workflow using standard licensed services and existing Baeyo Digital operational resources.

The workflow is enabled, has passed end-to-end validation, and is ready for controlled operational use.
