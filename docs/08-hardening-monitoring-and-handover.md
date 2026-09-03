# Module 08 — Hardening, Monitoring and Handover

## Module status

| Field | Value |
|---|---|
| Documentation type | Sanitized public portfolio implementation record |
| Status | Complete and validated |
| Implementation period | 30 August–1 September 2026 |
| Implementer | Valery — Baeyo Digital |
| Tenant | `baeyodigital.com` |
| Subscription | Microsoft 365 Business Premium |
| Managed device | BAEYO-WIN-01 |
| Change reference | CHG-0009 |
| Evidence register | Approved |
| Overall result | Implementation and validation completed with documented limitations |

## Objective

Complete the Baeyo Digital Microsoft 365 administrator lab by applying practical tenant hardening, establishing operational monitoring, validating email and endpoint protection, confirming privileged recovery access, and documenting the remaining security backlog for handover.

## Business reason

Modules 00–07 established identity, authentication, endpoint management, Microsoft 365 services, Power Platform governance and the client-enquiry workflow.

Module 08 was required to ensure those services were:

- Protected against common endpoint and email threats.
- Visible through monitoring and audit tools.
- Supported by operational notification channels.
- Recoverable through designated administrator accounts.
- Validated using actual portal, device and external results.
- Accompanied by a clear record of unresolved limitations and future work.

The module was not designed to maximise Microsoft Secure Score or activate every available security recommendation without testing.

## Scope and dependencies

### Included

- Microsoft Secure Score baseline and closure assessment.
- Microsoft Defender for Business setup.
- Microsoft Defender for Endpoint and Intune integration.
- Onboarding and validation of BAEYO-WIN-01.
- Standard preset email protection.
- Protected-user impersonation configuration.
- DKIM configuration for `baeyodigital.com`.
- DMARC aggregate reporting.
- External SPF, DKIM and DMARC validation.
- Service-health email monitoring.
- Message Center email notifications and weekly digest.
- Microsoft Purview Audit validation.
- Global Administrator and emergency-access assignment review.
- Operational-health validation of the Module 07 client-intake flow.
- Troubleshooting, evidence collection and handover.

### Dependencies established in locked modules

The following controls were implemented and evidenced in Modules 00–07 and were not reopened:

- Tenant identity, accounts, groups and licensing.
- Security Defaults.
- Windows 11 Microsoft Entra join and Intune enrolment.
- Device compliance and configuration.
- Exchange Online, SharePoint Online, Microsoft Teams and Planner.
- Power Platform data-loss-prevention governance.
- BAEYO client-enquiry intake and workflow automation.

### Excluded, incomplete or deferred

- Strict preset email protection.
- Custom-domain impersonation protection, which remained at `0/50`.
- DMARC enforcement using `p=quarantine` or `p=reject`.
- Attack Surface Reduction enforcement without an Audit-mode pilot.
- Conditional Access redesign; Security Defaults remained active.
- Remediation of the separate Windows login/administrative-elevation issue.
- Emergency-account authentication-method and sign-in testing.
- Emergency-account alerting and credential-storage procedures.
- Endpoint deployment beyond BAEYO-WIN-01.
- Reimplementation of the Module 07 workflow.
- Advanced security capabilities outside the available licensing and approved scope.

## Initial assessment

The discovery phase established the following baseline:

| Area | Initial state |
|---|---|
| Secure Score | Approximately 48.5% |
| Defender connector | Unavailable in Intune |
| Endpoint reporting | Zero onboarded devices and no useful EDR results |
| Standard protection | Off |
| Strict protection | Off |
| DKIM | Disabled with `NoDKIMKeys` |
| DMARC | `p=none` without aggregate reporting |
| Service-health email | Disabled |
| Message Center email | Incomplete and dependent on the primary administrator address |
| Purview Audit | No completed search history visible |
| Workflow | Existing Module 07 flow required current-state validation |
| Privileged access | Global Administrator assignments required review |

These results formed the before-state for Module 08.

## Implementation

### 1. Microsoft Defender for Business

The Defender for Business setup wizard was completed with:

- Security permissions assigned for security review.
- Incident and vulnerability email notifications configured.
- The Windows device selected for onboarding.
- Microsoft Intune retained as the endpoint security-management platform.
- Recommended endpoint security configuration applied through the existing Intune relationship.

