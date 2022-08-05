#Requires -Modules Az.Accounts, Az.Network, Color, AWS.Tools.Common, AWS.Tools.SimpleSystemsManagement

#region MODULES
Import-Module -Name 'Color'
#endregion

#region MISC
#endregion

#region FUNCTIONS
function Get-FrCreds {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [string] $ProfileName,

        [Parameter()]
        [string] $Region = 'us-east-1'
    )

    $Keys = @{ProfileName = $ProfileName; Region = $Region }
    $Inventory = (Get-SSMParameter @Keys -Name Inventory).Value | ConvertFrom-Json
    $Params = @{ Account = $Inventory.Accounts; RoleName = $Inventory.Roles.Infrastructure }
    Get-RoleCredential @Keys @Params
}

function Get-RoleCredential {
    <# =========================================================================
    .SYNOPSIS
        Get IAM credential object
    .DESCRIPTION
        Get IAM Credential from IAM Role
    .PARAMETER ProfileName
        AWS Credential Profile name
    .PARAMETER Keys
        AWS access key and secret keys in a PSCredential object
    .PARAMETER Region
        AWS Region
    .PARAMETER Account
        Custom object containing AWS Account Name and Id properties
    .PARAMETER RoleName
        Name of AWS IAM Role to utilize and obtain credentials
    .PARAMETER DurationInSeconds
        Duration of temporary credential in seconds
    .INPUTS
        None.
    .OUTPUTS
        System.Object.
    .EXAMPLE
        PS C:\> $acc = [PSCustomObject] @{ Name = 'myAccount'; Id = '012345678901' }
        PS C:\> Get-RoleCredential -ProfileName myProfile -Region us-east-1 -Acount $acc -RoleName mySuperRole
        Get AWS Credential object(s) for account ID 012345678901 and Role name mySuperRole
    .NOTES
        General notes
    ========================================================================= #>
    [CmdletBinding(DefaultParameterSetName = '_profile')]
    [Alias('Get-AwsCreds')]
    Param(
        [Parameter(Mandatory, HelpMessage = 'AWS Profile', ParameterSetName = '_profile')]
        [ValidateScript( { (Get-AWSCredential -ListProfileDetail).ProfileName -contains $_ })]
        [string] $ProfileName,

        [Parameter(Mandatory, HelpMessage = 'Access key and Secret key', ParameterSetName = '_keys')]
        [ValidateNotNullOrEmpty()]
        [pscredential] $Keys,

        [Parameter(Mandatory, HelpMessage = 'AWS Region')]
        [ValidateScript( { (Get-AWSRegion).Region -contains $_ })]
        [string] $Region,

        [Parameter(Mandatory, HelpMessage = 'PS Object containing AWS Account Name and ID properties')]
        [ValidateNotNullOrEmpty()]
        [System.Object[]] $Account,

        [Parameter(Mandatory, HelpMessage = 'AWS Role name')]
        [ValidateNotNullOrEmpty()]
        [string] $RoleName,

        [Parameter(HelpMessage = 'Duration of temporary credential in seconds')]
        [ValidateNotNullOrEmpty()]
        [int] $DurationInSeconds = 3600
    )

    Begin {
        $Creds = @{ Region = $Region }

        if ( $PSCmdlet.ParameterSetName -eq '_keys' ) {
            $Creds.Add('AccessKey', $Keys.UserName)
            $Creds.Add('SecretKey', $Keys.GetNetworkCredential().Password )
        }
        else {
            $Creds.Add('ProfileName', $ProfileName)
        }

        $Credential = @{ }
    }

    Process {
        foreach ( $Acc in $Account ) {
            $StsParams = @{
                RoleArn           = 'arn:aws:iam::{0}:role/{1}' -f $SAcc.Id, $RoleName
                RoleSessionName   = 'SwitchToChild'
                DurationInSeconds = $DurationInSeconds # aws default is 3600 (1hr)
            }

            $Credential.Add($Acc.Name, (New-AWSCredential -Credential (Use-STSRole @Creds @StsParams).Credentials))
        }
    }

    End {
        $Credential
    }
}

function Get-NextAzureCidrRange {
    $ExistingCidrRanges = @()
    $Vnets = @()
    $SecondOctets = @()
    $AzureCidrRange = @(0..128)

    try {
        $Subs = Get-AzSubscription

        # loop through subs and get cidr ranges from all vents
        foreach ($Sub in $Subs) {
            $Vnets = $null
            Set-AzContext -SubscriptionId $Sub.Id | Out-Null
            $Vnets += Get-AzVirtualNetwork -ErrorAction SilentlyContinue
            if ($null -eq $Vnets) { continue }
            else {
                foreach ($Vnet in $Vnets) {
                    if ($($Vnet.AddressSpace.AddressPrefixes) -like '10.*') {
                        $ExistingCidrRanges += $($Vnet.AddressSpace.AddressPrefixes)
                    }
                    else { continue }
                }
            }
        }

        # get array of second octets
        foreach ($Range in $ExistingCidrRanges) {
            $SecondOctets += [int]($Range -replace '10\.(\d{1,3})(\.\d{1,3}){2}/16', '$1')
        }

        # sort octets from lowers to highest
        $SortedSecondOctets = $SecondOctets | Sort-Object

        $Differences = Compare-Object $SortedSecondOctets $AzureCidrRange
        [int]$FirstFree = $Differences[0].InputObject

        return "10.$FirstFree.0.0/16"
    }
    catch {
        Write-Error "Ran into an issue: Line $($_.InvocationInfo.ScriptLineNumber) returned '$($_.Exception.Message)'" -ErrorAction Continue
        throw $PSItem
    }
}
#endregion

#region ALIASES
Set-Alias -Name 'll' -Value 'Get-ChildItem'
#endregion

Clear-Host