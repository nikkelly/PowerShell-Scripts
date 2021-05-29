# Single setting update
$tenantId = (Get-AzureadTenantDetail).ObjectId
$roleSettings = Get-AzureADMSPrivilegedRoleSetting -ProviderId 'aadRoles' -Filter "ResourceId eq '$tenantId'"
foreach ($roleSetting in $roleSettings){
$setting = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedRuleSetting
$setting.RuleIdentifier = "ApprovalRule"
$setting.Setting= '{
"Enabled": true,
"IsCriteriaSupported": true,
"Approvers": [
  {
    "Id": "e3bbd114-fbbb-4d53-b612-2f29520582ce",
    "Type": "Group",
    "DisplayName": "PIM Approvers",
    "PrincipalName": ""
  }
],
"HasNotificationPolicy": true
}'
Write-Host (Get-AzureADMSPrivilegedRoleDefinition -ProviderId 'aadRoles' -ResourceId $rolesetting.ResourceId -Id $rolesetting.RoleDefinitionId).DisplayName : $roleSetting.roleDefinitionId
Set-AzureADMSPrivilegedRoleSetting -ProviderId 'aadRoles' -Id $roleSetting.Id -ResourceId $roleSetting.resourceId -RoleDefinitionId $roleSetting.roleDefeinintionId -UserMemberSettings $setting
}

## How do I skip the global admin account?
foreach ($roleSetting in $roleSettings | Where-Object {$_.RoleDefinitionId -ne '62e90394-69f5-4237-9190-012177145e10'}){

# Multiple Setting Update
$tenantId = (Get-AzureadTenantDetail).ObjectId
$roleSettings = Get-AzureADMSPrivilegedRoleSetting -ProviderId 'aadRoles' -Filter "ResourceId eq '$tenantId'"
foreach ($roleSetting in $roleSettings | Where-Object {$_.RoleDefinitionId -ne '62e90394-69f5-4237-9190-012177145e10'}){
$setting = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedRuleSetting
#Settings go here
# Set timeout to 4 hours
$setting.RuleIdentifier = "ExpirationRule"
$setting.Setting= '{
  "permanentAssignment":true,
  "maximumGrantPeriodInMinutes":60
  }'
$setting1 = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedRuleSetting
# Require Azure MFA on all roles
$setting1.RuleIdentifier = "MfaRule"
$setting1.Setting= '{
  "mfaRequired":false
  }'
$setting2 = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedRuleSetting
# Don't Require Justification
$setting2.RuleIdentifier = "JustificationRule"
$setting2.Setting='{
  "required":true
}'
$setting3 = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedRuleSetting
# Remove approvers
$setting3.RuleIdentifier = "ApprovalRule"
$setting3.Setting= '{
"Enabled": false
}'
Write-Host (Get-AzureADMSPrivilegedRoleDefinition -ProviderId 'aadRoles' -ResourceId $rolesetting.ResourceId -Id $rolesetting.RoleDefinitionId).DisplayName : $roleSetting.roleDefinitionId
Set-AzureADMSPrivilegedRoleSetting -ProviderId 'aadRoles' -Id $roleSetting.Id -ResourceId $roleSetting.resourceId -RoleDefinitionId $roleSetting.roleDefeinintionId -UserMemberSettings $setting,$setting1,$setting2,$setting3
}