The final wizard review showed one Security Reader assignment, operational email notifications, one device selected for onboarding and continued management of endpoint security policies through Intune.

### 2. Defender and Intune integration

The Defender for Endpoint connector initially appeared as unavailable. After the Defender setup process, the connector showed as enabled.

A default Endpoint Detection and Response policy created by Microsoft Defender for Endpoint was present in Intune and assigned to the `MDB Windows device onboarding group`. BAEYO-WIN-01 was confirmed as a direct member of that group.

Despite this assignment, Intune initially continued to report zero onboarded devices and zero policy results.

### 3. Local endpoint validation

Because the Intune reports remained empty, read-only PowerShell checks were run from the available user session.

The results confirmed:

- Microsoft Defender for Endpoint sensor service running.
- Microsoft Defender Antivirus service running.
- Both services configured for automatic startup.
- `OnboardingState` equal to `1`.
- Antivirus enabled.
- Real-time protection enabled.
- Behaviour monitoring enabled.
- Tamper protection enabled.
- Defender operating in Normal mode.

The checks did not remediate or validate the separate Windows administrative-login problem.

### 4. Defender Device inventory validation

The Microsoft Defender Device inventory later reported one device, BAEYO-WIN-01, with an Active sensor and Onboarded status. The Not onboarded count was zero.

This service-specific Defender result was accepted as the authoritative final endpoint state, despite Intune’s delayed EDR reporting.

### 5. Standard preset email protection

The initial Preset security policies page showed Built-in protection available, Standard protection off and Strict protection off.

During configuration, early Exchange Online Protection and Defender for Office 365 wizard screens initially displayed **None** while recipient scope was being selected. The scope was corrected before completion.

The configured Standard policy included:

- Exchange Online Protection.
- Defender for Office 365 protection.
- Safe Links and Safe Attachments.
- Protected-user impersonation configuration for the designated Baeyo Digital identity.

The protected-user table contained one user even though the navigation counter continued to show `0/350`.

Repeated attempts to add a protected custom domain did not change the `0/50` counter. No custom-domain impersonation entry was verified, so this control is not claimed as completed.

The policy was initially staged with **Leave it turned off** and enabled later.

Final state:

- Built-in protection applied.
- Standard protection on.
- Strict protection off.

Strict protection was intentionally not enabled because its more aggressive handling was outside the approved small-business baseline.

### 6. DKIM implementation

DKIM was initially disabled for `baeyodigital.com` with a `NoDKIMKeys` state.

Microsoft supplied two selector CNAME requirements. The corresponding records were created through the authoritative cPanel DNS zone.

The first selector was initially entered with an incomplete `_domainkey` label. The record was corrected before activation, and the screenshot containing the typo was excluded from permanent evidence.

After DNS propagation, DKIM status changed to Valid, DKIM signing was enabled and outbound mail was signed using `baeyodigital.com`.

### 7. DMARC reporting

The cPanel DMARC editor initially presented structured policy choices, making it difficult to confirm the complete TXT value. The authoritative DNS zone list was used to verify the final record:

```text
v=DMARC1; p=none; rua=mailto:daily-user@baeyodigital.example;
```

The implementation retained `p=none` intentionally. This enables reporting without rejecting or quarantining legitimate messages during the initial monitoring period. Only one DMARC record was retained.

### 8. External email-authentication validation

A validation message was sent from the Baeyo Digital custom domain to an external Gmail mailbox.

Gmail’s original-message analysis reported:

- SPF: PASS.
- DKIM: PASS for `baeyodigital.com`.
- DMARC: PASS.

The message arrived in Gmail’s Spam folder. This did not invalidate the authentication test: authentication passed, while inbox placement remained affected by separate reputation, content and recipient-history signals.

The personal Gmail address and raw message headers are removed from repository evidence.

### 9. Service-health monitoring

Service-health email notifications were enabled for `daily-user@baeyodigital.example`.

All three issue categories were selected:

- Incidents.
- Advisories.
- Issues in the tenant environment requiring action.

Sixteen monitored services were verified across two screenshots:

