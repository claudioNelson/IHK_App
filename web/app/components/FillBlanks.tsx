"use client";

import { useMemo } from "react";
import { FillBlanksData } from "@/data/exam-types";

interface FillBlanksProps {
    data: FillBlanksData;
    value: string;                          // serialisierter JSON-State (Record<slotName, antwort>)
    onChange: (value: string) => void;
}

// Parse {{slotName}} Marker im Template
// Liefert eine Liste alternierender Text- und Slot-Segmente
type Segment =
    | { type: "text"; content: string }
    | { type: "slot"; name: string };

function parseTemplate(template: string): Segment[] {
    const segments: Segment[] = [];
    const regex = /\{\{(\w+)\}\}/g;
    let lastIndex = 0;
    let match: RegExpExecArray | null;

    while ((match = regex.exec(template)) !== null) {
        if (match.index > lastIndex) {
            segments.push({ type: "text", content: template.slice(lastIndex, match.index) });
        }
        segments.push({ type: "slot", name: match[1] });
        lastIndex = match.index + match[0].length;
    }
    if (lastIndex < template.length) {
        segments.push({ type: "text", content: template.slice(lastIndex) });
    }
    return segments;
}

export default function FillBlanks({ data, value, onChange }: FillBlanksProps) {
    // State parsen — defensiv (kaputtes JSON → leerer State)
    const answers = useMemo<Record<string, string>>(() => {
        if (!value) return {};
        try {
            const parsed = JSON.parse(value);
            return typeof parsed === "object" && parsed !== null ? parsed : {};
        } catch {
            return {};
        }
    }, [value]);

    // Template einmalig parsen
    const segments = useMemo(() => parseTemplate(data.template), [data.template]);

    // Slot-Lookup für Placeholder/Width
    const slotMap = useMemo(() => {
        const map: Record<string, { placeholder?: string; width?: string }> = {};
        for (const s of data.slots) {
            map[s.name] = { placeholder: s.placeholder, width: s.width };
        }
        return map;
    }, [data.slots]);

    const updateSlot = (name: string, val: string) => {
        const next = { ...answers, [name]: val };
        onChange(JSON.stringify(next));
    };

    return (
        <div className="fb-wrap">
            <style>{`
                .fb-wrap {
                    background: #FAFAF9;
                    border: 1px solid rgba(10,10,15,0.08);
                    border-radius: 10px;
                    padding: 18px 20px;
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 13px;
                    color: #0A0A0F;
                    line-height: 1.7;
                    white-space: pre-wrap;
                    overflow-x: auto;
                }
                .fb-input {
                    display: inline-block;
                    background: #FFFFFF;
                    border: 1.5px solid #7C6DFF;
                    border-radius: 5px;
                    padding: 2px 8px;
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 13px;
                    color: #0A0A0F;
                    outline: none;
                    transition: border-color 0.15s, box-shadow 0.15s;
                    vertical-align: baseline;
                    line-height: 1.4;
                }
                .fb-input:focus {
                    border-color: #6856E6;
                    box-shadow: 0 0 0 3px rgba(124,109,255,0.18);
                }
                .fb-input::placeholder {
                    color: #B5B5BC;
                    font-style: italic;
                }
            `}</style>

            {segments.map((seg, i) => {
                if (seg.type === "text") {
                    return <span key={i}>{seg.content}</span>;
                }
                const meta = slotMap[seg.name] ?? {};
                return (
                    <input
                        key={i}
                        type="text"
                        className="fb-input"
                        value={answers[seg.name] ?? ""}
                        onChange={(e) => updateSlot(seg.name, e.target.value)}
                        placeholder={meta.placeholder ?? seg.name}
                        style={{ width: meta.width ?? "auto", minWidth: "100px" }}
                        spellCheck={false}
                        autoCapitalize="off"
                        autoCorrect="off"
                    />
                );
            })}
        </div>
    );
}