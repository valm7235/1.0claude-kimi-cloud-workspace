# Cloudflare Workers — URL gratuite alternative

## Principe

Un Cloudflare Worker peut servir de **proxy** ou de **redirect** vers l'URL Hugging Face native.

## Avantages

- URL sur `*.workers.dev` : gratuite et durable.
- Pas de date d'expiration connue.
- HTTPS natif.
- Performances Cloudflare (CDN).

## Inconvenients

- **Ce n'est PAS un vrai domaine custom** pour Hugging Face.
- Le Worker est une couche supplementaire.
- Si le Worker est supprime, l'URL cesse de fonctionner.

## Configuration

1. Creer un compte Cloudflare gratuit sur https://dash.cloudflare.com/sign-up
2. Aller dans **Workers & Pages**
3. Creer un service
4. Deployer le fichier `cloudflare-worker/worker.js`
5. L'URL sera du type :
   ```
   https://claude-kimi-cloud.VOTRE_COMPTE.workers.dev
   ```

## URL finale retenue

Apres comparaison, l'URL **native Hugging Face** est retenue comme URL principale car :
- Zero configuration supplementaire.
- Zero risque de couche intermediaire.
- Directement liee au Space.

```
URLHTTPSUI_FINAL = https://vmu7235-1-0claude-kimi-hf-space.hf.space
```

Le Worker Cloudflare reste documente comme solution de **fallback** ou de **redirection** si necessaire.

## workers.dev vs URL native

| Critere | URL native HF | workers.dev |
|---------|---------------|-------------|
| Gratuit | Oui | Oui |
| HTTPS natif | Oui | Oui |
| Configuration | Aucune | Worker a deployer |
| Date expiration | Aucune connue | Aucune connue |
| Complexite | Minimal | Moyenne |
| Maintenance | Faible | Moyenne |
