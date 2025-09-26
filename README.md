# 📝 Relatório Técnico - Coprocessador em FPGA

## 📑 Sumário
- 🎯 [Introdução](#introdução)
- 🎯 [Objetivos e Requisitos do Problema](#objetivos-e-requisitos-do-problema)
- 🛠️ [Recursos Utilizados](#recursos-utilizados)

- 🚀 [Desenvolvimento e Descrição em Alto Nível](#desenvolvimento-e-descrição-em-alto-nível)
- 🎛️ [Unidade de Controle](#unidade-de-controle)
- 🧮 [ULA (Unidade Lógica e Aritmética)](#unidade-lógica-aritmética)
- 🧪 [Testes, Simulações, Resultados e Discussões](#testes-simulações-resultados-e-discussões)

---

## Introdução

A evolução das tecnologias de processamento de imagem tem impulsionado avanços significativos em sistemas de vigilância e exibição em tempo real, demandando soluções eficientes para manipulação e redimensionamento de imagens. Neste contexto, a implementação de algoritmos de interpolação visual em hardware dedicado, como FPGAs (Field-Programmable Gate Arrays), destaca-se pela capacidade de oferecer alto desempenho e baixa latência, características essenciais para aplicações críticas.

O presente projeto insere-se no âmbito do desenvolvimento de um módulo embarcado para redimensionamento de imagens, especificamente projetado para operar como um coprocessador gráfico autossuficiente na plataforma DE1-SoC. Utilizando a linguagem Verilog para síntese na FPGA, o sistema é capaz de executar algoritmos de ampliação (zoom in) e redução (zoom out) por meio de técnicas como **Vizinho Mais Próximo** (Nearest Neighbor Interpolation), **Replicação de Pixel** (Pixel Replication), **Decimação** (Nearest Neighbor for Zoom Out) e **Média de Blocos** (Block Averaging), atendendo aos requisitos de processamento em tempo real.

Além da implementação em hardware, o projeto visa permitir futuras expansões do sistema. O controle é realizado por meio de chaves e botões físicos da placa, e a saída processada é exibida via interface VGA, proporcionando uma solução completa e integrada.

Este relatório detalha o processo de desenvolvimento, desde a concepção arquitetural até a validação prática, abordando aspectos como mapeamento de memória, interação hardware-software e otimizações para eficiência computacional. Através de uma documentação robusta e código devidamente comentado, busca-se não apenas cumprir os objetivos técnicos, mas também fornecer um referencial para projetos futuros na área de sistemas digitais reconfiguráveis.


## 📋 Requisitos do Projeto
1. O código deve ser escrito em linguagem Verilog;
2. O sistema só poderá utilizar os componentes disponíveis na placa;
3. Realizar Zoom In e Zoom Out em passos de 2X,através dos algoritmos:
1. [Nearest Neighbor Interpolation](#nearest-neighbor-interpolation)
3. [Replicação de Pixel](#pixel-replication)
4. [Decimação/Amostragem](#amostragem)
6. [Média de blocos](#block-averaging)
4. As imagens são representadas em escala de cinza e cada elemento da imagem
(pixel) deverá ser representado por um número inteiro de 8 bits.
5. Devem ser utilizados chaves e/ou botões para determinar a ampliação e redução da imagem;
6. O coprocessador deve ser compatível com o processador ARM (Hard Processor
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

- Periféricos Utilizados:
- Acesso à Chip Memory:
O design utiliza diretamente a memória embarcada na FPGA para armazenamento temporário de dados e matrizes, eliminando a necessidade de interfaces externas para memória DDR3.

- Referência oficial:
[**Manual da Placa**](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=836&PartNo=4)

### 🔧 Recurso

#### 🔌 VGA module
Módulo responsável pela comunicação entre o monitor e a memória (no caso, On Chip memory),utilizado para exibir as imagens processadas ou não através do conector VGA.

As saídas next_x e next_y do módulo VGA definem o endereço de leitura para a memória e acessa as informações de cor dos pixels.

Controlar uma tela VGA requer a manipulação de dois pinos de sincronização digital e três pinos analógicos coloridos (VERMELHO, VERDE e AZUL). Um dos pinos de sincronização, HSYNC, informa à tela quando mover para uma nova linha de pixels. O outro pino de sincronização, VSYNC, informa à tela quando iniciar um novo quadro. O protocolo é descrito abaixo, tanto textualmente quanto visualmente.


- Referência oficial:
[**Verilog VGA module**](https://vanhunteradams.com/DE1/VGA_Driver/Driver.html)



## 🤖 Algoritmos
### Nearest Neighbor Interpolation
A interpolação por vizinho mais próximo é um dos métodos mais simples para ampliação de imagem. Ele mapeia o valor de cada pixel ampliado para o valor do pixel mais próximo da posição original. Esse método resulta em uma ampliação com bordas visíveis e com um efeito pixelado. É eficiente em termos de tempo de execução e ideal para sistemas embarcados, como o FPGA, onde o desempenho em tempo real é crucial.
### Block Averaging
A média de blocos é um algoritmo utilizado para reduzir a resolução de uma imagem. Nesse processo, grupos de pixels adjacentes são combinados, tirando-se a média de seus valores para criar um único pixel representando o bloco. Esse processo é especialmente útil para zoom out, pois suaviza a imagem resultante, eliminando a "dureza" associada a outras técnicas de redução. Ele é particularmente útil quando se deseja preservar a suavidade visual ao reduzir a resolução de uma imagem.

### Pixel Replication
Na replicação de pixel, o algoritmo simplesmente copia o valor de um pixel para preencher múltiplos pixels vizinhos na nova imagem ampliada. Por exemplo, ao aumentar a imagem em 2x, cada pixel é duplicado para preencher quatro novas posições. Embora esse método não produza uma imagem suavizada, ele é rápido e eficiente, o que o torna útil para sistemas com restrições de tempo de processamento.



### 🚀 Desenvolvimento e Descrição em Alto Nível
O projeto foi desenvolvido com foco em garantir **fluxo contínuo de pixels** e **uso eficiente dos recursos lógicos da FPGA**.
👉 A imagem de entrada padrão possui resolução **160×120 pixels**, enquanto a interface VGA trabalha em **640×480 pixels**, permitindo validar o processo de redimensionamento em hardware.

---

## 🗺️ Diagramação do Sistema
Como estamos lidando com um sistema que envolve múltiplos recursos da placa, foi necessário realizar uma **diagramação e modularização inicial**, com o objetivo de orientar o desenvolvimento do projeto de forma gradual e organizada.

1. O desenvolvimento iniciou-se com a importação e adaptação do módulo de exibição VGA (`vga_module`).
- Responsável por gerar os sinais de sincronização **HSYNC** e **VSYNC**, além das coordenadas `(next_x, next_y)`.
- Essa etapa permitiu validar visualmente os endereços e a sincronização antes de integrar o processamento.

2. Em seguida, foi trabalhada a **memória on-chip**, incluindo a RAM (`imagem_mod`) e as ROMs em formato `.mif` (`imagem` e `imagem_test`).
- **RAM**: framebuffer de 8 bits para pixels processados.
- **ROMs**: imagens original de 160×120.

3. Implementação e teste dos algoritmos de redimensionamento com fator de 2x ou 4x:
- **Nearest Neighbor**
- **Replicação de Pixel**
- **Média de Blocos**
- **Decimação**

Cada um foi validado via `pixel_out_valid`, garantindo integridade antes de armazenar os dados.
- O algoritmo/estado do coprocessador é controlado pelas chaves `SW[8:2]` (seleção do algoritmo e fator de escala).

4. Após a validação, os pixels processados foram gravados na RAM.
- Escrita única por pixel.
- Leitura contínua pelo VGA.

Essa abordagem incremental e modular garantiu confiabilidade e sincronismo no fluxo de pixels.

## 🏜️ Modularização e Fluxo de Pixels
O sistema segue arquitetura modular, em que cada módulo executa uma função específica.
O fluxo de pixels percorre desde a **ROM**, passa pelo **processamento**, é armazenado em **RAM** e finalmente exibido no **VGA**.

### 📦 1. Módulos de Memória ROM
- **Função**: Armazenar imagens originais em formato `.mif`.
- **Módulos**:
- `imagem` → resolução **160×120**.
- `imagem_test` → resolução **320×240**.
- **Saída**: pixel de 8 bits endereçado por `(x, y)` do VGA.

### 🎛️ 2. Unidade de Controle (`main.v`)
- Divide o clock (`clk_50 → clk_25`).
- Gera sinais de reset e controla estados de processamento.
- Conta os pixels processados e impede reescrita contínua na RAM.
- Encaminha ao coprocessador o **estado/algoritmo ativo**, definido pelas chaves `SW[3:0]`.

### ⚙️ 3. Coprocessador
- **Função**: Redimensionar a imagem original 160×120.
- **Algoritmos** (selecionados via `SW[3:0]`):
- `0001` → Nearest Neighbor
- `0010` → Replicação de Pixel
- `0100` → Média de Blocos
- `1000` → Decimação
- **Processo**:
- Aplica o algoritmo selecionado.
- Usa `pixel_out_valid` para handshake e sincronismo.
- **Saída**: pixel redimensionado pronto para escrita na RAM.

### 📂 4. Memória RAM (`imagem_mod`)
- **Função**: Armazenar a imagem processada.
- **Escrita**: ocorre uma única vez, controlada pelo `pixel_count`.
- **Leitura**: contínua, sincronizada com `(next_x, next_y)` do VGA.

### 🖥️ 5. Interface VGA (`vga_module`)
- **Função**: Exibir a imagem no monitor.
- **Entradas**: pixel vindo diretamente da ROM, do processador ou da RAM.
- **Saída**: sinais digitais **RGB (8 bits cada)**, **HSYNC**, **VSYNC**, **BLANK**, **SYNC**, **CLK**.
- **Extra**: gera as coordenadas de varredura para endereçar ROM e RAM.


###  6. Phase-Locked Loop, (`pll`)
- **Função**: circuito eletrônico que multiplica e ajusta fase da frequncia
- **Entradas**: Sinal de clock de referência
- **Saída**:Sinais de clock de saída com frequências e fases controladas.


---

### 🔄 Sequência do Fluxo de Dados
1. **ROM** fornece os pixels originais (160×120 ou 320×240).
2. **Coprocessador** aplica o algoritmo selecionado via `SW[3:0]`.
3. **RAM** armazena a imagem processada em 320×240.
4. **Unidade de Controle** organiza o fluxo de escrita/leitura.
5. **VGA** renderiza a imagem em 640×480.

![](https://github.com/JuliaSantanaS2/processamento_de_imagem_FPGA/blob/main/fluxodedados.png?raw=true)

****


## 📦 Memória On-Chip e Integração com o Coprocessador

A memória on-chip da FPGA DE1-SoC é responsável por armazenar a **imagem processada** antes de sua exibição via VGA.
No projeto, foi utilizada uma **RAM de 8 bits**, suficiente para guardar pixels em escala de cinza (0–255), operando como **framebuffer** intermediário entre os algoritmos e o VGA.

Diferente de arquiteturas que utilizam memória para instruções, aqui a memória é **dedicada exclusivamente ao armazenamento de dados de imagem**, garantindo que cada pixel processado seja escrito **uma única vez** e lido de forma contínua pelo VGA.

---

### ⚙️ Parâmetros da RAM (`imagem_mod`)

- **address [18:0]** → Endereço de leitura/escrita.
- Durante o processamento: recebe `pixel_count` sequencial para percorrer toda a imagem.
- Durante a exibição VGA: recebe `rom_address_M`, gerado pelas coordenadas `(next_x, next_y)`.
- Seleção escrita/leitura feita via sinal `processing_done` do coprocessador.

- **clock (clk_25)** → Sinal derivado de `clk_50`.
- Sincroniza escrita de pixels processados e leitura contínua pelo VGA.

- **data [7:0]** → Pixel de entrada no barramento de 8 bits, vindo do coprocessador (`pixel_out`).

- **wren** → Habilita escrita na RAM.
- Ativado enquanto `pixel_out_valid = 1` e até que todos os pixels sejam gravados (`pixel_count == IMG_SIZE - 1`).
- Após o término do processamento (`processing_done = 1`), `wren` é desativado permanentemente.

- **q [7:0]** → Pixel de saída lido pelo VGA durante a varredura da tela.

- **pixel_in_ready** → Sinal do coprocessador indicando que ele está pronto para receber novos pixels.
- Garante **handshake** entre o módulo de entrada e o coprocessador, evitando perda de dados.

---

### 🔄 Ciclo de uso da RAM

1. **Escrita**
- O pixel processado é armazenado em `ram_address_write`.
- Cada módulo de processamento (`replicacao_pixel`, `media_de_blocos`, `vizinho_proximo_in`, `vizinho_proximo_out`) gera `pixel_out` e `pixel_out_valid`, selecionados pelo **mux do coprocessador** de acordo com `SW[3:0]`.
- Processo continua até que todos os pixels da imagem (**320×240**) sejam gravados, acionando `processing_done`.

2. **Leitura**
- Após o término da escrita, os pixels são acessados em tempo real pelo VGA via `ram_address_read`.
- Permite exibir a imagem final de forma estável e contínua no monitor.

---

### 📥 Fluxo de Pixels e Handshake

- Cada algoritmo possui sinais próprios de **ready/valid**:
- `out_algoritmo_valid_*` → indica pixel válido.
- `ready_algoritmo_*` → indica que o algoritmo está pronto para receber/entregar o próximo pixel.
- O **coprocessador** faz o mux das saídas com base em `SW[3:0]`, selecionando:
- 0000 → passthrough da ROM (`pixel_in`).
- 0001 → replicação de pixel
- 0010 → nearest neighbor (zoom in)
- 0100 → nearest neighbor (zoom out)
- 1000 → média de blocos

- **pixel_in_ready** do coprocessador é o ready do algoritmo selecionado, garantindo **handshake correto** e evitando overflow.

---

### 🔎 Leitura das ROMs

- A leitura de pixels da ROM é feita pelo **VGA controller (`vga_module`)**, que gera `(next_x, next_y)`.
- Endereços das ROMs calculados como `(next_y * IMG_WIDTH + next_x)`.
- Pixels podem ser enviados diretamente para o VGA ou para o coprocessador, garantindo **sincronismo completo**.

---

📌 Em resumo:
- A RAM funciona como **framebuffer da imagem processada**, não armazena instruções.
- O coprocessador controla a escrita usando **pixel_out_valid**, **processing_done** e **pixel_in_ready**.
- A seleção de algoritmo via `SW[5:2]` permite alternar dinamicamente entre diferentes métodos de redimensionamento.


## 🏗️ Arquitetura Geral

### 🔧 Módulo Principal (`main.v`)
- Instancia os módulos de leitura, processamento, memória e VGA,funcionando como uma unidade de controle.
- Divide o clock (**50 MHz → 25 MHz**) e gera sinais de reset.
- Multiplica o clock para **100MHz**
- Registra estado do processo através do reset automático e manual (SW[9])
    + Zera contadores
    + Máquinas de estado voltam para o estado IDLE (ocioso).
    + Limpa flags
- Controla endereços de leitura e escrita da RAM.
- Encaminha para o coprocessador o **estado/algoritmo ativo** de acordo com as chaves (`SW[5:2]`).
- Permite selecionar dinamicamente entre imagem original, imagem processada ou alternativa.

---

### ⚙️ Submódulos Especializados
| Módulo | Operação | Descrição |
|------------------------|-----------------|---------------------------------------------------------------------------|
| `imagem` | ROM 160×120 | Armazena a imagem original em baixa resolução |
| `imagem_test` | ROM 320×240 | Alternativa de imagem em resolução maior |
| `replicacao_pixel` | Processamento | Realiza **replicação de pixels** (zoom in / redimensionamento) |
| `media_pixel` | Processamento | Calcula **média de blocos** para suavizar e redimensionar a imagem |
| `vizinho_proximo_in` | Processamento | Implementa **Nearest Neighbor (zoom in)** |
| `vizinho_proximo_out` | Processamento | Implementa **Nearest Neighbor (zoom out / decimação)** |
| `imagem_mod` | RAM | Framebuffer de 8 bits. Guarda a imagem processada para leitura posterior |
| `vga_module` | Exibição | Gera sinais **RGB, HSYNC, VSYNC**, além das coordenadas `(next_x,next_y)` |

---

## 🔍 Detecção de Overflow (Handshake Overflow)
Foi implementado um **mecanismo de handshake** para evitar perda de dados entre módulos.
O problema de **overflow** ocorre quando a taxa de produção de pixels é maior que a de consumo.

- **Buffer cheio** → ativa sinal de `stall` na FSM.
- **Latência do VGA** → controlada via protocolo **ready/valid**.
- **Solução** → pixels só avançam quando o próximo módulo está pronto, garantindo integridade da imagem.

---

## 🎛️ Seleção de Algoritmos
As chaves da placa determinam qual **algoritmo/estado** o coprocessador executa:

| SW[5:2] | Algoritmo / Estado |
|---------|-----------------------------|
| `0001` | Nearest Neighbor (Zoom In) |
| `0010` | Replicação de Pixel |
| `0100` | Média de Blocos |
| `1000` | Nearest Neighbor (Zoom Out) |
| Outros | Exibição direta da ROM/RAM |

---

## 🧪 Testes e Simulações

- **Simulação (Icarus Verilog/ModelSim)**: validação isolada de cada módulo utilizando amostras reduzidas de pixels em escala de cinza (ex.: 8×8 ou 16×16) para observar o comportamento interno dos algoritmos.
- **Integração (Quartus Prime II)**: verificação do fluxo completo, da ROM até a VGA, com monitoramento dos sinais de handshake e endereços de RAM.
- **Implementação (DE1-SoC)**: execução prática com imagens em `.mif` de 160×120 redimensionadas para 640×480, permitindo validar visualmente o resultado.


### 🔎 Observação de Waveforms

Durante a simulação, foram geradas waveforms para cada algoritmo aplicado:

| Algoritmo | Objetivo | Observações nas Waveforms |
|----------------------------|-----------------------------------------------|----------------------------------------------------|
| **Nearest Neighbor (Zoom In)** | Ampliação da imagem | Pixels replicados seguindo o valor do vizinho mais próximo, mantendo bordas visíveis. |
| **Pixel Replication** | Ampliação simples | Cada pixel duplicado em blocos 2×2 (ou conforme fator), rápido e sem suavização. |
| **Block Averaging** | Redução de resolução | Pixels de blocos são combinados via média, suavizando a imagem final. |
| **Decimação / Nearest Neighbor (Zoom Out)** | Redução da imagem | Seleção de pixels estratégicos, mantendo proporção, mas perdendo detalhes finos. |

> 💡 Para observação clara em waveform, utilizamos amostras de pixels pequenas em escala de cinza. Isso permite visualizar cada ciclo de clock, sinais `pixel_in_valid`, `pixel_out_valid`, `wren` e os endereços da RAM (`ram_address_write`) sem precisar renderizar toda a imagem.

### 🖼️ Exemplos de Waveforms
<p align="center">
<img src="images/waveform_nearest_neighbor.png" width="500"/>
<img src="images/waveform_pixel_replication.png" width="500"/>
<img src="images/waveform_block_averaging.png" width="500"/>
<img src="images/waveform_decimation.png" width="500"/>
</p>

> As imagens acima ilustram como os sinais internos mudam a cada ciclo de clock, mostrando escrita em RAM e processamento de pixels.

---

## 📈 Análise dos Resultados
- Processamento em tempo real sem perda de pixels.
- Imagens originais de 160×120 foram ampliadas para 640×480 e vice versa via coprocessador, observando no VGA:
- Ampliação correta sem distorções.
- Diferentes modos selecionáveis via `SW[3:0]` (imagem original, processada, RAM, alternativa 320×240).
- Latência mínima, sem perda de pixels, confirmando a eficácia do handshake workflow.
- Handshake overflow garantiu sincronização estável sem sobrescrita de pixels ou vazementos.

---

## 📉 Desempenho e Uso de Recursos
- Uso eficiente de recursos lógicos da FPGA.
- Pipeline otimizado para throughput contínuo.
- Buffer garantiu equilíbrio entre produção e consumo.

---

## 💭 Discussões e Melhorias Futuras
- Adição de novos algoritmos de interpolação para zoom in.
- Suporte a diferentes resoluções além da matriz fixa.
- Expansão para imagens RGB de 24 bits.

## 🏁 Conclusão

O projeto demonstrou a capacidade de processar e redimensionar imagens em **tempo real** utilizando um coprocessador gráfico em FPGA, com:

- Controle eficiente de memória RAM on-chip como framebuffer.
- Sincronização precisa via handshake workflow, evitando overflow.
- Modularidade que permite fácil inclusão de novos algoritmos.
- Validação completa via simulação e implementação prática em DE1-SoC.

O trabalho abre caminho para futuras expansões, como suporte a imagens RGB, diferentes resoluções e algoritmos mais sofisticados de interpolação.
	
## ✍️ Colaboradores

Este projeto foi desenvolvido por:

- [**Julia Santana**](https://github.com/)
- [**Maria Clara**](https://github.com/)
- [**Vitor Dórea**](https://github.com/)

Agradecimentos ao(a) professor(a) [**Angelo Duarte**] pela orientação.
