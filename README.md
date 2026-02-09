# Real Weather API for SAMP/open.mp

**Sincronização Meteorológica em Tempo Real via HG Brasil**

Este projeto permite que servidores de SAMP (San Andreas Multiplayer) e open.mp sincronizem o clima e a hora do jogo com as condições climáticas reais do **Estado de São Paulo**. Atualmente, este sistema é uma tecnologia ativa na **Nacional Player SP**.

---

## Como Funciona?

O sistema utiliza uma arquitetura de ponte (bridge):

1. **Node.js API:** Atua como intermediário, consultando a API da [HG Brasil](https://hgbrasil.com/), processando o JSON e mapeando as condições climáticas para os IDs nativos do GTA San Andreas.
2. **SAMP Server (Pawn):** Realiza requisições HTTP para a nossa API Node.js e aplica as mudanças de clima e tempo mundial de forma sincronizada para todos os jogadores.

## Funcionalidades

* **Sincronização Automática:** Atualiza o clima em intervalos definidos (ex: a cada 10 minutos).
* **Mapeamento Inteligente:** Converte condições como "Ensolarado", "Tempestade" ou "Neblina" para IDs visuais otimizados do SAMP.
* **Otimização para Mobile:** O sistema converte automaticamente climas pesados (Chuva/Tempestade) para Nublado, garantindo performance e evitando lag em dispositivos móveis.
* **Trava de Admin:** Comando para bloquear a sincronização caso seja necessário realizar eventos com clima fixo.

## Instalação

### 1. Requisitos

* Node.js instalado.
* Plugin `a_http` ou `requests` no seu servidor SAMP.
* Uma chave de API da [HG Brasil Weather](https://hgbrasil.com/status/weather).

### 2. Configuração da API (Node.js)

Instale as dependências:

```bash
npm install express axios

```

Configure sua chave no arquivo principal:

```javascript
const API_KEY = 'SUA_CHAVE_AQUI';
const CITY = 'Sao%20Paulo,SP';

```

## Mapeamento de Climas

Para manter a fidelidade visual sem prejudicar a jogabilidade, utilizamos o seguinte mapeamento:

| Condição Real | ID SAMP | Ajuste Mobile (Otimizado) |
| --- | --- | --- |
| Ensolarado | 10 | 10 |
| Nublado | 7 | 7 |
| Chuva / Tempestade | 8 / 16 | **7 (Nublado)** |
| Neblina | 9 | 9 |
| Noite Limpa | 11 | 11 |

---

## 📄 Créditos & Desenvolvimento

* **Integração:** Joseph Dyer - Nacional Player SP
* **Fonte de Dados:** HG Brasil Weather API.
* **Plataforma:** SAMP / open.mp.

---

> **Nota:** Este sistema foi desenvolvido com foco em realismo e imersão para a comunidade de Roleplay, mantendo a performance como prioridade máxima.