1. Exchange Online.
2. Microsoft 365 apps.
3. Microsoft 365 for the web.
4. Microsoft 365 suite.
5. Microsoft Defender XDR.
6. Microsoft Entra.
7. Microsoft Forms.
8. Microsoft Intune.
9. Microsoft OneDrive.
10. Microsoft Power Automate.
11. Microsoft Power Automate in Microsoft 365.
12. Microsoft Purview.
13. Microsoft Teams.
14. Planner.
15. Power Apps in Microsoft 365.
16. SharePoint Online.

An earlier capture did not reliably display the saved recipient or complete list. The configuration was reopened and validated using final upper and lower screenshots.

### 10. Message Center monitoring

Message Center preferences were updated so that:

- The primary administrator address was unchecked.
- `daily-user@baeyodigital.example` was selected as the operational recipient.
- Major-update emails were enabled.
- Data-privacy emails were enabled.
- Weekly digest emails were enabled.
- Relevant Microsoft 365 service categories were selected.

The complete Message Center service list was not independently enumerated. It is not claimed to be identical to the 16 Service-health services because Message Center uses different categories, including **General announcement**.

### 11. Microsoft Purview Audit

Purview initially displayed classic/new portal prompts and an empty search-history page.

An Audit search was configured for the Module 08 implementation period. The first result showed the search job as **Queued**. After processing and refreshing the page, the search changed to **Completed** and returned 211 records.

The results included activities related to:

- Enabling Exchange Online Protection preset policies.
- Enabling Defender for Office 365 protection.
- Configuring DKIM signing.
- Administrator sign-in and tenant configuration activity.

This confirmed that administrative changes were recorded and searchable.

### 12. Privileged and emergency access

The Global Administrator role contained three direct user assignments:

| Name | Username | Type | Scope |
|---|---|---|---|
| Baeyo Emergency Access 01 | `[redacted]@tenant-name.onmicrosoft.com` | User | Directory |
| Baeyo Emergency Access 02 | `[redacted]@tenant-name.onmicrosoft.com` | User | Directory |
| Valery – Baeyo Tenant Admin | `tenant-admin@baeyodigital.example` | User | Directory |

This proves the assignments and Directory scope. It does not prove authentication-method resilience, secure credential storage, successful emergency sign-in, emergency-account usage alerting or a completed recovery drill. Those items remain operational follow-ups.

### 13. Existing workflow health

The Module 07 flow, **BAEYO – Enquiry – Client Intake**, was reviewed without changing its implementation.

The current state showed:

- Flow status: On.
- Microsoft Forms connection displayed as healthy.
- Latest test succeeded.
- Recent production runs succeeded.
- Average run duration approximately eight seconds.
- One earlier failed run followed by successful runs.

The workflow is documented as currently operational, not as failure-free.

## Troubleshooting and issues encountered

| Stage | Issue encountered | Investigation or action | Final result |
|---|---|---|---|
| Portal navigation | Entra and Purview onboarding/welcome panels interrupted navigation | Closed or bypassed the panels and returned through the required portal route | No configuration impact |
| Windows administration | Existing login/elevation issue remained unresolved | Used the available PowerShell session for read-only checks | Endpoint state validated; login issue not fixed |
| Defender discovery | Connector unavailable and EDR showing zero devices | Completed Defender setup while retaining Intune management | Connector enabled |
| Endpoint reporting | Intune continued to show `0/0` after connector enablement | Checked policy assignment and group membership | Assignment existed |
| Device synchronisation | Sync reported partial success, with 5 of 6 policies succeeding | Attempted to inspect individual policy results | Pane provided no usable detail |
| EDR report | Device assignment report remained empty | Used local service, registry and Defender-status checks | Onboarding confirmed locally |
| Conflicting portals | Intune still showed zero while the device appeared configured | Checked Microsoft Defender Device inventory | Device Active and Onboarded |
| Preset recipient selection | Early wizard screens displayed None | Corrected recipient scope before completion | Protection applied to intended recipients |
| User-impersonation counter | Counter remained `0/350` despite one table entry | Verified the actual table row | One protected user recorded |
| Domain-impersonation counter | Repeated attempts remained `0/50` | Continued without claiming the domain entry | Not implemented or evidenced |
| Policy state | Initial review showed Leave it turned off | Enabled after remaining email work | Standard protection on |
| DKIM selector | First CNAME contained an incomplete `_domainkey` label | Corrected the DNS record | DKIM later Valid and Enabled |
| DKIM propagation | Defender continued to show disabled immediately after DNS changes | Waited and refreshed after propagation | Keys detected |
| DMARC editor | Structured editor obscured the raw TXT value | Verified the DNS zone-record list | One correct DMARC record confirmed |
| Service-health evidence | Recipient and full service list could not be shown reliably in one capture | Reopened and captured two portions | Recipient, issue types and 16 services verified |
| Message Center | Initial settings used the primary administrator and incomplete options | Changed to operational recipient and enabled required emails | Final upper preferences verified |
| Purview portal | Welcome prompts and no search history caused uncertainty | Started an Audit search | Search job accepted |
| Audit processing | Search remained Queued | Refreshed after processing | Completed with 211 records |
| Audit instructions | Initial instruction about the UTC range was unclear | Clarified where and why the range was required | Correct implementation period searched |
| Gmail validation | Test message arrived in Spam | Inspected Show original authentication results | SPF, DKIM and DMARC passed |
| Secure Score | Score stayed near 48.5% while actions increased | Compared initial and final posture | Increased recommendation visibility documented |
| Workflow history | One earlier failed flow run existed | Reviewed later test and production runs | Current flow health successful |
| Screenshot quality | Several screenshots showed intermediate, incorrect or superseded states | Compared them with authoritative final results | Excluded from permanent evidence |

