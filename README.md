"# historyLink" 
<p align='center'>
A quick and easy way to get your history link on PC! Follow the steps below and use your link to start tracking your wishes today!<br>

Steps:<br>
> 1. Open Genshin Impact Game on your PC<br>
<img src="https://i.imgur.com/EGu7rg4.png"><br>
> 2. Go to the wish history page and wait for it to load<br>
<img src="https://i.imgur.com/xsg6rOF.png"><br>
> 3. Go back to Windows<br>
> 4. In the start menu search for "PowerShell" and open "Windows PowerShell"<br>
<img src="https://i.imgur.com/3Xxgb7R.png"><br>
> 5. Then copy the following code and paste it in the Powershell window:<br>
```ps1
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex "&{$((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Genshin-Wizard/historyLink/master/historykey.ps1'))} global"
```
> 6. Hit ENTER to have the link copied to your clipboard<br>
<img src="https://i.imgur.com/Sf9VGBZ.png"><br>
> 7. Paste it into the required field in our discord<br>
</p>
