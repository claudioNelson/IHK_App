"use client";

import { Handle, Position } from "reactflow";

interface ClassNodeData {
    label: string;
    description?: string;  // Format: "attributes\n---\nmethods"
}

export default function ClassNode({ data }: { data: ClassNodeData }) {
    // Parse description: Vor "---" = Attribute, Nach "---" = Methoden
    const parts = (data.description || "").split("---");
    const attributes = parts[0]?.trim() || "";
    const methods = parts[1]?.trim() || "";

    return (
        <div className="class-node">
            <style>{`
                .class-node {
                    background: var(--surface);
                    border: 1.5px solid var(--accent);
                    border-radius: var(--r-btn);
                    min-width: 180px;
                    box-shadow: var(--shadow);
                    font-family: var(--font-sans);
                    overflow: hidden;
                }

                /* Klassenname Header */
                .class-node-header {
                    background: linear-gradient(135deg, var(--accent), var(--accent-2));
                    color: #fff;
                    padding: 10px 14px;
                    text-align: center;
                    font-weight: 600;
                    font-size: 14px;
                    letter-spacing: -0.2px;
                    border-bottom: 1px solid rgba(255,255,255,0.15);
                }

                /* Bereich Attribute */
                .class-node-section {
                    padding: 8px 12px;
                    min-height: 28px;
                    font-family: var(--font-mono);
                    font-size: 11px;
                    color: var(--text);
                    line-height: 1.55;
                    white-space: pre-wrap;
                    word-break: break-word;
                }
                .class-node-section.empty {
                    color: var(--text-3);
                    font-style: italic;
                }

                /* Trenner zwischen Attribute und Methoden */
                .class-node-divider {
                    height: 1px;
                    background: color-mix(in srgb, var(--accent) 20%, transparent);
                    margin: 0;
                }

                /* React-Flow Handles */
                .class-node :global(.react-flow__handle) {
                    width: 8px;
                    height: 8px;
                    background: var(--accent);
                    border: 2px solid var(--surface);
                }
                .class-node :global(.react-flow__handle:hover) {
                    background: var(--accent-2);
                    transform: scale(1.3);
                }
            `}</style>

            {/* Connection Handles */}
            <Handle type="target" position={Position.Top}    id="top" />
            <Handle type="source" position={Position.Bottom} id="bottom" />
            <Handle type="target" position={Position.Left}   id="left" />
            <Handle type="source" position={Position.Right}  id="right" />

            {/* Klassenname */}
            <div className="class-node-header">
                {data.label || "Klasse"}
            </div>

            {/* Attribute */}
            <div className={`class-node-section ${!attributes ? "empty" : ""}`}>
                {attributes || "(Attribute)"}
            </div>

            <div className="class-node-divider" />

            {/* Methoden */}
            <div className={`class-node-section ${!methods ? "empty" : ""}`}>
                {methods || "(Methoden)"}
            </div>
        </div>
    );
}