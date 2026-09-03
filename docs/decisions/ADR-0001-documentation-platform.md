# ADR-0001 — Use GitHub and Markdown for Deployment Documentation

- Status: Accepted and reaffirmed
- Decision date: 2026-07-21
- Closure review: 2026-09-02
- Decision owner: Valery

## Context

Baeyo Digital needed documentation that was version controlled, portable, portfolio-friendly, and suitable for technical diagrams and configuration evidence. The completed lab also requires a clear separation between its authoritative private record and any later employer-facing public edition.

## Decision

Use this private GitHub repository as the authoritative source of truth. Write technical documentation in Markdown, retain only approved private-master evidence, and use Mermaid for architecture and workflow diagrams.

Create any public portfolio edition as a separate sanitized repository with independently reviewed content and fresh Git history. Do not make this private master public or use it as the direct public release source.

## Consequences

### Positive

- Complete private change history
- Easy review and rollback of documentation
- Strong portfolio evidence
- Documentation remains independent of the Microsoft tenant
- Public-release sanitization can be reviewed separately

### Risks

- Accidental exposure of secrets, identifiers, or personal information
- Screenshots can contain tenant, device, account, or operational data
- Publishing the private repository would also expose its historical Git objects

### Controls

- Keep the authoritative deployment repository private
- Use `.gitignore`
- Review every staged file before committing
- Classify and sanitize evidence before repository inclusion
- Create a separate sanitized public portfolio repository later
