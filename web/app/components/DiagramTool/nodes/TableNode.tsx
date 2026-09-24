"use client";

import { Handle, Position } from "reactflow";

const SLATE = "var(--accent)";
const SLATE_DARK = "var(--accent-2)";
const PK_YELLOW = "var(--warn)";
const FK_INDIGO = "var(--accent)";

interface TableNodeData {
    label: string;          // Tabellenname
    description?: string;   // Spalten, eine pro Zeile
}

// Parse-Logik: Erkennt PK und FK Markierungen
function parseColumn(line: string): { name: string; isPK: boolean; isFK: boolean } {
    const trimmed = line.trim();
    const isPK = /\(PK\)/i.test(trimmed) || trimmed.startsWith("PK:");
    const isFK = /\(FK\)/i.test(trimmed) || trimmed.startsWith("FK:");
    const name = trimmed
        .replace(/\s*\(PK\)/gi, "")
        .replace(/\s*\(FK\)/gi, "")
        .replace(/^PK:\s*/i, "")
        .replace(/^FK:\s*/i, "")
        .trim();
    return { name, isPK, isFK };
}

export default function TableNode({ data }: { data: TableNodeData }) {
    const lines = (data.description || "").split("\n").filter((l) => l.trim() !== "");
    const columns = lines.length > 0
        ? lines.map(parseColumn)
        : [{ name: "id (PK)", isPK: true, isFK: false }];

    return (
        <div className="tn-wrap">
            <style>{`
                .tn-wrap {
                    background: var(--surface);
                    border: 1.5px solid ${SLATE_DARK};
                    border-radius: 6px;
                    min-width: 180px;
                    box-shadow: var(--shadow);
                    font-family: var(--font-sans);
                    overflow: hidden;
                }

                .tn-header {
                    background: ${SLATE_DARK};
                    color: #fff;
                    padding: 8px 14px;
                    text-align: center;
                    font-weight: 700;
                    font-size: 12px;
                    letter-spacing: 1px;
                    text-transform: uppercase;
                    font-family: var(--font-mono);
                }

                .tn-body {
                    padding: 0;
                    background: var(--bg-2);
                }

                .tn-col {
                    padding: 7px 14px;
                    font-family: var(--font-mono);
                    font-size: 12px;
                    color: var(--text);
                    border-bottom: 1px solid var(--line);
                    display: flex;
                    align-items: center;
                    gap: 6px;
                }
                .tn-col:last-child { border-bottom: none; }

                .tn-col-name {
                    flex: 1;
                }
                .tn-col.pk .tn-col-name {
                    font-weight: 700;
                    color: var(--text);
                    text-decoration: underline;
                }
                .tn-col.fk .tn-col-name {
                    font-style: italic;
                    color: ${FK_INDIGO};
                }

                .tn-badge {
                    font-size: 9px;
                    font-weight: 700;
                    padding: 2px 5px;
                    border-radius: 3px;
                    letter-spacing: 0.5px;
                }
                .tn-badge.pk {
                    background: var(--warn-soft);
                    color: ${PK_YELLOW};
                    border: 1px solid color-mix(in srgb, ${PK_YELLOW} 40%, transparent);
                }
                .tn-badge.fk {
                    background: var(--accent-soft);
                    color: ${FK_INDIGO};
                    border: 1px solid color-mix(in srgb, ${FK_INDIGO} 30%, transparent);
                }

                .tn-wrap :global(.react-flow__handle) {
                    width: 8px;
                    height: 8px;
                    background: ${SLATE};
                    border: 2px solid var(--surface);
                }
            `}</style>

            <Handle type="target" position={Position.Top}    id="top"    />
            <Handle type="source" position={Position.Bottom} id="bottom" />
            <Handle type="target" position={Position.Left}   id="left"   />
            <Handle type="source" position={Position.Right}  id="right"  />

            <div className="tn-header">{data.label || "TABELLE"}</div>

            <div className="tn-body">
                {columns.map((col, i) => (
                    <div key={i} className={`tn-col ${col.isPK ? "pk" : ""} ${col.isFK ? "fk" : ""}`}>
                        <span className="tn-col-name">{col.name || "?"}</span>
                        {col.isPK && <span className="tn-badge pk">PK</span>}
                        {col.isFK && <span className="tn-badge fk">FK</span>}
                    </div>
                ))}
            </div>
        </div>
    );
}