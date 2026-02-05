[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# --- RENDSZERGAZDAI JOGOK ELLENŐRZÉSE ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Add-Type -AssemblyName System.Windows.Forms, System.Drawing

# Elérési utak
$listFile = Join-Path $PSScriptRoot "programlist.txt"
$logFile = Join-Path $PSScriptRoot "wizard_history.log"
$readmeFile = Join-Path $PSScriptRoot "README.txt"

# --- NAPLÓZÁS ---
function Write-WizardLog($message) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[$timestamp] $message" | Out-File -FilePath $logFile -Append -Encoding UTF8
}

# --- ADATOK BETÖLTÉSE PROGRESS BAR-RAL ---
$apps = @()
if (Test-Path $listFile) {
    $lines = Get-Content $listFile | Where-Object { $_.Trim() -ne "" }
    $total = $lines.Count
    
    $loadForm = New-Object System.Windows.Forms.Form
    $loadForm.Text = "Wizard: Verziók lekérése..."
    $loadForm.Size = New-Object System.Drawing.Size(400, 120)
    $loadForm.StartPosition = "CenterScreen"
    $loadForm.FormBorderStyle = "FixedDialog"
    $loadForm.ControlBox = $false
    $loadForm.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
    $loadForm.ForeColor = [System.Drawing.Color]::White

    $pb = New-Object System.Windows.Forms.ProgressBar
    $pb.Location = New-Object System.Drawing.Point(20, 45)
    $pb.Size = New-Object System.Drawing.Size(340, 20)
    $pb.Maximum = $total
    $loadForm.Controls.Add($pb)

    $lbl = New-Object System.Windows.Forms.Label
    $lbl.Text = "Elemzés: 0 / $total"
    $lbl.Location = New-Object System.Drawing.Point(20, 15)
    $lbl.Size = New-Object System.Drawing.Size(340, 20)
    $loadForm.Controls.Add($lbl)
    $loadForm.Show()

    foreach ($line in $lines) {
        $parts = $line -split " \| "
        if ($parts.Count -ge 2) {
            $id = $parts[1].Trim()
            $pb.Value++
            $lbl.Text = "Lekérdezés ($($pb.Value) / $total): $($parts[0].Trim())"
            $loadForm.Refresh()

            $vInfo = winget show --id $id --accept-source-agreements | Select-String "Version:"
            $version = if($vInfo) { ($vInfo -split ": ")[1].Trim() } else { "N/A" }
            
            $apps += [PSCustomObject]@{
                Name    = $parts[0].Trim()
                ID      = $id
                Version = $version
                Desc    = if($parts[2]){$parts[2].Trim()}else{""}
            }
        }
    }
    $loadForm.Close()
}

# --- FŐ ABLAK (DINAMIKUS) ---
$screen = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
$form = New-Object System.Windows.Forms.Form
$form.Text = "Winget Wizard v1.4.1 - Search Edition"

$initWidth = [int]($screen.Width * 0.7)
$initHeight = [int]($screen.Height * 0.7)
$form.Size = New-Object System.Drawing.Size($initWidth, $initHeight)
$form.MinimumSize = New-Object System.Drawing.Size(850, 600)
$form.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 20)
$form.StartPosition = "CenterScreen"

# KERESŐ SÁV (Fent)
$txtSearch = New-Object System.Windows.Forms.TextBox
$txtSearch.Location = New-Object System.Drawing.Point(20, 15)
$txtSearch.Size = New-Object System.Drawing.Size(300, 25)
$txtSearch.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 40)
$txtSearch.ForeColor = [System.Drawing.Color]::White
$txtSearch.BorderStyle = "FixedSingle"
$txtSearch.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$form.Controls.Add($txtSearch)

$lblSearch = New-Object System.Windows.Forms.Label
$lblSearch.Text = "🔍 Keresés név vagy ID alapján..."
$lblSearch.Location = New-Object System.Drawing.Point(330, 17)
$lblSearch.ForeColor = [System.Drawing.Color]::Gray
$lblSearch.AutoSize = $true
$form.Controls.Add($lblSearch)

# TÁBLÁZAT (ListView)
$listView = New-Object System.Windows.Forms.ListView
$listView.View = 'Details'
$listView.FullRowSelect = $true
$listView.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$listView.ForeColor = [System.Drawing.Color]::White
$listView.BorderStyle = 'None'
$listView.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$listView.Location = New-Object System.Drawing.Point(20, 55)
$listView.Size = New-Object System.Drawing.Size(($form.ClientSize.Width - 40), ($form.ClientSize.Height - 195))
$listView.Anchor = "Top, Left, Right, Bottom"

