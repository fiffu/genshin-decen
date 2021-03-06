# genshin.ps1
#
# Usage:
# 1. Ensure that $genshinInstallFolder points to the folder where Genshin Impact
#    is installed. Also, you can set $removeCensor to $false if you don't want
#    the censorship folder to be automatically deleted when the game starts.
#
# 2. Right-click this file (genshin.ps1) and select 'Run with PowerShell'.
#
# 3. You should see a shortcut file appear. You can double-click on it to start
#    Genshin Impact.
#
# 4. If you have $removeCensor set to $true, a prompt will appear asking 
#    "Do you want to allow this app to make changes to your device?"
#    Below that you should see 'Windows PowerShell'.
#
# 5. Click yes. This will allow the script to delete the censorship folder.
#    The game will start after that.
#
# Requires PowerShell 3 or higher.


param( [switch]$runGameElseMakeShortcut = $false )


# Settings
# ------------------------------------------------

# Folder where Genshin Impact is installed. There should be no trailing \
$genshinInstallFolder = "C:\Program Files\Genshin Impact"

# Set to $false to start game without starting the launcher
$useLauncher = $true

# Set to $false if you don't want to remove the censorship
$removeCensor = $true

# Name of the shortcut generated
$shortcutName = "RunGenshinImpact.lnk"

# ------------------------------------------------



$exePath = "$genshinInstallFolder\Genshin Impact Game\GenshinImpact.exe"
if ($useLauncher) {
    $exePath = "$genshinInstallFolder\launcher.exe"
}


if (-NOT $runGameElseMakeShortcut) {
    # When invoking this script without args, this block will create a .lnk that
    # calls this script again with the -runGameElseMakeShortcut flag.

    $shortcutPath = "$PSScriptRoot\$shortcutName"

    # Create shortcut - https://stackoverflow.com/a/9701907
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($shortcutPath)
    $Shortcut.IconLocation = "$exePath, 0"

    $Shortcut.TargetPath = "powershell.exe"
    $Shortcut.Arguments = "-ExecutionPolicy unrestricted -file `"$PSCommandPath`" -runGameElseMakeShortcut"
    $Shortcut.Save()
    # Target should be:
    # ...\powershell.exe -ExecutionPolicy unrestricted -file "E:\genshin.ps1" -runGameElseMakeShortcut

    if ($removeCensor) {
        # Now force the lnk to have run as admin. When the lnk opens, it will
        # start a PS session with elevated access to the install folder.
        # Elevated access is needed when invoking Remove-Item below.
        # https://stackoverflow.com/a/29002207
        $bytes = [System.IO.File]::ReadAllBytes($shortcutPath)
        $bytes[0x15] = $bytes[0x15] -BOR 0x20   # Set byte 21 (0x15) bit 6 (0x20) ON
        [System.IO.File]::WriteAllBytes($shortcutPath, $bytes)
    }

} else {

    # Drop the censor folder if it exists
    $censorFile = "$genshinInstallFolder\Genshin Impact Game\GenshinImpact_Data\Persistent\AssetBundles\blocks\00\29342328.blk"
    if ($removeCensor -and (Test-Path $censorFile)) {
        Remove-Item $censorFile -Force
    }

    if (Test-Path $censorFile) {
        Write-Output "Failed to remove $censorFile"
        Pause
    }

    # Start game
    Start-Process $exePath

}
