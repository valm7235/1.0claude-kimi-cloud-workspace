# Règles projet — Claude Kimi Cloud

## Ce que le projet fait

Ce projet héberge une interface web de chat (Node.js/Express) dans un Hugging Face Docker Space gratuit, connectée au modèle Kimi K2.6 via l'API Moonshot.

## Limites techniques à respecter

- **Ne JAMAIS prétendre que le gratuit garantit H24**.
- **Ne JAMAIS prétendre zéro interruption**.
- **Ne JAMAIS prétendre que c'est une copie exacte de Windows**.
- **Ne JAMAIS afficher de token complet** dans les logs, fichiers commités, ou rapports.
- **Claude Code CLI** (propriétaire Anthropic) n'est PAS inclus car non publiquement installable via npm.

## Classification des résultats

Toute affirmation doit être classée :
- **PROUVÉ** — test réel effectué avec logs ou captures vérifiables.
- **PROBABLE** — forte présomption basée sur des preuves partielles.
- **HYPOTHÈSE** — raisonnement théorique sans test direct.
- **NON FAIT** — pas encore testé ou impossible avec les moyens actuels.

## Procédures de modification

- Avant toute modification risquée : écrire un plan d'abord.
- Après modification : lister les fichiers modifiés.
- Après modification : lancer les tests disponibles.
- Toute simulation doit produire des logs ou une sortie vérifiable.

## Interdictions de langage

- Ne jamais dire "100 % optimisé" sans que 100 % des critères de validation passent.
- Ne jamais dire "simulation réelle complète" si le test n'a pas réellement utilisé l'URL HTTPS finale.
- Ne jamais dire "simulation iPhone Safari complète" si elle n'a pas été réellement exécutée depuis un appareil iOS ou un émulateur fidèle.
