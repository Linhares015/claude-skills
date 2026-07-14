# claude-skills

Skills pessoais para Claude Code.

## Skills disponíveis

### `user-skills:codex-mode`
Workflow onde Claude planeja e Codex executa. Define responsabilidades, estrutura de plano, protocolos de bloqueio, formato de entrega e ciclo de revisão.

## Instalação em uma nova máquina

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
