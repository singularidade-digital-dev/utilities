# pgModeler 1.2.1 — Build from Source

Script de instalação do [pgModeler](https://pgmodeler.io/) compilado a partir do código-fonte para **Linux Mint 22.1 Xia** (base Ubuntu 24.04 Noble).

## Por que compilar?

- A versão dos repositórios do Ubuntu/Mint (1.1.0-beta1) é **incompatível com PostgreSQL 16+**
- A versão compilada (1.2.1) suporta até **PostgreSQL 18**
- O binário oficial custa ~$387 USD

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
4. Compila com `qmake6` + `make`
5. Instala em `/usr/local/bin/`

## Binários instalados

| Binário | Descrição |
|---------|-----------|
| `pgmodeler` | Interface gráfica |
| `pgmodeler-cli` | Interface de linha de comando |
| `pgmodeler-ch` | Crash handler |
| `pgmodeler-se` | Schema editor |

## Uso com PostgreSQL (Docker)

```bash
# Reverse engineering via CLI (exemplo)
pgmodeler-cli --import-db \
  --input-db integras \
  --host localhost --port 5432 \
  --user integras --passwd integras \
  --ignore-errors \
  --filter-objects "table:config.*:wildcard" \
  --only-matching --force-children all \
  --output modelo.dbm
```

Ou abra o `pgmodeler` (GUI) e use **File > Import** para reverse engineering interativo.

## Licença

- **Este script**: MIT (veja LICENSE na raiz do repositório)
- **pgModeler**: [GPLv3](https://github.com/pgmodeler/pgmodeler/blob/main/LICENSE) — o código-fonte é livre, mas binários redistribuídos devem seguir a GPLv3
