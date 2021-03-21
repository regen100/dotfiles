Param([Int]$status = -1)

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class Win32 {
  [DllImport("user32.dll")]
  public static extern IntPtr GetForegroundWindow();

  [DllImport("user32.dll")]
  public static extern int SendMessage(IntPtr hWnd, uint Msg, int wParam, int lParam);

  [DllImport("imm32.dll")]
  public static extern IntPtr ImmGetDefaultIMEWnd(IntPtr hWnd);

  public const uint WM_IME_CONTROL = 0x283;
  public const int IMC_GETOPENSTATUS = 0x0005;
  public const int IMC_SETOPENSTATUS = 0x0006;
}
"@

$imeWnd = [Win32]::ImmGetDefaultIMEWnd([Win32]::GetForegroundWindow())
$before = [Win32]::SendMessage($imeWnd, [Win32]::WM_IME_CONTROL, [Win32]::IMC_GETOPENSTATUS, 0)
if ($status -in 0..1) {
  [void][Win32]::SendMessage($imeWnd, [Win32]::WM_IME_CONTROL, [Win32]::IMC_SETOPENSTATUS, $status)
}
Write-Host $before
