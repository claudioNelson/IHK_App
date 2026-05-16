"use client";

import { Handle, Position } from "reactflow";

const EMERALD = "#10B981";
const EMERALD_DARK = "#047857";
const RED_FIREWALL = "#DC2626";

// Wiederverwendbare Handles
function AllHandles({ color = EMERALD }: { color?: string }) {
    return (
        <>
            <Handle type="target" position={Position.Top}    id="top"    style={{ background: color, border: '2px solid #fff' }} />
            <Handle type="source" position={Position.Bottom} id="bottom" style={{ background: color, border: '2px solid #fff' }} />
            <Handle type="target" position={Position.Left}   id="left"   style={{ background: color, border: '2px solid #fff' }} />
            <Handle type="source" position={Position.Right}  id="right"  style={{ background: color, border: '2px solid #fff' }} />
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
            background: '#FFFFFF',
            border: `1.5px solid ${EMERALD}`,
            borderRadius: 8,
            minWidth: 130,
            boxShadow: `0 4px 12px ${EMERALD}25`,
            fontFamily: "'Inter Tight', system-ui, sans-serif",
            overflow: 'hidden',
        }}>
            <AllHandles />
            <div style={{
                padding: '8px 14px',
                background: `linear-gradient(135deg, ${EMERALD}, ${EMERALD_DARK})`,
                color: '#FFFFFF',
                textAlign: 'center',
                fontWeight: 600,
                fontSize: 13,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                gap: 6,
            }}>
                <span style={{ fontSize: 14 }}>🖥️</span>
                {data.label || "Server"}
            </div>
            {data.description && (
                <div style={{
                    padding: '8px 12px',
                    fontFamily: "'JetBrains Mono', monospace",
                    fontSize: 11,
                    color: '#0A0A0F',
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
            background: '#FFFFFF',
            border: `2px solid ${RED_FIREWALL}`,
            borderRadius: 8,
            minWidth: 130,
            boxShadow: `0 4px 12px ${RED_FIREWALL}30`,
            fontFamily: "'Inter Tight', system-ui, sans-serif",
            overflow: 'hidden',
        }}>
            <AllHandles color={RED_FIREWALL} />
            <div style={{
                padding: '8px 14px',
                background: `linear-gradient(135deg, ${RED_FIREWALL}, #991B1B)`,
                color: '#FFFFFF',
                textAlign: 'center',
                fontWeight: 700,
                fontSize: 12,
                letterSpacing: '1px',
                textTransform: 'uppercase',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                gap: 6,
                fontFamily: "'JetBrains Mono', monospace",
            }}>
                🔥 {data.label || "Firewall"}
            </div>
            {data.description && (
                <div style={{
                    padding: '8px 12px',
                    fontFamily: "'JetBrains Mono', monospace",
                    fontSize: 11,
                    color: '#0A0A0F',
                    lineHeight: 1.5,
                    whiteSpace: 'pre-wrap',
                    background: '#FEF2F2',
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
            background: `${EMERALD}08`,
            border: `2px dashed ${EMERALD}`,
            borderRadius: 12,
            minWidth: 220,
            minHeight: 120,
            padding: '14px',
            fontFamily: "'Inter Tight', system-ui, sans-serif",
            position: 'relative',
        }}>
            <AllHandles />
            <div style={{
                position: 'absolute',
                top: 8,
                left: 14,
                background: EMERALD,
                color: '#FFFFFF',
                padding: '3px 10px',
                borderRadius: 5,
                fontFamily: "'JetBrains Mono', monospace",
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
                    fontFamily: "'JetBrains Mono', monospace",
                    fontSize: 11,
                    color: EMERALD_DARK,
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
            background: '#FFFFFF',
            border: `2px solid #6B7280`,
            borderRadius: 30,
            padding: '12px 24px',
            minWidth: 140,
            textAlign: 'center',
            boxShadow: '0 4px 12px rgba(107,114,128,0.20)',
            fontFamily: "'Inter Tight', system-ui, sans-serif",
            fontWeight: 600,
            fontSize: 13,
            color: '#0A0A0F',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            gap: 8,
            position: 'relative',
        }}>
            <Handle type="target" position={Position.Top}    id="top"    style={{ background: '#6B7280', border: '2px solid #fff' }} />
            <Handle type="source" position={Position.Bottom} id="bottom" style={{ background: '#6B7280', border: '2px solid #fff' }} />
            <Handle type="target" position={Position.Left}   id="left"   style={{ background: '#6B7280', border: '2px solid #fff' }} />
            <Handle type="source" position={Position.Right}  id="right"  style={{ background: '#6B7280', border: '2px solid #fff' }} />
            <span style={{ fontSize: 16 }}>🌐</span>
            {data.label || "Internet"}
        </div>
    );
}