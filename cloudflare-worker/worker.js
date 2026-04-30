/**
 * Cloudflare Worker — Proxy vers Hugging Face Space
 *
 * Ce Worker redirige les requetes vers l'URL du Space Hugging Face.
 * Il peut aussi servir de fallback si le proxy direct n'est pas compatible.
 */

export default {
  async fetch(request, env, ctx) {
    const HFSPACEURL = env.HFSPACEURL || "https://vmu7235-1-0claude-kimi-hf-space.hf.space";

    const url = new URL(request.url);
    const target = new URL(url.pathname + url.search, HFSPACEURL);

    try {
      const response = await fetch(target, {
        method: request.method,
        headers: request.headers,
        body: request.body,
        redirect: "follow"
      });
      return new Response(response.body, {
        status: response.status,
        statusText: response.statusText,
        headers: response.headers
      });
    } catch (e) {
      // Fallback : redirect simple
      return Response.redirect(HFSPACEURL + url.pathname + url.search, 302);
    }
  }
};
