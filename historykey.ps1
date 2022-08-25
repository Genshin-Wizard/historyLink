# Genshin Wizard | History Link
# Script Credits: github.com/jogerj

Write-Host "                                                                                          " -ForegroundColor Cyan     
Write-Host "      _____         ______  _____   ______            ______   ____   ____  ____  _____   ______   " -ForegroundColor Cyan
Write-Host "  ___|\    \    ___|\     \|\    \ |\     \       ___|\     \ |    | |    ||    ||\    \ |\     \  " -ForegroundColor Cyan
Write-Host " /    /\    \  |     \     \\\    \| \     \     |    |\     \|    | |    ||    | \\    \| \     \ " -ForegroundColor Cyan
Write-Host "|    |  |____| |     ,_____/|\|    \  \     |    |    |/____/||    |_|    ||    |  \|    \  \     |" -ForegroundColor Cyan
Write-Host "|    |    ____ |     \--'\_|/ |     \  |    | ___|    \|   | ||    .-.    ||    |   |     \  |    |" -ForegroundColor Cyan
Write-Host "|    |   |    ||     /___/|   |      \ |    ||    \    \___|/ |    | |    ||    |   |      \ |    |" -ForegroundColor Cyan
Write-Host "|    |   |_,  ||     \____|\  |    |\ \|    ||    |\     \    |    | |    ||    |   |    |\ \|    |" -ForegroundColor Cyan
Write-Host "|\ ___\___/  /||____ '     /| |____||\_____/||\ ___\|_____|   |____| |____||____|   |____||\_____/|" -ForegroundColor Cyan
Write-Host "| |   /____ / ||    /_____/ | |    |/ \|   ||| |    |     |   |    | |    ||    |   |    |/ \|   ||" -ForegroundColor Cyan
Write-Host " \|___|    | / |____|     | / |____|   |___|/ \|____|_____|   |____| |____||____|   |____|   |___|/" -ForegroundColor Cyan
Write-Host "  \( |____|/    \( |_____|/    \(       )/      \(    )/       \(     )/    \(       \(       )/  " -ForegroundColor Cyan
Write-Host "   '   )/        '    )/        '       '        '    '         '     '      '        '       '   " -ForegroundColor Cyan
Write-Host "           _____            ____    _____                ____        _____        _____                      " -ForegroundColor Red     
Write-Host "          |\    \   _____  |    |  /    /|___       ____|\   \   ___|\    \   ___|\    \                     " -ForegroundColor Red     
Write-Host "          | |    | /    /| |    | /    /|    |     /    /\    \ |    |\    \ |    |\    \                    " -ForegroundColor Red     
Write-Host "          \/     / |    || |    ||\____\|    |    |    |  |    ||    | |    ||    | |    |                   " -ForegroundColor Red     
Write-Host "          /     /_  \   \/ |    || |   |/    |___ |    |__|    ||    |/____/ |    | |    |                   " -ForegroundColor Red     
Write-Host "         |     // \  \   \ |    | \|___/    /    ||    .--.    ||    |\    \ |    | |    |                   " -ForegroundColor Red     
Write-Host "         |    |/   \ |    ||    |    /     /|    ||    |  |    ||    | |    ||    | |    |                   " -ForegroundColor Red     
Write-Host "         |\ ___/\   \|   /||____|   |_____|/____/||____|  |____||____| |____||____|/____/|                   " -ForegroundColor Red     
Write-Host "         | |   | \______/ ||    |   |     |    | ||    |  |    ||    | |    ||    /    | |                   " -ForegroundColor Red     
Write-Host "          \|___|/\ |    | ||____|   |_____|____|/ |____|  |____||____| |____||____|____|/                    " -ForegroundColor Red     
Write-Host "             \(   \|____|/   \(       \(    )/      \(      )/    \(     )/    \(    )/                      " -ForegroundColor Red     
Write-Host "              '      )/       '        '    '        '      '      '     '      '    '                       " -ForegroundColor Red     
Write-Host "                     '                                                                                       " -ForegroundColor Red                                                     
Write-Host "" -ForegroundColor Magenta     

$reg = $args[0]
$logPath = [System.Environment]::ExpandEnvironmentVariables("%userprofile%\AppData\LocalLow\miHoYo\Genshin Impact\output_log.txt");
if (!(Test-Path $logPath) -or $reg -eq "china") {
    $logPath = [System.Environment]::ExpandEnvironmentVariables("%userprofile%\AppData\LocalLow\miHoYo\$([char]0x539f)$([char]0x795e)\output_log.txt");
    if (!(Test-Path $logPath)) {
        Write-Host "Unable to locate the log file! Make sure you have opened the wish history ingame before trying to grab the link!" -ForegroundColor Red
        if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {  
            Write-Host "Do you want to try to run the script as Administrator? Press [ENTER] to continue, or any key to cancel."
            $keyInput = [Console]::ReadKey($true).Key
            if ($keyInput -ne "13") {
                return
            }
            $arguments = "& '" +$myinvocation.mycommand.definition + "'"
            Start-Process powershell -Verb runAs -ArgumentList "-noexit $arguments $reg"
            break
        } 
        return
    }
}

