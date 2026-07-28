# claude-skills

Skills pessoais para Claude Code e Codex.

## Skills disponíveis

### `user-skills:codex-mode`

Workflow onde Claude planeja e Codex executa. Define responsabilidades, estrutura de plano, protocolos de bloqueio, formato de entrega e ciclo de revisão.

### `orquestrar-desenvolvimento-eficiente`

Política para coordenar desenvolvimento com uso eficiente de modelos: mantém planejamento, arquitetura e integração no agente principal; delega tarefas claras a subagentes econômicos; e exige validação antes da entrega.

## Instalação em uma nova máquina

### Claude Code

Adicione ao `~/.claude/settings.json`:

```json
"extraKnownMarketplaces": {
  "claude-skills": {
    "source": {
      "source": "github",
      "repo": "Linhares015/claude-skills"
    }
  }
}
```

Depois instale o plugin via Claude Code: `/plugins install user-skills@claude-skills`

### Codex

Em outro computador, instale a skill do repositório com o `skill-installer`:

```bash
python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo Linhares015/claude-skills \
  --path codex-skills/orquestrar-desenvolvimento-eficiente
```

O instalador usa como destino padrão `$CODEX_HOME/skills/orquestrar-desenvolvimento-eficiente` (normalmente `~/.codex/skills/orquestrar-desenvolvimento-eficiente`). Para cópia manual, use esse mesmo destino. A skill ficará disponível no próximo turno do Codex.

Os arquivos de skills locais não são sincronizados automaticamente pela conta: copie, versione ou reinstale a skill em cada computador em que quiser usá-la.
