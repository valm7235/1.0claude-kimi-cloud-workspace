# Boucle d'Autocorrection

## Principe

Cette boucle est obligatoire : elle continue jusqu'a ce que tous les criteres mesurables soient satisfaits.

## Etapes de la boucle

### A. Verification fichiers

Verifier que tous les fichiers obligatoires existent :
- README.md
- Dockerfile
- package.json
- scripts/start.sh
- scripts/autosave.sh
- scripts/healthcheck.sh
- scripts/simulate-ui-message.sh
- .env.example
- .gitignore
- docs/*.md
- cloudflare-worker/worker.js
- .github/workflows/*.yml

**Si manquant** : creer le fichier et reprendre a A.

### B. Verification syntaxe

- Scripts shell : `bash -n scripts/*.sh`
- YAML GitHub Actions : verifier indentation
- JSON : `node -e "require('./package.json')"`

**Si erreur** : corriger et reprendre a B.

### C. Build Docker local

```bash
docker build -t claude-kimi-hf-cloud .
```

**Si erreur** : analyser les logs, corriger le Dockerfile, reprendre a C.

### D. Run local + healthcheck

```bash
docker run -d -p 7860:7860 --env-file .env claude-kimi-hf-cloud
bash scripts/healthcheck.sh
```

**Si erreur** : analyser les logs, corriger, reprendre a D.

### E. URL HTTPS finale

Verifier que `URLHTTPSUI_FINAL` repond :
```bash
curl -fsS https://vmu7235-1-0claude-kimi-hf-space.hf.space/health
```

**Si erreur** : verifier le deploiement, corriger, reprendre a E.

### F. Simulation utilisateur

Lancer `scripts/simulate-ui-message.sh`.

Verifier :
- Plusieurs messages de test envoyes
- Reponses recues
- Logs sans erreur critique
- Simulation mobile Safari si possible

**Si simulation partielle seulement** : documenter precisement pourquoi.
**Si erreur** : corriger et reprendre a F.

### G. Autosave dry-run

Tester la logique autosave sur un repo temporaire si possible.
Verifier que rien n'est pousse par accident.
Verifier que README.md complet est present cote GitHub workspace.

**Si erreur** : corriger et reprendre a G.

### H. Keepalive

Verifier `keepalive.yml` :
- URL configurable
- Ping `URLHTTPSUI_FINAL`
- Meilleure solution gratuite documentee

**Si erreur** : corriger et reprendre a H.

## Criteres d'arret de la boucle

La boucle s'arrete quand :
- [ ] Tous les fichiers obligatoires existent
- [ ] Smoke-test passe
- [ ] Docker build passe si testable localement
- [ ] Healthcheck passe si service lance
- [ ] URLHTTPSUI_FINAL repond
- [ ] Simulation utilisateur passe ou documentee comme partielle avec raison valide
- [ ] Logs sans erreur critique
- [ ] Autosave script fonctionne en test local ou dry-run
- [ ] Keepalive workflow valide syntaxiquement
- [ ] Documentation coherente
- [ ] README complet present sur le repo GitHub workspace

## Regle d'or

**Ne pas ecrire "100% optimise" sauf si tous ces criteres passent.**
