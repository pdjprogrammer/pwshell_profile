if (Test-Path $profile)
{
	Copy-Item -Path "profile.ps1" -Destination $profile -Force
}

else
{
	New-Item -Path $profile -ItemType File -Force
	Copy-Item -Path "profile.ps1" -Destination $profile -Force
}

