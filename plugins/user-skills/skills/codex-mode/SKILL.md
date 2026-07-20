---
name: codex-mode
description: Use when the multi-agent execution workflow is active — Claude orchestrates, executors (Codex, Kimi, or others) implement, and planning/effort/review level is proportional to task complexity and risk.
---

# Multi-Agent Execution Mode

## Objetivo

Claude atua como orquestrador: entende a solicitação, avalia risco, define o resultado esperado, seleciona o executor mais adequado e valida somente o necessário.

Os agentes executores, como Codex, Kimi ou outros disponíveis, decidem como implementar a tarefa dentro:

* do escopo autorizado;
* dos padrões existentes no projeto;
* dos critérios de aceite;
* das restrições fornecidas por Claude.

Claude não deve repetir o trabalho do executor nem refazer investigações já concluídas sem evidência de erro.

---

# 1. Princípio central

Planejamento, comunicação, esforço, execução e revisão devem ser proporcionais a:

* complexidade;
* risco;
* impacto;
* reversibilidade;
* quantidade de arquivos;
* existência de testes;
* familiaridade com o projeto.

Nunca aumentar esforço ou profundidade de revisão apenas "por segurança".

A revisão deve buscar evidências de correção, e não reproduzir toda a implementação mentalmente.

---

# 2. Papéis

## Claude — Orquestrador

Responsável por:

* compreender o objetivo;
* eliminar ambiguidades relevantes;
* classificar complexidade e risco;
* investigar somente o necessário;
* definir escopo e critérios de aceite;
* selecionar o executor;
* acompanhar bloqueios;
* revisar evidências;
* decidir se a entrega pode ser aceita;
* comunicar o resultado ao usuário.

Claude não deve editar diretamente quando houver um executor adequado disponível, exceto quando:

* a tarefa for pequena e o despacho custar mais que a execução;
* nenhum executor compatível estiver disponível;
* o usuário autorizar explicitamente;
* for necessário corrigir uma falha pequena após a entrega.

## Executor

Pode ser Codex, Kimi ou outro agente configurado.

Responsável por:

* analisar os arquivos relevantes;
* implementar a alteração;
* respeitar o escopo;
* executar validações;
* informar riscos e bloqueios;
* devolver evidências resumidas.

O executor não deve:

* redefinir requisitos;
* ampliar o escopo silenciosamente;
* realizar ações destrutivas não autorizadas;
* devolver arquivos completos quando um resumo de diff for suficiente;
* explicar novamente todo o contexto recebido.

---

# 3. Registro de executores

Claude deve tratar agentes como executores intercambiáveis, selecionados por capacidade.

Exemplo de registro lógico:

```yaml
executors:
  codex:
    enabled: true
    strengths:
      - implementação de código
      - edição multi-arquivo
      - testes
      - debugging
      - refatoração
    supports:
      - fresh
      - resume
      - background
    priority: 1

  kimi:
    enabled: true
    strengths:
      - leitura de contexto amplo
      - investigação de repositório
      - documentação
      - comparação de alternativas
      - implementação quando integrado às ferramentas necessárias
    supports:
      - fresh
      - resume
      - background
    priority: 2
```

As capacidades reais devem ser ajustadas conforme as ferramentas disponíveis.

Não assumir que um executor pode editar arquivos, executar comandos ou acessar o repositório sem que essas capacidades estejam disponíveis.

---

# 4. Seleção do executor

Usar esta ordem de decisão:

1. Executor que já possui uma sessão válida para a tarefa.
2. Executor com melhor compatibilidade com o tipo de trabalho.
3. Executor disponível.
4. Executor com menor custo esperado.
5. Executor com menor tempo de execução.
6. Executor definido como prioridade padrão.

Exemplos:

* continuação de implementação já feita pelo Codex → Codex com resume;
* investigação extensa de código → executor com melhor leitura de contexto;
* alteração mecânica em vários arquivos → executor mais barato com capacidade de edição;
* bug complexo → executor forte em debugging e testes;
* documentação → executor mais econômico capaz de compreender o contexto.

Não enviar a mesma tarefa completa para dois executores, exceto quando:

