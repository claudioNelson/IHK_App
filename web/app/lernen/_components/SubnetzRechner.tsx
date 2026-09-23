"use client";

// Subnetz-Rechner mit Binaer-Rechenweg (.ls-calc, nach mockup-thema.html).
// Labels mit for, Slider mit <output> und aria-valuetext, Fehlertext als
// role="alert", Ergebnis als <dl>-Kacheln. Im Rechenweg sind die Netz-Bits
// farbig (<b>), die Host-Bits grau. Rechenlogik unveraendert aus der alten
// Komponente.

import { useId, useState, type ReactNode } from "react";

function parseIp(s: string): number | null {
  const parts = s.trim().split(".");
  if (parts.length !== 4) return null;
  let ip = 0;
  for (const p of parts) {
    if (!/^\d{1,3}$/.test(p)) return null;
    const n = Number(p);
    if (n < 0 || n > 255) return null;
    ip = ((ip << 8) | n) >>> 0;
  }
  return ip >>> 0;
}

function ipToStr(ip: number): string {
  return [24, 16, 8, 0].map((s) => (ip >>> s) & 255).join(".");
}

/** Binaerdarstellung mit Punkt je Oktett; die ersten `prefix` Bits sind Netz-Bits. */
function ipToBin(ip: number, prefix: number): ReactNode[] {
  let bits = "";
  for (let s = 31; s >= 0; s--) bits += (ip >>> s) & 1;
  const out: ReactNode[] = [];
  for (let o = 0; o < 4; o++) {
    const oktett = bits.slice(o * 8, o * 8 + 8);
    const netz = Math.max(0, Math.min(8, prefix - o * 8));
    if (netz > 0) out.push(<b key={`n${o}`}>{oktett.slice(0, netz)}</b>);
    out.push(oktett.slice(netz));
    if (o < 3) out.push(".");
  }
  return out;
}

const STANDARD_IP = "192.168.10.130";

export default function SubnetzRechner() {
  const id = useId();
  const ipId = `${id}-ip`;
  const prefixId = `${id}-prefix`;
  const binId = `${id}-bin`;

  const [ipStr, setIpStr] = useState(STANDARD_IP);
  // Letzte gueltige Adresse: bei Tippfehlern bleibt das Ergebnis abgeblendet stehen
  const [letzteIp, setLetzteIp] = useState<number>(() => parseIp(STANDARD_IP) ?? 0);
  const [prefix, setPrefix] = useState(26);
  const [zeigeBinaer, setZeigeBinaer] = useState(false);

  const gueltig = parseIp(ipStr) !== null;
  const ip = letzteIp;

  const mask = (0xffffffff << (32 - prefix)) >>> 0;
  const network = (ip & mask) >>> 0;
  const broadcast = (network | (~mask >>> 0)) >>> 0;
  const firstHost = (network + 1) >>> 0;
  const lastHost = (broadcast - 1) >>> 0;
  const hosts = Math.pow(2, 32 - prefix) - 2;

  return (
    <div className="ls-calc">
      <div className="ls-calc-form">
        <div className="ls-field" data-invalid={gueltig ? "false" : "true"}>
          <label htmlFor={ipId}>IP-Adresse</label>
          <input
            className="ls-input"
            id={ipId}
            type="text"
            inputMode="decimal"
            autoComplete="off"
            spellCheck={false}
            value={ipStr}
            placeholder="z. B. 192.168.10.130"
            aria-invalid={gueltig ? "false" : "true"}
            aria-describedby={`${ipId}-hint ${ipId}-error`}
            onChange={(e) => {
              const wert = e.target.value;
              setIpStr(wert);
              const neu = parseIp(wert);
              if (neu !== null) setLetzteIp(neu);
            }}
          />
          <p className="ls-field-hint" id={`${ipId}-hint`}>
            Vier Zahlen von 0 bis 255, durch Punkte getrennt.
          </p>
          <p className="ls-field-error" id={`${ipId}-error`} role="alert">
            {gueltig ? "" : "Das ist keine gültige IPv4-Adresse. Beispiel: 192.168.1.10"}
          </p>
        </div>

        <div className="ls-field">
          <label htmlFor={prefixId}>
            Präfix (CIDR)
            <output htmlFor={prefixId}>/{prefix}</output>
          </label>
          <input
            className="ls-range"
            id={prefixId}
            type="range"
            min={1}
            max={30}
            value={prefix}
            aria-valuetext={`/${prefix}`}
            onChange={(e) => setPrefix(Number(e.target.value))}
          />
          <p className="ls-field-hint">/1 bis /30, mit den Pfeiltasten einstellbar.</p>
        </div>
      </div>

      <div className="ls-calc-out" aria-live="polite" style={gueltig ? undefined : { opacity: 0.4 }}>
        <dl className="ls-result">
          <div>
            <dt>Subnetzmaske</dt>
            <dd>{ipToStr(mask)}</dd>
          </div>
          <div>
            <dt>Netzadresse</dt>
            <dd>{ipToStr(network)}</dd>
          </div>
          <div>
            <dt>Broadcast</dt>
            <dd>{ipToStr(broadcast)}</dd>
          </div>
          <div>
            <dt>Erster Host</dt>
            <dd>{ipToStr(firstHost)}</dd>
          </div>
          <div>
            <dt>Letzter Host</dt>
            <dd>{ipToStr(lastHost)}</dd>
          </div>
          <div>
            <dt>Nutzbare Hosts</dt>
            <dd>{hosts.toLocaleString("de-DE")}</dd>
          </div>
        </dl>

        <div className="ls-calc-actions">
          <button
            className="btn btn-ghost btn-sm"
            type="button"
            aria-expanded={zeigeBinaer}
            aria-controls={binId}
            onClick={() => setZeigeBinaer((z) => !z)}
          >
            {zeigeBinaer ? "Rechenweg ausblenden" : "Rechenweg in Binär anzeigen"}
          </button>
        </div>

        <div className="ls-bin" id={binId} hidden={!zeigeBinaer}>
          <div className="ls-bin-rows">
            <span>IP-Adresse</span>
            <code>{ipToBin(ip, prefix)}</code>
            <span>Maske /{prefix}</span>
            <code>{ipToBin(mask, prefix)}</code>
            <div className="ls-bin-line" aria-hidden="true"></div>
            <p className="ls-bin-op">bitweise UND</p>
            <span>Netzadresse</span>
            <code>{ipToBin(network, prefix)}</code>
            <span>Broadcast</span>
            <code>{ipToBin(broadcast, prefix)}</code>
          </div>
          <p className="ls-bin-legend">
            <span>
              <i style={{ background: "var(--accent)" }}></i>Netz-Bits
            </span>
            <span>
              <i style={{ background: "var(--text-3)" }}></i>Host-Bits
            </span>
          </p>
          <p className="ls-field-hint" style={{ marginTop: 10 }}>
            Netzadresse = IP UND Maske (bitweise). Broadcast = Netzadresse mit allen
            Host-Bits auf 1. Nutzbare Hosts = 2^(32 − Präfix) − 2.
          </p>
        </div>
      </div>
    </div>
  );
}
