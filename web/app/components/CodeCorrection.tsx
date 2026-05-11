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
                    font-family: 'Inter Tight', system-ui, sans-serif;
                }

                /* CODE-BOX */
                .cc-code {
                    background: #0F0F18;
                    border: 1px solid rgba(10,10,15,0.20);
                    border-radius: 12px;
                    overflow: hidden;
                    margin-bottom: 14px;
                }
                .cc-code-head {
                    padding: 10px 16px;
                    border-bottom: 1px solid rgba(255,255,255,0.08);
                    display: flex; align-items: center; justify-content: space-between;
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 10px;
                    letter-spacing: 1px;
                    text-transform: uppercase;
                    background: #15151E;
                }
                .cc-code-lang {
                    color: #7C6DFF;
                    font-weight: 700;
                }
                .cc-code-info {
                    color: #8A8A92;
                    font-weight: 500;
                }
                .cc-code-info .marked {
                    color: ${expectedCount && errorCount > expectedCount ? "#DC2626" : "#7C6DFF"};
                    font-weight: 700;
                }

                .cc-code-body {
                    overflow-x: auto;
                    padding: 14px 0;
                }
                .cc-line {
                    display: flex;
                    align-items: stretch;
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 13px;
                    line-height: 1.6;
                    transition: background 0.15s;
                }
                .cc-line:hover {
                    background: rgba(255,255,255,0.03);
                }
                .cc-line.marked {
                    background: rgba(220,38,38,0.10);
                }
                .cc-line.marked:hover {
                    background: rgba(220,38,38,0.14);
                }

                .cc-line-num {
                    width: 40px;
                    text-align: right;
                    color: #4A4A55;
                    user-select: none;
                    padding: 0 12px 0 14px;
                    flex-shrink: 0;
                    font-weight: 500;
                }
                .cc-line.marked .cc-line-num {
                    color: #FCA5A5;
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
                    border: 1.5px solid rgba(255,255,255,0.20);
                    background: transparent;
                    cursor: pointer;
                    transition: all 0.15s;
                    color: #FFFFFF;
                    font-size: 11px;
                    display: flex; align-items: center; justify-content: center;
                    padding: 0;
                }
                .cc-line-mark-btn:hover {
                    border-color: #DC2626;
                    background: rgba(220,38,38,0.20);
                }
                .cc-line.marked .cc-line-mark-btn {
                    background: #DC2626;
                    border-color: #DC2626;
                }

                .cc-line-code {
                    flex: 1;
                    color: #E4E4E8;
                    padding: 0 14px 0 8px;
                    white-space: pre;
                    min-width: 0;
                }
                .cc-line.marked .cc-line-code {
                    color: #FFFFFF;
                }

                /* HELP TEXT */
                .cc-help {
                    background: rgba(34,211,238,0.04);
                    border: 1px solid rgba(34,211,238,0.20);
                    border-radius: 10px;
                    padding: 14px 16px;
                    margin-bottom: 14px;
                    font-size: 12px;
                    line-height: 1.6;
                    color: #0A0A0F;
                    font-family: 'JetBrains Mono', monospace;
                    white-space: pre-wrap;
                }
                .cc-help-label {
                    display: block;
                    font-size: 10px;
                    font-weight: 700;
                    color: #0891B2;
                    letter-spacing: 1.5px;
                    text-transform: uppercase;
                    margin-bottom: 6px;
                    font-family: 'JetBrains Mono', monospace;
                }

                /* INSTRUCTION */
                .cc-instr {
                    background: #FAFAF9;
                    border: 1px solid rgba(10,10,15,0.08);
                    border-radius: 10px;
                    padding: 12px 14px;
                    margin-bottom: 14px;
                    font-size: 13px;
                    color: #55555F;
                    line-height: 1.5;
                    display: flex; gap: 10px; align-items: flex-start;
                }
                .cc-instr-icon {
                    flex-shrink: 0;
                    color: #7C6DFF;
                    font-weight: 700;
                }
                .cc-instr strong { color: #0A0A0F; font-weight: 600; }

                /* CORRECTION FORM */
                .cc-corrections {
                    display: flex; flex-direction: column;
                    gap: 12px;
                }
                .cc-correction {
                    background: #FFFFFF;
                    border: 1px solid rgba(124,109,255,0.30);
                    border-radius: 12px;
                    padding: 18px;
                }
                .cc-correction-head {
                    display: flex; align-items: center; gap: 10px;
                    margin-bottom: 14px;
                }
                .cc-correction-badge {
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 11px;
                    font-weight: 700;
                    color: #7C6DFF;
                    background: rgba(124,109,255,0.08);
                    border: 1px solid rgba(124,109,255,0.30);
                    padding: 3px 10px;
                    border-radius: 5px;
                    letter-spacing: 0.5px;
                }
                .cc-correction-orig {
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 12px;
                    color: #55555F;
                    background: #F4F4F1;
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
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 10px;
                    font-weight: 700;
                    color: #7C6DFF;
                    letter-spacing: 1.5px;
                    text-transform: uppercase;
                    margin-bottom: 6px;
                    display: block;
                }
                .cc-field input,
                .cc-field textarea {
                    width: 100%;
                    padding: 10px 12px;
                    background: #FAFAF9;
                    border: 1px solid rgba(10,10,15,0.08);
                    border-radius: 8px;
                    font-size: 13px;
                    color: #0A0A0F;
                    outline: none;
                    transition: border-color 0.15s, box-shadow 0.15s;
                }
                .cc-field input {
                    font-family: 'JetBrains Mono', monospace;
                }
                .cc-field textarea {
                    font-family: 'Inter Tight', system-ui, sans-serif;
                    min-height: 60px;
                    resize: vertical;
                    line-height: 1.5;
                }
                .cc-field input:focus,
                .cc-field textarea:focus {
                    border-color: #7C6DFF;
                    box-shadow: 0 0 0 3px rgba(124,109,255,0.08);
                    background: #FFFFFF;
                }
                .cc-field input::placeholder,
                .cc-field textarea::placeholder {
                    color: #8A8A92;
                }

                .cc-empty {
                    text-align: center;
                    padding: 24px;
                    background: #FAFAF9;
                    border: 1px dashed rgba(10,10,15,0.16);
                    border-radius: 10px;
                    color: #8A8A92;
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