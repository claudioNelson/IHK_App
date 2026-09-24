"use client";

import { Handle, Position } from "reactflow";

const BLUE = "var(--accent)";
const BLUE_DARK = "var(--accent-2)";

// Wiederverwendbare Handles
function AllHandles({ color = BLUE }: { color?: string }) {
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
// ENTITY — Rechteck mit Name + optional Attributen
// ============================================
interface EntityData { label: string; description?: string; }

export function EntityNode({ data }: { data: EntityData }) {
    return (
        <div style={{
            background: 'var(--surface)',
            border: `1.5px solid ${BLUE}`,
            borderRadius: 4,
            minWidth: 140,
            boxShadow: `0 4px 12px color-mix(in srgb, ${BLUE} 15%, transparent)`,
            fontFamily: "var(--font-sans)",
            overflow: 'hidden',
        }}>
            <AllHandles />
            <div style={{
                padding: '10px 14px',
                background: `linear-gradient(135deg, ${BLUE}, ${BLUE_DARK})`,
                color: '#fff',
                textAlign: 'center',
                fontWeight: 600,
                fontSize: 13,
                letterSpacing: '0.2px',
                textTransform: 'uppercase',
            }}>
                {data.label || "ENTITY"}
            </div>
            {data.description && (
                <div style={{
                    padding: '8px 12px',
                    fontFamily: "var(--font-mono)",
                    fontSize: 11,
                    color: 'var(--text)',
                    lineHeight: 1.6,
                    whiteSpace: 'pre-wrap',
                    background: 'var(--bg-2)',
                }}>
                    {data.description}
                </div>
            )}
        </div>
    );
}

// ============================================
// RELATIONSHIP — Raute zwischen Entities
// ============================================
interface RelationshipData { label: string; }

export function RelationshipNode({ data }: { data: RelationshipData }) {
    return (
        <div style={{
            position: 'relative',
            width: 130,
            height: 70,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
        }}>
            <Handle type="target" position={Position.Top}    id="top"    style={{ background: BLUE, border: '2px solid var(--surface)' }} />
            <Handle type="source" position={Position.Bottom} id="bottom" style={{ background: BLUE, border: '2px solid var(--surface)' }} />
            <Handle type="source" position={Position.Left}   id="left"   style={{ background: BLUE, border: '2px solid var(--surface)' }} />
            <Handle type="source" position={Position.Right}  id="right"  style={{ background: BLUE, border: '2px solid var(--surface)' }} />
            <div style={{
                position: 'absolute',
                inset: 8,
                background: 'var(--surface)',
                border: `1.5px solid ${BLUE}`,
                transform: 'rotate(45deg) scale(0.8)',
                boxShadow: `0 4px 12px color-mix(in srgb, ${BLUE} 18%, transparent)`,
            }} />
            <span style={{
                position: 'relative',
                zIndex: 10,
                fontSize: 12,
                fontWeight: 600,
                color: BLUE,
                textAlign: 'center',
                padding: 4,
                fontFamily: "var(--font-sans)",
                lineHeight: 1.3,
            }}>
                {data.label || "hat"}
            </span>
        </div>
    );
}

// ============================================
// ATTRIBUTE — Oval, optional als Primärschlüssel (unterstrichen)
// ============================================
interface AttributeData { label: string; description?: string; }

export function AttributeNode({ data }: { data: AttributeData }) {
    const isPK = data.description === "pk" || data.description === "PK";

    return (
        <div style={{
            background: isPK ? 'var(--warn-soft)' : 'var(--surface)',
            border: `1.5px solid ${isPK ? 'var(--warn)' : BLUE}`,
            borderRadius: 999,
            padding: '8px 18px',
            minWidth: 80,
            textAlign: 'center',
            boxShadow: isPK
                ? 'var(--shadow)'
                : `0 4px 12px color-mix(in srgb, ${BLUE} 15%, transparent)`,
            fontFamily: "var(--font-sans)",
            fontSize: 12,
            fontWeight: isPK ? 700 : 500,
            color: isPK ? 'var(--warn)' : 'var(--text)',
            textDecoration: isPK ? 'underline' : 'none',
            position: 'relative',
        }}>
            <Handle type="target" position={Position.Top} id="top" style={{ background: isPK ? 'var(--warn)' : BLUE, border: '2px solid var(--surface)' }} />
            <Handle type="source" position={Position.Bottom} id="bottom" style={{ background: isPK ? 'var(--warn)' : BLUE, border: '2px solid var(--surface)' }} />
            <Handle type="target" position={Position.Left} id="left" style={{ background: isPK ? 'var(--warn)' : BLUE, border: '2px solid var(--surface)' }} />
            <Handle type="source" position={Position.Right} id="right" style={{ background: isPK ? 'var(--warn)' : BLUE, border: '2px solid var(--surface)' }} />
            {data.label || "attr"}
        </div>
    );
}

// ============================================
// CARDINALITY — Kleine Beschriftung
// ============================================
interface CardinalityData { label: string; }

export function CardinalityNode({ data }: { data: CardinalityData }) {
    return (
        <div style={{
            background: 'var(--surface)',
            border: `1px solid ${BLUE}`,
            borderRadius: 4,
            padding: '3px 8px',
            fontFamily: "var(--font-mono)",
            fontSize: 11,
            fontWeight: 700,
            color: BLUE,
            boxShadow: `0 2px 6px color-mix(in srgb, ${BLUE} 12%, transparent)`,
            position: 'relative',
        }}>
            <Handle type="target" position={Position.Top} id="top" style={{ background: BLUE, border: '1px solid var(--surface)', width: 6, height: 6 }} />
            <Handle type="source" position={Position.Bottom} id="bottom" style={{ background: BLUE, border: '1px solid var(--surface)', width: 6, height: 6 }} />
            <Handle type="target" position={Position.Left} id="left" style={{ background: BLUE, border: '1px solid var(--surface)', width: 6, height: 6 }} />
            <Handle type="source" position={Position.Right} id="right" style={{ background: BLUE, border: '1px solid var(--surface)', width: 6, height: 6 }} />
            {data.label || "1:n"}
        </div>
    );
}