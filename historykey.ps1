function error{
    param ($exception)
    Write-Host "There's been an excpetion! We cannot find $exception!" -ForegroundColor Red
    Write-Host "Make sure you have opened the wish history ingame before trying to grab the link!" -ForegroundColor DarkRed
    Write-Host "Run powershell as administrator if this error persists." -ForegroundColor DarkRed
}
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

$primaryPath  = [System.Environment]::ExpandEnvironmentVariables("%userprofile%\AppData\LocalLow\miHoYo\Genshin Impact\output_log.txt");
$secondaryPath = [System.Environment]::ExpandEnvironmentVariables("%userprofile%\AppData\LocalLow\miHoYo\$([char]0x539f)$([char]0x795e)\output_log.txt");
$boolPrimary = [System.IO.File]::Exists($primaryPath);
$boolSecondary = [System.IO.File]::Exists($secondaryPath);


Write-Host "" -ForegroundColor Magenta                                                                                                                                                                                           
Write-Host "      _____         ______    _____   ______            ______   ____   ____  ____  _____   ______           _____            ____    _____                ____        _____        _____   " -ForegroundColor Cyan 
Write-Host "  ___|\    \    ___|\     \  |\    \ |\     \       ___|\     \ |    | |    ||    ||\    \ |\     \         |\    \   _____  |    |  /    /|___       ____|\   \   ___|\    \   ___|\    \  " -ForegroundColor Cyan 
Write-Host " /    /\    \  |     \     \  \\    \| \     \     |    |\     \|    | |    ||    | \\    \| \     \        | |    | /    /| |    | /    /|    |     /    /\    \ |    |\    \ |    |\    \ " -ForegroundColor Cyan 
Write-Host "|    |  |____| |     ,_____/|  \|    \  \     |    |    |/____/||    |_|    ||    |  \|    \  \     |       \/     / |    || |    ||\____\|    |    |    |  |    ||    | |    ||    | |    |" -ForegroundColor Cyan 
Write-Host "|    |    ____ |     \--'\_|/   |     \  |    | ___|    \|   | ||    .-.    ||    |   |     \  |    |       /     /_  \   \/ |    || |   |/    |___ |    |__|    ||    |/____/ |    | |    |" -ForegroundColor Cyan 
Write-Host "|    |   |    ||     /___/|     |      \ |    ||    \    \___|/ |    | |    ||    |   |      \ |    |      |     // \  \   \ |    | \|___/    /    ||    .--.    ||    |\    \ |    | |    |" -ForegroundColor Cyan 
Write-Host "|    |   |_,  ||     \____|\    |    |\ \|    ||    |\     \    |    | |    ||    |   |    |\ \|    |      |    |/   \ |    ||    |    /     /|    ||    |  |    ||    | |    ||    | |    |" -ForegroundColor Cyan 
Write-Host "|\ ___\___/  /||____ '     /|   |____||\_____/||\ ___\|_____|   |____| |____||____|   |____||\_____/|      |\ ___/\   \|   /||____|   |_____|/____/||____|  |____||____| |____||____|/____/|" -ForegroundColor Cyan 
Write-Host "| |   /____ / ||    /_____/ |   |    |/ \|   ||| |    |     |   |    | |    ||    |   |    |/ \|   ||      | |   | \______/ ||    |   |     |    | ||    |  |    ||    | |    ||    /    | |" -ForegroundColor Cyan 
Write-Host " \|___|    | / |____|     | /   |____|   |___|/ \|____|_____|   |____| |____||____|   |____|   |___|/       \|___|/\ |    | ||____|   |_____|____|/ |____|  |____||____| |____||____|____|/ " -ForegroundColor Cyan 
Write-Host "   \( |____|/    \( |_____|/      \(       )/      \(    )/       \(     )/    \(       \(       )/            \(   \|____|/   \(       \(    )/      \(      )/    \(     )/    \(    )/   " -ForegroundColor Cyan 
Write-Host "    '   )/        '    )/          '       '        '    '         '     '      '        '       '              '      )/       '        '    '        '      '      '     '      '    '    " -ForegroundColor Cyan 
Write-Host "       '              '                                                                                               '                   " -ForegroundColor Cyan                                                  
Write-Host ""

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