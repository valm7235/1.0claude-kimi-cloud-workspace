# Deploiement sur Hugging Face Spaces

## Etape par etape

1. **Creer un compte Hugging Face** (gratuit) sur https://huggingface.co/join
2. **Creer un Space**
   - Aller sur https://huggingface.co/new-space
   - Nom recommande : `1.0claude-kimi-hf-space`
   - Choisir le SDK **Docker**
   - Choisir l'instance **CPU Basic** (gratuite)
3. **Pousser les fichiers**
   ```bash
   git init
   git remote add space https://huggingface.co/spaces/USER/1.0claude-kimi-hf-space
   git add .
   git commit -m "Initial commit"
   git push space main
   ```
4. **Configurer les variables d'environnement**
   - Dans l'onglet **Settings** > **Variables and Secrets**
   - Ajouter :
     - `ANTHROPIC_AUTH_TOKEN` = votre cle Moonshot
     - `ANTHROPIC_BASE_URL` = `https://api.moonshot.ai/anthropic`
     - `ANTHROPIC_MODEL` = `kimi-k2.6`
     - `GITHUB_REPO_URL` = `https://github.com/USER/1.0claude-kimi-cloud-workspace.git`
     - `GITHUB_TOKEN` = votre token GitHub
5. **Verifier le build**
   - Attendre que le build Docker se termine (onglet **Logs**)
6. **Ouvrir l'URL**
   - `https://vmu7235-1-0claude-kimi-hf-space.hf.space`
   - Verifier que l'interface s'affiche
   - Verifier que `/health` repond

## Verification post-deploy

- Ouvrir `https://vmu7235-1-0claude-kimi-hf-space.hf.space`
- Verifier que CloudCLI UI s'ouvre (page HTML avec chat)
- Verifier que Kimi est utilise (voir `/health` ou les logs)
- Verifier que Claude Code repond via l'interface (envoyer un message de test)

## Limites du gratuit

- **Ce n'est PAS un Windows cloud exact** : c'est un conteneur Linux.
- **Le Space peut dormir** apres inactivite (keepalive obligatoire).
- **CPU Basic** = performances limitees.
- **Pas de domaine custom gratuit** officiellement chez Hugging Face.

## URL HTTPS finale

```
URLHTTPSUI_FINAL = https://vmu7235-1-0claude-kimi-hf-space.hf.space
```