## Standards and decisions

### Standard rather than Strict protection

Standard preset protection provides a Microsoft-maintained baseline while reducing unnecessary disruption for the current environment.

### Gradual DMARC enforcement

DMARC remained at `p=none` so authentication reports can be reviewed before progressing to `p=quarantine` or `p=reject`.

### Multiple endpoint-validation sources

The device was validated using Intune assignment and group membership, local Windows services and onboarding state, and Microsoft Defender Device inventory. This prevented delayed Intune reporting from being treated as proof of implementation failure.

### Secure Score as an assessment tool

Secure Score was used to identify improvement opportunities rather than as the only success measurement.

Initial score:

```text
Approximately 48.5%
```

Closure score:

```text
48.45%
```

The final page showed 101 actions to address after endpoint recommendations became visible. The effectively unchanged score does not mean that Module 08 failed. Attack Surface Reduction recommendations were reviewed but deferred until they can be piloted in Audit mode.

## Validation summary

| Control | Result | Evidence |
|---|---|---|
| Secure Score baseline | Initial posture recorded | E08-01 |
| Defender/Intune integration | Connector and onboarding assignment established | E08-02–E08-05 |
| Local endpoint state | Services and onboarding state confirmed | E08-06 |
| Defender inventory | BAEYO-WIN-01 Active and Onboarded | E08-07 |
| Preset email protection | Standard on; Strict off | E08-08–E08-10 |
| DKIM | Valid and enabled | E08-11–E08-14 |
| DMARC | Monitoring and aggregate reporting configured | E08-12, E08-15 |
| External authentication | SPF, DKIM and DMARC PASS | E08-16 |
| Service-health monitoring | Operational recipient, three issue types and 16 services | E08-17–E08-19 |
| Message Center | Operational recipient and three email options enabled | E08-20–E08-21 |
| Purview Audit | Search completed with 211 records | E08-22–E08-23 |
| Global Administrator assignments | Three Directory-scoped users verified | E08-24 |
| Client-intake workflow | On with successful recent runs | E08-25 |
| Closure assessment | Remaining backlog documented | E08-26 |

## Evidence inventory

Approved evidence location:

```text
assets/screenshots/08-hardening-monitoring-and-handover/
```

