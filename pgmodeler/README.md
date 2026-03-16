# pgModeler 1.2.1 — Build from Source

Script de instalação do [pgModeler](https://pgmodeler.io/) compilado a partir do código-fonte para **Linux Mint 22.1 Xia** (base Ubuntu 24.04 Noble), com patch de compatibilidade para **PostgreSQL 18**.

## Por que compilar?

| | Versão apt (Ubuntu/Mint) | Build from source |
|---|---|---|
| **Versão** | 1.1.0-beta1 | 1.2.1 |
| **PostgreSQL** | Até PG 15 | Até PG 18 (com patch) |
| **Custo** | Grátis | Grátis |
| **Binário oficial** | — | ~$387 USD |

## Instalação

```bash
chmod +x install.sh
./install.sh
```

## O que o script faz

1. Instala dependências de build (Qt6, libpq, libxml2, etc.)
2. Remove a versão antiga do apt (se existir)
3. Clona o pgModeler v1.2.1 do GitHub
4. Aplica o patch de compatibilidade com PostgreSQL 18
5. Compila com `qmake6` + `make`
6. Instala em `/usr/local/bin/`

## Patch PostgreSQL 18

O pgModeler 1.2.1 suporta oficialmente até o PG 17. Quando conecta ao PG 18, o version parser retorna `10.0` (MinimumVersion) como fallback, causando uso de catalog queries obsoletas (`pg_proc.proisagg`, removido no PG 11).

O patch — embutido no `install.sh` — adiciona `PgSqlVersion180` à lista de versões suportadas e atualiza a `DefaultVersion` de `17.0` para `18.0`. Arquivos alterados:

- `libs/libutils/src/pgsqlversions.h` — declara `PgSqlVersion180`
- `libs/libutils/src/pgsqlversions.cpp` — define `"18.0"`, atualiza `DefaulVersion` e `AllVersions`

## Uso

```bash
# GUI
pgmodeler

# CLI — reverse engineering de um schema
pgmodeler-cli --import-db \
  --input-db integras \
  --host localhost --port 5432 \
  --user integras --passwd integras \
  --ignore-errors \
  --filter-objects "table:config.*:wildcard" \
  --only-matching --force-children all \
  --output modelo.dbm
```

## Licença

- **Este script**: MIT (veja [LICENSE](../LICENSE))
- **pgModeler**: [GPLv3](https://github.com/pgmodeler/pgmodeler/blob/main/LICENSE)
