O objetivo em um arquivo README pode estar no bloco inicial de informações contendo:

    Descrição técnica do objetivo do código.
    Links para conteúdos técnicos adicionais.
    Link para materiais relacionados ao negócio, como o Modelo de negócio, Personas, Modelo de domínio, Épicos e História

Para conteúdo adicional, pode-se também fazer o uso de arquivos Markdown e eles podem estar em um diretório docs na raiz do projeto.

Por exemplo, arquiteturas monolíticas podem ter artefatos diferentes de arquiteturas em microsserviços, onde a primeira poderá ter apenas uma documentação da sua arquitetura salva no próprio projeto e a segunda poderá ter uma documentação geral de estruturação dos serviços salva externamente.

Para ambas situações, há algumas boas práticas que podem ser aplicadas:

    Oferecer uma breve descrição sobre a arquitetura utilizada.
    Quando a arquitetura segue um padrão ou estilo conceitual, não é necessário detalhar o conceito, basta citar o padrão ou estilo criando um link para um conteúdo confiável que detalhe o mesmo.
    Caso a documentação de arquitetura esteja em um arquivo próprio, citá-lo no README com um link para o mesmo.
    Fazer uso de desenhos para representar a arquitetura. Esta prática está detalhada no tema Desenhos técnicos no guia.
    Citar a linguagem e frameworks utilizados, informando no máximo a sua versão major. Isso porque normalmente o detalhe das versões está no arquivo de configuração da ferramenta de dependências utilizada, logo não é necessário ter informações duplicadas.
    Informar as dependências do projeto, sejam as de outros serviços, projetos ou bibliotecas. Para caso de bibliotecas, o i

Acesso e execução do código

Saber onde está o código fonte parece algo simples, mas muitas vezes se torna uma dificuldade em times de desenvolvimento.

A forma para documentar essa questão pode variar de acordo com a ferramenta utilizada para versionar o código. No passado, ferramentas focadas nesse assunto não proviam portais de acesso aos usuários, era necessário registrar o local do projeto em outros documentos ou apenas na memória.

Atualmente, ferramentas como as já citadas GitHub, GitLab, BitBucket, permitiram uma grande evolução na gestão de código fonte, o que tornou dispensável documentos auxiliares para esse tipo de informação.

O recomendável é o uso desta ferramentas, onde desenvolvedores(as) com seus usuários poderão ver todos os projetos com código fonte aos quais possuem acesso.

Ainda assim, é importante seguir algumas boas práticas para facilitar a localização do projeto:

    Uso de nomes adequados ao objetivo do código e que evitem confusões a desenvolvedores(as).
    Uso do campo de descrição do projeto com conteúdo inicial usado no README.
    Organização dos agrupamentos e permissões de acesso. Dar acesso a todos os projetos sem qualquer critério polui a visão da lista de projetos.

Nas informações de execução do projeto, o README pode conter:

    Configurações necessárias no ambiente para rodar com sucesso o projeto.
    Instruções para uso da ferramenta de build adotada no projeto.
    Os comandos necessários para rodar o projeto localmente e demais scripts auxiliares.


Alterações, testes e validações

Uma das atividades mais realizadas por desenvolvedores(as) sobre um código fonte será a de modificá-lo, logo é essencial que esteja documentado o processo utilizado pelo time para alterar, testar e validar suas alterações, sejam com testes automatizados (que é o mais adequado) ou acessando e usando o sistema localmente.
documentar:

    Comandos auxiliares para geração/carregamento de cenários de dados.
    Dados de autenticação para acesso ao sistema, considerando inclusive informações de usuários de papéis diferentes quando existentes.

Atualização e monitoramento

Para atualizar o software em um ambiente, normalmente há passos que devem ser seguidos e é importante que essas informações estejam documentadas.

Ao colocar em um ambiente uma nova versão, principalmente em produção, desenvolvedores(as) precisam também saber como monitorar e verificar problemas no software caso eles ocorram.

Essas informações normalmente estão documentadas fora do projeto, é adequado então fazer o link para tais conteúdos.

Além do como documentar há também o desafio de manter e utilizar a documentação técnica.

Para manter uma documentação atualizada é necessário comprometimento e responsabilidade dos times para tal atividade. Uma boa prática é documentar antes de implementar. Isso evita cair na armadilha de passar para outras tarefas porque a anterior já parece estar pronta. Nesse caso documentar, quando necessário, se torna o trabalho inicial de uma tarefa de implementação, semelhante ao TDD para testes automatizados.

Outro aspecto que estimula os times manterem atualizadas as documentações é perceberem que elas são utilizadas. Nesse sentido deve-se buscar:

    Indicar a documentação sempre que as pessoas perguntarem sobre algo que esteja devidamente documentado. Se há documentação não deve-se usar muito tempo para repetir verbalmente informações contidas nelas.
    Usar a documentação em reuniões e momentos de decisões onde elas possam colaborar para clareza das conversas.
    Dar espaço a todos para contribuírem nas documentações, de forma que possam editá-las sempre que houver algo novo ou a ser corrigido.

