#!/usr/bin/env pwsh

###!!! PowerShell WinForm Feature only works on Windows !!!###

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "Type Your Beachball Info"
$objForm.Size = New-Object System.Drawing.Size(350,400) 
$objForm.StartPosition = "CenterScreen"

$objForm.KeyPreview = $True
$objForm.Add_KeyDown({
    if ($_.KeyCode -eq "Enter" -or $_.KeyCode -eq "Escape"){
        $objForm.Close()
    }
})

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(90,330)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.Add_Click({$objForm.Close()})
$objForm.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(180,330)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.Add_Click({
    $objForm.Close()
    [environment]::exit(0)
})
$objForm.Controls.Add($CancelButton)

################################################################

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,20) 
$objLabel.Size = New-Object System.Drawing.Size(480,20) 
$objLabel.Text = "Please enter the information about your beachball"
$objForm.Controls.Add($objLabel) 

################################################################

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,40) 
$objLabel.Size = New-Object System.Drawing.Size(40,20) 
$objLabel.Text = "Strike"
$objForm.Controls.Add($objLabel) 

$objTextBox = New-Object System.Windows.Forms.TextBox 
$objTextBox.Location = New-Object System.Drawing.Size(90,40) 
$objTextBox.Size = New-Object System.Drawing.Size(220,20) 
$objTextBox.Text = "180"
$objForm.Controls.Add($objTextBox) 

################################################################

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,70) 
$objLabel.Size = New-Object System.Drawing.Size(40,20) 
$objLabel.Text = "Dip"
$objForm.Controls.Add($objLabel) 

$objTextBox2 = New-Object System.Windows.Forms.TextBox 
$objTextBox2.Location = New-Object System.Drawing.Size(90,70) 
$objTextBox2.Size = New-Object System.Drawing.Size(220,20) 
$objTextBox2.Text = "45"
$objForm.Controls.Add($objTextBox2) 

################################################################

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,100) 
$objLabel.Size = New-Object System.Drawing.Size(40,20) 
$objLabel.Text = "Rake"
$objForm.Controls.Add($objLabel)

$objTextBox3 = New-Object System.Windows.Forms.TextBox 
$objTextBox3.Location = New-Object System.Drawing.Size(90,100) 
$objTextBox3.Size = New-Object System.Drawing.Size(220,20) 
$objTextBox3.Text = "22.5"
$objForm.Controls.Add($objTextBox3) 
################################################################

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,130) 
$objLabel.Size = New-Object System.Drawing.Size(80,20) 
$objLabel.Text = "Color Red"
$objForm.Controls.Add($objLabel)

$objTextBox4 = New-Object System.Windows.Forms.TextBox 
$objTextBox4.Location = New-Object System.Drawing.Size(90,130) 
$objTextBox4.Size = New-Object System.Drawing.Size(220,20) 
$objTextBox4.Text = "255"
$objForm.Controls.Add($objTextBox4)

################################################################

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,160) 
$objLabel.Size = New-Object System.Drawing.Size(80,20) 
$objLabel.Text = "Color Green"
$objForm.Controls.Add($objLabel)

$objTextBox5 = New-Object System.Windows.Forms.TextBox 
$objTextBox5.Location = New-Object System.Drawing.Size(90,160) 
$objTextBox5.Size = New-Object System.Drawing.Size(220,20) 
$objTextBox5.Text = "0"
$objForm.Controls.Add($objTextBox5)

################################################################

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,190) 
$objLabel.Size = New-Object System.Drawing.Size(80,20) 
$objLabel.Text = "Color Blue"
$objForm.Controls.Add($objLabel)

$objTextBox6 = New-Object System.Windows.Forms.TextBox 
$objTextBox6.Location = New-Object System.Drawing.Size(90,190) 
$objTextBox6.Size = New-Object System.Drawing.Size(220,20) 
$objTextBox6.Text = "0"
$objForm.Controls.Add($objTextBox6)

################################################################

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,220) 
$objLabel.Size = New-Object System.Drawing.Size(40,20) 
$objLabel.Text = "Title"
$objForm.Controls.Add($objLabel)

$objTextBox7 = New-Object System.Windows.Forms.TextBox 
$objTextBox7.Location = New-Object System.Drawing.Size(90,220) 
$objTextBox7.Size = New-Object System.Drawing.Size(220,20) 
$objTextBox7.Text = "Hello"
$objForm.Controls.Add($objTextBox7)

################################################################

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,250) 
$objLabel.Size = New-Object System.Drawing.Size(480,20) 
$objLabel.Text = "Please enter the information about your API server:"
$objForm.Controls.Add($objLabel) 

################################################################

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,280) 
$objLabel.Size = New-Object System.Drawing.Size(80,20) 
$objLabel.Text = "Server URL:"
$objForm.Controls.Add($objLabel)

$objTextBox8 = New-Object System.Windows.Forms.TextBox 
$objTextBox8.Location = New-Object System.Drawing.Size(90,280) 
$objTextBox8.Size = New-Object System.Drawing.Size(220,20) 
$objTextBox8.Text = "http://127.0.0.1:5000/simplemeca"
$objForm.Controls.Add($objTextBox8)

################################################################

$objForm.Topmost = $True

$objForm.Add_Shown({$objForm.Activate()})
[void]$objForm.ShowDialog()

$strike = ($objTextBox.Text -as [double])
$dip = ($objTextBox2.Text -as [double])
$rake = ($objTextBox3.Text -as [double])
$color_r = ($objTextBox4.Text -as [double])
$color_g = ($objTextBox5.Text -as [double])
$color_b = ($objTextBox6.Text -as [double])
$title = $objTextBox7.Text
$server_url = $objTextBox8.Text

$postParams = @{strike=$strike;dip=$dip;rake=$rake;color_r=$color_r;color_g=$color_g;color_b=$color_b;title=$title}
$result = Invoke-WebRequest -Uri $server_url -Method POST -Body ( $postParams | ConvertTo-Json ) -ContentType "application/json"
$result
start ( $result.Content | ConvertFrom-Json ).image_url