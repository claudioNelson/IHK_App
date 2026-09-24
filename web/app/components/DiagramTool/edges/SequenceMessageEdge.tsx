"use client";

import { EdgeProps, EdgeLabelRenderer, BaseEdge, getStraightPath } from "reactflow";

const ROSE = "var(--accent)";
const ROSE_DARK = "var(--accent)";

export type SequenceMessageType = "sync" | "async" | "return";

interface SequenceMessageData {
    label?: string;
    messageType?: SequenceMessageType;
}

export default function SequenceMessageEdge({
    id,
    sourceX,
    sourceY,
    targetX,
    targetY,
    data,
    markerEnd,
}: EdgeProps<SequenceMessageData>) {
    const messageType: SequenceMessageType = data?.messageType ?? "sync";

    // Gerade horizontale Linie (Y wird auf Source-Y gezwungen für strikt horizontal)
    const [edgePath, labelX, labelY] = getStraightPath({
        sourceX,
        sourceY,
        targetX,
        targetY: sourceY, // horizontal
    });

    // Style je nach Nachrichtentyp
    const isDashed = messageType === "return";
    const isFilledArrow = messageType === "sync";

    // Eindeutige Marker-IDs pro Edge
    const markerId = `seq-arrow-${id}`;

    return (
        <>
            {/* Pfeilspitzen-Definition */}
            <defs>
                <marker
                    id={markerId}
                    viewBox="0 0 10 10"
                    refX="9"
                    refY="5"
                    markerWidth="10"
                    markerHeight="10"
                    orient="auto-start-reverse"
                >
                    {isFilledArrow ? (
                        // Gefüllte Pfeilspitze (synchron)
                        <path d="M 0 0 L 10 5 L 0 10 z" fill={ROSE} />
                    ) : (
                        // Offene Pfeilspitze (async / return)
                        <path
                            d="M 0 0 L 10 5 L 0 10"
                            fill="none"
                            stroke={ROSE}
                            strokeWidth="1.5"
                        />
                    )}
                </marker>
            </defs>

            <BaseEdge
                id={id}
                path={edgePath}
                markerEnd={`url(#${markerId})`}
                style={{
                    stroke: ROSE,
                    strokeWidth: 1.5,
                    strokeDasharray: isDashed ? "6 4" : undefined,
                }}
            />

            {/* Label über dem Pfeil */}
            {data?.label && (
                <EdgeLabelRenderer>
                    <div
                        style={{
                            position: 'absolute',
                            transform: `translate(-50%, -100%) translate(${labelX}px, ${labelY}px)`,
                            background: 'var(--surface)',
                            padding: '2px 8px',
                            borderRadius: 4,
                            border: `1px solid color-mix(in srgb, ${ROSE} 30%, transparent)`,
                            fontSize: 11,
                            fontFamily: "var(--font-mono)",
                            color: ROSE_DARK,
                            pointerEvents: 'all',
                            whiteSpace: 'nowrap',
                        }}
                        className="nodrag nopan"
                    >
                        {data.label}
                    </div>
                </EdgeLabelRenderer>
            )}
        </>
    );
}