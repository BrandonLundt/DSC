function Get-TargetResource {
	[CmdletBinding()]
	[OutputType([Hashtable])]
	param (
		[parameter(Mandatory)]
		[String]$DomainName
	)

	$returnValue = @{
		DomainName = Get-CimInstance -ClassName Win32_ComputerSystem |
                     Select-Object -ExpandProperty Domain
	}

	$returnValue

}

function Set-TargetResource {
	[CmdletBinding()]
	param (
		[parameter(Mandatory)]
		[String]$DomainName
	)

    if (-not(Test-TargetResource -DomainName $DomainName)) {
        Add-Computer -DomainName $DomainName -Restart
    }

	#Include this line if the resource requires a system reboot.
	$global:DSCMachineStatus = 1

}

function Test-TargetResource {
	[CmdletBinding()]
	[OutputType([Boolean])]
	param (
		[parameter(Mandatory)]
		[String]$DomainName
	)

    $CurrentSetting = (Get-CimInstance -ClassName Win32_ComputerSystem).Domain

    if ($DomainName -eq $CurrentSetting -or $DomainName -eq ($CurrentSetting -replace '\.[^\.]*$')) {
        Write-Verbose -Message 'DomainName matches the desired state.'
        [bool]$true
    }
    else {
        Write-Verbose -Message 'DomainName is Non-Compliant!'
        [bool]$false
    }
}

Export-ModuleMember -Function *-TargetResource