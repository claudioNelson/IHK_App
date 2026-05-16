"use client";

import { Handle, Position } from "reactflow";

const CYAN = "#22D3EE";
const CYAN_DARK = "#0891B2";

// Wiederverwendbarer Handle-Block für alle Knoten
function AllHandles({ color = CYAN }: { color?: string }) {
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
// START — Gefüllter Kreis
// ============================================
export function StartNode() {
    return (
        <div style={{
            width: 36, height: 36, borderRadius: '50%',
            background: '#0A0A0F',
            boxShadow: '0 4px 12px rgba(10,10,15,0.20)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
            <Handle type="source" position={Position.Bottom} id="bottom" style={{ background: CYAN, border: '2px solid #fff' }} />
            <Handle type="source" position={Position.Top} id="top" style={{ background: CYAN, border: '2px solid #fff' }} />
            <Handle type="source" position={Position.Left} id="left" style={{ background: CYAN, border: '2px solid #fff' }} />
            <Handle type="source" position={Position.Right} id="right" style={{ background: CYAN, border: '2px solid #fff' }} />
        </div>
    );
}

// ============================================
// END — Doppelkreis (Ring außen, gefüllt innen)
// ============================================
export function EndNode() {
    return (
        <div style={{
            width: 36, height: 36, borderRadius: '50%',
            border: '2.5px solid #0A0A0F',
            background: '#FFFFFF',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            boxShadow: '0 4px 12px rgba(10,10,15,0.15)',
        }}>
            <Handle type="target" position={Position.Top} id="top" style={{ background: CYAN, border: '2px solid #fff' }} />
            <Handle type="target" position={Position.Bottom} id="bottom" style={{ background: CYAN, border: '2px solid #fff' }} />
            <Handle type="target" position={Position.Left} id="left" style={{ background: CYAN, border: '2px solid #fff' }} />
            <Handle type="target" position={Position.Right} id="right" style={{ background: CYAN, border: '2px solid #fff' }} />
            <div style={{
                width: 18, height: 18, borderRadius: '50%',
                background: '#0A0A0F',
            }} />
        </div>
    );
}

// ============================================
// ACTION — Abgerundetes Rechteck
// ============================================
interface ActionData { label: string; description?: string; }

export function ActionNode({ data }: { data: ActionData }) {
    return (
        <div style={{
            background: '#FFFFFF',
            border: `1.5px solid ${CYAN}`,
            borderRadius: 18,
            minWidth: 140,
            maxWidth: 220,
            boxShadow: `0 4px 12px ${CYAN}25`,
            fontFamily: "'Inter Tight', system-ui, sans-serif",
            overflow: 'hidden',
        }}>
            <AllHandles />
            <div style={{
                padding: '8px 14px',
                background: `linear-gradient(135deg, ${CYAN}, ${CYAN_DARK})`,
                color: '#FFFFFF',
                textAlign: 'center',
                fontWeight: 600,
                fontSize: 13,
                letterSpacing: '-0.2px',
            }}>
                {data.label || "Aktion"}
            </div>
            {data.description && (
                <div style={{
                    padding: '8px 12px',
                    fontSize: 11,
                    color: '#55555F',
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
// DECISION — Raute
// ============================================
interface DecisionData { label: string; }

export function DecisionNode({ data }: { data: DecisionData }) {
    return (
        <div style={{
            position: 'relative',
            width: 100,
            height: 100,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
        }}>
            <Handle type="target" position={Position.Top}    id="top"    style={{ background: CYAN, border: '2px solid #fff' }} />
            <Handle type="source" position={Position.Bottom} id="bottom" style={{ background: CYAN, border: '2px solid #fff' }} />
            <Handle type="source" position={Position.Left}   id="left"   style={{ background: CYAN, border: '2px solid #fff' }} />
            <Handle type="source" position={Position.Right}  id="right"  style={{ background: CYAN, border: '2px solid #fff' }} />
            <div style={{
                position: 'absolute',
                inset: 10,
                background: '#FFFFFF',
                border: `1.5px solid ${CYAN}`,
                transform: 'rotate(45deg)',
                boxShadow: `0 4px 12px ${CYAN}25`,
            }} />
            <span style={{
                position: 'relative',
                zIndex: 10,
                fontSize: 11,
                fontWeight: 600,
                color: CYAN_DARK,
                textAlign: 'center',
                padding: 4,
                fontFamily: "'Inter Tight', system-ui, sans-serif",
                lineHeight: 1.3,
            }}>
                {data.label || "?"}
            </span>
        </div>
    );
}

// ============================================
// FORK / JOIN — Balken (synchronisation)
// ============================================
export function ForkNode() {
    return (
        <div style={{
            width: 140,
            height: 6,
            background: '#0A0A0F',
            borderRadius: 3,
            position: 'relative',
            boxShadow: '0 2px 6px rgba(10,10,15,0.25)',
        }}>
            <Handle type="target" position={Position.Top}    id="top"    style={{ background: CYAN, border: '2px solid #fff', top: -3 }} />
            <Handle type="source" position={Position.Bottom} id="bottom-l" style={{ background: CYAN, border: '2px solid #fff', left: '25%', bottom: -3 }} />
            <Handle type="source" position={Position.Bottom} id="bottom-c" style={{ background: CYAN, border: '2px solid #fff', left: '50%', bottom: -3 }} />
            <Handle type="source" position={Position.Bottom} id="bottom-r" style={{ background: CYAN, border: '2px solid #fff', left: '75%', bottom: -3 }} />
        </div>
    );
}

export function JoinNode() {
    return (
        <div style={{
            width: 140,
            height: 6,
            background: '#0A0A0F',
            borderRadius: 3,
            position: 'relative',
            boxShadow: '0 2px 6px rgba(10,10,15,0.25)',
        }}>
            <Handle type="target" position={Position.Top} id="top-l" style={{ background: CYAN, border: '2px solid #fff', left: '25%', top: -3 }} />
            <Handle type="target" position={Position.Top} id="top-c" style={{ background: CYAN, border: '2px solid #fff', left: '50%', top: -3 }} />
            <Handle type="target" position={Position.Top} id="top-r" style={{ background: CYAN, border: '2px solid #fff', left: '75%', top: -3 }} />
            <Handle type="source" position={Position.Bottom} id="bottom" style={{ background: CYAN, border: '2px solid #fff', bottom: -3 }} />
        </div>
    );
}

// ============================================
// NOTE — Sticky Note (geteilt für alle Modi)
// ============================================
interface NoteData { label: string; }

export function NoteNode({ data }: { data: NoteData }) {
    return (
        <div style={{
            background: '#FEF3C7',
            border: '1px solid #F59E0B',
            padding: '10px 12px',
            minWidth: 100,
            maxWidth: 200,
            boxShadow: '0 2px 6px rgba(245,158,11,0.20)',
            clipPath: 'polygon(0 0, calc(100% - 12px) 0, 100% 12px, 100% 100%, 0 100%)',
            fontFamily: "'Inter Tight', system-ui, sans-serif",
            fontSize: 11,
            color: '#92400E',
            lineHeight: 1.5,
            whiteSpace: 'pre-wrap',
        }}>
            <Handle type="target" position={Position.Top} id="top" style={{ background: '#F59E0B', border: '2px solid #fff' }} />
            <Handle type="source" position={Position.Bottom} id="bottom" style={{ background: '#F59E0B', border: '2px solid #fff' }} />
            <Handle type="target" position={Position.Left} id="left" style={{ background: '#F59E0B', border: '2px solid #fff' }} />
            <Handle type="source" position={Position.Right} id="right" style={{ background: '#F59E0B', border: '2px solid #fff' }} />
            {data.label || "Notiz"}
        </div>
    );
}

// ============================================
// INTERFACE — Für UML-Klasse-Modus (gestrichelt)
// ============================================
interface InterfaceData { label: string; description?: string; }

export function InterfaceNode({ data }: { data: InterfaceData }) {
    return (
        <div style={{
            background: '#FFFFFF',
            border: '1.5px dashed #7C6DFF',
            borderRadius: 10,
            minWidth: 150,
            boxShadow: '0 4px 12px rgba(124,109,255,0.10)',
            fontFamily: "'Inter Tight', system-ui, sans-serif",
            overflow: 'hidden',
        }}>
            <AllHandles color="#7C6DFF" />
            <div style={{
                padding: '4px 12px',
                background: 'rgba(124,109,255,0.04)',
                borderBottom: '1px solid rgba(124,109,255,0.20)',
                textAlign: 'center',
                fontFamily: "'JetBrains Mono', monospace",
                fontSize: 10,
                fontWeight: 600,
                color: '#7C6DFF',
                letterSpacing: '1px',
            }}>
                «interface»
            </div>
            <div style={{
                padding: '8px 14px',
                background: 'rgba(124,109,255,0.06)',
                borderBottom: '1px solid rgba(124,109,255,0.20)',
                textAlign: 'center',
                fontWeight: 600,
                fontSize: 13,
                color: '#0A0A0F',
            }}>
                {data.label || "Interface"}
            </div>
            <div style={{
                padding: '8px 12px',
                fontFamily: "'JetBrains Mono', monospace",
                fontSize: 11,
                color: '#0A0A0F',
                lineHeight: 1.5,
                whiteSpace: 'pre-wrap',
                minHeight: 28,
            }}>
                {data.description || ""}
            </div>
        </div>
    );
}

// ============================================
// STATE — Zustand für UML-Zustandsdiagramm (abgerundetes Rechteck, amber)
// ============================================
interface StateData { label: string; description?: string; }

const AMBER = "#F59E0B";
const AMBER_DARK = "#B45309";

export function StateNode({ data }: { data: StateData }) {
    return (
        <div style={{
            background: '#FFFFFF',
            border: `1.5px solid ${AMBER}`,
            borderRadius: 14,
            minWidth: 140,
            maxWidth: 220,
            boxShadow: `0 4px 12px ${AMBER}25`,
            fontFamily: "'Inter Tight', system-ui, sans-serif",
            overflow: 'hidden',
        }}>
            <AllHandles color={AMBER} />
            <div style={{
                padding: '8px 14px',
                background: `${AMBER}10`,
                borderBottom: `1px solid ${AMBER}30`,
                textAlign: 'center',
                fontWeight: 600,
                fontSize: 13,
                color: AMBER_DARK,
            }}>
                {data.label || "Zustand"}
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