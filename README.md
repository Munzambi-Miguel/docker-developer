# Munzambi Miguel


| Windows_11_Windows:terminal___________                                                                    | Suporte ubuntu 22 e 24 ou a dist baseado em derbian                                                                   |
| --------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| ![Windows 10 icon in Windows 11 Color Style](https://img.icons8.com/?size=380&id=gXoJoyTtYXFg&format=png) | ![Ubuntu Logo PNG Vector SVG, EPS, Ai formats (3.08 KB) Free Download](https://www.cdnlogo.com/logos/u/42/ubuntu.svg) |


| **Serviço**   | **Configuração**                                                                                                                                                                                                                          |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **app**        | -**Imagem**:`ntemomiguel/lab-laravel:latest`<br/>-**Container Name**:`laravel-app`<br/>-**Diretório de Trabalho**:`/var/www/html`<br/>-**Memória Limite**: 8G<br/>-**Memória Reservada**: 6G                                             |
|                | -**Volumes**:`<br>&nbsp;&nbsp;- .:/var/www/html/:delegated`<br/>-`./containers/php/php.ini:/usr/local/etc/php/php.ini`<br/>-**Ambiente**:`COMPOSER_ALLOW_SUPERUSER=1`                                                                       |
|                | -**Dependências**:`mysql`<br/>-**Redes**:`app-network`<br/>-**Comando**:`php-fpm`<br/>-**Entrypoint**: \`sh -c "if ! command -v laravel > /dev/null; then curl -fsSL[https://php.new/install/linux/8.4](https://php.new/install/linux/8.4) |
| **nginx**      | -**Imagem**:`nginx:stable-alpine`<br/>-**Container Name**:`nginx-server`<br/>-**Portas**:`"8080:80"`<br/>-**Volumes**:`<br>&nbsp;&nbsp;- .:/var/www/html:delegated`<br/>-`./containers/nginx/default.conf:/etc/nginx/conf.d/default.conf`   |
|                | -**Dependências**:`app`<br/>-**Redes**:`app-network`                                                                                                                                                                                       |
| **mysql**      | -**Imagem**:`mysql:latest`<br/>-**Container Name**:`mysql-db`<br/>-**Arquivo de Variáveis de Ambiente**:`./containers/mysql/.env`<br/>-**Volumes**:`<br>&nbsp;&nbsp;- ./containers/mysql/volume:/var/lib/mysql`                            |
|                | -**Portas**:`"3306:3306"`<br/>-**Redes**:`app-network`                                                                                                                                                                                      |
| **phpmyadmin** | -**Imagem**:`phpmyadmin/phpmyadmin:latest`<br/>-**Container Name**:`phpmyadmin`<br/>-**Memória Limite**: 4G<br/>-**Memória Reservada**: 4G                                                                                                |
|                | -**Ambiente**:`PMA_HOST: mysql`,`PMA_PORT: 3306`<br/>-**Portas**:`"8081:80"`<br/>-**Dependências**:`mysql`<br/>-**Redes**:`app-network`                                                                                                    |
| **redes**      | -**app-network**:`driver: bridge`                                                                                                                                                                                                           |

```yml
version: '3.8'

services:
  app:
    image: ntemomiguel/lab-laravel:latest  # Use a imagem do Docker Hub
    container_name: laravel-app
    working_dir: /var/www/html
    mem_limit: 8G
    mem_reservation: 6G
    volumes:
      - .:/var/www/html/:delegated
      - ./containers/php/php.ini:/usr/local/etc/php/php.ini
    environment:
      - COMPOSER_ALLOW_SUPERUSER=1
    depends_on:
      - mysql
    networks:
      - app-network
    command: ["php-fpm"]
    entrypoint: >
      sh -c "
      if ! command -v laravel > /dev/null; then
        curl -fsSL https://php.new/install/linux/8.4 | bash;
      fi &&
      php-fpm
      "
  
  nginx:
    image: nginx:stable-alpine
    container_name: nginx-server
    ports:
      - "8080:80"
    volumes:
      - .:/var/www/html:delegated
      - ./containers/nginx/default.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - app
    networks:
      - app-network

  mysql:
    image: mysql:latest
    container_name: mysql-db
    env_file:
      - ./containers/mysql/.env
    volumes:
      - ./containers/mysql/volume:/var/lib/mysql
    ports:
      - "3306:3306"
    networks:
      - app-network

  phpmyadmin:
    image: phpmyadmin/phpmyadmin:latest
    container_name: phpmyadmin
    mem_limit: 4G
    mem_reservation: 4G
    environment:
      PMA_HOST: mysql
      PMA_PORT: 3306
    ports:
      - "8081:80"
    depends_on:
      - mysql
    networks:
      - app-network

networks:
  app-network:
    driver: bridge

```

### **O projeto tem como objetivo facilitar o uso do Docker com Laravel para iniciantes que desejam configurar um ambiente de desenvolvimento.**

A ideia é proporcionar uma maneira simples e prática de configurar o Docker e o Laravel em uma máquina local, permitindo que desenvolvedores iniciantes possam concentrar-se no desenvolvimento de suas aplicações sem se preocupar com configurações complexas de ambiente.

Com esse projeto, os usuários podem facilmente:

* Rodar containers Docker para isolar o ambiente de desenvolvimento.
* Configurar o Laravel para ser executado dentro do Docker, permitindo que o projeto tenha uma configuração limpa e consistente.
* Facilitar a execução de comandos Artisan e outros comandos do Laravel diretamente dentro do container, sem a necessidade de configurações adicionais complexas.

O projeto foi desenvolvido para ser simples de usar e ideal para desenvolvedores que estão começando com Docker e Laravel. A ideia é proporcionar um ambiente de desenvolvimento rápido e eficiente, sem a necessidade de uma infraestrutura complicada.

> ````
> docker-compose up --build -d
> ````
>
> * [X]  Para configurar o ambiente Windows na raiz do seu projeto, use o comando indicado em cima: Isso permitirá iniciar o ambiente Laravel Developer utilizando Docker. ☝️☝️☝️☝️☝️☝️
>
> Para criar uma novo projecto laravel, basta escrever
>
> ```
> .\bantu laravel new
> ```
>
> Ou Escreva usando o composer
>
> ````
> .\bantu composer create-project
> ````
>
> quasquer comando artisan do laravel podes usar o comando o win.ps1 pa, faz a vez do php artisan na pasta do projecto que será app
>
> ```
> .\bantu pa list
> ```
>
> para ambiente dist linux, ubuntu ou derbian, pode ser usado o lin, em vez de win
>
> ```
>
> ./bantu composer create-project
> ```

**Para usuários do WSL (Windows Subsystem for Linux), como Ubuntu ou Debian:**

Se você deseja acessar arquivos do sistema de arquivos do Windows a partir do terminal WSL, pode montar a unidade do Windows manualmente utilizando o seguinte comando:

```bash
sudo mount -t drvfs C: /mnt/c
```

Esse comando monta a unidade `C:` do Windows no caminho `/mnt/c`, permitindo que você acesse arquivos e pastas como se estivesse em um ambiente Linux padrão.

> 💡 Observação: Em versões mais recentes do WSL, os discos do Windows geralmente já são montados automaticamente em `/mnt`, como `/mnt/c`, `/mnt/d`, etc. No entanto, esse comando pode ser útil caso a montagem automática não ocorra ou tenha sido desativada.

---

Se quiser posso incluir também o uso em scripts ou alias para facilitar a vida no terminal. Deseja?

````
 cd /mnt/c/Users/<username>/Documents/GitHub/Local/docker/projecto0.1.1
 docker-compose --env-file ./containers/Env/.env up --build -d
 docker-compose restart nginx
````

````
.\bantu  # para ober o menu interrativo no ambiente windows ou linux
````

![1745537426803](images/README/1745537426803.png)


| Windows_11_Windows:terminal___________                                                                    | Suporte ubuntu 22 e 24 ou a dist baseado em derbian                                                                   |
| --------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| ![Windows 10 icon in Windows 11 Color Style](https://img.icons8.com/?size=180&id=gXoJoyTtYXFg&format=png) | ![Ubuntu Logo PNG Vector SVG, EPS, Ai formats (3.08 KB) Free Download](https://www.cdnlogo.com/logos/u/42/ubuntu.svg) |

```yml
version: '3.8'

services:
  app:
    image: munzambimiguel/laravel-buider:latest  # Use a imagem do Docker Hub
    container_name: laravel-app
    working_dir: /var/www/html
    mem_limit: 8G
    mem_reservation: 6G
    volumes:
      - .:/var/www/html/:delegated
      - ./containers/php/php.ini:/usr/local/etc/php/php.ini
    environment:
      - COMPOSER_ALLOW_SUPERUSER=1
    depends_on:
      - mysql
    networks:
      - app-network
    command: ["php-fpm"]
    entrypoint: >
      sh -c "
      if ! command -v laravel > /dev/null; then
        curl -fsSL https://php.new/install/linux/8.4 | bash;
      fi &&
      php-fpm
      "
  
  nginx:
    image: nginx:stable-alpine
    container_name: nginx-server
    ports:
      - "8080:80"
    volumes:
      - .:/var/www/html:delegated
      - ./containers/nginx/default.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - app
    networks:
      - app-network

  mysql:
    image: mysql:latest
    container_name: mysql-db
    env_file:
      - ./containers/mysql/.env
    volumes:
      - ./containers/mysql/volume:/var/lib/mysql
    ports:
      - "3306:3306"
    networks:
      - app-network

  phpmyadmin:
    image: phpmyadmin/phpmyadmin:latest
    container_name: phpmyadmin
    mem_limit: 4G
    mem_reservation: 4G
    environment:
      PMA_HOST: mysql
      PMA_PORT: 3306
    ports:
      - "8081:80"
    depends_on:
      - mysql
    networks:
      - app-network

networks:
  app-network:
    driver: bridge

```

### **O projeto tem como objetivo facilitar o uso do Docker com Laravel para iniciantes que desejam configurar um ambiente de desenvolvimento.**

A ideia é proporcionar uma maneira simples e prática de configurar o Docker e o Laravel em uma máquina local, permitindo que desenvolvedores iniciantes possam concentrar-se no desenvolvimento de suas aplicações sem se preocupar com configurações complexas de ambiente.

Com esse projeto, os usuários podem facilmente:

* Rodar containers Docker para isolar o ambiente de desenvolvimento.
* Configurar o Laravel para ser executado dentro do Docker, permitindo que o projeto tenha uma configuração limpa e consistente.
* Facilitar a execução de comandos Artisan e outros comandos do Laravel diretamente dentro do container, sem a necessidade de configurações adicionais complexas.

O projeto foi desenvolvido para ser simples de usar e ideal para desenvolvedores que estão começando com Docker e Laravel. A ideia é proporcionar um ambiente de desenvolvimento rápido e eficiente, sem a necessidade de uma infraestrutura complicada.

> ````
> docker-compose up --build -d
> ````
>
> * [X]  Para configurar o ambiente Windows na raiz do seu projeto, use o comando indicado em cima: Isso permitirá iniciar o ambiente Laravel Developer utilizando Docker. ☝️☝️☝️☝️☝️☝️
>
> Para criar uma novo projecto laravel, basta escrever
>
> ```
> .\bantu laravel new
> ```
>
> Ou Escreva usando o composer
>
> ````
> .\bantu composer create-project
> ````
>
> quasquer comando artisan do laravel podes usar o comando o win.ps1 pa, faz a vez do php artisan na pasta do projecto que será app
>
> ```
> .\bantu pa list
> ```
>
> para ambiente dist linux, ubuntu ou derbian, pode ser usado o lin, em vez de win
>
> ```
>
> ./bantu composer create-project
> ```

**Para usuários do WSL (Windows Subsystem for Linux), como Ubuntu ou Debian:**

Se você deseja acessar arquivos do sistema de arquivos do Windows a partir do terminal WSL, pode montar a unidade do Windows manualmente utilizando o seguinte comando:

```bash
sudo mount -t drvfs C: /mnt/c
```

Esse comando monta a unidade `C:` do Windows no caminho `/mnt/c`, permitindo que você acesse arquivos e pastas como se estivesse em um ambiente Linux padrão.

> 💡 Observação: Em versões mais recentes do WSL, os discos do Windows geralmente já são montados automaticamente em `/mnt`, como `/mnt/c`, `/mnt/d`, etc. No entanto, esse comando pode ser útil caso a montagem automática não ocorra ou tenha sido desativada.

---

Se quiser posso incluir também o uso em scripts ou alias para facilitar a vida no terminal. Deseja?

````
 cd /mnt/c/Users/<username>/Documents/GitHub/Local/docker/projecto0.1.1
 docker-compose --env-file ./containers/Env/.env up --build -d
 docker-compose restart nginx
````

````
.\bantu  # para ober o menu interrativo no ambiente windows ou linux
````

![1745537426803](images/README/1745537426803.png)