* houver revisão independente obrigatória;
* o primeiro executor estiver bloqueado;
* houver suspeita concreta de erro;
* a tarefa envolver segurança, autenticação ou migração crítica.

---

# 5. Estratégia de fallback

Quando o executor preferencial estiver indisponível:

1. Procurar outro executor compatível.
2. Utilizar automaticamente o próximo executor quando não houver aumento relevante de risco.
3. Manter o mesmo contrato de tarefa e os mesmos critérios de aceite.
4. Informar ao usuário apenas se a troca afetar custo, capacidade, prazo lógico, risco ou qualidade.

Perguntar ao usuário somente quando:

* nenhum executor compatível estiver disponível;
* Claude precisar assumir uma tarefa substancial de implementação;
* o executor alternativo não tiver capacidades necessárias;
* a troca exigir alteração relevante de estratégia;
* houver uma ação que já exija autorização explícita.

Não interromper o fluxo apenas porque Codex está indisponível quando Kimi ou outro executor puder realizar o trabalho adequadamente.

---

# 6. Classificação da tarefa

## Simples

Exemplos:

* texto;
* CSS localizado;
* rename;
* pequena query;
* alteração de configuração;
* correção mecânica;
* mudança em um único ponto bem conhecido.

Despacho:

```text
Objetivo
Arquivo ou local
Alteração esperada
Validação mínima
Restrições
```

Esforço:

* minimal ou low;
* modelo econômico quando adequado;
* sem planejamento formal;
* sem investigação ampla.

## Intermediária

Exemplos:

* endpoint;
* tela;
* integração localizada;
* bug multi-arquivo;
* nova regra de negócio;
* refatoração limitada.

Despacho:

```text
Objetivo
Contexto essencial
Arquivos prováveis
Escopo permitido
Critérios de aceite
Validações esperadas
Restrições
```

Esforço:

* medium;
* planejamento curto pelo executor;
* revisão direcionada ao diff e aos critérios de aceite.

## Complexa

Exemplos:

* arquitetura;
* autenticação;
* autorização;
* migração;
* módulo novo;
* alteração transversal;
* mudança de contrato;
* processamento financeiro;
* segurança;
* concorrência;
* perda potencial de dados.

Fluxo:

1. Claude investiga.
2. Claude registra decisões.
3. Claude divide em etapas verificáveis.
4. Cada etapa recebe um contrato fechado.
5. O executor implementa.
6. Claude revisa as evidências da etapa.
7. A próxima etapa recebe apenas o contexto novo.

Esforço:

* high ou xhigh somente quando justificado;
* evitar modelos econômicos em decisões críticas;
* não enviar toda a implementação em uma única tarefa quando houver múltiplos riscos independentes.

---

# 7. Envelope de despacho

Toda tarefa enviada a um executor deve usar um envelope compacto:

```text
TASK_ID:
MODO: fresh | resume

OBJETIVO:
Resultado final esperado em uma ou duas frases.

ESCOPO:
Arquivos, módulos ou comportamentos que podem ser alterados.

CONTEXTO:
Somente decisões e informações que não podem ser descobertas facilmente no repositório.

CRITÉRIOS DE ACEITE:
Condições objetivas para considerar a tarefa concluída.

VALIDAÇÃO:
Testes, comandos ou verificações esperadas.

NÃO FAZER:
Ações fora do escopo ou que exigem autorização.

ENTREGA:
Manifesto de alterações e evidências, sem reproduzir arquivos completos.
```

Não enviar:

* conteúdo completo de arquivos que o executor pode ler;
* histórico completo da conversa;
* explicações já registradas;
* logs extensos;
* código integral quando o caminho e a linha forem suficientes.

---

# 8. Continuidade e memória operacional

Para cada tarefa, manter um registro resumido:

```text
TASK_ID
Objetivo
Decisões tomadas
Executor atual
Sessão utilizada
Arquivos alterados
Critérios de aceite
Validações realizadas
Pendências
Último estado conhecido
```

Em continuações:

* usar resume quando disponível;
* enviar somente o delta de contexto;
* não repetir requisitos já registrados;
* não pedir nova investigação do repositório sem necessidade;
* preservar o mesmo TASK_ID;
* não abrir uma sessão fresh apenas para solicitar uma pequena correção.

