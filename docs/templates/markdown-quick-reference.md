# Markdown Quick Reference

## Headings

```markdown
# Main title
## Section
### Subsection
```

## Emphasis

```markdown
**bold**
*italic*
`inline command`
```

## Lists

```markdown
- Item
- Item

1. First
2. Second

- [ ] Open task
- [x] Completed task
```

## Link and image

```markdown
[Microsoft Learn](https://learn.microsoft.com/)
![Alternative text](../../assets/screenshots/example.png)
```

## Table

```markdown
| Setting | Value | Reason |
|---|---|---|
| MDM user scope | Some | Pilot before broad rollout |
```

## Code block

````markdown
```powershell
Get-ComputerInfo
```
````

## Callout

```markdown
> [!WARNING]
> Never publish passwords, tokens, recovery codes, or private tenant data.
```

## Mermaid diagram

````markdown
```mermaid
flowchart LR
    A[User] --> B[Microsoft Entra ID]
    B --> C[Intune]
    C --> D[Windows Device]
```
````
