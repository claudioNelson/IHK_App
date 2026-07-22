"use client";

import { useState } from "react";

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

function ipToBin(ip: number): string {
  return [24, 16, 8, 0]
    .map((s) => ((ip >>> s) & 255).toString(2).padStart(8, "0"))
    .join(".");
}

const box: React.CSSProperties = {
  background: "#12121C",
  border: "1px solid rgba(124,109,255,0.35)",
  borderRadius: 16,
  padding: "24px 26px",
  margin: "20px 0",
};

const inputStyle: React.CSSProperties = {
  background: "rgba(255,255,255,0.05)",
  border: "1px solid rgba(255,255,255,0.15)",
  borderRadius: 10,
  color: "#F5F5F7",
  padding: "11px 14px",
  fontSize: 16,
  fontFamily: "var(--font-geist-mono), ui-monospace, monospace",
  outline: "none",
  width: "100%",
  boxSizing: "border-box",
};

const th: React.CSSProperties = {
  textAlign: "left",
  padding: "8px 12px",
  color: "#A0A0B0",
  fontSize: 13,
  fontWeight: 600,
  textTransform: "uppercase",
  letterSpacing: "0.04em",
  borderBottom: "1px solid rgba(255,255,255,0.08)",
};

const td: React.CSSProperties = {
  padding: "9px 12px",
  borderBottom: "1px solid rgba(255,255,255,0.06)",
  color: "#E0E0E8",
  fontFamily: "var(--font-geist-mono), ui-monospace, monospace",
  fontSize: 15,
};

export default function SubnetzRechner() {
  const [ipStr, setIpStr] = useState("192.168.10.130");
  const [prefix, setPrefix] = useState(26);
  const [zeigeBinaer, setZeigeBinaer] = useState(false);

  const ip = parseIp(ipStr);
  const gueltig = ip !== null && prefix >= 1 && prefix <= 30;

  let mask = 0,
    network = 0,
    broadcast = 0,
    firstHost = 0,
    lastHost = 0,
    hosts = 0;

  if (gueltig && ip !== null) {
    mask = (0xffffffff << (32 - prefix)) >>> 0;
    network = (ip & mask) >>> 0;
    broadcast = (network | (~mask >>> 0)) >>> 0;
    firstHost = (network + 1) >>> 0;
    lastHost = (broadcast - 1) >>> 0;
    hosts = Math.pow(2, 32 - prefix) - 2;
  }

  return (
    <div style={box}>
      <div style={{ display: "flex", gap: 12, flexWrap: "wrap", marginBottom: 18 }}>
        <div style={{ flex: "1 1 220px" }}>
          <label
            style={{ display: "block", color: "#A0A0B0", fontSize: 13, marginBottom: 6, fontWeight: 600 }}
          >
            IP-Adresse
          </label>
          <input
            style={inputStyle}
            value={ipStr}
            onChange={(e) => setIpStr(e.target.value)}
            placeholder="z. B. 192.168.10.130"
            inputMode="decimal"
          />
        </div>
        <div style={{ flex: "0 1 160px" }}>
          <label
            style={{ display: "block", color: "#A0A0B0", fontSize: 13, marginBottom: 6, fontWeight: 600 }}
          >
            Präfix (CIDR): /{prefix}
          </label>
          <input
            type="range"
            min={1}
            max={30}
            value={prefix}
            onChange={(e) => setPrefix(Number(e.target.value))}
            style={{ width: "100%", accentColor: "#7C6DFF", marginTop: 14 }}
          />
        </div>
      </div>

      {!gueltig && (
        <p style={{ color: "#FF6B63", fontSize: 15, margin: 0 }}>
          Bitte eine gültige IPv4-Adresse eingeben (vier Zahlen von 0–255, z. B.
          192.168.1.10).
        </p>
      )}

      {gueltig && ip !== null && (
        <>
          <table style={{ width: "100%", borderCollapse: "collapse" }}>
            <tbody>
              <tr>
                <td style={th}>Subnetzmaske</td>
                <td style={td}>{ipToStr(mask)}</td>
              </tr>
              <tr>
                <td style={th}>Netzadresse</td>
                <td style={td}>{ipToStr(network)}</td>
              </tr>
              <tr>
                <td style={th}>Broadcast</td>
                <td style={td}>{ipToStr(broadcast)}</td>
              </tr>
              <tr>
                <td style={th}>Erster Host</td>
                <td style={td}>{ipToStr(firstHost)}</td>
              </tr>
              <tr>
                <td style={th}>Letzter Host</td>
                <td style={td}>{ipToStr(lastHost)}</td>
              </tr>
              <tr>
                <td style={th}>Nutzbare Hosts</td>
                <td style={td}>{hosts.toLocaleString("de-DE")}</td>
              </tr>
            </tbody>
          </table>

          <button
            onClick={() => setZeigeBinaer(!zeigeBinaer)}
            style={{
              marginTop: 16,
              padding: "9px 16px",
              borderRadius: 8,
              background: "rgba(124,109,255,0.14)",
              border: "1px solid rgba(124,109,255,0.4)",
              color: "#C4BBFF",
              fontSize: 14,
              cursor: "pointer",
              fontFamily: "inherit",
            }}
          >
            {zeigeBinaer ? "Rechenweg ausblenden" : "Rechenweg in Binär anzeigen"}
          </button>

          {zeigeBinaer && (
            <div
              style={{
                marginTop: 14,
                background: "rgba(0,0,0,0.35)",
                borderRadius: 10,
                padding: "14px 16px",
                overflowX: "auto",
              }}
            >
              <pre
                style={{
                  margin: 0,
                  color: "#C8C8D2",
                  fontFamily: "var(--font-geist-mono), ui-monospace, monospace",
                  fontSize: 13.5,
                  lineHeight: 1.9,
                }}
              >
{`IP-Adresse   ${ipToBin(ip)}
Maske (/${String(prefix).padEnd(2)})  ${ipToBin(mask)}
             ${"─".repeat(35)}  UND-Verknüpfung
Netzadresse  ${ipToBin(network)}
Broadcast    ${ipToBin(broadcast)}`}
              </pre>
              <p style={{ color: "#A0A0B0", fontSize: 13.5, margin: "10px 0 0" }}>
                Netzadresse = IP UND Maske (bitweise). Broadcast = Netzadresse mit
                allen Host-Bits auf 1. Nutzbare Hosts = 2^{32 - prefix} − 2.
              </p>
            </div>
          )}
        </>
      )}
    </div>
  );
}
