---
name: orquestrar-desenvolvimento-eficiente
description: Orquestre tarefas de desenvolvimento com uso eficiente de modelos e subagentes. Use ao planejar, delegar ou integrar trabalho de implementação, revisão, depuração e validação em projetos de software.
---

# Orquestrar desenvolvimento eficiente

## Roteamento

- Use o modelo mais capaz no agente principal para planejamento, arquitetura, decisões ambíguas, integração e revisão crítica.
- Use modelos econômicos em subagentes para tarefas claras, delimitadas e de baixo risco, como inventário, buscas, alterações mecânicas e testes.
- Não fixe nomes de modelos: escolha conforme as opções disponíveis na plataforma.
- Escalone uma subtarefa para um modelo mais capaz após duas falhas, diante de novo risco ou quando surgir ambiguidade relevante.
- Informe o usuário se a plataforma não permitir selecionar o modelo por agente.

## Delegação e conclusão

- Paralelize somente tarefas independentes, com escopos sem sobreposição de arquivos ou decisões.
- Mantenha no agente principal a coordenação, as decisões de arquitetura, a integração e a verificação final.
- Sempre execute verificações proporcionais ao risco e reporte seus resultados antes de declarar a entrega concluída.
