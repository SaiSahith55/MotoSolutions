Param(
 [string]$webappname,
 [string]$webappserviceplanname,
 [string]$resourcegroupname,
 [string]$location,
 [string]$env,
 [string]$department
)


Connect-AzAccount -Identity

# Create a resource group.
New-AzResourceGroup -Name "$resourcegroupname" -Location "$location" -Tag @{Empty="$env"; Department="$department"}

# Create an App Service plan in Free tier.
New-AzAppServicePlan -Name $webappname -Location $location -ResourceGroupName $resourcegroupname -Tier Free

# Create a web app slot.
New-AzWebAppSlot -Name $webappname -ResourceGroupName -AppServicePlan $webappserviceplanname $resourcegroupname -Slot staging
#deploy to slot
Publish-AzWebApp -ResourceGroupName $resourcegroupname -Name $webappname -AppServicePlan $webappserviceplanname -Slot Staging -ArchivePath */**/MotoSolution.Zip
#swap staging to prod slot
Write-Host "deployment to slot is completed"
Switch-AzWebAppSlot -Name $webappname -AppServicePlan $webappserviceplanname -ResourceGroupName $resourcegroupname -SourceSlotName staging -DestinationSlotName production
write-host "swap staging to prod is completed"
Disconnect-AzAccount

