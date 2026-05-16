"use client";

import { useEffect, useState } from "react";
import { Node } from "reactflow";

interface EditModalProps {
    node: Node | null;
    onSave: (label: string, attributes: string, methods: string) => void;
    onClose: () => void;
    color: string;
}

export default function EditModal({ node, onSave, onClose, color }: EditModalProps) {
    const [label, setLabel] = useState("");
    const [attributes, setAttributes] = useState("");
    const [methods, setMethods] = useState("");

    useEffect(() => {
        if (node) {
            setLabel(node.data.label || "");
            // description ist "attributes\n---\nmethods"
            const parts = (node.data.description || "").split("---");
            setAttributes(parts[0]?.trim() || "");
            setMethods(parts[1]?.trim() || "");
        }
    }, [node]);

    if (!node) return null;

    const handleSave = () => {
        onSave(label, attributes, methods);
    };

    // Welche Felder zeigen wir je nach Knoten-Typ?
    const isClass = node.type === "class";
    const isInterface = node.type === "interface";
    const isNote = node.type === "note";
    const showCodeFields = isClass; // Attribute + Methoden nur bei Klasse

    return (
        <div className="em-overlay" onClick={onClose}>
            <style>{`
                .em-overlay {
                    position: fixed;
                    inset: 0;
                    background: rgba(10,10,15,0.6);
                    backdrop-filter: blur(6px);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    z-index: 1000;
                    padding: 20px;
                    font-family: 'Inter Tight', system-ui, sans-serif;
                }

                .em-modal {
                    background: #FFFFFF;
                    border: 1px solid rgba(10,10,15,0.08);
                    border-radius: 14px;
                    max-width: 520px;
                    width: 100%;
                    box-shadow: 0 30px 80px rgba(10,10,15,0.4);
                    position: relative;
                    overflow: hidden;
                }
                .em-modal::before {
                    content: '';
                    position: absolute;
                    top: 0; left: 0; right: 0;
                    height: 2px;
                    background: ${color};
                }

                .em-head {
                    padding: 20px 24px 14px;
                    border-bottom: 1px solid rgba(10,10,15,0.08);
                }
                .em-eyebrow {
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 10px;
                    font-weight: 700;
                    letter-spacing: 1.5px;
                    text-transform: uppercase;
                    color: ${color};
                    margin-bottom: 6px;
                }
                .em-title {
                    font-size: 18px;
                    font-weight: 600;
                    color: #0A0A0F;
                    letter-spacing: -0.3px;
                }

                .em-body {
                    padding: 18px 24px 4px;
                }

                .em-field {
                    margin-bottom: 16px;
                }
                .em-field-label {
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 10px;
                    font-weight: 700;
                    color: ${color};
                    letter-spacing: 1.5px;
                    text-transform: uppercase;
                    margin-bottom: 6px;
                    display: block;
                }
                .em-input,
                .em-textarea {
                    width: 100%;
                    padding: 10px 12px;
                    background: #FAFAF9;
                    border: 1px solid rgba(10,10,15,0.08);
                    border-radius: 8px;
                    font-size: 13px;
                    color: #0A0A0F;
                    outline: none;
                    transition: border-color 0.15s, box-shadow 0.15s;
                    font-family: 'Inter Tight', system-ui, sans-serif;
                }
                .em-textarea.mono {
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 12px;
                    line-height: 1.6;
                    min-height: 80px;
                    resize: vertical;
                }
                .em-input:focus,
                .em-textarea:focus {
                    border-color: ${color};
                    box-shadow: 0 0 0 3px ${color}15;
                    background: #FFFFFF;
                }
                .em-hint {
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 10px;
                    color: #8A8A92;
                    margin-top: 4px;
                    line-height: 1.4;
                }

                .em-footer {
                    padding: 16px 24px 20px;
                    display: flex;
                    gap: 10px;
                    border-top: 1px solid rgba(10,10,15,0.08);
                }
                .em-btn {
                    flex: 1;
                    padding: 11px;
                    border-radius: 8px;
                    font-family: 'Inter Tight', system-ui, sans-serif;
                    font-size: 13px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.15s;
                    border: 1px solid;
                }
                .em-btn.cancel {
                    background: #FFFFFF;
                    color: #55555F;
                    border-color: rgba(10,10,15,0.16);
                }
                .em-btn.cancel:hover {
                    background: #FAFAF9;
                    color: #0A0A0F;
                }
                .em-btn.save {
                    background: ${color};
                    color: #FFFFFF;
                    border-color: ${color};
                }
                .em-btn.save:hover {
                    transform: translateY(-1px);
                    box-shadow: 0 4px 12px ${color}40;
                }
            `}</style>

            <div className="em-modal" onClick={(e) => e.stopPropagation()}>
                <div className="em-head">
                    <div className="em-eyebrow">
                        {isClass ? "UML-Klasse" : isInterface ? "Interface" : isNote ? "Notiz" : "Element"} bearbeiten
                    </div>
                    <div className="em-title">{label || "Neues Element"}</div>
                </div>

                <div className="em-body">
                    {/* Label / Name */}
                    <div className="em-field">
                        <label className="em-field-label">{isNote ? "Inhalt" : "Name"}</label>
                        {isNote ? (
                            <textarea
                                className="em-textarea"
                                value={label}
                                onChange={(e) => setLabel(e.target.value)}
                                placeholder="Notiz-Text..."
                                autoFocus
                                rows={3}
                            />
                        ) : (
                            <input
                                type="text"
                                className="em-input"
                                value={label}
                                onChange={(e) => setLabel(e.target.value)}
                                placeholder={isClass ? "z.B. Workstation" : "z.B. Comparable"}
                                autoFocus
                            />
                        )}
                    </div>

                    {/* Attribute + Methoden nur bei Klasse */}
                    {showCodeFields && (
                        <>
                            <div className="em-field">
                                <label className="em-field-label">Attribute</label>
                                <textarea
                                    className="em-textarea mono"
                                    value={attributes}
                                    onChange={(e) => setAttributes(e.target.value)}
                                    placeholder={"- cpu: String\n- ram: int\n- gpu: String"}
                                />
                                <div className="em-hint">UML-Stil: -privat / +öffentlich / #geschützt, jedes Attribut in einer Zeile</div>
                            </div>

                            <div className="em-field">
                                <label className="em-field-label">Methoden</label>
                                <textarea
                                    className="em-textarea mono"
                                    value={methods}
                                    onChange={(e) => setMethods(e.target.value)}
                                    placeholder={"+ starten(): void\n+ herunterfahren(): void"}
                                />
                                <div className="em-hint">+ public, - private, # protected</div>
                            </div>
                        </>
                    )}

                    {/* Interface bekommt nur Methoden-Liste */}
                    {isInterface && (
                        <div className="em-field">
                            <label className="em-field-label">Methoden</label>
                            <textarea
                                className="em-textarea mono"
                                value={methods}
                                onChange={(e) => setMethods(e.target.value)}
                                placeholder={"+ compare(other: T): int"}
                            />
                        </div>
                    )}
                </div>

                <div className="em-footer">
                    <button onClick={onClose} className="em-btn cancel">
                        Abbrechen
                    </button>
                    <button onClick={handleSave} className="em-btn save">
                        Speichern →
                    </button>
                </div>
            </div>
        </div>
    );
}