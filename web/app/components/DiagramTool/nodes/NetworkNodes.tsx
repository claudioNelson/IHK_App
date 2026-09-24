"use client";

import { Handle, Position } from "reactflow";

const EMERALD = "var(--accent)";
const EMERALD_DARK = "var(--accent-2)";
const RED_FIREWALL = "var(--err)";

// Wiederverwendbare Handles
function AllHandles({ color = EMERALD }: { color?: string }) {
    return (
        <>
            <Handle type="target" position={Position.Top}    id="top"    style={{ background: color, border: '2px solid var(--surface)' }} />
            <Handle type="source" position={Position.Bottom} id="bottom" style={{ background: color, border: '2px solid var(--surface)' }} />
            <Handle type="target" position={Position.Left}   id="left"   style={{ background: color, border: '2px solid var(--surface)' }} />
            <Handle type="source" position={Position.Right}  id="right"  style={{ background: color, border: '2px solid var(--surface)' }} />
        </>
    );
}

// ============================================
// SERVER — Klassischer Server-Style
// ============================================
interface ServerData { label: string; description?: string; }

export function ServerNode({ data }: { data: ServerData }) {
    return (
        <div style={{
            background: 'var(--surface)',
            border: `1.5px solid ${EMERALD}`,
            borderRadius: 8,
            minWidth: 130,
            boxShadow: `0 4px 12px color-mix(in srgb, ${EMERALD} 18%, transparent)`,
            fontFamily: "var(--font-sans)",
            overflow: 'hidden',
        }}>
            <AllHandles />
            <div style={{
                padding: '8px 14px',
                background: `linear-gradient(135deg, ${EMERALD}, ${EMERALD_DARK})`,
                color: '#fff',
                textAlign: 'center',
                fontWeight: 600,
                fontSize: 13,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                gap: 6,
            }}>
                {data.label || "Server"}
            </div>
            {data.description && (
                <div style={{
                    padding: '8px 12px',
                    fontFamily: "var(--font-mono)",
                    fontSize: 11,
                    color: 'var(--text)',
                    lineHeight: 1.5,
                    whiteSpace: 'pre-wrap',
                }}>
                    {data.description}
                </div>
            )}
        </div>
    );
}

// ============================================
// FIREWALL — Rot, mit Schild-Symbol
// ============================================
interface FirewallData { label: string; description?: string; }

export function FirewallNode({ data }: { data: FirewallData }) {
    return (
        <div style={{
            background: 'var(--surface)',
            border: `2px solid ${RED_FIREWALL}`,
            borderRadius: 8,
            minWidth: 130,
            boxShadow: `0 4px 12px color-mix(in srgb, ${RED_FIREWALL} 20%, transparent)`,
            fontFamily: "var(--font-sans)",
            overflow: 'hidden',
        }}>
            <AllHandles color={RED_FIREWALL} />
            <div style={{
                padding: '8px 14px',
                background: RED_FIREWALL,
                color: '#fff',
                textAlign: 'center',
                fontWeight: 700,
                fontSize: 12,
                letterSpacing: '1px',
                textTransform: 'uppercase',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                gap: 6,
                fontFamily: "var(--font-mono)",
            }}>
                {data.label || "Firewall"}
            </div>
            {data.description && (
                <div style={{
                    padding: '8px 12px',
                    fontFamily: "var(--font-mono)",
                    fontSize: 11,
                    color: 'var(--text)',
                    lineHeight: 1.5,
                    whiteSpace: 'pre-wrap',
                    background: 'var(--err-soft)',
                }}>
                    {data.description}
                </div>
            )}
        </div>
    );
}

// ============================================
// ZONE — Container für Netzwerk-Bereich (DMZ, LAN, etc.)
// ============================================
interface ZoneData { label: string; description?: string; }

export function ZoneNode({ data }: { data: ZoneData }) {
    return (
        <div style={{
            background: `color-mix(in srgb, ${EMERALD} 6%, transparent)`,
            border: `2px dashed ${EMERALD}`,
            borderRadius: 12,
            minWidth: 220,
            minHeight: 120,
            padding: '14px',
            fontFamily: "var(--font-sans)",
            position: 'relative',
        }}>
            <AllHandles />
            <div style={{
                position: 'absolute',
                top: 8,
                left: 14,
                background: EMERALD,
                color: '#fff',
                padding: '3px 10px',
                borderRadius: 5,
                fontFamily: "var(--font-mono)",
                fontSize: 10,
                fontWeight: 700,
                letterSpacing: '1px',
                textTransform: 'uppercase',
            }}>
                {data.label || "Zone"}
            </div>
            {data.description && (
                <div style={{
                    marginTop: 24,
                    padding: '8px 0 0',
                    fontFamily: "var(--font-mono)",
                    fontSize: 11,
                    color: EMERALD,
                    lineHeight: 1.5,
                    whiteSpace: 'pre-wrap',
                    fontStyle: 'italic',
                }}>
                    {data.description}
                </div>
            )}
        </div>
    );
}

// ============================================
// INTERNET — Wolke
// ============================================
interface InternetData { label: string; }

export function InternetNode({ data }: { data: InternetData }) {
    return (
        <div style={{
            background: 'var(--surface)',
            border: `2px solid var(--line-2)`,
            borderRadius: 30,
            padding: '12px 24px',
            minWidth: 140,
            textAlign: 'center',
            boxShadow: 'var(--shadow)',
            fontFamily: "var(--font-sans)",
            fontWeight: 600,
            fontSize: 13,
            color: 'var(--text)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: 8,
            position: 'relative',
        }}>
            <Handle type="target" position={Position.Top}    id="top"    style={{ background: 'var(--text-3)', border: '2px solid var(--surface)' }} />
            <Handle type="source" position={Position.Bottom} id="bottom" style={{ background: 'var(--text-3)', border: '2px solid var(--surface)' }} />
            <Handle type="target" position={Position.Left}   id="left"   style={{ background: 'var(--text-3)', border: '2px solid var(--surface)' }} />
            <Handle type="source" position={Position.Right}  id="right"  style={{ background: 'var(--text-3)', border: '2px solid var(--surface)' }} />
            {data.label || "Internet"}
        </div>
    );
}