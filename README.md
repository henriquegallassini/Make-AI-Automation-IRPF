# Automação de IRPF com Make, Supabase e Inteligência Artificial

Projeto de automação para processamento de declarações de Imposto de Renda Pessoa Física (IRPF), organização documental, identificação de pendências e envio automático de solicitações por e-mail.

A solução é composta por **duas automações tecnicamente independentes**, mas integradas por meio de um banco **PostgreSQL hospedado no Supabase**, formando um fluxo contínuo entre processamento documental, controle de pendências e comunicação com clientes.

> **Aviso:** este repositório contém versões demonstrativas e sanitizadas das automações. Nenhuma credencial, chave de API, token, dado pessoal real ou documento de cliente está incluído.

---

## Visão geral

O projeto automatiza parte do processo operacional relacionado à coleta, conferência e cobrança de documentos para declaração de IRPF.

A solução foi dividida em dois cenários principais:

- **Automação 1 — Processamento de declarações e geração de pendências**
  - recebe documentos via Google Drive;
  - utiliza IA para extrair dados relevantes da declaração;
  - registra pessoas, exercícios, uploads e documentos no Supabase;
  - identifica documentos ausentes e registra pendências.

- **Automação 2 — Cobrança automática de documentos pendentes**
  - consulta os documentos pendentes no Supabase;
  - agrupa as pendências por cliente;
  - utiliza IA para redigir mensagens personalizadas;
  - envia cobranças automáticas por e-mail.

---

## Cenários no Make

### 1) Processamento de declarações e geração de pendências

<p align="center">
  <img
    src="images/1-fluxo_processamento_irpf.jpeg"
    alt="Fluxo de processamento de declarações de IRPF"
    width="100%"
  >
</p>

### 2) Cobrança automática de documentos pendentes

<p align="center">
  <img
    src="images/2-fluxo_cobranca_pendencias.jpeg"
    alt="Fluxo de cobrança de documentos pendentes"
    width="100%"
  >
</p>

---

## Arquitetura da solução

```mermaid
flowchart LR
    A[Google Drive] --> B[Make - Processamento da declaração]
    B --> C[Gemini AI]
    C --> D[Supabase PostgreSQL]

    D --> E[Pessoas]
    D --> F[Exercícios]
    D --> G[Documentos]
    D --> H[Pendências]
    D --> I[Uploads]

    H --> J[View de documentos pendentes]
    J --> K[Make - Cobrança automática]
    K --> L[OpenAI]
    L --> M[Gmail]
    M --> N[Cliente]