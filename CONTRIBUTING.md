# Contributing

Contributions that improve defensive Windows investigation, documentation, testing, accessibility, or safe evidence collection are welcome.

## Workflow

1. Open an issue describing the problem or proposed improvement.
2. Create a focused branch from `main`.
3. Add or update tests for behavior changes.
4. Run Pester and PSScriptAnalyzer locally.
5. Submit a pull request explaining the security value, test evidence, and documentation changes.

## Quality requirements

- Use approved PowerShell verbs and comment-based help.
- Prefer structured objects to formatted text.
- Collect only the data required for the documented defensive purpose.
- Use synthetic names, domains, addresses, and event data.
- Do not add offensive payloads, credential theft, persistence, evasion, or unauthorized scanning capabilities.
- Document assumptions, required permissions, limitations, and safe usage.

## Pull request evidence

Include:

- the issue being solved;
- before-and-after behavior;
- Pester results;
- PSScriptAnalyzer results;
- sanitized screenshots when they materially improve verification; and
- any compatibility considerations.

All participants must follow the repository code of conduct.
