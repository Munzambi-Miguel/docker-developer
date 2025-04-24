# Nome do container Docker
$ContainerName = "laravel-app"

# Junta todos os argumentos em uma string
$Arguments = $args -join " "

function Show-DockerStyleProgress {
    param (
        [string]$TaskName,
        [int]$Step,
        [int]$TotalSteps
    )

    $progressBarLength = 40
    $currentIndex = [math]::Floor(($Step / $TotalSteps) * $progressBarLength)

    $bar = ""

    for ($i = 0; $i -lt $progressBarLength; $i++) {
        if ($i -lt $currentIndex) {
            $bar += "⣿"
        }
        elseif ($i -eq $currentIndex) {
            $bar += "⣷"
        }
        else {
            $bar += " "
        }
    }

    $percentage = [math]::Floor(($Step / $TotalSteps) * 100)
    Write-Host -NoNewline "$TaskName [$bar] $Step MB / $TotalSteps MB ($percentage%)`r"
}

# Simulação de progresso de 0 a 10


# Função para mostrar o progresso no terminal
function Show-ProgressBar {
    param (
        [string]$TaskName,
        [float]$CurrentSize,
        [float]$TotalSize
    )

    $progress = [math]::Floor(($CurrentSize / $TotalSize) * 100)
    $progressBarLength = 20  # Comprimento total da barra de progresso
    $progressBar = '⣷' * [math]::Floor(($progress / 100) * $progressBarLength) + ' ' * ($progressBarLength - [math]::Floor(($progress / 100) * $progressBarLength))
    
    # Exibindo a barra de progresso
    Write-Host -NoNewline "$TaskName [$progressBar] $([math]::Round($CurrentSize, 2))MB / $([math]::Round($TotalSize, 2))MB $progress%`r"
}

function Show-InteractiveMenu {
    param (
        [string[]]$Options,
        [string]$Prompt = "Selecione uma opção:"
    )

    $selected = 0
    $key = $null

    do {
        Clear-Host
        Write-Host $Prompt -ForegroundColor Cyan
        Write-Host "Use ↑ ↓ e Enter para selecionar:`n"

        for ($i = 0; $i -lt $Options.Length; $i++) {
            if ($i -eq $selected) {
                Write-Host ("🟢 " + $Options[$i]) -ForegroundColor Green
            }
            else {
                Write-Host ("🔘 " + $Options[$i]) -ForegroundColor Cyan
            }
        }

        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode

        switch ($key) {
            38 { if ($selected -gt 0) { $selected-- } } # UP
            40 { if ($selected -lt ($Options.Length - 1)) { $selected++ } } # DOWN
            13 { return $Options[$selected] } # ENTER
        }
    } while ($true)
}

if (-not $args) {
    $options = @(
        "php -v",
        "php artisan migrate", 
        "php artisan config:clear",
        "php artisan db:seed",
        "composer install",
        "composer dump-autoload",
        "composer create-project laravel/laravel",
        "chmod -R 777 app",
        "laravel -v",
        "laravel new ",
        "Sair"
    )

    $selection = Show-InteractiveMenu -Options $options

    if ($selection -eq "Sair") {
        Write-Host "`nSaindo..."
      
        exit
    }

    $Arguments = $selection.Split(" ")
}


Write-Host ""
Write-Host ""
Write-Host "[ $args ] Executando..." -ForegroundColor Yellow
# Simulando o progresso de download ou execução do comando
# Simulação
$TotalSize = 100
$Increment = 10

for ($i = 0; $i -le $TotalSize; $i += $Increment) {
    Show-DockerStyleProgress -TaskName  $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') -Step $i -TotalSteps $TotalSize
    Start-Sleep -Seconds 0.5
}
Write-Host ""
Write-Host ""

# Função para verificar se o container está em execução
function Test-ContainerRunning {
    $containerStatus = docker inspect -f '{{.State.Running}}' $ContainerName 2>$null
    return $containerStatus -eq "true"
}

# Se o container não estiver rodando, inicie-o
if (-not (Test-ContainerRunning)) {
    Write-Host "Container '$ContainerName' não está em execução. Iniciando..."
    docker-compose up -d
    Start-Sleep -Seconds 5 # Espera 5 segundos para garantir que o container tenha tempo para iniciar
}

# Força sempre a criação na pasta 'app'
if ($args[0] -eq "composer" -and $args[1] -eq "create-project") {
    # Exemplo: composer create-project laravel/laravel . => composer create-project laravel/laravel app
    $ComposerCommand = "composer create-project laravel/laravel app"
    $TotalSize = 257.8  # Total em MB (exemplo)
    $CurrentSize = 0

    # Simulando o progresso de download ou execução do comando
    while ($CurrentSize -lt $TotalSize) {
        Show-ProgressBar -TaskName "Pulling" -CurrentSize $CurrentSize -TotalSize $TotalSize
        $CurrentSize += 5  # Incrementa 5MB a cada iteração
        Start-Sleep -Seconds 1
    }
    docker exec -it $ContainerName bash -c "$ComposerCommand"

    # Adiciona permissão 777 para a pasta 'app'
    docker exec -it $ContainerName bash -c "chmod -R 777 /var/www/html/app"

}
elseif ($args[0] -eq "laravel" -and $args[1] -eq "new") {
    # Exemplo: laravel new qualquercoisa => laravel new app
    $LaravelCommand = "laravel new app"
    docker exec -it $ContainerName bash -c "$LaravelCommand"

    # Adiciona permissão 777 para a pasta 'app'
    docker exec -it $ContainerName bash -c "chmod -R 777 /var/www/html/app"
}
elseif ($args[0] -eq "app-permission") {
    docker exec -it $ContainerName bash -c "chmod -R 777 /var/www/html/app"
    Write-Host "Permissões 777 atribuídas à pasta 'app'." -ForegroundColor Green
}
elseif ($args[0] -eq "app-permission" -and $args.Length -gt 1) {
    $folderName = $args[1]
    docker exec -it $ContainerName bash -c "chmod -R 777 /var/www/html/$folderName"
    Write-Host "Permissões 777 atribuídas à pasta '$folderName'." -ForegroundColor Green
}
elseif ($args[0] -eq "pa") {
    # Remove 'pa' e executa o comando PHP artisan
    $ArtisanCommand = $args[1..($args.Length - 1)] -join " "
    docker exec -it $ContainerName bash -c "cd /var/www/html/app && php artisan $ArtisanCommand"
}
elseif ($args[0] -eq "artisan") {
    # Remove 'artisan' e executa como comando PHP com 'artisan'
    $ArtisanCommand = $args[1..($args.Length - 1)] -join " "
    docker exec -it $ContainerName bash -c "php artisan $ArtisanCommand"
}
else {
    # Executa o comando diretamente (ex: php -v)
    docker exec -it $ContainerName bash -c "$Arguments"
}

Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host "[ $args ] concluído..." -ForegroundColor Yellow
Write-Host $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  " [⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿]" -ForegroundColor Green
