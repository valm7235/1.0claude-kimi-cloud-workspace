# Keepalive — Empecher le sommeil du Space gratuit

## Probleme

Hugging Face **cpu-basic gratuit** peut mettre un Space en veille (sleep) apres une periode d'inactivite. Un keepalive reduit ce risque en generant du trafic regulier.

## Solutions gratuites comparees

| Solution | Gratuit | Frequence min | Fiabilite | Simplicite | Redondance |
|----------|---------|---------------|-----------|------------|------------|
| **GitHub Actions cron** | Oui | 5 min | Bonne | Simple | Oui (CI GitHub) |
| **UptimeRobot** | Oui (50 moniteurs) | 5 min | Tres bonne | Tres simple | Oui (externe) |
| **Better Stack** | Oui (10 moniteurs) | 3 min | Tres bonne | Simple | Oui (externe) |
| **cron-job.org** | Oui | 1 min | Moyenne | Simple | Oui (externe) |
| **Cloudflare Workers scheduled trigger** | Oui (limites genereuses) | 1 min | Tres bonne | Moyenne | Oui (externe) |

## Solution retenue

**GitHub Actions + UptimeRobot** (redondance double)

### Pourquoi cette combinaison ?

1. **GitHub Actions** :
   - 100 % gratuit pour les repos publics.
   - Integre au repo GitHub workspace.
   - Pas besoin de compte tiers supplementaire.
   - Logs historiques visibles dans l'onglet Actions.

2. **UptimeRobot** :
   - Service specialise dans le monitoring uptime.
   - Interface simple et fiable.
   - Historique de disponibilite.
   - Redondance si GitHub Actions tombe en panne.

### Frequence

- **GitHub Actions** : toutes les **5 minutes** (`*/5 * * * *`)
- **UptimeRobot** : toutes les **5 minutes**

### Limites

- **Aucune garantie de zero interruption** : le keepalive reduit le risque mais ne l'elimine pas.
- Si Hugging Face decide de mettre en veille malgre le trafic, le Space peut quand meme dormir.
- Le mode gratuit reste du **best effort**.

## URL reellement pingee

```
URLHTTPSUI_FINAL = https://1.0claude-kimi-hf-space.hf.space
```

Le endpoint `/health` est utilise pour minimiser la charge.

## Comment tester manuellement le keepalive

```bash
curl -v https://1.0claude-kimi-hf-space.hf.space/health
```

Ou lancer le workflow manuellement depuis l'onglet **Actions** > **Keepalive** > **Run workflow**.
