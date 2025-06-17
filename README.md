# 🔧 WiseTour - Shell Scripts ☁️

Sistema de **automação da infraestrutura AWS** para deploy e gerenciamento do ambiente de análise estratégica do setor de turismo internacional no Brasil.

---

## 📋 Visão Geral

O módulo Shell Scripts do WiseTour é responsável por automatizar a criação, configuração e gerenciamento da infraestrutura AWS necessária para o funcionamento completo do sistema de análise de dados turísticos.

### 🎯 Objetivo
Automatizar o provisionamento e gerenciamento da infraestrutura AWS, incluindo:
- **Containers Docker** para aplicações Java e Node.js
- **Banco de dados MySQL** em ambiente containerizado
- **Configuração de ambiente** para desenvolvimento e produção
- **Scripts de inicialização** e deploy automatizado

---

## ⚙️ Funcionamento dos Scripts

### 1. **Configuração de Container Java**
- Setup automatizado do ambiente Java
- Configuração do Docker para aplicações ETL
- Arquivos: `java/`

### 2. **Configuração de Container MySQL**
- Provisionamento de banco de dados MySQL
- Configuração de volumes e persistência
- Arquivos: `mysql/`

### 3. **Configuração de Aplicação Node.js**
- Setup do ambiente Node.js para frontend/backend
- Configuração de dependências e build
- Arquivos: `node-app/`

### 4. **Scripts de Inicialização**
- Automação completa do ambiente
- Deploy coordenado de todos os serviços
- Arquivos: `init_setup.sh`, `iniciar_docker_compose.sh`

---

## 🗂️ Estrutura do Projeto

```
shell-scripts/
 ├── java/                      -> Scripts para container Java
 ├── mysql/                     -> Scripts para container MySQL
 ├── node-app/                  -> Scripts para aplicação Node.js
 ├── docker-compose.yml         -> Orquestração de containers
 ├── iniciar_docker_compose.sh  -> Script de inicialização
 ├── init_setup.sh              -> Setup inicial do ambiente
 ├── .gitignore                 -> Arquivos ignorados pelo Git
 └── README.md                  -> Documentação
```

---

## 🐳 Containerização

### ✅ Serviços Provisionados

**Container Java:**
- Ambiente otimizado para processamento ETL
- Apache POI para leitura de Excel
- Conectividade com AWS S3 e MySQL

**Container MySQL:**
- Base de dados estruturada para turismo
- Volumes persistentes configurados
- Otimizações para consultas analíticas

**Container Node.js:**
- Frontend da aplicação WiseTour
- API backend para consumo de dados
- Build automatizado e otimizado

---

## 🔧 Tecnologias Utilizadas

| Tecnologia | Finalidade |
|------------|------------|
| **Docker** | Containerização de aplicações |
| **Docker Compose** | Orquestração de serviços |
| **Shell Script** | Automação da infraestrutura |
| **AWS CLI** | Integração com serviços AWS |
| **MySQL** | Banco de dados containerizado |
| **Java Runtime** | Ambiente para processamento ETL |
| **Node.js** | Runtime para aplicação web |

---

## 🌐 Contexto no Projeto WiseTour

Os Shell Scripts fazem parte do **ecossistema WiseTour**, sistema de análise de dados turísticos composto por:

### 📦 Módulos do Projeto

| Módulo | Descrição | Repositório |
|--------|-----------|-------------|
| **WiseTour Web** | Frontend + Backend da aplicação | [wise-tour](https://github.com/WiseTour/wise-tour) |
| **ETL** | Processamento de dados | [etl](https://github.com/WiseTour/etl) |
| **Database** | Modelagem e scripts do banco | [database](https://github.com/WiseTour/database) |
| **Shell Scripts** | Automação da infraestrutura AWS (este módulo) | [shell-scripts](https://github.com/WiseTour/shell-scripts) |

### 🎯 Público-Alvo
**Desenvolvedores e DevOps** que precisam de:
- Deploy automatizado da solução completa
- Ambiente de desenvolvimento padronizado
- Infraestrutura como código
- Configuração simplificada de serviços

---

## 📈 Fluxo de Deploy

```
Scripts → Docker Containers → AWS Infrastructure → WiseTour Running
```

1. **Scripts** configuram o ambiente
2. **Containers** são provisionados via Docker Compose
3. **Infraestrutura** AWS é configurada automaticamente
4. **Aplicação** WiseTour fica disponível
5. **Dados** fluem pelo pipeline ETL → Database → Frontend

---

## 🚀 Comandos Úteis

```bash
# Iniciar todos os serviços
./iniciar_docker_compose.sh

# Parar todos os serviços
docker-compose down

# Verificar status dos containers
docker-compose ps

# Logs de um serviço específico
docker-compose logs [service-name]

# Rebuild completo
docker-compose up --build
```

---

## 💡 Motivação

Projeto desenvolvido após **visita técnica à Agaxtur Viagens** com o executivo **Ricardo Braga**, identificando necessidades reais do setor:

- ❌ **Complexidade de deploy** manual
- ❌ **Ambiente inconsistente** entre desenvolvedores
- ❌ **Falta de automação** na infraestrutura

- ✅ **Solução:** Infraestrutura como código com **deploy automatizado**

---

## 📄 Licença

Projeto acadêmico desenvolvido para o **Projeto Integrador da SPTECH School**.
Todos os direitos reservados aos autores e à instituição.

> **WiseTour Shell Scripts — Automatizando a infraestrutura para insights estratégicos do turismo.**
