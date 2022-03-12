"# historyLink" 

A quick and easy way to get your history link on PC!

Steps:
1. Open Genshin Impact on your PC
2. Go to the wish history page and wait for it to load
3. Go back to Windows
4. In the start menu search for "PowerShell" and open "Windows PowerShell"
5. Then copy the following code and paste it in the Powershell window:

    `iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/genshin-wishes/genshin-wishes-getlink/main/global.ps1'));`

6. Hit ENTER then a link will be copied to your clipboard
7. Paste it in the box below