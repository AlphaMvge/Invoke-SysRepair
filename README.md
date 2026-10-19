# 🛡️ Invoke-SysRepair

[![PowerShell 5.1+](https://img.shields.io/badge/PowerShell-5.1%20%7C%207%2B-blue.svg)](https://github.com/PowerShell/PowerShell)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011%20%7C%20Server-lightgrey.svg)](https://microsoft.com/windows)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Zero-Reboot](https://img.shields.io/badge/Architecture-Zero--Reboot%20Hot--Repair-brightgreen.svg)](#zero-reboot-philosophy)
[![Code Style](https://img.shields.io/badge/Code%20Style-PSScriptAnalyzer-brightgreen.svg)](https://github.com/PowerShell/PSScriptAnalyzer)

> **Enterprise-Grade Zero-Reboot Windows Diagnostics, Component Store & Self-Healing Restoration Suite for PowerShell.**

`Invoke-SysRepair` is a production-grade system restoration utility designed to diagnose and repair corrupt Windows components, degraded file systems, and stalled network stacks **without requiring a system reboot**. Engineered to replace destructive and obsolete `.bat` scripts, it features **on-the-spot root cause diagnostics (RDS)**, **live online NTFS repairs**, **intelligent DISM component store caching**, **non-disruptive adapter cycling**, and **educational terminal explanations**.

---

## 📸 Real-Time Interactive ANSI Terminal Dashboard

```text
╔══════════════════════════════════════════════════════════════════════════════╗
║        INVOKE-SYSREPAIR : ZERO-REBOOT WINDOWS DIAGNOSTICS & REPAIR           ║
╠══════════════════════════════════════════════════════════════════════════════╣
║ Production-Grade Online Self-Healing, Hot-Fix Services & Root Cause Diag     ║
╚══════════════════════════════════════════════════════════════════════════════╝

Select a routine by entering the corresponding number:

  [1] System Integrity & File Checker      (SFC + Smart DISM repair)
  [2] Live Disk Health & Self-Healing      (Online chkdsk /scan + TRIM/Defrag)
  [3] Zero-Reboot Network Stack Reset      (DNS, ARP, DHCP & Adapter refresh)
  [4] Safe Cache & Explorer Rebuild        (Temp files + Thumbnail DB rebuild)
  [5] Startup & Process Resource Audit     (CIM startup list + RAM audit)
  [6] >> RUN FULL RECOMMENDED SUITE <<     (Automated sequential execution)
  [7] Advanced Deep Clean (Optional)       (Prefetch & Event logs - with warnings)
  [8] View Current RDS Summary Table       (Root cause diagnostics & logs)
  [9] Exit

Enter Choice [1-9]:
```

---

## ⚡ Instant One-Liner Quickstart

Run directly from any elevated PowerShell prompt without installing:

```powershell
irm https://raw.githubusercontent.com/AlphaMvge/Invoke-SysRepair/main/install.ps1 | iex
```

Once installed globally, you can invoke the suite anytime from any directory:

```powershell
Invoke-SysRepair
```

Or run headless in task schedulers and maintenance pipelines:

```powershell
Invoke-SysRepair -Mode Full -NonInteractive -ExportReport
```

---

## 🚀 Key Features

- 🔄 **Zero-Reboot Self-Healing**: Eliminates disruptive `shutdown /r` commands. Repairs system files, volume descriptors, and networking while the machine stays fully operational.
- 🩺 **Root Cause Diagnosis Summary (RDS)**: Generates a clear before-and-after audit table tracking the diagnostic status (`OPTIMAL`, `REPAIRED`, `ATTENTION`), exact actions taken, and log file exports.
- 🧠 **On-The-Spot Educational Learning**: Integrates `[DID YOU KNOW?]` breakdowns before each operation, explaining OS architecture (Component Store vs. Active Binaries, TRIM vs. Defrag, DNS cache mechanics).
- 🔬 **Intelligent DISM Triage**: Stops running redundant 20-minute `RestoreHealth` scans when the Component Store is verified clean via fast `CheckHealth` telemetry.
- 💽 **Live Online NTFS Repair**: Replaces volume-locking `chkdsk /R` with `chkdsk C: /scan`, fixing index entries and bad clusters live without dismounting the volume.
- ⚡ **SSD Wear-Aware Optimization**: Automatically detects drive media type—dispatches `ReTrim` to maintain NAND performance on SSDs and defragments only rotational HDDs.
- 🌐 **Surgical Network Restoration**: Bypasses stack-destroying `netsh winsock reset` by cleanly flushing DNS, renewing DHCP, purging ARP tables, and soft-cycling network adapters live.
- 🧹 **Safe Locked-File Cache Cleanup**: Cleans `%TEMP%` and Explorer thumbnail databases without crashing Explorer or throwing ugly red errors on active process files.
- 📊 **Modern CIM Startup Telemetry**: Replaces deprecated `wmic` with high-speed CIM instances (`Win32_StartupCommand`) and audits top RAM consumers.

---

## 📊 Architectural Comparison

| Dimension | Legacy Maintenance Scripts (`.bat`) | `Invoke-SysRepair` Suite |
| :--- | :--- | :--- |
| **System Downtime** | 🔴 Forces reboot (`shutdown /r /f /t 5`) | 🟢 **100% Zero-Reboot online repair** |
| **Disk Checking** | 🔴 `chkdsk /R` locks volume, halts scripts | 🟢 **`chkdsk C: /scan` live online self-healing** |
| **Drive Media Type** | 🔴 Blindly defragments SSDs (causes wear) | 🟢 **Detects SSD (TRIM) vs HDD (Defrag)** |
| **Network Reset** | 🔴 `netsh winsock reset` breaks stack till reboot | 🟢 **Soft adapter cycle + DNS/ARP/DHCP flush** |
| **DISM Efficiency** | 🔴 3x linear scan (wastes 25+ minutes) | 🟢 **Smart triage: RestoreHealth only if damaged** |
| **Prefetch Handling** | 🔴 Destroys prefetch (slows subsequent app boots) | 🟢 **Preserved; optional deep clean with warnings** |
| **Diagnostics & RDS** | 🔴 Silent exit or raw screen vomit | 🟢 **Structured Root Cause Diagnosis (RDS) Table** |
| **Headless Support** | 🔴 Pauses waiting for user keystrokes | 🟢 **Full CLI parameters (`-Mode`, `-NonInteractive`)** |

---

## 🔬 Educational Deep Dive (Built Into The CLI)

```text
┌── [ON-THE-SPOT DIAGNOSIS & LEARNING : SFC vs. DISM Triage] 
│   DISM inspects the Windows Component Store (C:\Windows\WinSxS), the authoritative
│   repository of all OS binary payloads. SFC validates the active operating system files
│   against that clean store.
│   Running RestoreHealth blindly wastes 20+ minutes when the store is already intact.
│   We diagnose first via CheckHealth and trigger online restoration only when needed!
└──
```

### 1. Why `chkdsk C: /scan` instead of `chkdsk /R`?
Traditional `chkdsk /R` attempts to read every sector on the disk, requiring the drive to be dismounted. On an active system drive, this forces a restart prompt and delays boot for hours. Modern Windows NTFS supports online self-healing via `/scan`, which repairs metadata inconsistencies without taking the filesystem offline.

### 2. Why shouldn't you blindly clear `C:\Windows\Prefetch`?
The Windows Cache Manager records application memory pages and file dependencies into `.pf` files. Clearing prefetch does **not** free substantial storage or speed up Windows; instead, it causes applications to launch significantly slower for days while Windows re-profiles their binaries. `Invoke-SysRepair` keeps prefetch intact by default.

---

## 📋 Root Cause Diagnosis Summary (RDS) Report

At the conclusion of each repair session, the built-in RDS engine compiles a diagnostic audit:

```text
╔══════════════════════════════════════════════════════════════════════════════╗
║                 ROOT CAUSE DIAGNOSIS & RESULTS SUMMARY (RDS)                 ║
╠══════════════════════════════════════════════════════════════════════════════╣
TIME      | SUBSYSTEM        | STATUS     | DIAGNOSIS & OUTCOME                 
------------------------------------------------------------------------------
09:12:05  | DISM Image       | OPTIMAL    | Store healthy -> CheckHealth comp...
09:12:28  | SFC Files        | REPAIRED   | Corrupt files found -> Repaired f...
09:12:45  | NTFS Volume      | OPTIMAL    | Healthy -> chkdsk /scan executed    
09:13:01  | Storage Media    | OPTIMAL    | SSD Detected -> ReTrim dispatched   
09:13:14  | Network          | OPTIMAL    | Refreshed stack -> DNS/ARP/DHCP r...
09:13:30  | Explorer & Cache | OPTIMAL    | Cleaned caches -> Purged Temp + T...
------------------------------------------------------------------------------
```

---

## 🛠️ CLI Parameter Reference

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `-Mode` | `String` | Selects routine: `Full`, `Integrity`, `Disk`, `Network`, `Cache`, `Startup`, `DeepClean` |
| `-NonInteractive` | `Switch` | Suppresses all prompts and menus for unattended automation. |
| `-ExportReport` | `Switch` | Automatically exports the RDS report to a `.txt` file upon completion. |
| `-ReportPath` | `String` | Optional custom file path or directory for the exported RDS summary. |

### CLI Examples

```powershell
# Run the complete repair suite without interactive prompts and export the report
.\Invoke-SysRepair.ps1 -Mode Full -NonInteractive -ExportReport

# Refresh the network stack in under 5 seconds
.\Invoke-SysRepair.ps1 -Mode Network -NonInteractive

# Perform live online disk verification
.\Invoke-SysRepair.ps1 -Mode Disk
```

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/AlphaMvge/Invoke-SysRepair/issues).

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See [`LICENSE`](LICENSE) for more information.