$logs = Get-Content -Path $logPath
$regexPattern = "(?m).:/.+(GenshinImpact_Data|YuanShen_Data)"
$logMatch = $logs -match $regexPattern

if (-Not $logMatch) {
    Write-Host "There's been an excpetion! We cannot find the wish history url!" -ForegroundColor Red
    Write-Host "Make sure you have opened the wish history ingame before trying to grab the link!" -ForegroundColor Cyan
    pause
    return
}

$gameDataPath = ($logMatch | Select -Last 1) -match $regexPattern
$gameDataPath = Resolve-Path $Matches[0]

$cachePath = "$gameDataPath\\webCaches\\Service Worker\\CacheStorage\\f944a42103e2b9f8d6ee266c44da97452cde8a7c"
if (Test-Path $cachePath) {
    $cacheFolder = Get-ChildItem $cachePath | sort -Property LastWriteTime -Descending | select -First 1
    $content = Get-Content "$($cacheFolder.FullName)\\00d9a0f4d2a83ce0_0" | Select-String -Pattern "https.*#/log"
    $logEntry = $content[0].ToString()
    $wishUrl = $logEntry -match "https.*#/log"
    
    if ($wishUrl) {
        $wishUrl = $Matches[0]
    
        $wishUrlDate = $logEntry -match "\w{3}, \d{2} \w{3} \d{4} \d\d:\d\d:\d\d GMT"
        if ($wishUrlDate) {
            $wishUrlDate = $Matches[0] -as [datetime]
            $current = Get-Date
            $timeDiff = New-TimeSpan -Start $wishUrlDate -End $current | % {$_.Hours}
            if ($timeDiff -ge 24) {
                Write-Host "WARNING: Link found is older than 24 hours and might be expired! Open Wish History again to fetch a new link if it doesn't work" -ForegroundColor Yellow
                Read-Host -Prompt "Press ENTER to copy link anyway or CTRL+C to quit"
            }
        }
        Set-Clipboard -Value $wishUrl
        Write-Host "Link from $wishUrlDate has successfully been copied to your clipboard!" -ForegroundColor Green
        Write-Host "That's it! Paste the link to the required field in our discord." -ForegroundColor Cyan
        return
    }
} 

#  Fallback Method
$tempPath = mkdir "$env:TEMP\\genshinwizard" -Force
$cachePath = "$gameDataPath\\webCaches\\Cache\\Cache_Data"

# Download ChromeCacheView to read log files
Invoke-WebRequest -Uri "https://www.nirsoft.net/utils/chromecacheview.zip" -OutFile "$tempPath\\chromecacheview.zip"
Expand-Archive "$tempPath\\chromecacheview.zip" -DestinationPath "$tempPath\\chromecacheviewer" -Force
& "$tempPath\chromecacheviewer\\ChromeCacheView.exe" -folder $cachePath /scomma "$tempPath\\cache_data.csv"

# Processing cache can take a moment
while (!(Test-Path "$tempPath\\cache_data.csv")) { Start-Sleep 1 }
$wishLog = Import-Csv "$tempPath\\cache_data.csv" | select  "Last Accessed", "URL" | ? URL -like "*event/gacha_info/api/getGachaLog*" | Sort-Object -Descending { $_."Last Accessed" -as [datetime] } | select -first 1
$wishUrl = $wishLog | % {$_.URL.Substring(4)}
$wishUrlDate = $wishLog | % {$_."Last Accessed" -as [datetime]}

# Clean-up
Remove-Item -Recurse -Force $tempPath
if ($wishUrl) {
    $current = Get-Date
    $timeDiff = New-TimeSpan -Start $wishUrlDate -End $current | % {$_.Hours}

    if ($timeDiff -ge 24) {
        Write-Host "WARNING: Link found is older than 24 hours and might be expired! Open Wish History again to fetch a new link if it doesn't work" -ForegroundColor Yellow
        Read-Host -Prompt "Press ENTER to copy link anyway or CTRL+C to quit"
    }
    Set-Clipboard -Value $wishUrl
    Write-Host "Link from $wishUrlDate has successfully been copied to your clipboard!" -ForegroundColor Green
    Write-Host "That's it! Paste the link to the required field in our discord." -ForegroundColor Cyan
} else {
    Write-Host "There's been an excpetion! We cannot find the wish history url!" -ForegroundColor Red
    Write-Host "Make sure you have opened the wish history ingame before trying to grab the link!" -ForegroundColor Cyan
    pause
}