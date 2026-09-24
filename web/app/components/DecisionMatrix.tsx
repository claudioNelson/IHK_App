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
                    border: 1px solid var(--line);
                    border-radius: var(--r);
                    overflow: hidden;
                    margin-bottom: 14px;
                    background: var(--surface);
                }

                .dm-table {
                    width: 100%;
                    border-collapse: collapse;
                    font-family: var(--font-sans);
                    font-size: 13px;
                }

                .dm-table thead {
                    background: var(--bg-2);
                }
                .dm-table th {
                    padding: 12px 14px;
                    text-align: left;
                    font-family: var(--font-mono);
                    font-size: 11px;
                    font-weight: 600;
                    color: var(--text-2);
                    letter-spacing: 0.5px;
                    text-transform: uppercase;
                    border-bottom: 1px solid var(--line);
                }
                .dm-table th.col-check {
                    text-align: center;
                    min-width: 90px;
                }

                .dm-row {
                    border-bottom: 1px solid var(--line);
                }
                .dm-row:last-child { border-bottom: none; }
                .dm-row.example { background: color-mix(in srgb, var(--accent) 4%, transparent); }

                .dm-row td {
                    padding: 14px;
                    vertical-align: top;
                }
                .dm-row td.col-label {
                    color: var(--text);
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
                    font-family: var(--font-mono);
                    font-size: 9px;
                    color: var(--accent);
                    background: var(--accent-soft);
                    border: 1px solid color-mix(in srgb, var(--accent) 30%, transparent);
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
                    border: 1.5px solid var(--line-2);
                    cursor: pointer;
                    transition: all 0.15s;
                    background: var(--surface);
                    color: transparent;
                    font-weight: 700;
                    font-size: 15px;
                }
                .dm-cell:hover {
                    border-color: var(--accent);
                    background: color-mix(in srgb, var(--accent) 5%, transparent);
                }
                .dm-cell.selected {
                    background: var(--accent);
                    border-color: var(--accent);
                    color: #fff;
                }
                .dm-cell.example-set {
                    background: var(--accent-soft);
                    border-color: color-mix(in srgb, var(--accent) 30%, transparent);
                    color: var(--accent);
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
                    background: var(--surface-2);
                    border: 1px solid var(--line);
                    border-radius: 8px;
                    font-family: var(--font-sans);
                    font-size: 13px;
                    color: var(--text);
                    resize: vertical;
                    outline: none;
                    transition: border-color 0.15s, box-shadow 0.15s;
                }
                .dm-reason-row textarea::placeholder {
                    color: var(--text-3);
                }
                .dm-reason-row textarea:focus {
                    border-color: var(--accent);
                    box-shadow: 0 0 0 3px var(--accent-soft);
                }
                .dm-reason-row .reason-label {
                    font-family: var(--font-mono);
                    font-size: 10px;
                    font-weight: 700;
                    color: var(--accent);
                    letter-spacing: 1px;
                    text-transform: uppercase;
                    margin-bottom: 6px;
                    display: block;
                }
                .dm-reason-row.example .reason-text {
                    font-size: 13px;
                    color: var(--text-2);
                    line-height: 1.5;
                    padding: 8px 12px;
                    background: color-mix(in srgb, var(--accent) 4%, transparent);
                    border: 1px dashed color-mix(in srgb, var(--accent) 30%, transparent);
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