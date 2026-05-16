"use client";

import { useEffect, useState } from "react";
import { Node } from "reactflow";

interface EditModalProps {
    node: Node | null;
    onSave: (updates: { label: string; description?: string }) => void;
    onClose: () => void;
    color: string;
}

// ============================================
// FELD-KONFIGURATION pro Knoten-Typ
// ============================================
interface FieldConfig {
    type: "input" | "textarea" | "code-pair" | "pk-toggle" | "none";
    label: string;             // angezeigtes Eyebrow-Label
    placeholder?: string;
    hint?: string;
    rows?: number;             // für textarea
}

interface NodeTypeConfig {
    title: string;             // Modal-Titel
    nameField?: FieldConfig;   // Feld für "label"
    descField?: FieldConfig;   // Feld für "description"
}

const NODE_CONFIGS: Record<string, NodeTypeConfig> = {
    // ============= UML-KLASSE =============
    class: {
        title: "UML-Klasse",
        nameField: { type: "input", label: "Klassenname", placeholder: "z.B. Workstation" },
        descField: { type: "code-pair", label: "Attribute / Methoden", hint: "Attribute + Methoden mit --- trennen. UML: - privat, + öffentlich, # geschützt" },
    },
    interface: {
        title: "Interface",
        nameField: { type: "input", label: "Name", placeholder: "z.B. Comparable" },
        descField: { type: "textarea", label: "Methoden", placeholder: "+ compare(other: T): int", rows: 4 },
    },
    note: {
        title: "Notiz",
        nameField: { type: "textarea", label: "Notiz-Text", placeholder: "Anmerkung…", rows: 3 },
    },
    // ============= UML-AKTIVITÄT =============
    action: {
        title: "Aktion",
        nameField: { type: "input", label: "Aktions-Name", placeholder: "z.B. Daten validieren" },
        descField: { type: "textarea", label: "Beschreibung (optional)", placeholder: "Details zur Aktion…", rows: 3 },
    },
    decision: {
        title: "Entscheidung",
        nameField: { type: "input", label: "Bedingung", placeholder: "z.B. Daten korrekt?" },
    },
    start: { title: "Start", nameField: { type: "none", label: "" } },
    end: { title: "Ende", nameField: { type: "none", label: "" } },
    fork: { title: "Fork", nameField: { type: "none", label: "" } },
    join: { title: "Join", nameField: { type: "none", label: "" } },
    // ============= ER-DIAGRAMM =============
    entity: {
        title: "Entity",
        nameField: { type: "input", label: "Entity-Name", placeholder: "z.B. Kunde" },
        descField: { type: "textarea", label: "Attribute (optional)", placeholder: "id (PK)\nname\nemail", rows: 4, hint: "Eine Zeile pro Attribut" },
    },
    relationship: {
        title: "Beziehung",
        nameField: { type: "input", label: "Beziehungs-Name", placeholder: "z.B. tätigt, gehört zu" },
    },
    attribute: {
        title: "Attribut",
        nameField: { type: "input", label: "Attribut-Name", placeholder: "z.B. kundenID" },
        descField: { type: "pk-toggle", label: "Primärschlüssel" },
    },
    cardinality: {
        title: "Kardinalität",
        nameField: { type: "input", label: "Kardinalität", placeholder: "z.B. 1:n, 1:1, m:n" },
    },
    // ============= TABELLEN =============
    table: {
        title: "DB-Tabelle",
        nameField: { type: "input", label: "Tabellen-Name", placeholder: "z.B. kunde, bestellung" },
        descField: { 
            type: "textarea", 
            label: "Spalten", 
            placeholder: "id (PK)\nname\nemail\nuser_id (FK)",
            rows: 6,
            hint: "Eine Spalte pro Zeile · (PK) für Primärschlüssel · (FK) für Fremdschlüssel" 
        },
    },
    // ============= NETZWERK =============
    server: {
        title: "Server",
        nameField: { type: "input", label: "Server-Name", placeholder: "z.B. Web-Server, DB-Server" },
        descField: { type: "textarea", label: "Beschreibung (optional)", placeholder: "IP: 192.168.1.10\nDienst: HTTP/HTTPS", rows: 3 },
    },
    firewall: {
        title: "Firewall",
        nameField: { type: "input", label: "Firewall-Name", placeholder: "z.B. Perimeter-FW" },
        descField: { type: "textarea", label: "Regeln (optional)", placeholder: "Allow: 80, 443\nDeny: alles andere", rows: 3 },
    },
    zone: {
        title: "Netzwerk-Zone",
        nameField: { type: "input", label: "Zonen-Name", placeholder: "z.B. DMZ, LAN, WAN" },
        descField: { type: "textarea", label: "Beschreibung (optional)", placeholder: "Demilitarisierte Zone\nfür öffentliche Server", rows: 3 },
    },
    internet: {
        title: "Internet",
        nameField: { type: "input", label: "Bezeichnung", placeholder: "z.B. Internet, WAN" },
    },
};

