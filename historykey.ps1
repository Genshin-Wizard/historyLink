Add-Type -AssemblyName System.Web

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

# script credits:
# author: jogerj

function processWishUrl($wishUrl) {
    if ($wishUrl -match "https:\/\/webstatic") {
        if ($wishUrl -match "hk4e_global") {
            $checkUrl = $wishUrl -replace "https:\/\/webstatic.+html\?", "https://hk4e-api-os.mihoyo.com/event/gacha_info/api/getGachaLog?"
        } else {
            $checkUrl = $wishUrl -replace "https:\/\/webstatic.+html\?", "https://hk4e-api.mihoyo.com/event/gacha_info/api/getGachaLog?"
        }
        $urlResponseMessage = Invoke-RestMethod -URI $checkUrl | % {$_.message}
    } else {
        $urlResponseMessage = Invoke-RestMethod -URI $wishUrl | % {$_.message}
    }

    if ($urlResponseMessage -ne "OK") {
        Write-Host "There's been an exception! Link has been found but is expired/invalid!" -ForegroundColor Yellow
        Write-Host "Open the wish history ingame before trying again to fetch a new link!" -ForegroundColor Cyan
        return $False
    }

    Write-Host $wishURL
    Set-Clipboard -Value $wishURL
    
    Write-Host "Link has successfully been copied to your clipboard!" -ForegroundColor Green
    Write-Host "That's it! Paste the link to the required field in our discord." -ForegroundColor Cyan
    
    return $True
}

$logPathGlobal = [System.Environment]::ExpandEnvironmentVariables("%userprofile%/AppData/LocalLow/miHoYo/Genshin Impact/output_log.txt");
$logPathChina = [System.Environment]::ExpandEnvironmentVariables("%userprofile%/AppData/LocalLow/miHoYo/$([char]0x539f)$([char]0x795e)/output_log.txt");
$globalExists = Test-Path $logPathGlobal;
$cnExists = Test-Path $logPathChina;

if ($globalExists) {
    if ($cnExists) {
        if ((Get-Item $logPathGlobal).LastWriteTime -ge (Get-Item $logPathChina).LastWriteTime) {
            $logPath = $logPathGlobal;
        } else {
            $logPath = $logPathChina;
        }
    } else {
        $logPath = $logPathGlobal;
    } 
} else {
    if ($cnExists) {
        $logPath = $logPathChina;
    } else {
        Write-Host "There's been an exception! We cannot find the wish history url!" -ForegroundColor Red
        Write-Host "Make sure you have opened the wish history ingame before trying to grab the link!" -ForegroundColor Cyan
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
    Write-Host "There's been an exception! We cannot find the wish history url!" -ForegroundColor Red
    Write-Host "Make sure you have opened the wish history ingame before trying to grab the link!" -ForegroundColor Cyan
    pause
    return
}

$gameDataPath = ($logMatch | Select -Last 1) -match $regexPattern
$gameDataPath = Resolve-Path $Matches[0]

$webcachePath = Resolve-Path "$gameDataPath/webCaches"
$cacheVerPath = Get-Item (Get-ChildItem -Path $webcachePath | Sort-Object LastWriteTime -Descending | Select-Object -First 1).FullName
$cachePath = Resolve-Path "$cacheVerPath/Cache/Cache_Data/data_2"

if (Test-Path $cachePath) {
    $tmpFile = "$env:TEMP/ch_data_2"
    Copy-Item $cachePath -Destination $tmpFile
    $content = Get-Content -Encoding UTF8 -Raw $tmpfile
    $splitted = $content -split "1/0/" | Select -Last 1
    $found = $splitted -match "https.+?game_biz=hk4e_(global|cn)"
    Remove-Item $tmpFile
    
    if ($found) {
        $wishUrl = $Matches[0]
        if (processWishUrl $wishUrl) {
            return
        }
    }

    Write-Host "There's been an exception! We cannot find the wish history url!" -ForegroundColor Red
    Write-Host "Make sure you have opened the wish history ingame before trying to grab the link!" -ForegroundColor Cyan
    
    pause
} else {
    Write-Host "There's been an exception! We cannot find the wish history url!" -ForegroundColor Red
    Write-Host "Make sure you have opened the wish history ingame before trying to grab the link!" -ForegroundColor Cyan
    
    pause
}

pause