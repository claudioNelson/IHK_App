// Gemeinsames CSS für alle Python-Kurs-Seiten (Übersicht + Lektionen).
// Wird als <style> in jede Seite eingebettet, damit Übersicht und
// Unterseiten exakt gleich aussehen.

export const kursCss = `
  .lp-wrap {
    --bg: #08080C; --bg-muted: #0E0E14; --surface: #12121C; --surface-2: #151521;
    --border: rgba(255,255,255,0.08); --border-strong: rgba(255,255,255,0.14);
    --text: #F5F5F7; --text-body: #C8C8D2; --text-dim: #A0A0B0;
    --accent: #7C6DFF; --accent-soft: rgba(124,109,255,0.14); --accent-text: #C4BBFF;
    --chip-bg: rgba(255,255,255,0.05); --chip-border: rgba(255,255,255,0.1);
    --input-bg: rgba(255,255,255,0.05); --input-border: rgba(255,255,255,0.15);
    --pre-bg: rgba(0,0,0,0.35);
    --ok: #5FD98A; --ok-bg: rgba(52,199,89,0.16); --ok-border: rgba(52,199,89,0.6); --ok-text: #B8F0C4;
    --err: #FF6B63; --err-bg: rgba(255,69,58,0.16); --err-border: rgba(255,69,58,0.6); --err-text: #FFC1BC;
    --warn-bg: rgba(255,159,10,0.14); --warn-border: rgba(255,159,10,0.55); --warn-text: #FFD79A;
    font-family: var(--font-geist-sans), system-ui, sans-serif;
    background: var(--bg);
    color: var(--text);
    min-height: 100vh;
    line-height: 1.65;
  }
  html[data-theme="light"] .lp-wrap {
    --bg: #FAFAF9; --bg-muted: #F4F4F1; --surface: #FFFFFF; --surface-2: #FFFFFF;
    --border: rgba(10,10,15,0.10); --border-strong: rgba(10,10,15,0.18);
    --text: #0A0A0F; --text-body: #3A3A44; --text-dim: #6A6A74;
    --accent: #6A5AE8; --accent-soft: rgba(106,90,232,0.10); --accent-text: #5B4BE0;
    --chip-bg: rgba(10,10,15,0.04); --chip-border: rgba(10,10,15,0.12);
    --input-bg: #FFFFFF; --input-border: rgba(10,10,15,0.18);
    --pre-bg: rgba(10,10,15,0.05);
    --ok: #1E9E50; --ok-bg: rgba(30,158,80,0.10); --ok-border: rgba(30,158,80,0.45); --ok-text: #14713A;
    --err: #D93B33; --err-bg: rgba(217,59,51,0.08); --err-border: rgba(217,59,51,0.45); --err-text: #A32620;
    --warn-bg: rgba(180,120,0,0.10); --warn-border: rgba(180,120,0,0.45); --warn-text: #8A5A00;
  }
  .lp-container { max-width: 780px; margin: 0 auto; padding: 72px 24px 96px; }
  .lp-crumb { font-size: 14px; color: var(--accent); margin-bottom: 24px; }
  .lp-crumb a { color: var(--accent); text-decoration: none; }
  .lp-crumb a:hover { text-decoration: underline; }
  .lp-wrap h1 {
    font-size: clamp(32px, 5vw, 46px);
    line-height: 1.1; letter-spacing: -0.02em;
    margin: 0 0 16px; font-weight: 700;
  }
  .lp-lead { font-size: 19px; color: var(--text-dim); margin: 0 0 32px; }
  .lp-wrap h2 { font-size: 26px; letter-spacing: -0.01em; margin: 64px 0 16px; font-weight: 650; }
  .lp-wrap h3 { font-size: 19px; margin: 28px 0 8px; font-weight: 600; }
  .lp-wrap p { color: var(--text-body); margin: 0 0 16px; }
  .lp-wrap strong { color: var(--text); }
  .lp-cta-row { display: flex; gap: 12px; flex-wrap: wrap; margin: 8px 0; }
  .lp-btn {
    display: inline-block; padding: 13px 26px; border-radius: 12px;
    font-weight: 600; font-size: 16px; text-decoration: none; transition: transform .12s ease;
  }
  .lp-btn-primary { background: #7C6DFF; color: #fff; box-shadow: 0 10px 30px rgba(124,109,255,0.35); }
  .lp-btn-primary:hover { transform: translateY(-2px); }
  .lp-btn-ghost { background: var(--chip-bg); color: var(--text); border: 1px solid var(--chip-border); }
  .lp-btn-ghost:hover { background: var(--accent-soft); }
  .lp-card { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; padding: 24px 26px; margin: 20px 0; }
  .lp-mono {
    font-family: var(--font-geist-mono), ui-monospace, monospace;
    background: var(--accent-soft); color: var(--accent-text);
    padding: 2px 7px; border-radius: 6px; font-size: 0.92em;
  }
  .lp-tip {
    background: var(--surface); border: 1px solid var(--border);
    border-left: 3px solid var(--accent);
    border-radius: 12px; padding: 16px 20px; margin: 26px 0;
  }
  .lp-tip p { margin: 0; color: var(--text-body); }
  .lp-tip strong { color: var(--text); }
  .lp-faq { margin: 8px 0; }
  .lp-faq details { background: var(--surface); border: 1px solid var(--border); border-radius: 12px; padding: 2px 22px; margin: 10px 0; transition: border-color .15s ease; }
  .lp-faq details[open] { border-color: var(--border-strong); }
  .lp-faq summary { cursor: pointer; font-weight: 600; color: var(--text); padding: 16px 0; list-style: none; display: flex; justify-content: space-between; align-items: center; gap: 16px; }
  .lp-faq summary::-webkit-details-marker { display: none; }
  .lp-faq summary::after { content: "+"; color: var(--accent); font-size: 22px; font-weight: 400; line-height: 1; }
  .lp-faq details[open] summary::after { content: "−"; }
  .lp-faq details p { padding: 0 0 16px; margin: 0; color: var(--text-body); }
  .lp-final {
    text-align: center; background: linear-gradient(180deg, var(--surface), var(--bg-muted));
    border: 1px solid rgba(124,109,255,0.25); border-radius: 20px;
    padding: 40px 28px; margin: 56px 0 0;
  }
  .lp-final h2 { margin-top: 0; }

  /* Kurs-spezifisch */
  .pk-lessons { display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin: 18px 0; }
  @media (max-width: 560px) { .pk-lessons { grid-template-columns: 1fr; } }
  .pk-lesson {
    display: flex; align-items: center; gap: 12px;
    background: var(--surface); border: 1px solid var(--border);
    border-radius: 12px; padding: 12px 16px; font-size: 15px; color: var(--text-body);
    text-decoration: none; transition: border-color .15s ease, background .15s ease;
  }
  .pk-lesson .nr {
    font-family: var(--font-geist-mono), ui-monospace, monospace;
    color: var(--accent-text); font-weight: 600; font-size: 13px; min-width: 22px;
  }
  .pk-lesson.live { border-color: rgba(124,109,255,0.4); }
  a.pk-lesson.live:hover { border-color: var(--accent); background: var(--accent-soft); }
  .pk-badge {
    margin-left: auto; font-size: 11px; letter-spacing: 0.06em; text-transform: uppercase;
    padding: 3px 9px; border-radius: 99px; white-space: nowrap;
  }
  .pk-badge.live { background: var(--ok-bg); color: var(--ok); border: 1px solid var(--ok-border); }
  .pk-badge.bald { background: var(--chip-bg); color: var(--text-dim); border: 1px solid var(--chip-border); }
  .pk-aufgabe {
    background: var(--chip-bg); border: 1px solid var(--chip-border);
    border-radius: 12px; padding: 14px 20px; margin: 30px 0 6px;
  }
  .pk-aufgabe p { margin: 0; color: var(--text-body); }
  .pk-aufgabe strong { color: var(--text); }
  .pk-divider { border: none; border-top: 1px solid var(--border); margin: 56px 0 0; }
  .pk-loesung { margin: 10px 0 18px; }
  .pk-loesung summary { cursor: pointer; color: var(--accent-text); font-size: 14.5px; font-weight: 600; list-style: none; }
  .pk-loesung summary::-webkit-details-marker { display: none; }
  .pk-loesung pre {
    background: var(--pre-bg); border: 1px solid var(--border); border-radius: 10px;
    padding: 12px 16px; margin: 10px 0 0; overflow-x: auto;
    font-family: var(--font-geist-mono), ui-monospace, monospace; font-size: 14px;
    color: var(--text-body); line-height: 1.6;
  }

  /* Lektions-Navigation (vor/zurück) */
  .pk-nav {
    display: flex; justify-content: space-between; align-items: center;
    gap: 12px; flex-wrap: wrap; margin-top: 72px;
    border-top: 1px solid var(--border); padding-top: 28px;
  }
  .pk-nav-soon { color: var(--text-dim); font-size: 14.5px; }
`;