| Evidence | Repository file |
|---|---|
| E08-01 | [Secure Score initial baseline](../assets/screenshots/08-hardening-monitoring-and-handover/08-01-secure-score-initial-baseline.png) |
| E08-02 | [Defender endpoint connector unavailable](../assets/screenshots/08-hardening-monitoring-and-handover/08-02-defender-endpoint-connector-unavailable.png) |
| E08-03 | [Intune EDR initial zero status](../assets/screenshots/08-hardening-monitoring-and-handover/08-03-intune-edr-initial-zero-status.png) |
| E08-04 | [Defender setup review](../assets/screenshots/08-hardening-monitoring-and-handover/08-04-defender-setup-review.png) |
| E08-05 | [Defender onboarding group membership](../assets/screenshots/08-hardening-monitoring-and-handover/08-05-defender-onboarding-group-membership.png) |
| E08-06 | [Defender local onboarding validation](../assets/screenshots/08-hardening-monitoring-and-handover/08-06-defender-local-onboarding-validation.png) |
| E08-07 | [Defender device Active and Onboarded](../assets/screenshots/08-hardening-monitoring-and-handover/08-07-defender-device-active-onboarded.png) |
| E08-08 | [Preset security policies before](../assets/screenshots/08-hardening-monitoring-and-handover/08-08-preset-security-policies-before.png) |
| E08-09 | [Standard protection impersonation user](../assets/screenshots/08-hardening-monitoring-and-handover/08-09-standard-protection-impersonation-user.png) |
| E08-10 | [Standard protection enabled](../assets/screenshots/08-hardening-monitoring-and-handover/08-10-standard-protection-enabled.png) |
| E08-11 | [DKIM disabled before](../assets/screenshots/08-hardening-monitoring-and-handover/08-11-dkim-disabled-before.png) |
| E08-12 | [DNS email authentication before](../assets/screenshots/08-hardening-monitoring-and-handover/08-12-dns-email-authentication-before.png) |
| E08-13 | [Microsoft DKIM CNAME requirements](../assets/screenshots/08-hardening-monitoring-and-handover/08-13-microsoft-dkim-cname-requirements.png) |
| E08-14 | [DKIM Valid and Enabled](../assets/screenshots/08-hardening-monitoring-and-handover/08-14-dkim-valid-enabled.png) |
| E08-15 | [DMARC reporting record](../assets/screenshots/08-hardening-monitoring-and-handover/08-15-dmarc-reporting-record.png) |
| E08-16 | [Email authentication PASS validation](../assets/screenshots/08-hardening-monitoring-and-handover/08-16-email-authentication-pass-validation.png) |
| E08-17 | [Service-health email before](../assets/screenshots/08-hardening-monitoring-and-handover/08-17-service-health-email-before.png) |
| E08-18 | [Service-health email enabled](../assets/screenshots/08-hardening-monitoring-and-handover/08-18-service-health-email-enabled.png) |
| E08-19 | [Service-health selected services](../assets/screenshots/08-hardening-monitoring-and-handover/08-19-service-health-selected-services.png) |
| E08-20 | [Message Center email before](../assets/screenshots/08-hardening-monitoring-and-handover/08-20-message-center-email-before.png) |
| E08-21 | [Message Center email enabled](../assets/screenshots/08-hardening-monitoring-and-handover/08-21-message-center-email-enabled.png) |
| E08-22 | [Purview Audit before](../assets/screenshots/08-hardening-monitoring-and-handover/08-22-purview-audit-before.png) |
| E08-23 | [Purview Audit results](../assets/screenshots/08-hardening-monitoring-and-handover/08-23-purview-audit-results.png) |
| E08-24 | [Global Administrator assignments](../assets/screenshots/08-hardening-monitoring-and-handover/08-24-global-administrator-assignments.png) |
| E08-25 | [Client-intake flow operational health](../assets/screenshots/08-hardening-monitoring-and-handover/08-25-client-intake-flow-operational-health.png) |
| E08-26 | [Secure Score closure review](../assets/screenshots/08-hardening-monitoring-and-handover/08-26-secure-score-closure-review.png) |

The approved evidence register is the authoritative source for final filenames, classifications and sanitisation requirements. Intermediate navigation, troubleshooting, duplicate and incorrect screenshots remain outside the permanent evidence set.

## Security and privacy notes

Before repository inclusion:

- Preserve the original screenshots separately.
- Create sanitized copies for repository use.
- Remove the personal Gmail address and raw message headers.
- Mask the tenant OrgId.
- Mask the device Object ID and Device AAD ID.
- Mask visible IP addresses where required.
- Preserve the approved Baeyo Digital administrator identity where it supports evidence.
- Preserve emergency-account display names while masking exact UPN local parts in published evidence.
- Do not include passwords, recovery information, tokens or authentication secrets.

## Lessons learned

