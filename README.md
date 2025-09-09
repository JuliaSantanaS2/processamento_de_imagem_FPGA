# 📝 Relatório Técnico - Coprocessador  em FPGA

## 📑 Sumário

- 🎯 [Objetivos e Requisitos do Problema](#objetivos-e-requisitos-do-problema)
- 🛠️ [Recursos Utilizados](#recursos-utilizados)
  - 🔧 [Quartus Prime](#quartus-prime)
  - 💻 [FPGA DE1-SoC](#fpga-de1-soc)
- 🚀 [Desenvolvimento e Descrição em Alto Nível](#desenvolvimento-e-descrição-em-alto-nível)
  - 🎛️ [Unidade de Controle](#unidade-de-controle)
  - 🧮 [ULA (Unidade Lógica e Aritmética)](#unidade-lógica-aritmética)
- 🧪 [Testes, Simulações, Resultados e Discussões](#testes-simulações-resultados-e-discussões)

---

## 🌟 Introdução



## 🎯 Objetivos e Requisitos do Problema



### 📋 Requisitos do Projeto
1. O código deve ser escrito em linguagem Verilog;
2. O sistema só poderá utilizar os componentes disponíveis na placa;
3. Implementação dos seguintes algoritmos para o redimensionamento
das imagens, ambos em passos de 2X:
  3.1. Aproximação (Zoom in)
  3.1.1. Vizinho Mais Próximo (Nearest Neighbor Interpolation);
  3.1.2. Replicação de Pixel (Pixel Replication / Block Replication)
  3.2. Redução (Zoom out)
  3.2.1. Decimação / Amostragem (Nearest Neighbor for Zoom Out)
  3.2.2. Média de Blocos (Block Averaging / Downsampling with Averaging)
1. As imagens são representadas em escala de cinza e cada elemento da imagem
(pixel) deverá ser representado por um número inteiro de 8 bits.
4.5. Devem ser utilizados chaves e/ou botões para determinar a ampliação e
redução da imagem;
4.6. O coprocessador deve ser compatível com o processador ARM (Hard Processor
System - HPS) para viabilizar o desenvolvimento das próximas etapas.


## 🛠️ Recursos Utilizados

### 🔧 Ferramentas 

#### 💻 Quartus Prime

- Síntese e Compilação:

O Quartus Prime é utilizado para compilar o projeto em Verilog, convertendo a descrição HDL em uma implementação física adequada para a FPGA. Durante esse processo, o compilador realiza a síntese lógica, o mapeamento e o ajuste de layout (place and route), otimizando as rotas lógicas e a alocação dos recursos internos da FPGA, conforme as recomendações descritas no User Guide: Compiler.

- Referência oficial: 
[**Quartus Prime Guide**](https://www.intel.com/content/www/us/en/support/programmable/support-resources/design-software/user-guides.html)

#### 💻 FPGA DE1-SoC

- Especificações Técnicas:

A placa DE1-SoC, baseada no FPGA Cyclone V SoC (modelo 5CSEMA5F31C6N), conta com aproximadamente 85K elementos lógicos (LEs), 4.450 Kbits de memória embarcada e 6 blocos DSP de 18x18 bits. Essas características permitem a implementação de designs complexos e o processamento paralelo de dados.

-   Periféricos Utilizados:
    
        
    -   Acesso à Chip Memory:
        O design utiliza diretamente a memória embarcada na FPGA para armazenamento temporário de dados e matrizes, eliminando a necessidade de interfaces externas para memória DDR3.
        

- Referência oficial:
[**Manual da Placa**](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=836&PartNo=4)

### Materiais

#### VGA module

- Referência oficial:
[**Verilog VGA module**](https://vanhunteradams.com/DE1/VGA_Driver/Driver.html)






## 🚀 Desenvolvimento e Descrição em Alto Nível

## 🎛️ Unidade de Controle

matrizes.

### 📜 Instruction Set Architecture



📋 Conjunto de instruções do coprocessador:

### 🔢 Instruções aritméticas e seus Códigos Hexadecimais


### 📥 Instruções de movimentação de dados e seus Códigos Hexadecimais


### 🔄 Etapas de processamento



---

#### ⚙️ Execute



---

#### Processamento 



###  Banco de Registradores


#### 🖼️ Diagrama Funcional



#### 📌 Tipos de Registradores


## Memória

A memória desempenha um papel crucial em co-processadores, pois é nela que as instruções e dados necessários para o processamento são acessados. No projeto desenvolvido, utilizamos a **OnChip Memory** da FPGA DE1-SoC. Essa memória funciona como uma memória RAM simples e possui parâmetros configuráveis, permitindo um controle mais eficiente durante o processamento.

Neste projeto, a memória foi projetada de forma enxuta, com o único objetivo de permitir o armazenamento e recebimento de instruções e os resultados após a finalização dos processos aritméticos.

#### Parâmetros de entrada e saída da memória:

- **clk**: Sinal de clock utilizado para sincronizar a memória com o restante do sistema.
- **wren**: Sinal de controle que permite a escrita na memória.
- **Mem_data**: Canal de 16 bits utilizado para a escrita de dados na memória (barramento de 16 bits).
- **q**: Canal de saída de dados da memória, também com barramento de 16 bits, responsável por retornar os dados armazenados.
- **address**: Entrada de dados que especifica o endereço de memória a ser acessado, permitindo a leitura ou escrita no local desejado.

#### Diagrama da memória
---
<p align="center">
<img src="images/RamMem.png" width="350"/>
</p>
---

## Leitura de Dados da Memória

A leitura dos dados da memória é realizada diretamente na unidade de controle. A lógica foi projetada para lidar com as matrizes de tamanho fixo 5x5, como mencionado anteriormente, e garantir a eficiência ao acessar os dados sequenciais da memória.



### Processo de Leitura:

1. **Início do processo de leitura:**
   - Quando `loadingMatrix` é zero, isso significa que ainda não começamos a carregar a matriz. Portanto e o contador de carregamento (`load_counter`) é zerado.
   - O sinal `read_pending` é ativado para aguardar a leitura dos dados.
   - Se a matriz que estamos carregando for a matriz A (`Flag_A == 0`), o vetor `matrix1` é zerado; caso contrário, a matriz B (`matrix2`) é zerada.

2. **Carregamento dos dados:**
   - O código verifica se a matriz ainda não foi completamente carregada. Se não foi, ele usa o contador de carregamento para calcular a linha e a coluna do elemento a ser lido e mapeado na posição correta da memória.
   - A matriz é preenchida utilizando índices virtuais, `virt_idx1` e `virt_idx2`, que são calculados com base no contador `load_counter`. Esses índices indicam a posição na matriz de 5x5. Isso é feito para armazenar e trabalhar com matrizes menores no formato 5x5 de forma correta.
   - O código também cuida de separar os dados de 16 bits, onde 8 bits são lidos de cada vez. Se for a matriz A (`Flag_A == 0`), os dados são colocados em `matrix1`; caso contrário, em `matrix2`.

3. **Controle de ciclos:**
   - A cada ciclo, o contador de leitura (`load_counter`) é incrementado em 2, já que estamos lendo dois números (16 bits) por vez. O endereço de memória é atualizado para acessar a próxima posição, e a variável `read_pending` é ativada novamente.

4. **Finalizando o carregamento:**
   - Quando todos os dados da matriz foram lidos, o sinal `load_done` é ativado, indicando que o carregamento da matriz foi concluído.

## Escrita de Dados na Memória

A escrita dos dados segue uma lógica semelhante à da leitura, mas com o objetivo de gravar os resultados após o processamento das matrizes. Dessa forma, a escrita das matrizes resultantes são feitas da seguinte forma:


### Código de Escrita:


### Processo de Escrita:

1. **Controle de Escrita:**
   - A escrita dos dados é iniciada ao ativar o sinal de controle  `WB`.
   - O vetor `write_data` é preenchido com os dados do resultado, onde o valor de `result` é dividido em duas partes. A primeira parte (8 bits) vai para `write_data[15:8]`, e a segunda parte vai para `write_data[7:0]`.

2. **Cálculo do Endereço de Memória:**
   - O endereço de memória é calculado com base no endereço base, somando o offset de cada par de elementos (dois elementos por palavra na memória).

3. **Controle de Ciclos de Escrita:**
   - Um contador (`write_counter`) é usado para controlar o número de ciclos de escrita. A cada ciclo, ele é incrementado até atingir o limite de 3, e então o contador é resetado.
   - O contador `store_counter` é utilizado para indicar o elemento atual a ser armazenado.

4. **Finalizando a Escrita:**
   - Quando todos os 25 elementos da matriz 5x5 (representados por `store_counter` até o valor 24) forem gravados na memória, o sinal `WB` é desativado, indicando que a escrita foi concluída, e o sinal `write_done` é ativado, finalizando o processo.

A implementação das operações de leitura e escrita foram projetadas para otimizar a interação com a memória, garantindo uma sincronização eficiente com o processo de manipulação das matrizes. As decisões de projeto adotadas, como o controle de ciclos e o uso de buffers de 5x5, permitem que os dados sejam acessados e armazenados de forma eficaz, minimizando desperdício de ciclos e garantindo a integridade dos resultados ao final do processamento.


### 🏗️ Arquitetura

#### Módulo Principal (`alu.v`)

- Controla todas as operações
- Seleciona sub-módulos baseado no opcode
- Gerencia sinais de clock, done e overflow

#### Sub-módulos Especializados

| Módulo                      | Operação | Descrição                     |
| --------------------------- | -------- | ----------------------------- |
| `alu_sum_module`            | A + B    | Soma elemento a elemento      |
| `alu_subtraction_module`    | A - B    | Subtração elemento a elemento |
| `alu_multiplication_module` | A × B    | Multiplicação matricial       |
| `alu_opposite_module`       | -A       | Matriz oposta                 |
| `alu_transpose_module`      | Aᵀ       | Matriz transposta             |
| `alu_scalar_module`         | k·A      | Multiplicação por escalar     |
| `alu_determinant_module`    | det(A)   | Cálculo de determinante       |

### 📊 Operações Suportadas



## 🔍 Detecção de Overflow

- Soma/Subtração: Verifica mudança inesperada no bit de sinal

- Multiplicação: Checa se bits superiores diferem do bit de sinal

- Determinante: Verifica se resultado excede 8 bits

## ⚙️ Como Executar



#### 📥 Como a ULA recebe os dados e sinais de controle

Após a UC [(Unidade de Controle)](#unidade-de-controle) obter as matrizes e o opcode da operação, ela realiza a tratativa e o empacotamento dos dados. Em seguida, envia para a ULA 25 bytes, cada um representando um elemento da matriz máxima suportada: uma matriz quadrada 5x5.

Essa padronização permite que a ULA opere diretamente sobre o conjunto de dados sem a necessidade de redefinir estruturas internas para diferentes dimensões de matriz.

#### 📤 Como os resultados são manipulados e retornados

A ULA opera sempre com matrizes de ordem 5x5, mesmo quando a matriz de entrada possui uma ordem inferior (como 2x2 ou 4x4). Para operações como soma, subtração, transposição, matriz oposta, produto por escalar e multiplicação de matrizes, o tamanho real da matriz não influencia no resultado, pois os elementos fora da região válida são preenchidos com zero.

Essa estratégia permite que todas as operações sejam realizadas por um único módulo, otimizando a lógica e facilitando o suporte a diferentes dimensões de matrizes de forma unificada.

Os valores são preenchidos corretamente nos espaços correspondentes da "fita de bytes", que posteriormente é retornada à UC (Unidade de Controle) para processamento ou exibição.

#### ⚠️ Atenção ao cálculo do determinante:

Para a operação de determinante, o tamanho da matriz impacta diretamente o resultado. Por isso, é utilizado o [Teorema de Laplace](https://pt.wikipedia.org/wiki/Teorema_de_Laplace), e há um módulo dedicado para cada tamanho de matriz, garantindo precisão no cálculo para matrizes de diferentes ordens.

## 🧪 Testes e Simulações

A metodologia de Testes usada para garantir o correto funcionamento da ULA foram conduzidos em duas etapas:

Simulação via Icarus Verilog, inicialmente, todos os módulos foram testados de forma isolada utilizando o simulador Icarus Verilog. Após a validação por simulação, o projeto foi sintetizado no ambiente Quartus Prime II e implementado na placa DE1-SoC, replicando o ambiente final de operação do co-processador.

## 📈 Análise dos Resultados


## 📉 Desempenho e Uso de Recursos


## 💭 Discussões e Melhorias Futuras

## ✍️ Colaboradores

Este projeto foi desenvolvido por:

- [**Julia Santana**](https://github.com/) 
- [**Maria Clara**](https://github.com/) 
- [**Vitor Dórea**](https://github.com/)
Agradecimentos ao(a) professor(a) [**Angelo Duarte**] pela orientação.

---








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