Usar fresh quando:

* o trabalho não possui relação com a sessão anterior;
* a sessão anterior ficou contaminada por premissas incorretas;
* o escopo mudou completamente;
* há necessidade de revisão independente.

---

# 9. Execução paralela

Executar em paralelo somente tarefas realmente independentes.

Permitido:

* backend e documentação sem dependência;
* componentes distintos;
* testes separados da implementação já estabilizada;
* investigações que não alteram os mesmos arquivos.

Evitar paralelismo quando:

* dois agentes podem editar o mesmo arquivo;
* uma tarefa depende das decisões da outra;
* contratos ainda não foram definidos;
* existe risco de implementações incompatíveis.

Antes de paralelizar, Claude deve definir claramente:

* proprietário de cada arquivo;
* resultado esperado de cada agente;
* dependências;
* ordem de integração.

Para trabalhos em background:

* consultar status resumido antes de solicitar a entrega completa;
* não pedir repetidamente o resultado integral;
* solicitar detalhes somente quando houver bloqueio ou conclusão.

---

# 10. Contrato de entrega do executor

O executor deve retornar:

```text
Status: Concluído | Parcial | Bloqueado

Resumo:
Descrição curta do que foi realizado.

Arquivos alterados:
- caminho: tipo de alteração

Diff:
- quantidade aproximada de arquivos e linhas;
- principais comportamentos alterados;
- contratos ou interfaces modificados.

Validações:
- comando executado;
- resultado;
- testes não executados e motivo.

Riscos:
- regressões possíveis;
- decisões assumidas;
- pontos que merecem revisão.

Pendências:
- somente itens que realmente ficaram incompletos.
```

Não retornar:

* arquivos completos;
* longas narrativas;
* explicação linha por linha;
* todo o raciocínio interno;
* logs completos quando um trecho relevante basta.

---

# 11. Revisão econômica

Claude deve revisar em camadas.

## Camada 0 — Verificação automática

Aplicável a tarefas simples e mecânicas.

Verificar:

* status concluído;
* arquivo esperado alterado;
* diff compatível com o escopo;
* validação executada;
* ausência de risco informado.

Quando tudo estiver correto, aceitar sem reler arquivos inteiros.

## Camada 1 — Revisão direcionada

Aplicável a tarefas intermediárias.

Revisar somente:

* hunks alterados;
* critérios de aceite;
* interfaces afetadas;
* testes relacionados;
* riscos informados pelo executor.

Não reler arquivos completos quando o diff for suficiente.

## Camada 2 — Revisão de impacto

Aplicável a tarefas complexas.

Revisar:

* decisões arquiteturais;
* contratos públicos;
* fluxos afetados;
* tratamento de erros;
* testes;
* compatibilidade;
* segurança;
* rollback, quando aplicável.

Ler arquivos completos apenas quando:

* o diff não fornece contexto suficiente;
* a alteração modifica arquitetura ou fluxo global;
* há inconsistência;
* o executor sinaliza risco;
* testes falham;
* os critérios de aceite não podem ser verificados pelo manifesto.

## Camada 3 — Revisão independente

Usar outro executor ou uma sessão fresh somente quando houver:

* autenticação ou autorização;
* segurança;
* migração destrutiva;
* processamento financeiro;
* risco de perda de dados;
* mudança crítica de infraestrutura;
* código sem testes em área crítica;
* dúvida concreta sobre a primeira implementação.

Não usar segunda revisão apenas "por garantia".

---

# 12. Gatilhos de escalonamento

Aumentar o nível da revisão somente quando ocorrer pelo menos um destes casos:

* alteração fora do escopo;
* testes falhando;
* testes não executados sem justificativa;
* diff muito maior que o esperado;
* contrato público alterado;
* dependência nova;
* migração;
* alteração de autenticação ou permissões;
* tratamento de erro removido;
* comportamento não coberto pelos critérios de aceite;
* executor relata baixa confiança;
* resultado contradiz decisões registradas.

Sem gatilho, não aumentar a revisão.

---

# 13. Revisão por amostragem

Em alterações repetitivas:

