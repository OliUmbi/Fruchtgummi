[array]$diceFaces = @("yellow", "red", "blue", "green", "brown", "ghost")
[int]$minSweets = 0
[int]$maxSweets = 0
[int]$minPathLenght = 0
[int]$maxPathLenght = 0
[int]$iterations = 0
[int]$rounds = 0
[int]$ghostPosition = 0
[hashtable]$castle = @{}
[array]$gameRounds = @()
[int]$playerWonCount  = 0
[array]$csvData = @()
[int]$sweets = 0
[int]$pathLenght = 0

function setParameters {
    do {
        $hasError = $false
        $global:minSweets = Read-Host "Min sweets"
        $global:maxSweets = Read-Host "Max sweets"
        $global:minPathLenght = Read-Host "Min path lenght"
        $global:maxPathLenght = Read-Host "Max path lenght"
        $global:iterations = Read-Host "Iterations"

        if ($iterations -lt 10 -or $iterations -gt 1000) {
            $hasError = $true
        }
    } while ($hasError)
}

function rollDice {
    return Get-Random -InputObject $diceFaces
}

function isGameOver {
    if ($ghostPosition -eq $pathLenght) {
        return $true
    }

    foreach($key in $castle.Keys){
        if ($castle[$key] -gt 0) {
            return $false
        }
    }

    $global:playerWonCount++
    return $true
}

function playGame {
    $global:rounds = 0
    $global:ghostPosition = 0

    do {
    
        [string]$dicedResult = rollDice

        if ($dicedResult -eq "ghost") {
            $global:ghostPosition++
        } else {
            $global:castle[$dicedResult]--
        }

        $global:rounds++

        [bool]$isGameOver = isGameOver

    } while (!$isGameOver)  

    $global:gameRounds += $rounds
}

function startIterations {
    $global:gameRounds = @()
    $global:playerWonCount = 0

    for ($i = 0; $i -lt $iterations; $i++) {
        $global:castle = @{yellow = $sweets; red = $sweets; blue = $sweets; green = $sweets; brown = $sweets}
        playGame
    }
}

function writeIterationData {
    $Avg = ($gameRounds | Measure-Object -Average)
    [int]$winRate = 100 / $iterations * $playerWonCount

    $global:csvData += [pscustomobject]@{
        sweets = $sweets
        pathLenght  = $pathLenght
        averageNumberOfGames  = $Avg.Average
        winRate = $winRate
    }
}

function exportIterationData {
    $csvData | Export-Csv -Path C:\Users\olive\Desktop\data.csv
}

function loadCsvInConsole {
    if ((Read-Host "do you want to load the .csv file in the console? [y/n]").ToLower() -eq "y") {
        $P = Import-Csv -Path C:\Users\olive\Desktop\data.csv | Select sweets,pathLenght,averageNumberOfGames,@{Name="winRate";Expression={[int]$_.winRate}} | sort winRate -Descending
        $P | Format-Table
    }
}

function deleteCsv {
    if ((Read-Host "do you want to delete the .csv file? [y/n]").ToLower() -eq "y") {
    Remove-Item -Path C:\Users\olive\Desktop\data.csv
    }
}

setParameters

Write-Host "processing..."

for ($global:sweets = $minSweets; $sweets -le $maxSweets; $global:sweets++) {
    for ($global:pathLenght = $minPathLenght; $pathLenght -le $maxPathLenght; $global:pathLenght++) {        
        startIterations
        writeIterationData
    }
}

Write-Host "finished!"

exportIterationData

loadCsvInConsole

deleteCsv