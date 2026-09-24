"use client";

import { Handle, Position } from "reactflow";

const CYAN = "var(--accent)";
const CYAN_DARK = "var(--accent-2)";

// Wiederverwendbarer Handle-Block für alle Knoten
function AllHandles({ color = CYAN }: { color?: string }) {
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
// START — Gefüllter Kreis
// ============================================
export function StartNode() {
    return (
        <div style={{
            width: 36, height: 36, borderRadius: '50%',
            background: 'var(--text)',
            boxShadow: 'var(--shadow)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
            <Handle type="source" position={Position.Bottom} id="bottom" style={{ background: CYAN, border: '2px solid var(--surface)' }} />
            <Handle type="source" position={Position.Top} id="top" style={{ background: CYAN, border: '2px solid var(--surface)' }} />
            <Handle type="source" position={Position.Left} id="left" style={{ background: CYAN, border: '2px solid var(--surface)' }} />
            <Handle type="source" position={Position.Right} id="right" style={{ background: CYAN, border: '2px solid var(--surface)' }} />
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
            border: '2.5px solid var(--text)',
            background: 'var(--surface)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            boxShadow: 'var(--shadow)',
        }}>
            <Handle type="target" position={Position.Top} id="top" style={{ background: CYAN, border: '2px solid var(--surface)' }} />
            <Handle type="target" position={Position.Bottom} id="bottom" style={{ background: CYAN, border: '2px solid var(--surface)' }} />
            <Handle type="target" position={Position.Left} id="left" style={{ background: CYAN, border: '2px solid var(--surface)' }} />
            <Handle type="target" position={Position.Right} id="right" style={{ background: CYAN, border: '2px solid var(--surface)' }} />
            <div style={{
                width: 18, height: 18, borderRadius: '50%',
                background: 'var(--text)',
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
            background: 'var(--surface)',
            border: `1.5px solid ${CYAN}`,
            borderRadius: 18,
            minWidth: 140,
            maxWidth: 220,
            boxShadow: `0 4px 12px color-mix(in srgb, ${CYAN} 18%, transparent)`,
            fontFamily: "var(--font-sans)",
            overflow: 'hidden',
        }}>
            <AllHandles />
            <div style={{
                padding: '8px 14px',
                background: `linear-gradient(135deg, ${CYAN}, ${CYAN_DARK})`,
                color: '#fff',
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
                    color: 'var(--text-2)',
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
            <Handle type="target" position={Position.Top}    id="top"    style={{ background: CYAN, border: '2px solid var(--surface)' }} />
            <Handle type="source" position={Position.Bottom} id="bottom" style={{ background: CYAN, border: '2px solid var(--surface)' }} />
            <Handle type="source" position={Position.Left}   id="left"   style={{ background: CYAN, border: '2px solid var(--surface)' }} />
            <Handle type="source" position={Position.Right}  id="right"  style={{ background: CYAN, border: '2px solid var(--surface)' }} />
            <div style={{
                position: 'absolute',
                inset: 10,
                background: 'var(--surface)',
                border: `1.5px solid ${CYAN}`,
                transform: 'rotate(45deg)',
                boxShadow: `0 4px 12px color-mix(in srgb, ${CYAN} 18%, transparent)`,
            }} />
            <span style={{
                position: 'relative',
                zIndex: 10,
                fontSize: 11,
                fontWeight: 600,
                color: CYAN,
                textAlign: 'center',
                padding: 4,
                fontFamily: "var(--font-sans)",
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
            background: 'var(--text)',
            borderRadius: 3,
            position: 'relative',
            boxShadow: 'var(--shadow)',
        }}>
            <Handle type="target" position={Position.Top}    id="top"    style={{ background: CYAN, border: '2px solid var(--surface)', top: -3 }} />
            <Handle type="source" position={Position.Bottom} id="bottom-l" style={{ background: CYAN, border: '2px solid var(--surface)', left: '25%', bottom: -3 }} />
            <Handle type="source" position={Position.Bottom} id="bottom-c" style={{ background: CYAN, border: '2px solid var(--surface)', left: '50%', bottom: -3 }} />
            <Handle type="source" position={Position.Bottom} id="bottom-r" style={{ background: CYAN, border: '2px solid var(--surface)', left: '75%', bottom: -3 }} />
        </div>
    );
}

export function JoinNode() {
    return (
        <div style={{
            width: 140,
            height: 6,
            background: 'var(--text)',
            borderRadius: 3,
            position: 'relative',
            boxShadow: 'var(--shadow)',
        }}>
            <Handle type="target" position={Position.Top} id="top-l" style={{ background: CYAN, border: '2px solid var(--surface)', left: '25%', top: -3 }} />
            <Handle type="target" position={Position.Top} id="top-c" style={{ background: CYAN, border: '2px solid var(--surface)', left: '50%', top: -3 }} />
            <Handle type="target" position={Position.Top} id="top-r" style={{ background: CYAN, border: '2px solid var(--surface)', left: '75%', top: -3 }} />
            <Handle type="source" position={Position.Bottom} id="bottom" style={{ background: CYAN, border: '2px solid var(--surface)', bottom: -3 }} />
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
            background: 'var(--warn-soft)',
            border: '1px solid var(--warn)',
            padding: '10px 12px',
            minWidth: 100,
            maxWidth: 200,
            boxShadow: 'var(--shadow)',
            clipPath: 'polygon(0 0, calc(100% - 12px) 0, 100% 12px, 100% 100%, 0 100%)',
            fontFamily: "var(--font-sans)",
            fontSize: 11,
            color: 'var(--warn)',
            lineHeight: 1.5,
            whiteSpace: 'pre-wrap',
        }}>
            <Handle type="target" position={Position.Top} id="top" style={{ background: 'var(--warn)', border: '2px solid var(--surface)' }} />
            <Handle type="source" position={Position.Bottom} id="bottom" style={{ background: 'var(--warn)', border: '2px solid var(--surface)' }} />
            <Handle type="target" position={Position.Left} id="left" style={{ background: 'var(--warn)', border: '2px solid var(--surface)' }} />
            <Handle type="source" position={Position.Right} id="right" style={{ background: 'var(--warn)', border: '2px solid var(--surface)' }} />
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
            background: 'var(--surface)',
            border: '1.5px dashed var(--accent)',
            borderRadius: 10,
            minWidth: 150,
            boxShadow: 'var(--shadow)',
            fontFamily: "var(--font-sans)",
            overflow: 'hidden',
        }}>
            <AllHandles color="var(--accent)" />
            <div style={{
                padding: '4px 12px',
                background: 'color-mix(in srgb, var(--accent) 5%, transparent)',
                borderBottom: '1px solid color-mix(in srgb, var(--accent) 20%, transparent)',
                textAlign: 'center',
                fontFamily: "var(--font-mono)",
                fontSize: 10,
                fontWeight: 600,
                color: 'var(--accent)',
                letterSpacing: '1px',
            }}>
                «interface»
            </div>
            <div style={{
                padding: '8px 14px',
                background: 'color-mix(in srgb, var(--accent) 8%, transparent)',
                borderBottom: '1px solid color-mix(in srgb, var(--accent) 20%, transparent)',
                textAlign: 'center',
                fontWeight: 600,
                fontSize: 13,
                color: 'var(--text)',
            }}>
                {data.label || "Interface"}
            </div>
            <div style={{
                padding: '8px 12px',
                fontFamily: "var(--font-mono)",
                fontSize: 11,
                color: 'var(--text)',
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

const AMBER = "var(--accent)";
const AMBER_DARK = "var(--accent)";

export function StateNode({ data }: { data: StateData }) {
    return (
        <div style={{
            background: 'var(--surface)',
            border: `1.5px solid ${AMBER}`,
            borderRadius: 14,
            minWidth: 140,
            maxWidth: 220,
            boxShadow: `0 4px 12px color-mix(in srgb, ${AMBER} 18%, transparent)`,
            fontFamily: "var(--font-sans)",
            overflow: 'hidden',
        }}>
            <AllHandles color={AMBER} />
            <div style={{
                padding: '8px 14px',
                background: `color-mix(in srgb, ${AMBER} 8%, transparent)`,
                borderBottom: `1px solid color-mix(in srgb, ${AMBER} 30%, transparent)`,
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