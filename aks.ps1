param(
    [string]$ResourceGroupName,
    [string]$AksClusterName,
    [string]$Action
)

if ($Action -ne "start" -and $Action -ne "stop") {
    Write-Error "L'action doit être 'start' ou 'stop'"
    exit
}

$ErrorActionPreference = "Stop"

$connection = Get-AutomationConnection -Name 'AzureRunAsConnection'
Connect-AzAccount -ServicePrincipal -TenantId $connection.TenantId -ApplicationId $connection.ApplicationId -CertificateThumbprint $connection.CertificateThumbprint

$agentPoolName = (Get-AzAks -ResourceGroupName $ResourceGroupName -Name $AksClusterName).AgentPoolProfiles[0].Name

if ($Action -eq "start") {
    $nodeCount = 3
} elseif ($Action -eq "stop") {
    $nodeCount = 0
}

Set-AzAksNodePool -ResourceGroupName $ResourceGroupName -ClusterName $AksClusterName -Name $agentPoolName -NodeCount $nodeCount
