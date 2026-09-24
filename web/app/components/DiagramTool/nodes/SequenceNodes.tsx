"use client";

import { Handle, Position } from "reactflow";

const ROSE = "var(--accent)";
const ROSE_DARK = "var(--accent)";
const ROSE_LIGHT = "var(--accent-soft)";

// ============================================
// LIFELINE — Objekt-Box oben + gestrichelte vertikale Linie nach unten
// ============================================
interface LifelineData {
    label: string;
    description?: string;
    lineHeight?: number; // Höhe der Lifeline-Linie (Default 400px)
}

export function LifelineNode({ data }: { data: LifelineData }) {
    const lineHeight = data.lineHeight ?? 400;

    return (
        <div style={{
            position: 'relative',
            minWidth: 140,
            maxWidth: 220,
            fontFamily: "var(--font-sans)",
        }}>
            {/* Box oben (Objektkopf) */}
            <div style={{
                background: ROSE_LIGHT,
                border: `1.5px solid ${ROSE}`,
                borderRadius: 6,
                padding: '10px 14px',
                textAlign: 'center',
                fontWeight: 600,
                fontSize: 13,
                color: ROSE_DARK,
                boxShadow: `0 4px 12px color-mix(in srgb, ${ROSE} 18%, transparent)`,
                position: 'relative',
                zIndex: 2,
            }}>
                {/* Handles am Kopf */}
                <Handle
                    type="source"
                    position={Position.Right}
                    id="right"
                    style={{ background: ROSE, border: '2px solid var(--surface)', top: '50%' }}
                />
                <Handle
                    type="target"
                    position={Position.Left}
                    id="left"
                    style={{ background: ROSE, border: '2px solid var(--surface)', top: '50%' }}
                />

                <div style={{ fontFamily: "var(--font-mono)", fontSize: 10, color: ROSE, opacity: 0.7, marginBottom: 2 }}>
                    :Objekt
                </div>
                {data.label || "Lifeline"}
                {data.description && (
                    <div style={{
                        marginTop: 4,
                        fontSize: 10,
                        fontFamily: "var(--font-mono)",
                        color: 'var(--text-2)',
                        fontWeight: 400,
                    }}>
                        {data.description}
                    </div>
                )}
            </div>

            {/* Gestrichelte vertikale Linie nach unten */}
            <div style={{
                position: 'absolute',
                top: '100%',
                left: '50%',
                transform: 'translateX(-50%)',
                width: 0,
                height: lineHeight,
                borderLeft: `1.5px dashed ${ROSE}`,
                pointerEvents: 'none',
                zIndex: 1,
            }} />

            {/* Unsichtbare Connect-Handles entlang der Linie (für Nachrichten) */}
            <Handle
                type="source"
                position={Position.Right}
                id="line-right"
                style={{
                    background: ROSE,
                    border: '2px solid var(--surface)',
                    top: lineHeight / 2 + 40,
                    opacity: 0.6,
                }}
            />
            <Handle
                type="target"
                position={Position.Left}
                id="line-left"
                style={{
                    background: ROSE,
                    border: '2px solid var(--surface)',
                    top: lineHeight / 2 + 40,
                    opacity: 0.6,
                }}
            />
        </div>
    );
}

// ============================================
// ACTIVATION — Aktivierungsbalken (schmaler vertikaler Streifen auf der Lifeline)
// ============================================
interface ActivationData {
    label?: string;
    height?: number; // Höhe in px (Default 80)
}

export function ActivationNode({ data }: { data: ActivationData }) {
    const height = data.height ?? 80;

    return (
        <div style={{
            position: 'relative',
            width: 16,
            height: height,
            background: 'var(--surface)',
            border: `1.5px solid ${ROSE}`,
            borderRadius: 2,
            boxShadow: `0 2px 6px color-mix(in srgb, ${ROSE} 20%, transparent)`,
        }}>
            {/* Handles oben und unten für Nachrichten */}
            <Handle
                type="target"
                position={Position.Left}
                id="left-top"
                style={{ background: ROSE, border: '2px solid var(--surface)', top: 8 }}
            />
            <Handle
                type="source"
                position={Position.Right}
                id="right-top"
                style={{ background: ROSE, border: '2px solid var(--surface)', top: 8 }}
            />
            <Handle
                type="target"
                position={Position.Left}
                id="left-bottom"
                style={{ background: ROSE, border: '2px solid var(--surface)', top: height - 12 }}
            />
            <Handle
                type="source"
                position={Position.Right}
                id="right-bottom"
                style={{ background: ROSE, border: '2px solid var(--surface)', top: height - 12 }}
            />

            {/* Optionales Label seitlich */}
            {data.label && (
                <div style={{
                    position: 'absolute',
                    left: 20,
                    top: '50%',
                    transform: 'translateY(-50%)',
                    fontSize: 10,
                    fontFamily: "var(--font-mono)",
                    color: ROSE_DARK,
                    whiteSpace: 'nowrap',
                    pointerEvents: 'none',
                }}>
                    {data.label}
                </div>
            )}
        </div>
    );
}