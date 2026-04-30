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
- **Claude Code CLI** (outil propriétaire Anthropic) n'est pas inclus car il n'est pas publiquement installable via npm. À la place, ce projet fournit une interface web qui appelle directement l'API Moonshot.

## URLs

- **URL Hugging Face native** : `https://1.0claude-kimi-hf-space.hf.space`
- **URL HTTPS finale gratuite retenue** : `https://1.0claude-kimi-hf-space.hf.space`
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

## Limites du gratuit

- Hugging Face Spaces gratuit peuvent être mis en veille après inactivité.
- Keepalive réduit le risque mais ne garantit pas zéro interruption.
- Pas de domaine custom officiel gratuit chez Hugging Face.
- L'URL `*.hf.space` est gratuite et durable tant que le Space existe.

## Licence

Projet de démonstration technique — utiliser dans le respect des CGU des services tiers.
