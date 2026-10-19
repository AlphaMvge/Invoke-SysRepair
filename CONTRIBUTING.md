# Contributing to Invoke-SysRepair

First off, thank you for considering contributing to `Invoke-SysRepair`! It's people like you that make it a premier tool for sysadmins and power users.

## Guidelines

1. **Zero-Reboot Invariant**: Any proposed repair or diagnostic routine must strive to maintain online system functionality without requiring forced system restarts.
2. **Safety First**: Destructive commands (such as clearing prefetch or forensic event logs) must remain opt-in and accompanied by clear educational explanations.
3. **PSScriptAnalyzer Compliance**: Ensure all PowerShell scripts conform to standard PowerShell formatting and pass static analysis.
4. **Structured Logging**: Diagnostic results should interface with the internal RDS logging engine so users receive consistent before-and-after audit logs.

## Submitting Pull Requests

1. Fork the repo and create your branch from `main`.
2. Test your changes locally in both interactive and `-NonInteractive` modes.
3. Submit a Pull Request describing your changes and testing environment.