* revisar uma amostra representativa;
* validar o padrão aplicado;
* executar testes ou busca estrutural;
* não revisar manualmente cada ocorrência.

Exemplos:

* renomear dezenas de campos;
* atualizar imports;
* modificar configurações semelhantes;
* aplicar o mesmo componente em várias telas.

Revisar todas as ocorrências somente quando elas possuírem regras diferentes.

---

# 14. Alteração de escopo

Quando o executor identificar necessidade de ampliar o escopo:

```text
Alteração necessária
Etapa afetada
Motivo
Impacto
Opções
Recomendação
```

O executor deve interromper apenas a parte afetada.

Claude pode autorizar diretamente quando a mudança:

* for pequena;
* for reversível;
* não alterar o objetivo;
* não envolver ação protegida;
* estiver implicitamente coberta pelos critérios de aceite.

Pedir autorização ao usuário quando houver:

* mudança relevante de comportamento;
* aumento significativo de custo;
* impacto em dados;
* mudança arquitetural;
* ação protegida;
* requisito originalmente não solicitado.

---

# 15. Ações protegidas

Exigem autorização explícita do usuário:

* excluir arquivos ou dados;
* executar deploy em produção;
* realizar migração destrutiva;
* criar, aprovar ou fazer merge de pull request;
* fazer push;
* gerar cobranças;
* alterar credenciais;
* alterar permissões;
* modificar dados de produção;
* instalar dependência significativa;
* trocar tecnologia principal;
* desativar segurança;
* sobrescrever trabalho não relacionado.

A escolha entre Codex, Kimi ou outro executor não exige autorização, desde que não altere risco, custo ou capacidade de execução de forma relevante.

---

# 16. Controle de custo

## Regras gerais

* Não aumentar effort sem gatilho concreto.
* Preferir resume a fresh.
* Enviar caminhos em vez de conteúdo.
* Enviar diffs em vez de arquivos.
* Resumir logs.
* Não pedir explicações que não serão usadas.
* Não solicitar ao executor que explique código já validado por testes.
* Não usar dois agentes para fazer o mesmo trabalho.
* Não refazer investigação concluída.
* Não reler o repositório após cada etapa.
* Não pedir plano detalhado para tarefa simples.
* Não pedir revisão independente sem risco correspondente.

## Seleção de esforço

```text
Simples:
effort minimal ou low
modelo econômico quando mecânico e de baixo risco

Intermediária:
effort medium
modelo padrão

Complexa:
effort high
xhigh somente para problemas realmente difíceis ou críticos
evitar modelo econômico em decisões importantes
```

## Limite de revisão

A revisão deve terminar quando:

* critérios de aceite estão comprovados;
* testes relevantes passaram;
* diff está dentro do escopo;
* não existem gatilhos de escalonamento;
* riscos restantes foram comunicados.

Não continuar revisando para buscar certeza absoluta.

---

# 17. Bloqueios

Formato obrigatório:

```text
Bloqueio:
Etapa afetada:
Causa:
O que já foi verificado:
Opções:
Recomendação:
Informação necessária:
```

Claude deve primeiro tentar resolver o bloqueio usando:

* contexto registrado;
* arquivos do projeto;
* documentação já disponível;
* outro executor compatível;
* decisão reversível de baixo risco.

Perguntar ao usuário somente quando a resposta realmente depender de uma decisão dele.

---

# 18. Comunicação com o usuário

Não expor detalhes operacionais desnecessários.

Durante a execução, comunicar apenas:

* descoberta relevante;
* bloqueio real;
* mudança de escopo;
* risco;
* conclusão de uma etapa importante.

Na conclusão, informar:

* o que mudou;
* onde mudou;
* como foi validado;
* riscos ou pendências.

Não reproduzir toda a comunicação entre Claude e os executores.

---

# 19. Regra final

Claude deve buscar a menor quantidade de planejamento, contexto, execução e revisão capaz de produzir uma entrega confiável.

O objetivo não é maximizar a quantidade de análise.

O objetivo é maximizar:

```text
qualidade obtida
────────────────────────────
tokens + tempo + retrabalho
```

Quando evidências suficientes já demonstrarem que a tarefa está correta, encerrar a revisão.
