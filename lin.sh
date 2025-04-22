#!/bin/bash

# Nome do container Docker
ContainerName="laravel-app"

# Junta todos os argumentos em uma string
Arguments="$*"

if [ -z "$Arguments" ]; then
    echo "Uso: ./lin.sh <comando>"
    echo "Exemplo: ./lin.sh artisan migrate"
    echo "         ./lin.sh php -v"
    echo "         ./lin.sh pa migrate"
    exit 1
fi

echo ""
echo ""
echo -e "\033[1;33m[ $* ] Executando...\033[0m"
echo -e "\033[1;32m:::::::::::::::::::::::::::::::\033[0m"
echo ""
echo ""

# Verifica se o container está em execução
is_container_running() {
    docker inspect -f '{{.State.Running}}' "$ContainerName" 2>/dev/null | grep -q true
}

if ! is_container_running; then
    echo "Container '$ContainerName' não está em execução. Iniciando..."
    docker-compose up -d
    sleep 5
fi

if [ "$1" == "composer" ] && [ "$2" == "create-project" ]; then
    # Ex: composer create-project laravel/laravel . => composer create-project laravel/laravel app
    ComposerCommand="composer create-project laravel/laravel app"
    docker exec -it $ContainerName bash -c "$ComposerCommand"

    # Adiciona permissão 777 para a pasta 'app'
    docker exec -it $ContainerName bash -c "chmod -R 777 /var/www/html/app"

elif [ "$1" == "laravel" ] && [ "$2" == "new" ]; then
    # Ex: laravel new qualquercoisa => laravel new app
    LaravelCommand="laravel new app"
    docker exec -it $ContainerName bash -c "$LaravelCommand"

    # Adiciona permissão 777 para a pasta 'app'
    docker exec -it $ContainerName bash -c "chmod -R 777 /var/www/html/app"

elif [ "$1" == "app-permission" ]; then
    if [ -z "$2" ]; then
        # Caso o nome da pasta não seja fornecido, usa 'app' por padrão
        docker exec -it $ContainerName bash -c "chmod -R 777 /var/www/html/app"
        echo "Permissões 777 atribuídas à pasta 'app'."
    else
        # Caso um nome de pasta seja fornecido
        folderName="$2"
        docker exec -it $ContainerName bash -c "chmod -R 777 /var/www/html/$folderName"
        echo "Permissões 777 atribuídas à pasta '$folderName'."
    fi
fi

# Lógica para 'pa'
if [ "$1" = "pa" ]; then
    shift
    if [ $# -eq 0 ]; then
        # Modo interativo na pasta app e executa php artisan
        docker exec -it "$ContainerName" bash -c "cd /var/www/html/app  && php artisan"
    else
        # Executa php artisan com argumentos e sai
        ArtisanCommand="$*"
        docker exec "$ContainerName" bash -c "cd /var/www/html/app && php artisan $ArtisanCommand"
    fi
elif [ "$1" = "artisan" ]; then
    shift
    ArtisanCommand="$*"
    docker exec "$ContainerName" bash -c "php artisan $ArtisanCommand"
else
    docker exec "$ContainerName" bash -c "$Arguments"
fi

# Só exibe mensagem final se foi execução direta
if [ "$#" -gt 0 ] && [ "$1" != "pa" -o "$#" -gt 1 ]; then
    echo ""
    echo ""
    echo -e "\033[1;33m[ $Arguments : $(date '+%Y-%m-%d %H:%M:%S') ] concluído...\033[0m"
    echo -e "\033[1;32m:::::::::::::::::::::::::::::::\033[0m"
fi
