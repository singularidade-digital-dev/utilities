# pgModeler 1.2.1 — Build from Source

Script de instalação do [pgModeler](https://pgmodeler.io/) compilado a partir do código-fonte para **Linux Mint 22.1 Xia** (base Ubuntu 24.04 Noble).

## Por que compilar?

- A versão dos repositórios do Ubuntu/Mint (1.1.0-beta1) é **incompatível com PostgreSQL 16+**
- A versão compilada (1.2.1) suporta até **PostgreSQL 17** (e **PG 18 com o patch incluso**)
- O binário oficial custa ~$387 USD

## Patch para PostgreSQL 18

O pgModeler 1.2.1 não reconhece o PostgreSQL 18 nativamente. Quando conecta ao PG 18, o version parser retorna a versão mínima (10.0), causando uso de catalog queries obsoletas (`proisagg` removido no PG 11).

O patch em `patches/pg18-support.patch` adiciona `PgSqlVersion180` ao namespace de versões suportadas e atualiza a `DefaultVersion` para 18.0. O script `install.sh` aplica o patch automaticamente.

## Requisitos

- Linux Mint 22.1+ / Ubuntu 24.04+
- ~2 GB de espaço em disco (build temporário)
- Conexão com internet (para clonar e instalar dependências)

## Instalação

```bash
chmod +x install.sh
./install.sh
```

O script:
1. Instala as dependências de build (Qt6, libpq, libxml2, etc.)
2. Remove a versão antiga do apt (se existir)
3. Clona o pgModeler v1.2.1 do GitHub
4. Aplica o patch de compatibilidade com PostgreSQL 18
5. Compila com `qmake6` + `make`
6. Instala em `/usr/local/bin/`

## Binários instalados

| Binário | Descrição |
|---------|-----------|
| `pgmodeler` | Interface gráfica |
| `pgmodeler-cli` | Interface de linha de comando |
| `pgmodeler-ch` | Crash handler |
| `pgmodeler-se` | Schema editor |

## Uso com PostgreSQL (Docker)

```bash
# Reverse engineering — schema config (integras-digital)
pgmodeler-cli --import-db \
  --input-db integras \
  --host localhost --port 5432 \
  --user integras --passwd integras \
  --ignore-errors \
  --filter-objects "table:config.*:wildcard" \
  --only-matching --force-children all \
  --output integras-digital.dbm

# Reverse engineering — schema platform (integras-digital-plataform)
pgmodeler-cli --import-db \
  --input-db integras \
  --host localhost --port 5432 \
  --user integras --passwd integras \
  --ignore-errors \
  --filter-objects "table:platform.*:wildcard" \
  --only-matching --force-children all \
  --output integras-digital-plataform.dbm
```

Ou abra o `pgmodeler` (GUI) e use **File > Import** para reverse engineering interativo.

## Estrutura

```
pgmodeler/
├── install.sh                      # Script de build e instalação
├── patches/
│   └── pg18-support.patch          # Patch para suporte ao PostgreSQL 18
└── README.md                       # Esta documentação
```

## Licença

- **Este script e patch**: MIT (veja LICENSE na raiz do repositório)
- **pgModeler**: [GPLv3](https://github.com/pgmodeler/pgmodeler/blob/main/LICENSE) — o código-fonte é livre, mas binários redistribuídos devem seguir a GPLv3
