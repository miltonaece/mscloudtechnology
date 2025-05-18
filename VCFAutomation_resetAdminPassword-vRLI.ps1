$password = "PASSWORD"

#Connect to SDDC and get token
Request-VCFToken `
    -fqdn "SDDC FQDN" `
    -username "administrator@vsphere.local" `
    -password $password

    connect-VcfSddcManagerServer `
    -server "SDDC FQDN" `
    -username "administrator@vsphere.local" `
    -password $password

    # Retrieve vRLI details
$vRLIInfo = get-vrliServerDetail -Fqdn "SDDC FQDN" -Username administrator@vsphere.local -Password $password

# Extract primary node FQDN
$PrimaryNodeFqdn = $vRLIInfo.node3Fqdn
Write-Host "Primary Node FQDN: $PrimaryNodeFqdn" -ForegroundColor Cyan


# Establish SSH connection to the primary node & #Check admin status
#ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$PrimaryNodeFqdn '/usr/lib/loginsight/application/sbin/li-reset-admin-passwd.sh --resetAdminPassword'

# Run the SSH command and capture the output
$output = ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$PrimaryNodeFqdn '/usr/lib/loginsight/application/sbin/li-reset-admin-passwd.sh --resetAdminPassword;exit'

# Use regex to extract the password
if ($output -match "SUCCESS: admin's password has been reset to: (\S+)") {
    $newPassword = $matches[1]
    Write-Host "New Admin Password: $newPassword"
} else {
    Write-Host "Password reset failed or the expected output format was not found."
}

Write-Host "New Password: $newPassword" -ForegroundColor Green
