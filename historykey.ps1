# Log File paths
$primaryPath  = [System.Environment]::ExpandEnvironmentVariables("%userprofile%\AppData\LocalLow\miHoYo\Genshin Impact\output_log.txt");
$secondaryPath = [System.Environment]::ExpandEnvironmentVariables("%userprofile%\AppData\LocalLow\miHoYo\$([char]0x539f)$([char]0x795e)\output_log.txt");
$boolPrimary = [System.IO.File]::Exists($primaryPath);
$boolSecondary = [System.IO.File]::Exists($secondaryPath);

# Error Function
function error{
    param ($exception)
    Write-Host "There's been an excpetion! We cannot find the wish history url!" -ForegroundColor Red
    Write-Host "Make sure you have opened the wish history ingame before trying to grab the link!" -ForegroundColor Cyan
    Write-Host "Run powershell as administrator if this error persists." -ForegroundColor Cyan
}

# Grab History Link
function getLink{
    param ($pathToFile)
    $logs = Get-Content -Path $pathToFile
    $match = $logs -match "^OnGetWebViewPageFinish.*log$"
    if (-Not $match) {
        error -exception "wish " 
        return
    }
    [string] $wishHistoryUrl = $match[$match.count-1] -replace 'OnGetWebViewPageFinish:', ''
    Set-Clipboard -Value $wishHistoryUrl
    Write-Host "Link has successfully been copied to your clipboard!" -ForegroundColor Green
    Write-Host "That's it! Paste the link to the required field in our discord." -ForegroundColor Cyan
}

Write-Host "                                                                                          " -ForegroundColor Cyan     
Write-Host "      _____         ______            ______  _____   ______    ____   ____  ____  _____   ______   " -ForegroundColor Cyan     
Write-Host "  ___|\    \    ___|\     \       ___|\     \|\    \ |\     \  |    | |    ||    ||\    \ |\     \  " -ForegroundColor Cyan     
Write-Host " /    /\    \  |     \     \     |    |\     \\\    \| \     \ |    | |    ||    | \\    \| \     \ " -ForegroundColor Cyan     
Write-Host "|    |  |____| |     ,_____/|    |    |/____/| \|    \  \     ||    |_|    ||    |  \|    \  \     |" -ForegroundColor Cyan     
Write-Host "|    |    ____ |     \--'\_|/ ___|    \|   | |  |     \  |    ||    .-.    ||    |   |     \  |    |" -ForegroundColor Cyan     
Write-Host "|    |   |    ||     /___/|  |    \    \___|/   |      \ |    ||    | |    ||    |   |      \ |    |" -ForegroundColor Cyan     
Write-Host "|    |   |_,  ||     \____|\ |    |\     \      |    |\ \|    ||    | |    ||    |   |    |\ \|    |" -ForegroundColor Cyan     
Write-Host "|\ ___\___/  /||____ '     /||\ ___\|_____|     |____||\_____/||____| |____||____|   |____||\_____/|" -ForegroundColor Cyan     
Write-Host "| |   /____ / ||    /_____/ || |    |     |     |    |/ \|   |||    | |    ||    |   |    |/ \|   ||" -ForegroundColor Cyan     
Write-Host " \|___|    | / |____|     | / \|____|_____|     |____|   |___|/|____| |____||____|   |____|   |___|/" -ForegroundColor Cyan     
Write-Host "  \( |____|/    \( |_____|/     \(    )/         \(       )/    \(     )/    \(       \(       )/  " -ForegroundColor Cyan     
Write-Host "   '   )/        '    )/         '    '           '       '      '     '      '        '       '   " -ForegroundColor Cyan          
Write-Host "  _____            ____    _____                ____        _____        _____                      " -ForegroundColor Red     
Write-Host " |\    \   _____  |    |  /    /|___       ____|\   \   ___|\    \   ___|\    \                     " -ForegroundColor Red     
Write-Host " | |    | /    /| |    | /    /|    |     /    /\    \ |    |\    \ |    |\    \                    " -ForegroundColor Red     
Write-Host " \/     / |    || |    ||\____\|    |    |    |  |    ||    | |    ||    | |    |                   " -ForegroundColor Red     
Write-Host " /     /_  \   \/ |    || |   |/    |___ |    |__|    ||    |/____/ |    | |    |                   " -ForegroundColor Red     
Write-Host "|     // \  \   \ |    | \|___/    /    ||    .--.    ||    |\    \ |    | |    |                   " -ForegroundColor Red     
Write-Host "|    |/   \ |    ||    |    /     /|    ||    |  |    ||    | |    ||    | |    |                   " -ForegroundColor Red     
Write-Host "|\ ___/\   \|   /||____|   |_____|/____/||____|  |____||____| |____||____|/____/|                   " -ForegroundColor Red     
Write-Host "| |   | \______/ ||    |   |     |    | ||    |  |    ||    | |    ||    /    | |                   " -ForegroundColor Red     
Write-Host " \|___|/\ |    | ||____|   |_____|____|/ |____|  |____||____| |____||____|____|/                    " -ForegroundColor Red     
Write-Host "    \(   \|____|/   \(       \(    )/      \(      )/    \(     )/    \(    )/                      " -ForegroundColor Red     
Write-Host "     '      )/       '        '    '        '      '      '     '      '    '                       " -ForegroundColor Red     
Write-Host "            '                                                                                       " -ForegroundColor Red                                                     
Write-Host "" -ForegroundColor Magenta     

if ($boolPrimary -xor $boolSecondary){
    if($boolPrimary){
        getLink -pathToFile $primaryPath
    } else {
        getLink -pathToFile $secondaryPath
    }
} else {
    if ($boolPrimary -and $boolSecondary){     
        if(((Get-ItemProperty -Path $secondaryPath -Name LastWriteTime).lastwritetime - (Get-ItemProperty -Path $primaryPath -Name LastWriteTime).lastwritetime) -gt 0){
            getLink -pathToFile $secondaryPath
        } else {
            getLink -pathToFile $primaryPath
        }
    } else {
        error -exception "GENSHIN IMPACT LOG FILE"
        return
    }
}