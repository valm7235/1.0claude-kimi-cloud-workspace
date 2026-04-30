const express = require('express');
const fetch = require('node-fetch');
const fs = require('fs');
const path = require('path');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app = express();
const PORT = process.env.PORT || 7860;

const ANTHROPIC_BASE_URL = process.env.ANTHROPIC_BASE_URL || 'https://api.moonshot.ai/anthropic';
const ANTHROPIC_AUTH_TOKEN = process.env.ANTHROPIC_AUTH_TOKEN || '';
const ANTHROPIC_MODEL = process.env.ANTHROPIC_MODEL || 'kimi-k2.6';

const LOG_DIR = '/workspace/logs';
const LOG_FILE = path.join(LOG_DIR, 'access.log');

function ensureLogDir() {
  try {
    if (!fs.existsSync(LOG_DIR)) {
      fs.mkdirSync(LOG_DIR, { recursive: true });
    }
  } catch (e) {
    console.error('[log] Cannot create log dir:', e.message);
  }
}

function logRequest(req) {
  try {
    const line = `[${new Date().toISOString()}] ${req.method} ${req.url}\n`;
    fs.appendFileSync(LOG_FILE, line);
  } catch (e) {
    // ignore logging errors
  }
}

app.use(express.json());
app.use((req, res, next) => {
  ensureLogDir();
  logRequest(req);
  next();
});

app.get('/debug/env', (req, res) => {
  res.json({
    github_repo_url_set: !!process.env.GITHUB_REPO_URL,
    github_token_set: !!process.env.GITHUB_TOKEN,
    anthropic_auth_token_set: !!process.env.ANTHROPIC_AUTH_TOKEN,
    hf_token_set: !!process.env.HF_TOKEN,
    model: process.env.ANTHROPIC_MODEL || 'default'
  });
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', model: ANTHROPIC_MODEL, timestamp: new Date().toISOString() });
});

app.post('/api/chat', async (req, res) => {
  try {
    const { message, history = [] } = req.body;
    if (!message) {
      return res.status(400).json({ error: 'Message requis' });
    }
    if (!ANTHROPIC_AUTH_TOKEN) {
      return res.status(500).json({ error: 'ANTHROPIC_AUTH_TOKEN non configure' });
    }

    const messages = [];
    for (const h of history) {
      messages.push({ role: h.role, content: h.content });
    }
    messages.push({ role: 'user', content: message });

    const response = await fetch(`${ANTHROPIC_BASE_URL}/v1/messages`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': ANTHROPIC_AUTH_TOKEN,
        'anthropic-version': '2023-06-01'
      },
      body: JSON.stringify({
        model: ANTHROPIC_MODEL,
        max_tokens: 4096,
        messages
      })
    });

    if (!response.ok) {
      const text = await response.text();
      console.error('Moonshot API error:', response.status, text);
      return res.status(502).json({ error: 'Erreur API Moonshot', detail: text });
    }

    const data = await response.json();
    const reply = data.content && data.content[0] && data.content[0].text ? data.content[0].text : JSON.stringify(data);
    res.json({ reply, model: ANTHROPIC_MODEL });
  } catch (err) {
    console.error('Chat error:', err);
    res.status(500).json({ error: err.message });
  }
});

const cloudcliProxy = createProxyMiddleware({
  target: 'http://localhost:3001',
  changeOrigin: true,
  ws: true,
  logLevel: 'info',
  onError: (err, req, res) => {
    console.error('Proxy error:', err.message);
    if (!res.headersSent) {
      res.status(502).send('CloudCLI UI indisponible (port 3001). Erreur: ' + err.message);
    }
  }
});

app.use('/', cloudcliProxy);

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Proxy serveur principal sur http://0.0.0.0:${PORT} -> CloudCLI http://localhost:3001`);
  console.log(`API Moonshot conservee sur /api/chat`);
});
