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
<img src="/home/clara/Downloads/diagramaknn" width="350"/>
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
|     |  |
|       |  |
| | |
|   | |
|     | |
|     |  |

