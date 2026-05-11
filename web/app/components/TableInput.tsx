"use client";

import React from "react";
import { TableInputData, TableRow, TableColumn } from "@/data/exam-types";

interface TableInputProps {
    questionId: string;
    table: TableInputData;
    value: string;                       // serialisierte Antwort aus answers[]
    onChange: (value: string) => void;
}

// Die Antwort wird als JSON serialisiert: { rowId: { columnKey: value } }
type TableAnswer = Record<string, Record<string, string>>;

export default function TableInput({ table, value, onChange }: TableInputProps) {
    // Antwort parsen oder leer initialisieren
    let parsed: TableAnswer = {};
    try {
        if (value) parsed = JSON.parse(value);
    } catch {
        // alte Antworten sind evtl. plain text - ignorieren
    }

    const updateCell = (rowId: string, columnKey: string, val: string) => {
        const next: TableAnswer = {
            ...parsed,
            [rowId]: {
                ...(parsed[rowId] || {}),
                [columnKey]: val,
            },
        };
        onChange(JSON.stringify(next));
    };

    const getCellValue = (row: TableRow, columnKey: string): string => {
        // Beispiel-Zeile: aus row.values lesen
        if (row.example && row.values) {
            return row.values[columnKey] || "";
        }
        // Sonst: aus User-Antwort lesen
        return parsed[row.id]?.[columnKey] || "";
    };

    return (
        <div className="ti-wrap">
            <style>{`
                .ti-wrap {
                    border: 1px solid rgba(10,10,15,0.08);
                    border-radius: 12px;
                    overflow: hidden;
                    margin-bottom: 14px;
                    background: #FFFFFF;
                }

                .ti-scroll {
                    overflow-x: auto;
                }

                .ti-table {
                    width: 100%;
                    border-collapse: collapse;
                    font-family: 'Inter Tight', system-ui, sans-serif;
                }

                .ti-table thead {
                    background: #F4F4F1;
                }
                .ti-table th {
                    padding: 12px 14px;
                    text-align: center;
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 11px;
                    font-weight: 600;
                    color: #55555F;
                    letter-spacing: 0.5px;
                    text-transform: uppercase;
                    border-bottom: 1px solid rgba(10,10,15,0.08);
                    white-space: nowrap;
                }
                .ti-table th.ti-row-header {
                    text-align: left;
                    min-width: 100px;
                }

                .ti-row {
                    border-bottom: 1px solid rgba(10,10,15,0.05);
                }
                .ti-row:last-child { border-bottom: none; }
                .ti-row.example { background: rgba(124,109,255,0.04); }

                .ti-row td {
                    padding: 8px 10px;
                    vertical-align: middle;
                    text-align: center;
                }
                .ti-row td.ti-row-label {
                    text-align: left;
                    padding: 10px 14px;
                    font-weight: 600;
                    color: #0A0A0F;
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 13px;
                }
                .ti-row td.ti-row-label .sublabel {
                    display: block;
                    font-family: 'Inter Tight', system-ui, sans-serif;
                    font-size: 11px;
                    font-weight: 400;
                    color: #8A8A92;
                    margin-top: 2px;
                    text-transform: none;
                    letter-spacing: 0;
                }

                .ti-example-tag {
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
                    margin-right: 8px;
                    font-weight: 700;
                    vertical-align: middle;
                }

                .ti-input {
                    width: 60px;
                    padding: 8px 10px;
                    background: #FAFAF9;
                    border: 1px solid rgba(10,10,15,0.08);
                    border-radius: 6px;
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 13px;
                    color: #0A0A0F;
                    text-align: center;
                    outline: none;
                    transition: border-color 0.15s, box-shadow 0.15s;
                }
                .ti-input::placeholder {
                    color: #C0C0C8;
                    font-weight: 400;
                }
                .ti-input:focus {
                    border-color: #7C6DFF;
                    box-shadow: 0 0 0 3px rgba(124,109,255,0.08);
                    background: #FFFFFF;
                }
                .ti-input.example-value {
                    background: rgba(124,109,255,0.06);
                    border-color: rgba(124,109,255,0.25);
                    color: #7C6DFF;
                    font-weight: 700;
                    cursor: default;
                }
                .ti-input.example-value:focus {
                    box-shadow: none;
                }

                @media (max-width: 700px) {
                    .ti-table th, .ti-row td { padding: 6px; font-size: 11px; }
                    .ti-input { width: 48px; padding: 6px 8px; font-size: 12px; }
                    .ti-row td.ti-row-label { padding: 8px 10px; font-size: 12px; }
                }
            `}</style>

            <div className="ti-scroll">
                <table className="ti-table">
                    <thead>
                        <tr>
                            <th className="ti-row-header">
                                {table.rowHeaderLabel || ""}
                            </th>
                            {table.columns.map((col: TableColumn) => (
                                <th key={col.key} style={col.width ? { width: col.width } : undefined}>
                                    {col.label}
                                </th>
                            ))}
                        </tr>
                    </thead>
                    <tbody>
                        {table.rows.map((row: TableRow) => (
                            <tr key={row.id} className={`ti-row ${row.example ? "example" : ""}`}>
                                <td className="ti-row-label">
                                    {row.example && <span className="ti-example-tag">Beispiel</span>}
                                    {row.label}
                                    {row.sublabel && <span className="sublabel">{row.sublabel}</span>}
                                </td>
                                {table.columns.map((col: TableColumn) => (
                                    <td key={col.key}>
                                        <input
                                            type="text"
                                            className={`ti-input ${row.example ? "example-value" : ""}`}
                                            value={getCellValue(row, col.key)}
                                            placeholder={row.example ? "" : (col.placeholder || "")}
                                            onChange={(e) => !row.example && updateCell(row.id, col.key, e.target.value)}
                                            readOnly={row.example}
                                            aria-label={`${row.label} - ${col.label}`}
                                        />
                                    </td>
                                ))}
                            </tr>
                        ))}
                    </tbody>
                </table>
            </div>
        </div>
    );
}