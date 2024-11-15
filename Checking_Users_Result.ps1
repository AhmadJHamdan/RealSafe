Write-Host "Welcome my Friend" -Foreground Green

Function Safe{
	Write-Host "Score = 100" -Foreground Green
	Write-Host "You are doing Great." -Foreground Green
}

<# Total Number of Users #>
$TNU = (Get-LocalUser).Name.count

<# Get Local Users on PC with their status #>
Write-Host "Local Users on this PC are:" -Foreground DarkCyan
(Get-LocalUser).Name

if((Get-LocalUser | findstr "Administrator" | findstr "Built-in" | findstr "False") -eq $null){
Write-Host "Default Administrator Account is used as a disaster recovery account. It is recommended to disabled it." -Foreground Magenta
}

Write-Host "Administrator, DefaultAccount, Guest and WDAGUtilityAccount come built in with Windows." -Foreground DarkCyan 

$KnowUsers = (Read-Host "Are you aware of the rest of users? [y/n]").tolower().trim()

if ($KnowUsers -ne 'y' -and $KnowUsers -ne 'n')
{
	$user_loop = 0
	while ($user_loop -ne 1)
	{
		Write-Host "Wrong Entry! Please answer using 'y' for Yes and 'n' for no" -Foreground Red
		$KnowUsers = (Read-Host "Are you aware of the rest of users? [y/n]").tolower().trim()
		if ($KnowUsers -eq 'y' -or $KnowUsers -eq 'n')
		{
			$user_loop = 1
		}
	}
}

if ($KnowUsers -eq 'y')
{
	$user_safe = 1
	Safe
	exit
} 

if ($KnowUsers -eq 'n')
{
	try 
	{
		[int]$UnknownUsers = (Read-Host "How many of the other users you aren't aware of? [Use Numbers, Default is 0.]").trim()
		 
		if (($UnknownUsers -gt $TNU) -or ($UnknownUsers -lt 0)) 
		{
			$unknown_loop = 0
			while ($unknown_loop -ne 1)
			{
				Write-Host "Entered Number Exceeds the number of Local Users or negative. Please Try Again." -Foreground Red
				[int]$UnknownUsers = (Read-Host "How many of the users you aren't aware of? [Use Numbers]").trim()
				if (($UnknownUsers -le $TNU) -and ($UnknownUsers -gt 0))
				{
					$unknown_loop = 1
				}
			}
		}
		elseif ($UnknownUsers -eq 0)
		{
			$user_safe = 1
			Safe
			exit
		}
		else
		{
			$user_safe = $UnknownUsers/$TNU
			$Score = 100 - [math]::floor($user_safe * 100)
			Write-Host "Score =" $Score -Foreground DarkYellow
			Write-Host "Please Investigate the Presence of Unknown Users." -Foreground DarkYellow
		}
	}
	catch 
	{
		Write-Host "Please Re-run the program and use numbers only." -Foreground Red
		exit
	}
}