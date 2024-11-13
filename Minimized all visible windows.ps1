# Delay for 60 seconds (adjust as needed)
Start-Sleep -Seconds 60

# This script minimizes only windows that are visible and not system processes
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hWnd);
    [DllImport("user32.dll", SetLastError=true)]
    public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);
    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);
    public const int SW_MINIMIZE = 6;
}
"@

[Win32]::EnumWindows({
    param($hWnd, $lParam)
    if ([Win32]::IsWindowVisible($hWnd)) {
        [Win32]::ShowWindow($hWnd, [Win32]::SW_MINIMIZE)
    }
    $true
}, [IntPtr]::Zero)