No sentido inverso do tema, há alguns pontos aos quais deve-se evitar gerar documentações auxiliares pois estas normalmente não são utilizadas e são difíceis de serem mantidas. Abaixo segue alguns:

    Código fonte: Um ponto polêmico entre desenvolvedores(as), cuja questão não está em documentar ou não o código fonte, mas sim o porquê e como documentar. Um código bem escrito, que segue as práticas de Código Limpo (Clean Code) teoricamente não precisa de documentação. Ainda assim há casos onde uma documentação pode ser útil, porém ela precisa ser simples. Se ela se torna complexa provavelmente é porque o código está complexo.
    Modelagem detalhada: É válido ter documentação sobre a modelagem da solução, seja de entidades, de componentes, dentre outros. Porém ela deve apenas prover a visão resumida do todo. Detalhes que são voláteis normalmente se tornam desatualizados na documentação. O código é a fonte mais confiável.
    Diagramas de classe: Ter um diagrama sobre as classes base de um projeto pode ser útil, porém representar todas as classes normalmente se torna uma documentação com pouca utilidade e desatualizada. A preferência normalmente será ir diretamente ao código fonte.
    Funcionalidades: Documentação técnica sobre funcionalidades pode ser válida para questões não mapeadas a nível de negócio. O importante é não repetir conteúdo já presente em Histórias, Casos de uso, ou outras documentações de negócio e requisítos, pois é normal as funcionalidades evoluírem e tais documentações técnicas não.

Uma boa documentação técnica contribui para eficiência e escala de times de desenvolvimento. Criar e mantê-la é um sinal de profissionalismo e maturidade.

O que e como documentar pode ser sempre adaptado conforme as necessidades, inclusive complementado com o tema Desenho Técnico, para buscar o nivelamento de conhecimento, diminuição do tempo usado com perguntas repetidas e evitar informações retidas apenas “na memória das pessoas”.

# Processamento_de_imagem_FPGA

## 📝 Sobre o Projeto 
Objetivo do projeto.

- 📌 Funcionalidades

  

  ### 🔧 Como o Sistema Funciona 


## 📃 Requisitos 


## 🛠️  Arquitetura

### Tecnologias


| Arquivo  | Descrição |
| ------------- |:-------------:|
| main.py      | Inicializa rotas, middlewares e configurações |
| server.py      | Entrada do uvicorn para execução do servidor |
| Dockerfile      | Configura o ambiente Docker para build da aplicação |
| docker-compose.yml     | Orquestra os serviços Docker (como banco de dados e o backend em si)|
| requirements.txt      | Lista de dependências Python da aplicação |
| pyproject.toml      | Configuração do projeto e suas dependências via poetry |




## 🚀 Como Rodar o Projeto (Passo a Passo Simples)

### Pré-requisitos:
- Python 3.8+
- Docker 

### Passo a Passo:

* **Configurar git**
  ```  
  git config --global user.email "example@mail.com"  
  ```  
  ```  
  git config --global user.name "Your Name"  
  ```  
  - Fazer um fork do projeto

1. **Baixar o código**:
   ```
   git clone https://github.com/EcompJr/pj-hans-back
   git init
   ```

2. **Configurar ambiente**:

 - Dependências

   ```
      sudo apt install -y make build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev git
   ```

  - Instalação
   ```
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
  ```
  - Configuração no shell
  ```
    nano ~/.bashrc
  ```

   ```
    export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  ```
  - Atualizar o shell
  ```
      source ~/.bashrc   
  ```
  - Verificação
  ```
      pyenv --version   
  ```
  - **Configuração do poetry**
  
  Dependências
  ```
  sudo apt install -y curl python3-pip
  Instalação
  curl -sSL https://install.python-poetry.org | python3 -
 ```
  Configuração
```
  export PATH="$HOME/.local/bin:$PATH"
  source ~/.bashrc
 ```
Verificar se foi instalado corretamente
 ```
poetry --version
 ```

3. **Instalar as dependências:**
  ```
  pip install -r requirements.txt  
  ```

  - Configurar as variáveis de ambiente do app. 
  
 4. **Verificar se há um arquivo `.env` na raiz do projeto com o seguinte conteúdo mínimo:**
  
  A forma geral é: DB_URL=TIPO_BD://USUARIO:SENHA@HOST:PORTA/NOME_BD?PARAM1=valor&PARAM2=valor
  ```
  echo '
  POSTGRES_USER=admin_ecompjr
  POSTGRES_PASSWORD=EcompJr123
  POSTGRES_DB=postgres
  SERVER_DATABASE_HOST=localhost
  APP_NAME=my-app
  APP_PORT=8080' >> .env
  ```

 5. **Instalar a interface de linha de comando do docker-compose:**
  ```
  sudo rm /usr/local/bin/docker-compose
  ```
  ```
  sudo ln -s /Applications/Docker.app/Contents/Resources/cli-plugins/docker-compose /usr/local/bin/docker-compose
  ``` 

6. **Configurar ferramenta de banco de dados**:
  

  - Reiniciar WSL

  ```
  wsl --shutdown
  wsl -d Ubuntu
  ```

  - Inicar e testar 

  ```
  sudo service docker start
  docker run hello-world
  ```

  -Subir banco de dados
```
  docker compose up -d  
  ```
  
  - Para buildar imagens dos containers
  ```
  docker compose build
  ``` 
  - Para parar os containers
  ```
  docker compose down
  ``` 

7. **Executar as migrações**(Cria as tabelas):
  ```
  docker exec <nome_do_container> aerich upgrade
  ```

8. **Ligar o servidor**(Inicia o servidor):
   ```hypercorn server:app --reload  # Inicia o sistema com auto-recarregamento```

10. **Acessar o servidor**:**
   ```http://localhost:8080/docs``` 


- Para encerrar a aplicação:
  ```
  Ctrl+C
  ```

  - Para encerrar o banco de dados:
  ```
  docker-compose down
  ```
   
  - Para rodar os testes:
  ```
  pytest -v
  ```


 


