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

    const getCellValue = (row: TableRow, columnKey: string, isReadonlyCol: boolean): string => {
        // 1. Beispiel-Zeile: alle Werte aus row.values
        if (row.example && row.values) {
            return row.values[columnKey] || "";
        }
        // 2. Readonly-Spalten: aus row.values lesen
        if (isReadonlyCol && row.values) {
            return row.values[columnKey] || "";
        }
        // 3. Vorausgefüllte Zelle: row.values hat Wert für diese Spalte
        if (row.values && row.values[columnKey] !== undefined && row.values[columnKey] !== "") {
            return row.values[columnKey];
        }
        // 4. Sonst: User-Antwort
        return parsed[row.id]?.[columnKey] || "";
    };

    return (
        <div className="ti-wrap">
            <style>{`
                .ti-wrap {
                    border: 1px solid var(--line);
                    border-radius: var(--r);
                    overflow: hidden;
                    margin-bottom: 14px;
                    background: var(--surface);
                }

                .ti-scroll {
                    overflow-x: auto;
                }

                .ti-table {
                    width: 100%;
                    border-collapse: collapse;
                    font-family: var(--font-sans);
                }

                .ti-table thead {
                    background: var(--bg-2);
                }
                .ti-table th {
                    padding: 12px 14px;
                    text-align: center;
                    font-family: var(--font-mono);
                    font-size: 11px;
                    font-weight: 600;
                    color: var(--text-2);
                    letter-spacing: 0.5px;
                    text-transform: uppercase;
                    border-bottom: 1px solid var(--line);
                    white-space: nowrap;
                }
                .ti-table th.ti-row-header {
                    text-align: left;
                    min-width: 100px;
                }

                .ti-row {
                    border-bottom: 1px solid var(--line);
                }
                .ti-row:last-child { border-bottom: none; }
                .ti-row.example { background: color-mix(in srgb, var(--accent) 4%, transparent); }

                .ti-row td {
                    padding: 8px 10px;
                    vertical-align: middle;
                    text-align: center;
                }
                .ti-row td.ti-row-label {
                    text-align: left;
                    padding: 10px 14px;
                    font-weight: 600;
                    color: var(--text);
                    font-family: var(--font-mono);
                    font-size: 13px;
                }

                /* Readonly-Spalten: statisches Display */
                .ti-readonly {
                    padding: 10px 14px !important;
                    font-family: var(--font-sans);
                    font-size: 13px;
                    color: var(--text);
                    line-height: 1.5;
                    font-weight: 500;
                }

                /* Text-Ausrichtungen */
                .ti-align-left { text-align: left; }
                .ti-align-center { text-align: center; }
                .ti-align-right { text-align: right; }

                .ti-table thead th.ti-align-left { text-align: left; }
                .ti-table thead th.ti-align-right { text-align: right; }

                .ti-row td.ti-row-label .sublabel {
                    display: block;
                    font-family: var(--font-sans);
                    font-size: 11px;
                    font-weight: 400;
                    color: var(--text-3);
                    margin-top: 2px;
                    text-transform: none;
                    letter-spacing: 0;
                }

                .ti-example-tag {
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
                    margin-right: 8px;
                    font-weight: 700;
                    vertical-align: middle;
                }

                .ti-input {
                    width: 60px;
                    padding: 8px 10px;
                    background: var(--surface-2);
                    border: 1px solid var(--line);
                    border-radius: 6px;
                    font-family: var(--font-mono);
                    font-size: 13px;
                    color: var(--text);
                    text-align: center;
                    outline: none;
                    transition: border-color 0.15s, box-shadow 0.15s;
                }

                /* Breite Inputs für Text-Spalten (align: left) */
                .ti-align-left .ti-input {
                    width: 100%;
                    min-width: 150px;
                    text-align: left;
                }
                .ti-align-left .ti-prefilled {
                    width: 100%;
                    min-width: 150px;
                    text-align: left;
                }

                .ti-input::placeholder {
                    color: var(--text-3);
                    font-weight: 400;
                }
                .ti-input:focus {
                    border-color: var(--accent);
                    box-shadow: 0 0 0 3px var(--accent-soft);
                    background: var(--surface);
                }
                .ti-input.example-value {
                    background: color-mix(in srgb, var(--accent) 6%, transparent);
                    border-color: color-mix(in srgb, var(--accent) 25%, transparent);
                    color: var(--accent);
                    font-weight: 700;
                    cursor: default;
                }
                .ti-input.example-value:focus {
                    box-shadow: none;
                }

                /* Below-Row: Textareas unter der Hauptzeile */
                .ti-below-row td {
                    padding: 0 14px 14px !important;
                    text-align: left;
                    background: transparent;
                }
                .ti-below-row.example td {
                    background: color-mix(in srgb, var(--accent) 4%, transparent);
                }
                .ti-below-label {
                    font-family: var(--font-mono);
                    font-size: 10px;
                    font-weight: 700;
                    color: var(--accent);
                    letter-spacing: 1px;
                    text-transform: uppercase;
                    margin-bottom: 6px;
                    display: block;
                }
                .ti-below-textarea {
                    width: 100%;
                    min-height: 70px;
                    padding: 10px 12px;
                    background: var(--surface-2);
                    border: 1px solid var(--line);
                    border-radius: 8px;
                    font-family: var(--font-sans);
                    font-size: 13px;
                    color: var(--text);
                    line-height: 1.5;
                    resize: vertical;
                    outline: none;
                    transition: border-color 0.15s, box-shadow 0.15s;
                }
                .ti-below-textarea::placeholder { color: var(--text-3); }
                .ti-below-textarea:focus {
                    border-color: var(--accent);
                    box-shadow: 0 0 0 3px var(--accent-soft);
                    background: var(--surface);
                }
                .ti-below-example {
                    font-size: 13px;
                    color: var(--text-2);
                    line-height: 1.5;
                    padding: 10px 12px;
                    background: color-mix(in srgb, var(--accent) 4%, transparent);
                    border: 1px dashed color-mix(in srgb, var(--accent) 30%, transparent);
                    border-radius: 8px;
                    font-style: italic;
                }

                /* Vorausgefüllte Zellen (statisch, ähnlich Beispiel-Tag) */
                .ti-prefilled {
                    display: inline-block;
                    width: 60px;
                    padding: 8px 10px;
                    background: color-mix(in srgb, var(--accent) 6%, transparent);
                    border: 1px solid color-mix(in srgb, var(--accent) 20%, transparent);
                    border-radius: 6px;
                    font-family: var(--font-mono);
                    font-size: 13px;
                    color: var(--accent);
                    text-align: center;
                    font-weight: 600;
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
                            {table.columns.filter(c => !c.belowRow).map((col: TableColumn) => (
                                <th
                                    key={col.key}
                                    className={`ti-align-${col.align || "center"}`}
                                    style={col.width ? { width: col.width } : undefined}
                                >
                                    {col.label}
                                </th>
                            ))}
                        </tr>
                    </thead>
                    <tbody>
                        {table.rows.map((row: TableRow) => {
                            const inlineCols = table.columns.filter(c => !c.belowRow);
                            const belowRowCols = table.columns.filter(c => c.belowRow);
                            const colSpan = inlineCols.length + 1;

                            return (
                                <React.Fragment key={row.id}>
                                    <tr className={`ti-row ${row.example ? "example" : ""}`}>
                                        <td className="ti-row-label">
                                            {row.example && <span className="ti-example-tag">Beispiel</span>}
                                            {row.label}
                                            {row.sublabel && <span className="sublabel">{row.sublabel}</span>}
                                        </td>
                                        {inlineCols.map((col: TableColumn) => {
                                            const cellValue = getCellValue(row, col.key, !!col.readonly);
                                            const isReadonly = col.readonly || row.example;
                                            const align = col.align || "center";

                                            if (col.readonly) {
                                                return (
                                                    <td key={col.key} className={`ti-readonly ti-align-${align}`}>
                                                        {cellValue || "—"}
                                                    </td>
                                                );
                                            }

                                            // Vorausgefüllte Zelle (Wert in row.values, aber keine example-Row)
                                            const isPrefilled = !row.example && row.values && row.values[col.key] !== undefined && row.values[col.key] !== "";

                                            if (isPrefilled) {
                                                return (
                                                    <td key={col.key} className={`ti-align-${align}`}>
                                                        <div className="ti-prefilled">{cellValue}</div>
                                                    </td>
                                                );
                                            }

                                            return (
                                                <td key={col.key} className={`ti-align-${align}`}>
                                                    <input
                                                        type="text"
                                                        className={`ti-input ${row.example ? "example-value" : ""}`}
                                                        value={cellValue}
                                                        placeholder={row.example ? "" : (col.placeholder || "")}
                                                        onChange={(e) => !isReadonly && updateCell(row.id, col.key, e.target.value)}
                                                        readOnly={isReadonly}
                                                        aria-label={`${row.label} - ${col.label}`}
                                                    />
                                                </td>
                                            );
                                        })}
                                    </tr>

                                    {/* Below-Row Spalten als Textareas drunter */}
                                    {belowRowCols.map((col: TableColumn) => {
                                        const cellValue = getCellValue(row, col.key, !!col.readonly);
                                        const isReadonly = col.readonly || row.example;
                                        return (
                                            <tr key={`${row.id}-${col.key}-below`} className={`ti-below-row ${row.example ? "example" : ""}`}>
                                                <td colSpan={colSpan}>
                                                    <span className="ti-below-label">{col.label}</span>
                                                    {row.example ? (
                                                        <div className="ti-below-example">{cellValue || "—"}</div>
                                                    ) : (
                                                        <textarea
                                                            className="ti-below-textarea"
                                                            value={cellValue}
                                                            placeholder={col.placeholder || "Antwort hier eingeben…"}
                                                            onChange={(e) => !isReadonly && updateCell(row.id, col.key, e.target.value)}
                                                            readOnly={isReadonly}
                                                            aria-label={`${row.label} - ${col.label}`}
                                                        />
                                                    )}
                                                </td>
                                            </tr>
                                        );
                                    })}
                                </React.Fragment>
                            );
                        })}
                    </tbody>
                </table>
            </div>
        </div>
    );
}