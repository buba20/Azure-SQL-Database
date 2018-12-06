# Login to azure

# Login-AzureRmAccount


# Helpers
# Get-AzureRmLocation | foreach { $_.Location }

# Variables
enum Purchasing {
    vCore
    DTU
}
$purchasingModel = [Purchasing]::DTU

$subscriptionName = "Prywatna MSDN"
$location = 'ukwest'
$rgName = 'SQLServerTestResourceGroup'
$sqlServerName = 'basasqlserver'
$databasename = 'basadatabase'
$requestedServiceObjectiveName = 'Basic'

$subscription = Get-AzureRmSubscription -SubscriptionName $subscriptionName
$subscription | Set-AzureRMContext

Write-Host 'Resource group'
$rg = Get-AzureRmResourceGroup -Name $rgName -ErrorAction SilentlyContinue -ErrorVariable notPresent


if($notPresent){
   Write-Host 'Create new resource group'
    $rg = New-AzureRmResourceGroup -Name $rgName -Location $location
}


$rg

# Create SQL Server
Write-Host 'Checking Database'
$sqlServer = Get-AzureRmSqlServer -ServerName $sqlServerName -ResourceGroupName $rg.ResourceGroupName -ErrorVariable notPresent -ErrorAction SilentlyContinue

if($notPresent) { 
    $sqlServer = New-AzureRmSqlServer -ResourceGroupName $rgName -ServerName $sqlServerName -Location $rg.Location -SqlAdministratorCredentials (Get-Credential)
}

$sqlServer

$db = New-AzureRmSqlDatabase -DatabaseName $databasename -ServerName $sqlServer.ServerName -ResourceGroupName $rg.ResourceGroupName -RequestedServiceObjectiveName requestedServiceObjectiveName

$db

