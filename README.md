# genshin.ps1

### Usage:

1. Right-click the script (`genshin.ps1`) and click 'Edit'.
   Ensure that `$genshinInstallFolder` points to the folder where Genshin Impact
   is installed. Also, you can set `$removeCensor` to `$false` if you don't want
   the censorship folder to be automatically deleted when the game starts.

2. Right-click on the script (`genshin.ps1`) and select 'Run with PowerShell'.

3. You should see a shortcut file appear. You can double-click on it to start
   Genshin Impact.

4. If you have $removeCensor set to $true, a prompt will appear asking 
   "Do you want to allow this app to make changes to your device?"
   Below that you should see 'Windows PowerShell'.

5. Click yes. This will allow the script to delete the censorship folder.
   The game will start after that.


### Requires:

* PowerShell 3 or higher.