$listView.Columns.Add("Program neve", 200) | Out-Null
$listView.Columns.Add("Winget ID", 220) | Out-Null
$listView.Columns.Add("Elérhető Verzió", 140) | Out-Null
$listView.Columns.Add("Leírás", -2) | Out-Null
$form.Controls.Add($listView)

# KERESÉS FUNKCIÓ (Az UpdateList-et hívja gépeléskor)
function Update-WizardList($filterText) {
    $listView.Items.Clear()
    $searchTerm = $filterText.ToLower()
    foreach ($app in $apps) {
        if ($app.Name.ToLower().Contains($searchTerm) -or $app.ID.ToLower().Contains($searchTerm)) {
            $item = New-Object System.Windows.Forms.ListViewItem($app.Name)
            $item.SubItems.Add($app.ID) | Out-Null
            $item.SubItems.Add($app.Version) | Out-Null
            $item.SubItems.Add($app.Desc) | Out-Null
            $listView.Items.Add($item) | Out-Null
        }
    }
}

$txtSearch.Add_TextChanged({ Update-WizardList $txtSearch.Text })
Update-WizardList "" # Alapértelmezett betöltés

# --- ALSÓ PANEL A GOMBOKNAK ---
$pnl = New-Object System.Windows.Forms.Panel
$pnl.Size = New-Object System.Drawing.Size($form.ClientSize.Width, 120)
$pnl.Location = New-Object System.Drawing.Point(0, ($form.ClientSize.Height - 120))
$pnl.Anchor = "Bottom, Left, Right"
$form.Controls.Add($pnl)

function Create-ResponsiveBtn($txt, $color, $index) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = $txt
    $btnWidth = [int](($pnl.Width - 80) / 3)
    $btn.Size = New-Object System.Drawing.Size($btnWidth, 55)
    $btn.Location = New-Object System.Drawing.Point((20 + ($index * ($btnWidth + 20))), 10)
    $btn.BackColor = $color
    $btn.FlatStyle = "Flat"
    $btn.FlatAppearance.BorderSize = 0
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
    if($index -eq 0) { $btn.Anchor = "Bottom, Left" }
    elseif($index -eq 1) { $btn.Anchor = "Bottom, Left, Right" }
    else { $btn.Anchor = "Bottom, Right" }
    return $btn
}

$btnIn = Create-ResponsiveBtn "TELEPÍTÉS" ([System.Drawing.Color]::FromArgb(0, 102, 204)) 0
$btnUp = Create-ResponsiveBtn "FRISSÍTÉS" ([System.Drawing.Color]::FromArgb(46, 139, 87)) 1
$btnUn = Create-ResponsiveBtn "ELTÁVOLÍTÁS" ([System.Drawing.Color]::FromArgb(178, 34, 34)) 2

$btnRead = New-Object System.Windows.Forms.Button
$btnRead.Text = "HASZNÁLATI ÚTMUTATÓ (README)"
$btnRead.Size = New-Object System.Drawing.Size(($pnl.Width - 40), 30)
$btnRead.Location = New-Object System.Drawing.Point(20, 75)
$btnRead.Anchor = "Bottom, Left, Right"
$btnRead.BackColor = [System.Drawing.Color]::FromArgb(60, 60, 60)
$btnRead.FlatStyle = "Flat"
$btnRead.ForeColor = [System.Drawing.Color]::White
$btnRead.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$btnRead.Add_Click({ if (Test-Path $readmeFile) { Start-Process "notepad.exe" $readmeFile } })

$script:selected = @()
$script:mode = ""
$onAction = {
    param($m)
    if ($listView.SelectedItems.Count -gt 0) {
        foreach($i in $listView.SelectedItems){ $script:selected += @{ ID=$i.SubItems[1].Text; Name=$i.Text } }
        $script:mode = $m
        $form.Close()
    }
}

$btnIn.Add_Click({ &$onAction "install" })
$btnUp.Add_Click({ &$onAction "upgrade" })
$btnUn.Add_Click({ &$onAction "uninstall" })

$pnl.Controls.AddRange(@($btnIn, $btnUp, $btnUn, $btnRead))
$form.ShowDialog() | Out-Null

# --- VÉGREHAJTÁS ---
if ($script:selected.Count -gt 0) {
    cls
    Write-WizardLog "START: $($script:mode.ToUpper())"
    foreach ($item in $script:selected) {
        Write-Host "Művelet ($($script:mode)): $($item.Name)" -ForegroundColor Cyan
        winget $script:mode --id $($item.ID) --silent --accept-package-agreements --accept-source-agreements
        Write-WizardLog "OK: $($item.Name) ($($item.ID))"
    }
    pause
}