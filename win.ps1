# Nome do container Docker
$ContainerName = "laravel-app"

# Junta todos os argumentos em uma string
$Arguments = $args -join " "


if (-not $Arguments) {
    Write-Host "Uso: .\docker-enter.ps1 <comando>"
    Write-Host "Exemplo: .\docker-enter.ps1 artisan migrate"
    Write-Host "         .\docker-enter.ps1 php -v"
    Write-Host "         .\docker-enter.ps1 pa migrate"
    exit 1
}
Write-Host ""
Write-Host ""
Write-Host "[ $args ] Executando..." -ForegroundColor Yellow
Write-Host ":::::::::::::::::::::::::::::::" -ForegroundColor Green
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
    docker exec -it $ContainerName bash -c "$ComposerCommand"

    # Adiciona permissão 777 para a pasta 'app'
    docker exec -it $ContainerName bash -c "chmod -R 777 /var/www/html/app"

} elseif ($args[0] -eq "laravel" -and $args[1] -eq "new") {
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
elseif ($args[0] -eq "app-permission") {
    docker exec -it $ContainerName bash -c "chmod -R 777 /var/www/html/app"
    Write-Host "Permissões 777 atribuídas à pasta 'app'." -ForegroundColor Green
}


# Se o argumento for 'pa', executa o comando 'php artisan' no diretório app
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
Write-Host "[ $args : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ] concluido..." -ForegroundColor Yellow
Write-Host ":::::::::::::::::::::::::::::::" -ForegroundColor Green
