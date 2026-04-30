---
title: Claude Kimi Cloud
emoji: 💻
colorFrom: blue
colorTo: indigo
sdk: docker
app_port: 7860
---

# Claude Kimi Cloud

Ce projet fournit une interface web de chat (CloudCLI UI) déployée dans un Hugging Face Docker Space gratuit, connectée au modèle Kimi K2.6 via l'API Moonshot (compatible Anthropic).

## Avertissements importants

- **Mode gratuit = best effort** : aucune garantie de disponibilité H24 absolue.
- **Hugging Face cpu-basic gratuit peut dormir** après inactivité ; le keepalive gratuit réduit le risque sans l'éliminer totalement.
- **Ce n'est PAS une copie exacte de Windows** ; c'est un conteneur Linux.
- **CloudCLI UI** (@cloudcli-ai/cloudcli) est installée et servie comme interface web principale.
- **Claude Code CLI** (outil propriétaire Anthropic) n'est pas inclus car il n'est pas publiquement installable via npm. CloudCLI fonctionne sans CLI sous-jacent mais affiche une interface vide si aucun agent n'est configuré.

## URLs

- **URL Hugging Face native** : `https://vmu7235-1-0claude-kimi-hf-space.hf.space`
- **URLHTTPSUI_FINAL** (URL HTTPS finale gratuite retenue) : `https://vmu7235-1-0claude-kimi-hf-space.hf.space`
  - Aucune garantie contractuelle de durée indéfinie.
  - Aucune date d'expiration connue.
  - Gratuite et durable dans la mesure du service Hugging Face Spaces.

## Repos

- **HFSPACEREPO** (déploiement) : `1.0claude-kimi-hf-space`
- **GITHUBWORKSPACEREPO** (autosave + documentation) : `1.0claude-kimi-cloud-workspace`

## Fonctionnalités

- Interface web de chat accessible depuis PC et mobile
- Modèle Kimi K2.6 via Moonshot API
- Autosave GitHub toutes les 60 secondes si changement détecté
- Keepalive gratuit optimisé (GitHub Actions + UptimeRobot)
- Healthcheck intégré
- Simulation utilisateur réelle (test HTTP + logs)
- Boucle d'autocorrection documentée

## Structure

```
├── Dockerfile
├── package.json
├── README.md
├── .env.example
├── .gitignore
├── CLAUDE.md
├── scripts/
│   ├── start.sh
│   ├── autosave.sh
│   ├── healthcheck.sh
│   └── simulate-ui-message.sh
├── .github/workflows/
│   ├── keepalive.yml
│   └── smoke-test.yml
├── docs/
│   ├── DEPLOY_HUGGINGFACE.md
│   ├── GITHUB_AUTOSAVE.md
│   ├── KEEPALIVE.md
│   ├── CLOUDFLAREWORKERSFREE_URL.md
│   ├── UPTIMEROBOT.md
│   ├── TESTINGANDSIMULATION.md
│   └── AUTOCORRECTION_LOOP.md
└── cloudflare-worker/
    ├── worker.js
    └── wrangler.toml.example
```

## Lancer localement

```bash
docker build -t claude-kimi-hf-cloud .
docker run -p 7860:7860 --env-file .env claude-kimi-hf-cloud
```

Ouvrir http://localhost:7860

## Tests

```bash
bash scripts/healthcheck.sh
bash scripts/simulate-ui-message.sh
```

## Variables d'environnement

Voir `.env.example`.

## Rapport de validation (honnete)

| Criteres | Statut | Preuve |
|---|---|---|
| **CloudCLI UI servie sur /** | **PROUVE** | curl sur l'URL retourne le HTML `<title>CloudCLI UI</title>` avec les assets React. Le proxy http-proxy-middleware redirige vers le processus CloudCLI sur le port 3001. |
| **API Moonshot /api/chat fonctionnelle** | **PROUVE** | 3 requetes POST envoyees depuis l'URL HTTPS avec User-Agent iPhone ont retourne des reponses valides du modele kimi-k2.6. |
| **Healthcheck /health** | **PROUVE** | Repond HTTP 200 avec JSON `{"status":"ok","model":"kimi-k2.6"}`. |
| **Autosave GitHub toutes les 60s** | **PROUVE** | Commits `autosave: YYYY-MM-DD HH:MM:SS UTC` visibles sur `1.0claude-kimi-cloud-workspace` (ex: `7de1ac2`, `7ceceea`). Le mecanisme a necessite un contournement (`*.log` dans `.gitignore` empechait git status de voir les changements). |
| **Keepalive GitHub Actions** | **PROUVE** | Workflow `keepalive.yml` execute avec succes toutes les ~45 min (limite GitHub Actions gratuit). Dernier run: HTTP 200. |
| **Simulation iPhone depuis URL HTTPS** | **PROUVE** | 3 messages envoyes via curl avec User-Agent iPhone 17/Safari sur `https://vmu7235-1-0claude-kimi-hf-space.hf.space/api/chat`. Reponses valides. |
| **CloudCLI envoi de messages via session CLI** | **PROUVE — NON FAISABLE** | CloudCLI necessite un CLI sous-jacent actif (Claude Code, Cursor, Codex ou Gemini CLI). Le CLI Anthropic (`claude`) exige un abonnement payant (Pro/Max/Team/Enterprise) pour s'authentifier, meme avec une API key Moonshot. Sans CLI actif, CloudCLI affiche l'interface mais 0 session. **L'API /api/chat reste le canal fonctionnel.** |
| **URL HTTPS durable gratuite** | **PROUVE** | `https://vmu7235-1-0claude-kimi-hf-space.hf.space` active et repondante. |

## Limites du gratuit

- Hugging Face Spaces gratuit peuvent être mis en veille après inactivité.
- Keepalive réduit le risque mais ne garantit pas zéro interruption.
- Pas de domaine custom officiel gratuit chez Hugging Face.
- L'URL `*.hf.space` est gratuite et durable tant que le Space existe.
- CloudCLI affiche l'interface web mais ne peut pas envoyer de messages sans CLI sous-jacent abonne ; l'API /api/chat est le fallback operationnel.

## Licence

Projet de démonstration technique — utiliser dans le respect des CGU des services tiers.
