"use client";

import { Handle, Position } from "reactflow";

const BLUE = "#3B82F6";
const BLUE_DARK = "#1D4ED8";

// Wiederverwendbare Handles
function AllHandles({ color = BLUE }: { color?: string }) {
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
// ENTITY — Rechteck mit Name + optional Attributen
// ============================================
interface EntityData { label: string; description?: string; }

export function EntityNode({ data }: { data: EntityData }) {
    return (
        <div style={{
            background: '#FFFFFF',
            border: `1.5px solid ${BLUE}`,
            borderRadius: 4,
            minWidth: 140,
            boxShadow: `0 4px 12px ${BLUE}20`,
            fontFamily: "'Inter Tight', system-ui, sans-serif",
            overflow: 'hidden',
        }}>
            <AllHandles />
            <div style={{
                padding: '10px 14px',
                background: `linear-gradient(135deg, ${BLUE}, ${BLUE_DARK})`,
                color: '#FFFFFF',
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
                    fontFamily: "'JetBrains Mono', monospace",
                    fontSize: 11,
                    color: '#0A0A0F',
                    lineHeight: 1.6,
                    whiteSpace: 'pre-wrap',
                    background: '#FAFAF9',
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
            <Handle type="target" position={Position.Top}    id="top"    style={{ background: BLUE, border: '2px solid #fff' }} />
            <Handle type="source" position={Position.Bottom} id="bottom" style={{ background: BLUE, border: '2px solid #fff' }} />
            <Handle type="source" position={Position.Left}   id="left"   style={{ background: BLUE, border: '2px solid #fff' }} />
            <Handle type="source" position={Position.Right}  id="right"  style={{ background: BLUE, border: '2px solid #fff' }} />
            <div style={{
                position: 'absolute',
                inset: 8,
                background: '#FFFFFF',
                border: `1.5px solid ${BLUE}`,
                transform: 'rotate(45deg) scale(0.8)',
                boxShadow: `0 4px 12px ${BLUE}25`,
            }} />
            <span style={{
                position: 'relative',
                zIndex: 10,
                fontSize: 12,
                fontWeight: 600,
                color: BLUE_DARK,
                textAlign: 'center',
                padding: 4,
                fontFamily: "'Inter Tight', system-ui, sans-serif",
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
            background: isPK ? '#FEF3C7' : '#FFFFFF',
            border: `1.5px solid ${isPK ? '#F59E0B' : BLUE}`,
            borderRadius: 999,
            padding: '8px 18px',
            minWidth: 80,
            textAlign: 'center',
            boxShadow: isPK
                ? '0 4px 12px rgba(245,158,11,0.20)'
                : `0 4px 12px ${BLUE}20`,
            fontFamily: "'Inter Tight', system-ui, sans-serif",
            fontSize: 12,
            fontWeight: isPK ? 700 : 500,
            color: isPK ? '#92400E' : '#0A0A0F',
            textDecoration: isPK ? 'underline' : 'none',
            position: 'relative',
        }}>
            <Handle type="target" position={Position.Top} id="top" style={{ background: isPK ? '#F59E0B' : BLUE, border: '2px solid #fff' }} />
            <Handle type="source" position={Position.Bottom} id="bottom" style={{ background: isPK ? '#F59E0B' : BLUE, border: '2px solid #fff' }} />
            <Handle type="target" position={Position.Left} id="left" style={{ background: isPK ? '#F59E0B' : BLUE, border: '2px solid #fff' }} />
            <Handle type="source" position={Position.Right} id="right" style={{ background: isPK ? '#F59E0B' : BLUE, border: '2px solid #fff' }} />
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
            background: '#FFFFFF',
            border: `1px solid ${BLUE}`,
            borderRadius: 4,
            padding: '3px 8px',
            fontFamily: "'JetBrains Mono', monospace",
            fontSize: 11,
            fontWeight: 700,
            color: BLUE_DARK,
            boxShadow: `0 2px 6px ${BLUE}15`,
            position: 'relative',
        }}>
            <Handle type="target" position={Position.Top} id="top" style={{ background: BLUE, border: '1px solid #fff', width: 6, height: 6 }} />
            <Handle type="source" position={Position.Bottom} id="bottom" style={{ background: BLUE, border: '1px solid #fff', width: 6, height: 6 }} />
            <Handle type="target" position={Position.Left} id="left" style={{ background: BLUE, border: '1px solid #fff', width: 6, height: 6 }} />
            <Handle type="source" position={Position.Right} id="right" style={{ background: BLUE, border: '1px solid #fff', width: 6, height: 6 }} />
            {data.label || "1:n"}
        </div>
    );
}