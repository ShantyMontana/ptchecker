Clear-Host

Write-Host @"
██████╗ ████████╗     ██████╗██╗  ██╗███████╗ ██████╗██╗  ██╗███████╗██████╗ 
██╔══██╗╚══██╔══╝    ██╔════╝██║  ██║██╔════╝██╔════╝██║ ██╔╝██╔════╝██╔══██╗
██████╔╝   ██║       ██║     ███████║█████╗  ██║     █████╔╝ █████╗  ██████╔╝
██╔═══╝    ██║       ██║     ██╔══██║██╔══╝  ██║     ██╔═██╗ ██╔══╝  ██╔══██╗
██║        ██║       ╚██████╗██║  ██║███████╗╚██████╗██║  ██╗███████╗██║  ██║
╚═╝        ╚═╝        ╚═════╝╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
"@ -ForegroundColor Yellow

Write-Host ""
Write-Host "PT CHECKER v2.0" -ForegroundColor Cyan
Write-Host "Все права защищены PT" -ForegroundColor White
Write-Host ""

Write-Host "Проверка начнется через 5 секунд..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

Clear-Host

Write-Host "██████╗████████╗     ██████╗██╗  ██╗███████╗ ██████╗██╗  ██╗███████╗██████╗ " -ForegroundColor Yellow
Write-Host "██╔══██╗╚══██╔══╝    ██╔════╝██║  ██║██╔════╝██╔════╝██║ ██╔╝██╔════╝██╔══██╗" -ForegroundColor Yellow
Write-Host "██████╔╝   ██║       ██║     ███████║█████╗  ██║     █████╔╝ █████╗  ██████╔╝" -ForegroundColor Yellow
Write-Host "██╔═══╝    ██║       ██║     ██╔══██║██╔══╝  ██║     ██╔═██╗ ██╔══╝  ██╔══██╗" -ForegroundColor Yellow
Write-Host "██║        ██║       ╚██████╗██║  ██║███████╗╚██████╗██║  ██╗███████╗██║  ██║" -ForegroundColor Yellow
Write-Host "╚═╝        ╚═╝        ╚═════╝╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝" -ForegroundColor Yellow
Write-Host ""
Write-Host "Проверка файлов..." -ForegroundColor Cyan
Write-Host ""

$names = @(
    "celka", "celestial", "xrau", "autofish", "autofarm", "neat", "wexide", 
    "XONE", "venusfree", "кфг", "haruka", "bariton", "nursultan", "britva", 
    "Ezka", "nightprodject", "akrien", "excellent", "expensive", "delta", 
    "hach", "rassvet", "newcode", "moonproject", "newlight", "deadcode", 
    "impact", "killaura", "fanarme", "minced", "meteor", "verist", "fluger"
)

$found = @()
$totalChecked = 0

$drives = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -gt 0 }

foreach ($drive in $drives) {
    $searchPath = $drive.Root
    Write-Host "Сканирование $searchPath ..." -ForegroundColor DarkGray
    
    foreach ($name in $names) {
        $results = @()
        $results += Get-ChildItem -Path $searchPath -Filter "$name*.exe" -ErrorAction SilentlyContinue -Recurse 2>$null
        $results += Get-ChildItem -Path $searchPath -Filter "*$name*.exe" -ErrorAction SilentlyContinue -Recurse 2>$null
        $results += Get-ChildItem -Path $searchPath -Directory -Filter "*$name*" -ErrorAction SilentlyContinue -Recurse 2>$null
        
        foreach ($item in $results) {
            $found += [PSCustomObject]@{
                Name = $name
                Path = $item.FullName
                Type = if ($item.PSIsContainer) { "ПАПКА" } else { "EXE" }
            }
        }
        $totalChecked++
        $percent = [math]::Round(($totalChecked / $names.Count) * 100)
        Write-Progress -Activity "Проверка читов" -Status "Обработано: $totalChecked из $($names.Count)" -PercentComplete $percent
    }
}

Write-Host ""
Write-Host "=" * 60
Write-Host ""

if ($found.Count -eq 0) {
    Write-Host " РЕЗУЛЬТАТ: Читы не обнаружены " -ForegroundColor Green -BackgroundColor Black
    Write-Host ""
    Write-Host "Система чиста. Нарушений не найдено." -ForegroundColor White
} else {
    Write-Host " РЕЗУЛЬТАТ: Обнаружены подозрительные файлы! " -ForegroundColor Red -BackgroundColor Black
    Write-Host ""
    
    foreach ($item in $found) {
        if ($item.Type -eq "ПАПКА") {
            Write-Host "[ПАПКА] $($item.Name)" -ForegroundColor Yellow
        } else {
            Write-Host "[EXE] $($item.Name)" -ForegroundColor Red
        }
        Write-Host "       Путь: $($item.Path)" -ForegroundColor Gray
        Write-Host ""
    }
}

Write-Host "=" * 60
Write-Host ""
Write-Host "Проверка завершена." -ForegroundColor Cyan
Write-Host "Все права защищены PT" -ForegroundColor White
Write-Host ""