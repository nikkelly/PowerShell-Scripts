## Available Settings in updatePimRoles
# Require Azure MFA on all roles
$setting.RuleIdentifier = "MfaRule"
$setting.Setting= '{
  "mfaRequired":true
  }'
# Don't Require Justification
$setting.RuleIdentifier = "JustificationRule"
$setting.Setting='{
  "required":false
}'
# Require Ticket
$setting.RuleIdentifier = "TicketingRule"
$setting.Setting='{
  "ticketingRequired":true
  }'
# Set timeout to 4 hours
$setting.RuleIdentifier = "ExpirationRule"
$setting.Setting= '{
  "permanentAssignment":true,
  "maximumGrantPeriodInMinutes":240
  }'
# Remove approvers
$setting.RuleIdentifier = "ApprovalRule"
$setting.Setting='{
  "Approvers":[]
  }'