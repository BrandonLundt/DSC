function Get-TargetResource {
	[CmdletBinding()]
	[OutputType([Hashtable])]
	param (
		[parameter(Mandatory)]
		[String]$ComputerName
    )

	$returnValue = @{
		ComputerName = $env:COMPUTERNAME
	}

	$returnValue

}

function Set-TargetResource {
	[CmdletBinding()]
	param (
		[parameter(Mandatory)]
		[String]$ComputerName
	)

    if (-not(Test-TargetResource -ComputerName $ComputerName)) {
        Rename-Computer -NewName $ComputerName -Force -Restart
    }

	#Include this line if the resource requires a system reboot.
	$global:DSCMachineStatus = 1
}
function Test-TargetResource {
	[CmdletBinding()]
	[OutputType([Boolean])]
	param (
		[parameter(Mandatory)]
		[String]$ComputerName
	)

    if ($ComputerName -eq $env:COMPUTERNAME) {
        Write-Verbose -Message 'ComputerName matches the desired state.'
        [bool]$true
    }
    else {
        Write-Verbose -Message 'ComputerName is Non-Compliant!'
        [bool]$false
    }
}

Export-ModuleMember -Function *-TargetResource