# I got sick of having to find tenant ID's to be able to sign into customers 365 Powershell using 
#Install-Module -Name PartnerCenter -AllowClobber -Scope AllUsers
#Install-Module -Name Az -AllowClobber -Scope AllUsers
#Enable-AzureRmAlias -Scope CurrentUser



Import-Module -Name PartnerCenter
Import-Module -Name az
Connect-PartnerCenter
 
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
 
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Select a Tenant'
$form.Size = New-Object System.Drawing.Size(480,640)
$form.StartPosition = 'CenterScreen'
 
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(75,560)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)
 
$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(150,560)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)
 
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please select a Tenant:'
$form.Controls.Add($label)
 
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(440,20)
$listBox.Height = 520
 
 
function CustList(){
$TenantList = get-partnercustomer
$Tenants =@()
 
foreach ($Tenant in $TenantList) {
$Tenants += [PSCustomObject]@{'CustomerId' = $Tenant.CustomerId; 'Name' = $Tenant.Name}
}
foreach ($Tenant2 in $Tenants){
        $hash = @{$Tenant2.Name = $Tenant2.CustomerId}
        $hash
    }
      
}
$Cust = CustList
foreach($key in $Cust.Keys){
        # loop trough the array with both key and values in, and select the key so that we can add it to the selectionlist
        $listBox.Items.Add($key)
}
 
$form.Controls.Add($listBox)
 
$form.Topmost = $true
 
$result = $form.ShowDialog()
 
if ($result -eq [System.Windows.Forms.DialogResult]::OK -and $listBox.SelectedIndex -ge 0)
{
    $x = $listBox.SelectedItem
    connect-azAccount -Tenant $Cust.$x
}