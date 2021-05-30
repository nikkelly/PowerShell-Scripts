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


$settingsTable = @{
JustificationRule = '{
  "required":true
}'
ApprovalRule = '{
"Enabled": false
}'
MfaRule = '{
  "mfaRequired":false
  }'
ExpirationRule = '{
  "permanentAssignment":true,
  "maximumGrantPeriodInMinutes":60
  }'
}

# Multiple Setting Update
$tenantId = (Get-AzureadTenantDetail).ObjectId
$roleSettings = Get-AzureADMSPrivilegedRoleSetting -ProviderId 'aadRoles' -Filter "ResourceId eq '$tenantId'"
foreach ($roleSetting in $roleSettings | Where-Object {$_.RoleDefinitionId -ne '62e90394-69f5-4237-9190-012177145e10'}){
  $UserMemberSettings = @()
  $settingstable.GetEnumerator() | Foreach-Object{
    $setting = New-Object Microsoft.Open.MSGraph.Model.AzureADMSPrivilegedRuleSetting
    $setting.RuleIdentifier = $_.key
    $setting.Setting = $_.value
    $UserMemberSettings += $setting
  }
Write-Host (Get-AzureADMSPrivilegedRoleDefinition -ProviderId 'aadRoles' -ResourceId $rolesetting.ResourceId -Id $rolesetting.RoleDefinitionId).DisplayName : $roleSetting.roleDefinitionId
Set-AzureADMSPrivilegedRoleSetting -ProviderId 'aadRoles' -Id $roleSetting.Id -ResourceId $roleSetting.resourceId -RoleDefinitionId $roleSetting.roleDefeinintionId -UserMemberSettings $UserMemberSettings
}