- Microsoft 365 portal reporting can lag behind actual device state.
- A zero count in one portal does not prove that implementation failed.
- Final validation should use the service that owns the authoritative state.
- Table contents may be more reliable than stale navigation counters.
- DNS labels must be entered exactly; a small `_domainkey` typo prevents DKIM activation.
- DNS propagation must be allowed before judging an email-authentication change.
- Structured DNS editors can obscure the final raw record.
- Authentication success does not guarantee inbox placement.
- Purview Audit searches run asynchronously and can remain queued before completion.
- Secure Score can introduce more recommendations when new telemetry becomes available.
- Security recommendations should be tested before enforcement.
- Successful recent workflow runs do not erase earlier failures; both should be documented honestly.
- Before-and-after evidence provides stronger implementation proof than wizard-progress screenshots.
- Monitoring, auditability and recovery planning are essential parts of service implementation.

## Final outcome

Module 08 established a practical hardening, monitoring and handover baseline for Baeyo Digital.

The validated final state includes:

- BAEYO-WIN-01 actively onboarded to Microsoft Defender.
- Microsoft Defender Antivirus and endpoint sensor services running.
- Standard Microsoft 365 email protection enabled.
- Protected-user impersonation configuration recorded.
- DKIM signing enabled for `baeyodigital.com`.
- DMARC aggregate reporting configured.
- SPF, DKIM and DMARC independently validated.
- Service-health notifications configured for 16 operational services.
- Message Center major-update, privacy and weekly-digest emails enabled.
- Searchable administrative audit activity confirmed.
- Two emergency-access Global Administrators and one normal tenant administrator verified.
- The Module 07 client-intake workflow confirmed as currently operational.
- Remaining security and operational limitations documented.

The following are not claimed as completed:

- Custom-domain impersonation protection.
- Resolution of the Windows login/elevation issue.
- Intune EDR reporting consistency.
- Gmail inbox-placement improvement.
- DMARC enforcement.
- Attack Surface Reduction enforcement.
- Emergency-account sign-in drills and alerting.
- Complete enumeration of Message Center service selections.

Within the approved scope and documented limitations:

```text
Module 08 implementation and validation complete.
```

## Non-blocking follow-ups

- Investigate and resolve the separate Windows login/administrative-elevation issue.
- Review DMARC aggregate reports.
- Progress to `p=quarantine` only after legitimate sending sources are validated.
- Consider `p=reject` after a successful monitored enforcement period.
- Review whether custom-domain impersonation should be configured separately.
- Pilot selected Attack Surface Reduction rules in Audit mode.
- Periodically verify Defender and Intune reporting consistency.
- Test emergency-access accounts using a controlled documented drill.
- Establish emergency-account credential-storage and access procedures.
- Configure alerts for emergency-account usage when the monitoring prerequisites are available.
- Consider Conditional Access in a separate approved change, including emergency-account exclusions.
- Monitor sending reputation and inbox placement separately from authentication.
- Onboard future Windows devices through the established Intune and Defender process.
- Continue monitoring the client-intake flow’s failed and successful run history.

## Microsoft references

- [Set up Microsoft Defender for Business](https://learn.microsoft.com/en-us/defender-business/mdb-setup-configuration)
- [Onboard devices to Defender for Business](https://learn.microsoft.com/en-us/defender-business/mdb-onboard-devices)
- [Microsoft Secure Score](https://learn.microsoft.com/en-us/defender-xdr/microsoft-secure-score)
- [Preset security policies](https://learn.microsoft.com/en-us/defender-office-365/preset-security-policies)
- [Configure DKIM](https://learn.microsoft.com/en-us/defender-office-365/email-authentication-dkim-configure)
- [Configure DMARC](https://learn.microsoft.com/en-us/defender-office-365/email-authentication-dmarc-configure)
- [Microsoft 365 Service health](https://learn.microsoft.com/en-us/microsoft-365/enterprise/view-service-health?view=o365-worldwide)
- [Message Center preferences](https://learn.microsoft.com/en-us/microsoft-365/admin/manage/message-center?view=o365-worldwide)
- [Microsoft Purview Audit](https://learn.microsoft.com/en-us/purview/audit-solutions-overview)
- [Manage emergency-access accounts](https://learn.microsoft.com/en-us/entra/identity/role-based-access-control/security-emergency-access)
