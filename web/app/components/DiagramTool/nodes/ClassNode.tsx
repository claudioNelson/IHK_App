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
                    background: #FFFFFF;
                    border: 1.5px solid #7C6DFF;
                    border-radius: 10px;
                    min-width: 180px;
                    box-shadow: 0 4px 12px rgba(124,109,255,0.10);
                    font-family: 'Inter Tight', system-ui, sans-serif;
                    overflow: hidden;
                }

                /* Klassenname Header */
                .class-node-header {
                    background: linear-gradient(135deg, #7C6DFF, #6856E6);
                    color: #FFFFFF;
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
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 11px;
                    color: #0A0A0F;
                    line-height: 1.55;
                    white-space: pre-wrap;
                    word-break: break-word;
                }
                .class-node-section.empty {
                    color: #C0C0C8;
                    font-style: italic;
                }

                /* Trenner zwischen Attribute und Methoden */
                .class-node-divider {
                    height: 1px;
                    background: rgba(124,109,255,0.20);
                    margin: 0;
                }

                /* React-Flow Handles */
                .class-node :global(.react-flow__handle) {
                    width: 8px;
                    height: 8px;
                    background: #7C6DFF;
                    border: 2px solid #FFFFFF;
                }
                .class-node :global(.react-flow__handle:hover) {
                    background: #6856E6;
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