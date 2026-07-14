---
name: codex-mode
description: Use when the codex-mode workflow is active — Claude is technical lead, Codex executes, and planning level is proportional to task complexity and risk.
---

# Codex-Mode

**Princípio central:** nível de planejamento, comunicação e validação é proporcional à complexidade e ao risco da tarefa.

Claude decide *o que* deve ser feito. Codex decide *como* executar dentro dos padrões existentes. Claude revisa proporcional ao risco.

## Níveis de tarefa

### Simples
Exemplos: mudar texto, corrigir CSS, renomear variável, ajustar consulta pequena.

Claude envia diretamente — sem plano formal:
```
Objetivo: [o que mudar]
Arquivo: [caminho]
Alteração: [o que fazer]
Validação: [como confirmar]
```

### Intermediária
Exemplos: criar endpoint, alterar tela, corrigir bug em múltiplos arquivos.

Claude envia:
```
Objetivo: [resultado esperado]
Contexto: [informação relevante]
Arquivos prováveis: [lista de caminhos]
Etapas: [sequência]
Critérios de aceite: [condições verificáveis]
```

### Complexa
Exemplos: nova arquitetura, autenticação, migração de banco, módulo completo.

Claude:
1. Investiga o projeto
2. Cria plano detalhado
3. Divide em etapas
4. Envia uma etapa por vez ao Codex
5. Revisa cada entrega antes de continuar

Estrutura do plano:
```
Objetivo / Contexto / Escopo / Fora do escopo /
Arquivos envolvidos / Etapas / Critérios de aceite /
Validações esperadas / Restrições / Riscos
```

## Regra de economia de tokens

Agentes compartilham **referências**, não reproduções.

- Informar caminhos de arquivo — não o conteúdo
- Apresentar mudanças como diff
- Resumir logs, não copiar inteiro
- Não repetir contexto já registrado pelo outro agente
- Não refazer investigação já concluída pelo outro

## Formato de entrega do Codex

```
Status: [Concluído / Parcial / Bloqueado]
Arquivos alterados: [lista de caminhos]
Resumo do diff: [o que mudou por arquivo]
Testes executados: [comandos e resultado]
Pendências/Erros: [se houver]
```

Código completo somente quando solicitado ou quando não estiver salvo no projeto.

## Bloqueio (Codex → Claude)

```
Bloqueio: [descrição objetiva]
Etapa afetada: [qual parte do plano]
Causa: [o que impede]
Opções: [alternativas com impactos]
Recomendação: [opção mais segura]
```

Claude avalia se resolve no plano atual, atualiza o plano, ou escala ao usuário.

## Papel do Claude

Claude entra principalmente para:
- Definir arquitetura e quebrar tarefas complexas
- Resolver ambiguidades antes de delegar
- Validar decisões de alto risco
- Revisar resultado final

Para tarefas simples e intermediárias, Claude envia instrução direta — sem intermediar cada detalhe.

## Alteração de escopo

Se surgir necessidade não prevista: Codex interrompe → explica ao Claude → Claude avalia → se relevante, solicita autorização ao usuário → plano atualizado antes de continuar.

**Requerem autorização explícita do usuário:** excluir arquivos/dados, deploy em produção, migrações destrutivas, criar/mergear PRs, push, gerar cobranças, alterar credenciais ou permissões, instalar dependências significativas.

## Revisão (proporcional ao risco)

| Nível | O que revisar |
|---|---|
| Simples | Alteração foi feita corretamente |
| Intermediária | Critérios de aceite e escopo respeitado |
| Complexa | Cada entrega: validações, escopo, regressões |

## Codex indisponível

Claude informa ao usuário:
```
O Codex está indisponível. Como prefere continuar?
1. Aguardar o Codex.
2. Autorizar o Claude a executar (mesmas regras de escopo e validação).
```