export default function EditModal({ node, onSave, onClose, color }: EditModalProps) {
    const [label, setLabel] = useState("");
    const [description, setDescription] = useState("");
    const [attributes, setAttributes] = useState("");
    const [methods, setMethods] = useState("");
    const [isPK, setIsPK] = useState(false);

    useEffect(() => {
        if (!node) return;
        setLabel(node.data.label || "");
        const desc = node.data.description || "";

        // Bei "code-pair" (UML-Klasse) den --- Split
        if (node.type === "class") {
            const parts = desc.split("---");
            setAttributes(parts[0]?.trim() || "");
            setMethods(parts[1]?.trim() || "");
        } else if (node.type === "attribute") {
            setIsPK(desc === "pk" || desc === "PK");
        } else {
            setDescription(desc);
        }
    }, [node]);

    if (!node) return null;

    const config = NODE_CONFIGS[node.type || ""] || {
        title: "Element",
        nameField: { type: "input", label: "Name" },
    };

    // Knoten ohne Edit (Start, End, Fork, Join): zeig leeren Modal
    if (config.nameField?.type === "none" && !config.descField) {
        return null; // erst gar nicht öffnen
    }

    const handleSave = () => {
        let finalDesc = "";

        if (node.type === "class") {
            finalDesc = `${attributes}\n---\n${methods}`;
            // Wenn beide leer: keine "---" Reste speichern
            if (!attributes.trim() && !methods.trim()) finalDesc = "";
        } else if (node.type === "attribute") {
            finalDesc = isPK ? "pk" : "";
        } else {
            finalDesc = description;
        }

        onSave({ label, description: finalDesc });
    };

    const renderField = (fieldConfig: FieldConfig, value: string, setValue: (v: string) => void, isFirst: boolean) => {
        if (fieldConfig.type === "none") return null;

        if (fieldConfig.type === "input") {
            return (
                <div className="em-field" key={fieldConfig.label}>
                    <label className="em-field-label">{fieldConfig.label}</label>
                    <input
                        type="text"
                        className="em-input"
                        value={value}
                        onChange={(e) => setValue(e.target.value)}
                        placeholder={fieldConfig.placeholder}
                        autoFocus={isFirst}
                    />
                    {fieldConfig.hint && <div className="em-hint">{fieldConfig.hint}</div>}
                </div>
            );
        }

        if (fieldConfig.type === "textarea") {
            return (
                <div className="em-field" key={fieldConfig.label}>
                    <label className="em-field-label">{fieldConfig.label}</label>
                    <textarea
                        className="em-textarea mono"
                        value={value}
                        onChange={(e) => setValue(e.target.value)}
                        placeholder={fieldConfig.placeholder}
                        rows={fieldConfig.rows || 4}
                        autoFocus={isFirst}
                    />
                    {fieldConfig.hint && <div className="em-hint">{fieldConfig.hint}</div>}
                </div>
            );
        }

        if (fieldConfig.type === "code-pair") {
            return (
                <div key={fieldConfig.label}>
                    <div className="em-field">
                        <label className="em-field-label">Attribute</label>
                        <textarea
                            className="em-textarea mono"
                            value={attributes}
                            onChange={(e) => setAttributes(e.target.value)}
                            placeholder="- cpu: String&#10;- ram: int&#10;- gpu: String"
                            rows={4}
                        />
                        <div className="em-hint">- privat / + öffentlich / # geschützt</div>
                    </div>
                    <div className="em-field">
                        <label className="em-field-label">Methoden</label>
                        <textarea
                            className="em-textarea mono"
                            value={methods}
                            onChange={(e) => setMethods(e.target.value)}
                            placeholder="+ starten(): void&#10;+ herunterfahren(): void"
                            rows={4}
                        />
                    </div>
                </div>
            );
        }

        if (fieldConfig.type === "pk-toggle") {
            return (
                <div className="em-field" key={fieldConfig.label}>
                    <label className="em-field-label">Schlüssel-Typ</label>
                    <div className="em-toggle-group">
                        <button
                            type="button"
                            className={`em-toggle ${!isPK ? "active" : ""}`}
                            onClick={() => setIsPK(false)}
                        >
                            Normales Attribut
                        </button>
                        <button
                            type="button"
                            className={`em-toggle ${isPK ? "active" : ""}`}
                            onClick={() => setIsPK(true)}
                        >
                            Primärschlüssel (PK)
                        </button>
                    </div>
                    <div className="em-hint">Primärschlüssel werden in der Visualisierung unterstrichen und gelb hervorgehoben.</div>
                </div>
            );
        }

        return null;
    };

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
                    max-height: 90vh;
                    display: flex;
                    flex-direction: column;
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
                    flex-shrink: 0;
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
                    overflow-y: auto;
                    flex: 1;
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

                .em-toggle-group {
                    display: flex;
                    gap: 8px;
                }
                .em-toggle {
                    flex: 1;
                    padding: 10px 12px;
                    border-radius: 8px;
                    border: 1px solid rgba(10,10,15,0.08);
                    background: #FFFFFF;
                    color: #55555F;
                    cursor: pointer;
                    font-family: 'Inter Tight', system-ui, sans-serif;
                    font-size: 12px;
                    font-weight: 600;
                    transition: all 0.15s;
                }
                .em-toggle:hover {
                    background: #FAFAF9;
                    color: #0A0A0F;
                }
                .em-toggle.active {
                    background: ${color};
                    color: #FFFFFF;
                    border-color: ${color};
                    box-shadow: 0 2px 8px ${color}40;
                }

                .em-footer {
                    padding: 16px 24px 20px;
                    display: flex;
                    gap: 10px;
                    border-top: 1px solid rgba(10,10,15,0.08);
                    flex-shrink: 0;
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
                    <div className="em-eyebrow">{config.title} bearbeiten</div>
                    <div className="em-title">{label || `Neu(es) ${config.title}`}</div>
                </div>

                <div className="em-body">
                    {config.nameField && renderField(config.nameField, label, setLabel, true)}
                    {config.descField && renderField(config.descField, description, setDescription, false)}
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