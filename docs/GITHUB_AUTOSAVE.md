# Autosave GitHub

## Principe

Le repo GitHub est **separe** du repo Hugging Face.

- **HFSPACEREPO** (`1.0claude-kimi-hf-space`) : contient le code du Space Docker.
- **GITHUBWORKSPACEREPO** (`1.0claude-kimi-cloud-workspace`) : contient les fichiers de travail, les autosaves et le README complet.

## Configuration

- `GITHUB_REPO_URL` : URL du repo GitHub workspace
- `GITHUB_TOKEN` : token d'acces avec droits `repo`

## Fonctionnement

Le script `scripts/autosave.sh` :
- Boucle toutes les **60 secondes**
- Va dans `/workspace`
- Verifie `git status --porcelain`
- Si changements :
  - `git add -A`
  - `git commit -m "autosave: YYYY-MM-DD HH:MM:SS UTC"`
  - `git push`
- Si rien a commit : ne fait rien
- En cas d'erreur : loggue et continue

## Pourquoi 60 secondes ?

- **Pas chaque seconde** : eviter de saturer l'API GitHub et de creer des milliers de commits.
- **Pas trop lent** : garantir une sauvegarde reguliere du travail.
- 60 secondes = compromis raisonnable entre securite et ressources.

## Comment verifier les commits autosave

```bash
git log --oneline --all
```

Ou consulter l'onglet **Commits** sur GitHub.

## Comment eviter la confusion entre repos

- Ne jamais pousser le workspace dans le repo Hugging Face.
- Ne jamais autosave dans le repo Hugging Face.
- Le repo Hugging Face ne contient que le code de l'application.
- Le repo GitHub contient les donnees et le README complet du projet.

## README complet

Le `README.md` complet du projet (avec documentation, URLs, etc.) doit etre present sur le repo GitHub workspace. Le script `start.sh` le copie automatiquement depuis `/app` si absent.
