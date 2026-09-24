"use client";

import React from "react";
import { CodeCorrectionData } from "@/data/exam-types";

interface CodeCorrectionProps {
    questionId: string;
    data: CodeCorrectionData;
    value: string;                       // serialisierte Antwort
    onChange: (value: string) => void;
}

// Antwort-Struktur: pro Zeilennummer eine Korrektur
interface LineCorrection {
    correction: string;     // Was die richtige Zeile sein sollte
    reason: string;         // Warum
}
type CodeAnswer = Record<string, LineCorrection>;   // lineNumber → correction

export default function CodeCorrection({ data, value, onChange }: CodeCorrectionProps) {
    // Antwort parsen
    let parsed: CodeAnswer = {};
    try {
        if (value) parsed = JSON.parse(value);
    } catch {
        // ignore
    }

    const lines = data.code.split("\n");

    const toggleLine = (lineNum: number) => {
        const key = String(lineNum);
        const next: CodeAnswer = { ...parsed };
        if (next[key]) {
            delete next[key];
        } else {
            next[key] = { correction: "", reason: "" };
        }
        onChange(JSON.stringify(next));
    };

    const updateCorrection = (lineNum: number, field: "correction" | "reason", val: string) => {
        const key = String(lineNum);
        const next: CodeAnswer = {
            ...parsed,
            [key]: {
                correction: parsed[key]?.correction || "",
                reason: parsed[key]?.reason || "",
                [field]: val,
            },
        };
        onChange(JSON.stringify(next));
    };

    const markedLines = Object.keys(parsed).map(Number).sort((a, b) => a - b);
    const errorCount = markedLines.length;
    const expectedCount = data.expectedErrorCount;

    return (
        <div className="cc-wrap">
            <style>{`
                .cc-wrap {
                    margin-bottom: 14px;
                    font-family: var(--font-sans);
                }

                /* CODE-BOX */
                .cc-code {
                    background: var(--bg-2);
                    border: 1px solid var(--line-2);
                    border-radius: var(--r);
                    overflow: hidden;
                    margin-bottom: 14px;
                }
                .cc-code-head {
                    padding: 10px 16px;
                    border-bottom: 1px solid var(--line);
                    display: flex; align-items: center; justify-content: space-between;
                    font-family: var(--font-mono);
                    font-size: 10px;
                    letter-spacing: 1px;
                    text-transform: uppercase;
                    background: var(--surface-2);
                }
                .cc-code-lang {
                    color: var(--accent);
                    font-weight: 700;
                }
                .cc-code-info {
                    color: var(--text-3);
                    font-weight: 500;
                }
                .cc-code-info .marked {
                    color: ${expectedCount && errorCount > expectedCount ? "var(--err)" : "var(--accent)"};
                    font-weight: 700;
                }

                .cc-code-body {
                    overflow-x: auto;
                    padding: 14px 0;
                }
                .cc-line {
                    display: flex;
                    align-items: stretch;
                    font-family: var(--font-mono);
                    font-size: 13px;
                    line-height: 1.6;
                    transition: background 0.15s;
                }
                .cc-line:hover {
                    background: var(--surface-2);
                }
                .cc-line.marked {
                    background: var(--err-soft);
                }
                .cc-line.marked:hover {
                    background: color-mix(in srgb, var(--err) 14%, transparent);
                }

                .cc-line-num {
                    width: 40px;
                    text-align: right;
                    color: var(--text-3);
                    user-select: none;
                    padding: 0 12px 0 14px;
                    flex-shrink: 0;
                    font-weight: 500;
                }
                .cc-line.marked .cc-line-num {
                    color: var(--err);
                    font-weight: 700;
                }

                .cc-line-mark {
                    width: 32px;
                    flex-shrink: 0;
                    display: flex; align-items: center; justify-content: center;
                }
                .cc-line-mark-btn {
                    width: 18px; height: 18px;
                    border-radius: 4px;
                    border: 1.5px solid var(--line-2);
                    background: transparent;
                    cursor: pointer;
                    transition: all 0.15s;
                    color: #fff;
                    font-size: 11px;
                    display: flex; align-items: center; justify-content: center;
                    padding: 0;
                }
                .cc-line-mark-btn:hover {
                    border-color: var(--err);
                    background: var(--err-soft);
                }
                .cc-line.marked .cc-line-mark-btn {
                    background: var(--err);
                    border-color: var(--err);
                }

                .cc-line-code {
                    flex: 1;
                    color: var(--text);
                    padding: 0 14px 0 8px;
                    white-space: pre;
                    min-width: 0;
                }
                .cc-line.marked .cc-line-code {
                    color: var(--text);
                }

                /* HELP TEXT */
                .cc-help {
                    background: var(--ok-soft);
                    border: 1px solid color-mix(in srgb, var(--ok) 30%, transparent);
                    border-radius: var(--r-btn);
                    padding: 14px 16px;
                    margin-bottom: 14px;
                    font-size: 12px;
                    line-height: 1.6;
                    color: var(--text);
                    font-family: var(--font-mono);
                    white-space: pre-wrap;
                }
                .cc-help-label {
                    display: block;
                    font-size: 10px;
                    font-weight: 700;
                    color: var(--ok);
                    letter-spacing: 1.5px;
                    text-transform: uppercase;
                    margin-bottom: 6px;
                    font-family: var(--font-mono);
                }

                /* INSTRUCTION */
                .cc-instr {
                    background: var(--surface-2);
                    border: 1px solid var(--line);
                    border-radius: var(--r-btn);
                    padding: 12px 14px;
                    margin-bottom: 14px;
                    font-size: 13px;
                    color: var(--text-2);
                    line-height: 1.5;
                    display: flex; gap: 10px; align-items: flex-start;
                }
                .cc-instr-icon {
                    flex-shrink: 0;
                    color: var(--accent);
                    font-weight: 700;
                }
                .cc-instr strong { color: var(--text); font-weight: 600; }

                /* CORRECTION FORM */
                .cc-corrections {
                    display: flex; flex-direction: column;
                    gap: 12px;
                }
                .cc-correction {
                    background: var(--surface);
                    border: 1px solid color-mix(in srgb, var(--accent) 30%, transparent);
                    border-radius: var(--r);
                    padding: 18px;
                }
                .cc-correction-head {
                    display: flex; align-items: center; gap: 10px;
                    margin-bottom: 14px;
                }
                .cc-correction-badge {
                    font-family: var(--font-mono);
                    font-size: 11px;
                    font-weight: 700;
                    color: var(--accent);
                    background: color-mix(in srgb, var(--accent) 8%, transparent);
                    border: 1px solid color-mix(in srgb, var(--accent) 30%, transparent);
                    padding: 3px 10px;
                    border-radius: 5px;
                    letter-spacing: 0.5px;
                }
                .cc-correction-orig {
                    font-family: var(--font-mono);
                    font-size: 12px;
                    color: var(--text-2);
                    background: var(--bg-2);
                    padding: 6px 10px;
                    border-radius: 5px;
                    overflow-x: auto;
                    white-space: pre;
                    flex: 1;
                    min-width: 0;
                }

                .cc-field {
                    margin-bottom: 12px;
                }
                .cc-field:last-child { margin-bottom: 0; }
                .cc-field-label {
                    font-family: var(--font-mono);
                    font-size: 10px;
                    font-weight: 700;
                    color: var(--accent);
                    letter-spacing: 1.5px;
                    text-transform: uppercase;
                    margin-bottom: 6px;
                    display: block;
                }
                .cc-field input,
                .cc-field textarea {
                    width: 100%;
                    padding: 10px 12px;
                    background: var(--surface-2);
                    border: 1px solid var(--line);
                    border-radius: 8px;
                    font-size: 13px;
                    color: var(--text);
                    outline: none;
                    transition: border-color 0.15s, box-shadow 0.15s;
                }
                .cc-field input {
                    font-family: var(--font-mono);
                }
                .cc-field textarea {
                    font-family: var(--font-sans);
                    min-height: 60px;
                    resize: vertical;
                    line-height: 1.5;
                }
                .cc-field input:focus,
                .cc-field textarea:focus {
                    border-color: var(--accent);
                    box-shadow: 0 0 0 3px var(--accent-soft);
                    background: var(--surface);
                }
                .cc-field input::placeholder,
                .cc-field textarea::placeholder {
                    color: var(--text-3);
                }

                .cc-empty {
                    text-align: center;
                    padding: 24px;
                    background: var(--surface-2);
                    border: 1px dashed var(--line-2);
                    border-radius: var(--r-btn);
                    color: var(--text-3);
                    font-size: 13px;
                    font-style: italic;
                }
            `}</style>

            {/* Help text (optional) */}
            {data.helpText && (
                <div className="cc-help">
                    <span className="cc-help-label">Hilfsinformation</span>
                    {data.helpText}
                </div>
            )}

            {/* Instruction */}
            <div className="cc-instr">
                <span className="cc-instr-icon">→</span>
                <span>
                    <strong>Klicke auf das Kästchen</strong> links neben einer Zeile, um sie als fehlerhaft zu markieren.
                    {expectedCount && <> Erwartet werden <strong>{expectedCount} Fehler</strong>.</>}
                </span>
            </div>

            {/* Code Box */}
            <div className="cc-code">
                <div className="cc-code-head">
                    <span className="cc-code-lang">{data.language || "code"}</span>
                    <span className="cc-code-info">
                        <span className="marked">{errorCount}</span>
                        {expectedCount ? ` / ${expectedCount}` : ""} markiert
                    </span>
                </div>
                <div className="cc-code-body">
                    {lines.map((line, idx) => {
                        const lineNum = idx + 1;
                        const isMarked = !!parsed[String(lineNum)];
                        return (
                            <div key={lineNum} className={`cc-line ${isMarked ? "marked" : ""}`}>
                                <span className="cc-line-num">{lineNum}</span>
                                <div className="cc-line-mark">
                                    <button
                                        type="button"
                                        className="cc-line-mark-btn"
                                        onClick={() => toggleLine(lineNum)}
                                        aria-label={`Zeile ${lineNum} als fehlerhaft markieren`}
                                        title={isMarked ? "Markierung aufheben" : "Als Fehler markieren"}
                                    >
                                        {isMarked ? "✕" : ""}
                                    </button>
                                </div>
                                <code className="cc-line-code">{line || " "}</code>
                            </div>
                        );
                    })}
                </div>
            </div>

            {/* Corrections per marked line */}
            {markedLines.length === 0 ? (
                <div className="cc-empty">
                    Markiere mindestens eine Zeile, um deine Korrektur einzutragen.
                </div>
            ) : (
                <div className="cc-corrections">
                    {markedLines.map((lineNum) => {
                        const correction = parsed[String(lineNum)];
                        const origLine = lines[lineNum - 1] || "";
                        return (
                            <div key={lineNum} className="cc-correction">
                                <div className="cc-correction-head">
                                    <span className="cc-correction-badge">Zeile {lineNum}</span>
                                    <span className="cc-correction-orig">{origLine.trim() || "(leer)"}</span>
                                </div>
                                <div className="cc-field">
                                    <label className="cc-field-label">Korrigierte Zeile</label>
                                    <input
                                        type="text"
                                        placeholder="z.B. if [ &quot;$FREI_PROZENT&quot; -lt 20 ]"
                                        value={correction?.correction || ""}
                                        onChange={(e) => updateCorrection(lineNum, "correction", e.target.value)}
                                    />
                                </div>
                                <div className="cc-field">
                                    <label className="cc-field-label">Begründung</label>
                                    <textarea
                                        placeholder="Warum ist die Originalzeile falsch und warum ist deine Korrektur richtig?"
                                        value={correction?.reason || ""}
                                        onChange={(e) => updateCorrection(lineNum, "reason", e.target.value)}
                                    />
                                </div>
                            </div>
                        );
                    })}
                </div>
            )}
        </div>
    );
}