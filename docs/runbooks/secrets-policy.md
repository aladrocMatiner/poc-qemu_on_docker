# Secrets Policy

## Principles
- Do not commit secrets, credentials, or private keys.
- Use Swarm `secrets`/`configs` or external secret stores when needed.

## Prohibited in git
- Passwords, tokens, API keys
- Private keys (*.key)
- ISO images or driver binaries

## Handling
- Keep secrets out of `.env` when possible.
- Store sensitive data outside the repo and reference via paths.
