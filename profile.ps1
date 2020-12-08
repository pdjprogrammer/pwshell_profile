Clear-Host

Function Clear-Trash {Clear-RecycleBin}
New-alias crb Clear-Trash

Function Get-IP4 {ipconfig | Select-String -Pattern "IPv4"}
New-alias ip4 Get-IP4

Function Get-HelpUpdate {Update-Help -Force -Ea 0 -Ev what}
New-alias updhelp Get-HelpUpdate

Function Get-Version {$psversiontable}
New-alias ver Get-Version

Function Get-OSInfo {Get-ComputerInfo | Select-Object WindowsProductName, OSArchitecture, WindowsVersion, OSBuildNumber}
New-alias sysinfo Get-OSInfo

Function Reset-DevEnvironment {
	$directory1 = "$env:USERPROFILE\.vscode"
	$directory2 = "$env:APPDATA\Code"
	$directory3 = "$env:USERPROFILE\.pylint.d"
	$directory4 = "$env:LOCALAPPDATA\pip"
	$directory5 = "$env:APPDATA\Python"
	$directory6 = "$env:USERPROFILE\.idlerc"

	# Reset VSCode
	if ((Test-Path $directory1) -and (Test-Path $directory2))
	{
		Remove-Item $directory1 -Recurse -Force
		Remove-Item $directory2 -Recurse -Force
	}

	# Reset pylint
	if (Test-Path $directory3)
	{
		Remove-Item $directory3 -Recurse -Force
	}

	# Reset pip
	if ((Test-Path $directory4) -and (Test-Path $directory5))
	{
		Remove-Item $directory4 -Recurse -Force
		Remove-Item $directory5 -Recurse -Force
	}

	# Reset IDLE
		if (Test-Path $directory6)
	{
		Remove-Item $directory6 -Recurse -Force
	}
}
New-alias devreset Reset-DevEnvironment

Function Clear-History {
	$historyFile = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
	$bash_history = "$env:HOMEPATH\.bash_history"

	if (Test-Path $historyFile)
	{
		Remove-Item $historyFile
	}

	if (Test-Path $bash_history)
	{
		Remove-Item $bash_history
	}
}
New-Alias clrhist Clear-History

$curUser = (Get-ChildItem Env:\USERNAME).Value
$isAdmin = (New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
$time = Get-Date
$hour = $time.Hour

if ($hour -ge 4 -and $hour -le 11)
{
	Write-Host "Good Morning, $curUser!"
}

if ($hour -ge 12 -and $hour -le 17)
{
	Write-Host "Good Afternoon, $curUser!"
}

if ($hour -ge 18 -and $hour -le 24)
{
	Write-Host "Good Evening, $curUser!"
}

if ($hour -ge 0 -and $hour -le 3)
{
	Write-Host "Good Evening, $curUser!"
}

Write-Host "Today is: $($time.ToLongDateString())" -foregroundColor Yellow

Write-Host "Added following aliases: crb, ip4, updhelp, ver, sysinfo, devreset, clrhist"

if ($isAdmin)
{
	Write-Host "WARNING: Logged in as Admin" -foregroundColor DarkRed
}

function prompt {
	Write-Host -NoNewLine "[" -foregroundColor Yellow
	Write-Host -NoNewLine (Get-Date -f "hh:mm:ss tt") -foregroundColor Cyan
	Write-Host -NoNewLine "] " -foregroundColor Yellow
	Write-Host -NoNewLine "$((Get-Location).Path)"

	Write-Host -Object "$(if ($isAdmin){ '#' } else { '$' })" -NoNewline -ForegroundColor DarkRed
	if ($isAdmin)
	{
		$host.UI.RawUI.WindowTitle = "Administrator"
	}
	else
	{
		$host.UI.RawUI.WindowTitle = "$curUser"
	}

	Return " "
}

