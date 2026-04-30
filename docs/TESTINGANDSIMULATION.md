# Tests et Simulation

## Tests locaux

### 1. Build Docker

```bash
cd C:\Users\valm7\claude-hf-cloud
docker build -t claude-kimi-hf-cloud .
```

### 2. Lancer le conteneur

```bash
docker run -p 7860:7860 --env-file .env claude-kimi-hf-cloud
```

### 3. Healthcheck

```bash
bash scripts/healthcheck.sh
```

Attendu : `OK — l'UI repond`

### 4. Simulation UI

```bash
bash scripts/simulate-ui-message.sh
```

Attendu : `SIMULATION TERMINEE — tous les criteres passent`

## Tests dans Hugging Face

1. Ouvrir l'URL : `https://vmu7235-1-0claude-kimi-hf-space.hf.space`
2. Verifier que la page HTML se charge.
3. Envoyer un message de test dans l'interface.
4. Verifier la reponse.

## Verification des logs

```bash
docker logs CONTENEUR_ID
```

Ou dans Hugging Face : onglet **Logs** du Space.

## Simulation utilisateur — complete ou partielle ?

### Simulation complete

Une simulation complete necessite :
- Ouvrir l'URL HTTPS finale dans un navigateur.
- Envoyer plusieurs questions.
- Verifier les reponses.
- Verifier les logs.

### Simulation partielle

Si la simulation complete n'est pas possible (ex. pas de token API configure, pas de navigateur disponible), la simulation partielle verifie :
- UI accessible HTTP 200 localement
- URL HTTPS publique accessible
- Processus CloudCLI actif
- Workspace disponible
- Variables modele visibles
- Absence d'erreur critique dans les logs
- Endpoint sante OK

## Test URL HTTPS finale depuis PC

```bash
curl -v https://vmu7235-1-0claude-kimi-hf-space.hf.space/health
```

## Test URL HTTPS finale depuis iPhone Safari

1. Ouvrir Safari sur iPhone.
2. Naviguer vers `https://vmu7235-1-0claude-kimi-hf-space.hf.space`.
3. Verifier que l'interface se charge.
4. Envoyer un message de test.
5. Verifier la reponse.

Alternative sans iPhone : utiliser curl avec un User-Agent mobile :

```bash
curl -H "User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15" \
  https://vmu7235-1-0claude-kimi-hf-space.hf.space/health
```

## Criteres de reussite minimale

- [ ] UI accessible HTTP 200 localement
- [ ] UI accessible via URLHTTPSUI_FINAL
- [ ] URLHTTPSUI_FINAL charge sur navigateur mobile ou simulation mobile
- [ ] CloudCLI process actif
- [ ] Workspace /workspace disponible
- [ ] Variables modele visibles sans token complet
- [ ] Absence d'erreur critique dans logs
- [ ] Plusieurs messages de test envoyes si API ou UI automatisable
- [ ] Reponses verifiees si API ou UI automatisable
- [ ] Autosave GitHub verifie apres interaction

## Criteres de simulation finale souhaite

- [ ] Ouvrir URLHTTPSUI_FINAL
- [ ] Simuler usage type iPhone Safari
- [ ] Envoyer plusieurs questions
- [ ] Verifier que l'UI repond
- [ ] Verifier les logs
- [ ] Verifier que le workspace reste stable
- [ ] Verifier autosave GitHub
