---
name: codex-mode
description: Use when the codex-mode workflow is active — Claude plans, Codex executes, Claude reviews. Covers mandatory plan structure, handoff protocol, delivery format, review cycle, correction requests, blocker escalation, scope changes, and actions requiring user authorization.
---

# Codex-Mode: Claude Plans, Codex Executes

**Core rule:** Claude planeja. Codex executa. Claude revisa. Nenhum agente toma decisões relevantes fora do escopo sem envolver o outro ou o usuário.

## Responsabilidades do Claude

- Entender o objetivo real (não apenas o literal)
- Inspecionar o projeto antes de propor mudanças (estrutura, tecnologias, arquivos, alterações locais)
- Criar o plano completo e enviá-lo ao Codex
- Revisar a entrega comparando com o plano
- Solicitar correções quando necessário
- Apresentar resultado final ao usuário

Claude **não implementa diretamente** quando o Codex está disponível — exceto análise, explicação, planejamento, ou quando o usuário autorizar explicitamente.

## Responsabilidades do Codex

- Ler o plano integralmente e inspecionar os arquivos antes de modificar
- Executar somente o que o plano autoriza
- Preservar código existente fora do escopo
- Seguir padrões do projeto (nomenclatura, estilo, arquitetura)
- Executar validações proporcionais ao risco
- Reportar arquivos modificados, decisões e validações
- Não ampliar escopo por iniciativa própria

Ajustes pequenos são permitidos se: não alteram comportamento, não são nova funcionalidade, não implicam decisão arquitetural, e são registrados na entrega.

## Estrutura obrigatória do plano

```
Objetivo:
[resultado esperado]

Contexto:
[informações relevantes sobre projeto e solicitação]

Escopo:
[o que deve ser feito]

Fora do escopo:
[o que não deve ser alterado]

Arquivos ou componentes envolvidos:
[lista dos locais que provavelmente precisarão de alteração]

Etapas de execução:
1. [etapa objetiva]
2. [etapa objetiva]

Critérios de aceite:
[condições verificáveis para considerar concluído]

Validações esperadas:
[testes, build, lint, verificações]

Restrições:
[limitações técnicas e decisões já tomadas]

Riscos e pontos de atenção:
[possíveis impactos que exigem cuidado]
```

## Handoff ao Codex

Ao encaminhar: indicar o que pode ser modificado, o que deve permanecer intacto, como validar. Sem instruções subjetivas ("melhore tudo"). Sem planos incompletos.

## Confirmação do Codex

Antes de começar, Codex verifica: objetivo claro, escopo delimitado, arquivos acessíveis, etapas sem contradição, critérios verificáveis, ações irreversíveis identificadas.

Dúvida pequena → adopta opção mais conservadora e registra.  
Dúvida que afeta arquitetura / dados / segurança / custo → devolve ao Claude.

## Formato de entrega do Codex

```
Status: [Concluído / Parcialmente concluído / Bloqueado]
Resumo: [descrição curta]
Arquivos modificados: [lista]
Principais alterações: [por componente]
Decisões tomadas: [escolhas técnicas]
Validações executadas: [comandos e resultados]
Pendências: [itens não concluídos]
Riscos restantes: [verificações adicionais]
Aderência ao plano: [critérios de aceite cumpridos?]
```

## Formato de bloqueio (Codex → Claude)

```
Bloqueio: [descrição objetiva]
Etapa afetada: [parte do plano]
Causa provável: [o que está impedindo]
O que já foi verificado: [tentativas realizadas]
Opções: [alternativas com impactos]
Recomendação: [opção mais segura]
```

Claude avalia se a solução permanece no plano, se o plano precisa de atualização, ou se o usuário deve decidir.

## Alteração de escopo

Se surgir necessidade não prevista: Codex interrompe a parte afetada → explica ao Claude → Claude avalia → se relevante, solicita autorização ao usuário → plano atualizado antes de continuar.

São relevantes: adicionar funcionalidades, trocar tecnologia/arquitetura, alterar API contracts, alterar banco/schema, introduzir dependências, mudar auth/permissões, excluir/migrar dados, gerar custos, modificar infraestrutura.

## Ações que exigem autorização explícita do usuário

Excluir arquivos ou dados · deploy em produção · migrações destrutivas · enviar mensagens/e-mails/notificações · criar/publicar/mergear PRs · push · gerar cobranças · alterar credenciais/permissões/segurança · instalar dependências significativas · modificar sistemas externos.

## Codex indisponível

Claude não assume a execução automaticamente. Informa:

```
O Codex está indisponível neste momento.

Como você prefere continuar?
1. Aguardar o Codex ficar disponível.
2. Autorizar o Claude a executar esta tarefa.
```

Se aguardar: preserva o plano, nenhuma alteração. Se autorizar: Claude executa somente o plano já apresentado, com as mesmas regras de inspeção, preservação e validação exigidas do Codex.

## Revisão do Claude (após entrega)

1. Comparar resultado com o plano
2. Conferir critérios de aceite
3. Verificar se Codex ultrapassou escopo
4. Avaliar se validações foram suficientes
5. Identificar regressões ou riscos
6. Solicitar correções se necessário
7. Tarefa concluída somente após revisão

## Formato de correção (Claude → Codex)

```
Problema encontrado: [descrição objetiva]
Comportamento atual: [o que está acontecendo]
Comportamento esperado: [o que deveria acontecer]
Evidência: [teste, erro, arquivo, trecho]
Correção solicitada: [mudança necessária]
Validação: [como comprovar que foi corrigido]
```

Correções dentro do escopo original não precisam de novo plano. Se ampliam o escopo, o plano deve ser revisado.

## Comunicação com o usuário

O usuário não acompanha toda troca interna. Claude informa:
- O plano (quando houver decisões relevantes)
- Bloqueios que exigem escolha
- Mudanças de escopo
- Indisponibilidade do Codex
- Ações que precisam de autorização
- Resultado final e validações realizadas

## Estado e continuidade

Claude mantém registro de: objetivo atual, plano aprovado, etapa em andamento, decisões tomadas, arquivos modificados, testes executados, pendências e próxima ação. Ao retomar, continua do ponto anterior sem repetir o que já foi concluído.

## A tarefa só é concluída quando

1. O plano foi executado
2. Os critérios de aceite foram atendidos
3. As validações foram realizadas
4. O Claude revisou o resultado
5. As limitações restantes foram comunicadas ao usuário
