"use client";

import React from "react";
import { DecisionMatrix as MatrixData, MatrixRow } from "@/data/exam-types";

interface DecisionMatrixProps {
    questionId: string;
    matrix: MatrixData;
    value: string;                          // serialisierte Antwort aus answers[]
    onChange: (value: string) => void;     // Antwort-Update an Parent
}

// Datenstruktur, die wir als JSON ins answers-Feld serialisieren
interface MatrixAnswer {
    selections: Record<string, string>;     // rowId → selectedColumn
    reasons: Record<string, string>;        // rowId → reason text
}

export default function DecisionMatrix({ matrix, value, onChange }: DecisionMatrixProps) {
    // Aktuelle Antwort parsen (oder leer initialisieren)
    let parsed: MatrixAnswer = { selections: {}, reasons: {} };
    try {
        if (value) parsed = JSON.parse(value);
    } catch {
        // alte Antworten könnten Plain-Text sein - ignorieren
    }

    const updateSelection = (rowId: string, column: string) => {
        const next: MatrixAnswer = {
            selections: { ...parsed.selections, [rowId]: column },
            reasons: parsed.reasons,
        };
        onChange(JSON.stringify(next));
    };

    const updateReason = (rowId: string, reason: string) => {
        const next: MatrixAnswer = {
            selections: parsed.selections,
            reasons: { ...parsed.reasons, [rowId]: reason },
        };
        onChange(JSON.stringify(next));
    };

    return (
        <div className="dm-wrap">
            <style>{`
                .dm-wrap {
                    border: 1px solid rgba(10,10,15,0.08);
                    border-radius: 12px;
                    overflow: hidden;
                    margin-bottom: 14px;
                    background: #FFFFFF;
                }

                .dm-table {
                    width: 100%;
                    border-collapse: collapse;
                    font-family: 'Inter Tight', system-ui, sans-serif;
                    font-size: 13px;
                }

                .dm-table thead {
                    background: #F4F4F1;
                }
                .dm-table th {
                    padding: 12px 14px;
                    text-align: left;
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 11px;
                    font-weight: 600;
                    color: #55555F;
                    letter-spacing: 0.5px;
                    text-transform: uppercase;
                    border-bottom: 1px solid rgba(10,10,15,0.08);
                }
                .dm-table th.col-check {
                    text-align: center;
                    min-width: 90px;
                }

                .dm-row {
                    border-bottom: 1px solid rgba(10,10,15,0.05);
                }
                .dm-row:last-child { border-bottom: none; }
                .dm-row.example { background: rgba(124,109,255,0.04); }

                .dm-row td {
                    padding: 14px;
                    vertical-align: top;
                }
                .dm-row td.col-label {
                    color: #0A0A0F;
                    font-weight: 500;
                    line-height: 1.5;
                    min-width: 240px;
                }
                .dm-row td.col-check {
                    text-align: center;
                    width: 90px;
                }

                .dm-example-tag {
                    display: inline-block;
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 9px;
                    color: #7C6DFF;
                    background: rgba(124,109,255,0.10);
                    border: 1px solid rgba(124,109,255,0.30);
                    padding: 2px 6px;
                    border-radius: 4px;
                    letter-spacing: 0.5px;
                    text-transform: uppercase;
                    margin-bottom: 6px;
                    font-weight: 700;
                }

                /* Radio-Style Checkbox */
                .dm-cell {
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    width: 32px; height: 32px;
                    border-radius: 8px;
                    border: 1.5px solid rgba(10,10,15,0.15);
                    cursor: pointer;
                    transition: all 0.15s;
                    background: #FFFFFF;
                    color: transparent;
                    font-weight: 700;
                    font-size: 15px;
                }
                .dm-cell:hover {
                    border-color: #7C6DFF;
                    background: rgba(124,109,255,0.05);
                }
                .dm-cell.selected {
                    background: #7C6DFF;
                    border-color: #7C6DFF;
                    color: #FFFFFF;
                }
                .dm-cell.example-set {
                    background: rgba(124,109,255,0.15);
                    border-color: rgba(124,109,255,0.30);
                    color: #7C6DFF;
                    cursor: default;
                }

                /* Reason input */
                .dm-reason-row td {
                    padding: 0 14px 14px;
                    background: transparent;
                }
                .dm-reason-row textarea {
                    width: 100%;
                    min-height: 50px;
                    padding: 8px 12px;
                    background: #FAFAF9;
                    border: 1px solid rgba(10,10,15,0.08);
                    border-radius: 8px;
                    font-family: 'Inter Tight', system-ui, sans-serif;
                    font-size: 13px;
                    color: #0A0A0F;
                    resize: vertical;
                    outline: none;
                    transition: border-color 0.15s, box-shadow 0.15s;
                }
                .dm-reason-row textarea::placeholder {
                    color: #8A8A92;
                }
                .dm-reason-row textarea:focus {
                    border-color: #7C6DFF;
                    box-shadow: 0 0 0 3px rgba(124,109,255,0.08);
                }
                .dm-reason-row .reason-label {
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 10px;
                    font-weight: 700;
                    color: #7C6DFF;
                    letter-spacing: 1px;
                    text-transform: uppercase;
                    margin-bottom: 6px;
                    display: block;
                }
                .dm-reason-row.example .reason-text {
                    font-size: 13px;
                    color: #55555F;
                    line-height: 1.5;
                    padding: 8px 12px;
                    background: rgba(124,109,255,0.04);
                    border: 1px dashed rgba(124,109,255,0.30);
                    border-radius: 8px;
                    font-style: italic;
                }

                @media (max-width: 700px) {
                    .dm-table th, .dm-row td { padding: 8px; font-size: 12px; }
                    .dm-row td.col-label { min-width: 180px; }
                    .dm-cell { width: 28px; height: 28px; }
                }
            `}</style>

            <table className="dm-table">
                <thead>
                    <tr>
                        <th>Maßnahme</th>
                        {matrix.columns.map((col) => (
                            <th key={col} className="col-check">{col}</th>
                        ))}
                    </tr>
                </thead>
                <tbody>
                    {matrix.rows.map((row: MatrixRow) => {
                        const selected = parsed.selections[row.id];
                        const reason = parsed.reasons[row.id] || "";

                        return (
                            <React.Fragment key={row.id}>
                                <tr key={row.id} className={`dm-row ${row.example ? "example" : ""}`}>
                                    <td className="col-label">
                                        {row.example && <span className="dm-example-tag">Beispiel</span>}
                                        {row.example && <br />}
                                        {row.label}
                                    </td>
                                    {matrix.columns.map((col) => {
                                        const isSelected = row.example
                                            ? row.exampleColumn === col
                                            : selected === col;
                                        return (
                                            <td key={col} className="col-check">
                                                <button
                                                    type="button"
                                                    className={`dm-cell ${isSelected ? (row.example ? "example-set" : "selected") : ""}`}
                                                    onClick={() => !row.example && updateSelection(row.id, col)}
                                                    disabled={row.example}
                                                    aria-label={`${row.label}: ${col}`}
                                                >
                                                    {isSelected ? "✓" : ""}
                                                </button>
                                            </td>
                                        );
                                    })}
                                </tr>
                                <tr key={`${row.id}-reason`} className={`dm-reason-row ${row.example ? "example" : ""}`}>
                                    <td colSpan={matrix.columns.length + 1}>
                                        {row.example ? (
                                            <>
                                                <span className="reason-label">Beispiel-Begründung</span>
                                                <div className="reason-text">{row.exampleReason}</div>
                                            </>
                                        ) : (
                                            <>
                                                <span className="reason-label">Begründung</span>
                                                <textarea
                                                    placeholder="Warum hast du dieses Schutzziel gewählt?"
                                                    value={reason}
                                                    onChange={(e) => updateReason(row.id, e.target.value)}
                                                />
                                            </>
                                        )}
                                    </td>
                                </tr>
                            </React.Fragment>
                        );
                    })}
                </tbody>
            </table>
        </div>
    );
}