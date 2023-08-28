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


$logLocation = "%userprofile%\AppData\LocalLow\miHoYo\Genshin Impact\output_log.txt";
$logLocationChina = "%userprofile%\AppData\LocalLow\miHoYo\$([char]0x539f)$([char]0x795e)\output_log.txt";

$reg = $args[0]
$apiHost = "hk4e-api-os.hoyoverse.com" 
if ($reg -eq "china") {
  Write-Host "[INFO] Using China cache log location..." -ForegroundColor Cyan
  $logLocation = $logLocationChina
  $apiHost = "hk4e-api.mihoyo.com"
}

$tmps = $env:TEMP + '\pm.ps1';
if ([System.IO.File]::Exists($tmps)) {
    Remove-Item $tmps;
}

$path = [System.Environment]::ExpandEnvironmentVariables($logLocation);
if (-Not [System.IO.File]::Exists($path)) {
    Write-Host "There's been an exception! We cannot find the wish history url!" -ForegroundColor Red
    Write-Host "Make sure you have opened the wish history ingame before trying to grab the link!" -ForegroundColor Cyan

    if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {  
        Write-Host "Do you want to try to run the script as Administrator? Press [ENTER] to continue, or any key to cancel." -ForegroundColor Yellow
        $keyInput = [Console]::ReadKey($true).Key
        if ($keyInput -ne "13") {
            return
        }

        $myinvocation.mycommand.definition > $tmps

        Start-Process powershell -Verb runAs -ArgumentList "-noexit", $tmps, $reg
        break
    }

    return
}

$logs = Get-Content -Path $path
$m = $logs -match "(?m).:/.+(GenshinImpact_Data|YuanShen_Data)"
$m[0] -match "(.:/.+(GenshinImpact_Data|YuanShen_Data))" >$null

if ($matches.Length -eq 0) {
    Write-Host "There's been an exception! We cannot find the wish history url!" -ForegroundColor Red
    Write-Host "Make sure you have opened the wish history ingame before trying to grab the link!" -ForegroundColor Cyan
    return
}

$gamedir = $matches[1]
$cachefile = "$gamedir/webCaches/2.15.0.0/Cache/Cache_Data/data_2"
$tmpfile = "$env:TEMP/ch_data_2"

Copy-Item $cachefile -Destination $tmpfile

function testUrl($url) {
  $ProgressPreference = 'SilentlyContinue'
  $uri = [System.UriBuilder]::New($url)
  $uri.Path = "event/gacha_info/api/getGachaLog"
  $uri.Host = $apiHost
  $uri.Fragment = ""
  $params = [System.Web.HttpUtility]::ParseQueryString($uri.Query)
  $params.Set("lang", "en");
  $params.Set("gacha_type", 301);
  $params.Set("size", "5");
  $params.Add("lang", "en-us");
  $uri.Query = $params.ToString()
  $apiUrl = $uri.Uri.AbsoluteUri

  $response = Invoke-WebRequest -Uri $apiUrl -ContentType "application/json" -UseBasicParsing -TimeoutSec 10 | ConvertFrom-Json
  $testResult = $response.retcode -eq 0
  return $testResult
}

$content = Get-Content -Encoding UTF8 -Raw $tmpfile
$splitted = $content -split "1/0/"
$found = $splitted -match "e20190909gacha-v2"
$link = $linkFound = $false

for ($i = $found.Length - 1; $i -ge 0; $i -= 1) {
    $t = $found[$i] -match "(https.+?game_biz=)"
    $link = $matches[0]
    Write-Host "`rChecking Link $i" -NoNewline
    $testResult = testUrl $link
    if ($testResult -eq $true) {
        $linkFound = $true
        break
    }
    Start-Sleep 1
}

Remove-Item $tmpfile

Write-Host ""

if (-Not $linkFound) {
    Write-Host "There's been an exception! We cannot find the wish history url!" -ForegroundColor Red
    Write-Host "Make sure you have opened the wish history ingame before trying to grab the link!" -ForegroundColor Cyan
    
    return
}

$wishHistoryUrl = $link

Set-Clipboard -Value $wishHistoryUrl
Write-Host "Link has successfully been copied to your clipboard!" -ForegroundColor Green
Write-Host "That's it! Paste the link to the required field in our discord." -ForegroundColor Cyan

pause