# UptimeRobot — Configuration

## Creation du compte

1. Aller sur https://uptimerobot.com/
2. Creer un compte gratuit
3. Confirmer l'email

## Creation du moniteur

1. Cliquer sur **Add New Monitor**
2. Type : **HTTP(s)**
3. Friendly Name : `Claude Kimi HF Space`
4. URL : `https://vmu7235-1-0claude-kimi-hf-space.hf.space/health`
5. Monitoring Interval : **5 minutes** (gratuit)
6. Cliquer sur **Create Monitor**

## Verification

- Consulter le dashboard UptimeRobot
- Verifier que le statut est **Up**
- Verifier les logs de requetes

## Redondance

UptimeRobot est une **redondance gratuite** au keepalive GitHub Actions.
Si l'un des deux tombe en panne, l'autre continue de pinger l'URL.

## Limites

- Intervalle minimum gratuit : 5 minutes.
- 50 moniteurs maximum en plan gratuit.
- Pas de garantie de zero interruption.
