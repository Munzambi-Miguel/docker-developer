#### 

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
> .\win.ps1 laravel new
> ```
>
> Ou Escreva usando o composer
>
> ````
> .\win.ps1 composer create-project
> ````
>
> quasquer comando artisan do laravel podes usar o comando o win.ps1 pa, faz a vez do php artisan na pasta do projecto que será app
>
> ```
> .\win.ps1 pa list
> ```
>
> para ambiente dist linux, ubuntu ou derbian, pode ser usado o lin, em vez de win
>
> ```
>
> ./lin.sh composer create-project
> ```
