import { DiagramMode } from "@/data/exam-types";

// ============================================
// MODI-KONFIGURATION
// Welche Knoten-Typen sind in welchem Modus verfügbar?
// ============================================

export interface NodeOption {
    id: string;           // Knoten-Typ (z.B. "class", "entity")
    label: string;        // Anzeige-Symbol (z.B. "□", "◆")
    name: string;         // voller Name (z.B. "Klasse", "Beziehung")
    description?: string; // Tooltip
}

export interface ModeConfig {
    name: string;           // Anzeigename des Modus
    color: string;          // Hauptfarbe für UI-Akzente
    description: string;    // kurze Beschreibung
    nodes: NodeOption[];    // verfügbare Knoten
}

// ============================================
// FARB-PALETTE (Lernarena-Stil)
// ============================================

export const DIAGRAM_COLORS = {
    primary:    "#7C6DFF",   // lila (Hauptfarbe der App)
    cyan:       "#22D3EE",   // cyan (Sekundär)
    blue:       "#3B82F6",   // sapphire (frisch)
    slate:      "#475569",   // monochrom (DB)
    emerald:    "#10B981",   // smaragd (network)
    amber:      "#F59E0B",   // amber (state)
    rose:       "#E11D48",   // rose (sequence)
    bg:         "#FAFAF9",
    text:       "#0A0A0F",
    border:     "rgba(10,10,15,0.08)",
};

// ============================================
// MODI-DEFINITIONEN
// ============================================

export const DIAGRAM_MODES: Record<DiagramMode, ModeConfig> = {
    "uml-class": {
        name: "UML-Klassendiagramm",
        color: DIAGRAM_COLORS.primary,
        description: "Klassen mit Attributen, Methoden und Beziehungen",
        nodes: [
            { id: "class",     label: "□",  name: "Klasse",    description: "Klasse mit Name, Attributen und Methoden" },
            { id: "interface", label: "I",  name: "Interface", description: "Interface (Schnittstelle)" },
            { id: "note",      label: "✎",  name: "Notiz",     description: "Erläuternde Notiz" },
        ],
    },
    "uml-activity": {
        name: "UML-Aktivitätsdiagramm",
        color: DIAGRAM_COLORS.cyan,
        description: "Ablauf mit Start, Aktionen, Entscheidungen, Ende",
        nodes: [
            { id: "start",    label: "●",  name: "Start",         description: "Startpunkt" },
            { id: "end",      label: "◉",  name: "Ende",          description: "Endpunkt" },
            { id: "action",   label: "▭",  name: "Aktion",        description: "Eine Aktivität" },
            { id: "decision", label: "◇",  name: "Entscheidung",  description: "Verzweigung" },
            { id: "fork",     label: "━",  name: "Fork",          description: "Parallelisierung" },
            { id: "join",     label: "═",  name: "Join",          description: "Synchronisation" },
            { id: "note",     label: "✎",  name: "Notiz",         description: "Erläuternde Notiz" },
        ],
    },
    "uml-state": {
        name: "UML-Zustandsdiagramm",
        color: DIAGRAM_COLORS.amber,
        description: "Zustände mit Übergängen (Start, Ende, Zustände)",
        nodes: [
            { id: "start",    label: "●",  name: "Start",        description: "Startpunkt" },
            { id: "end",      label: "◉",  name: "Ende",         description: "Endpunkt" },
            { id: "state",    label: "▭",  name: "Zustand",      description: "Zustand (z.B. nichtLadend)" },
            { id: "decision", label: "◇",  name: "Verzweigung",  description: "Bedingte Verzweigung" },
            { id: "note",     label: "✎",  name: "Notiz",        description: "Erläuternde Notiz" },
        ],
    },
    "uml-sequence": {
        name: "UML-Sequenzdiagramm",
        color: DIAGRAM_COLORS.rose,
        description: "Lifelines mit Nachrichten zwischen Objekten",
        nodes: [
            { id: "lifeline",   label: "│",  name: "Lifeline",   description: "Objekt mit vertikaler Lebenslinie" },
            { id: "activation", label: "▮",  name: "Aktivierung", description: "Aktivierungsbalken auf der Lifeline" },
            { id: "note",       label: "✎",  name: "Notiz",      description: "Erläuternde Notiz" },
        ],
    },
    "er": {
        name: "ER-Diagramm",
        color: DIAGRAM_COLORS.blue,
        description: "Entities mit Beziehungen und Kardinalitäten",
        nodes: [
            { id: "entity",       label: "▢",  name: "Entity",      description: "Entität (Tabelle)" },
            { id: "relationship", label: "◆",  name: "Beziehung",   description: "Relationship (Raute)" },
            { id: "attribute",    label: "◯",  name: "Attribut",    description: "Attribut (Oval)" },
            { id: "cardinality",  label: "1:n", name: "Kardinalität", description: "Kardinalität" },
            { id: "note",         label: "✎",  name: "Notiz",       description: "Erläuternde Notiz" },
        ],
    },
    "table": {
        name: "Datenbank-Tabellen",
        color: DIAGRAM_COLORS.slate,
        description: "DB-Tabellen für Normalformen",
        nodes: [
            { id: "table", label: "▦",  name: "Tabelle", description: "DB-Tabelle mit Spalten und Schlüsseln" },
            { id: "note",  label: "✎",  name: "Notiz",   description: "Erläuternde Notiz" },
        ],
    },
    "network": {
        name: "Netzwerk-Diagramm",
        color: DIAGRAM_COLORS.emerald,
        description: "Netzwerk-Zonen, Server, Firewalls",
        nodes: [
            { id: "server",   label: "▣",  name: "Server",    description: "Server / Workstation" },
            { id: "firewall", label: "🔥", name: "Firewall",  description: "Firewall" },
            { id: "zone",     label: "◰",  name: "Zone",      description: "Netzwerk-Zone (z.B. DMZ, LAN)" },
            { id: "internet", label: "🌐", name: "Internet",  description: "Internet / WAN" },
            { id: "note",     label: "✎",  name: "Notiz",     description: "Erläuternde Notiz" },
        ],
    },
    "free": {
        name: "Freies Diagramm",
        color: DIAGRAM_COLORS.primary,
        description: "Alle Knoten-Typen verfügbar",
        nodes: [],  // wird zur Laufzeit aus allen anderen Modi gemixt
    },
};

// Hilfsfunktion: Welche Knoten im "free"-Modus?
export const getAllNodeTypes = (): NodeOption[] => {
    const seen = new Set<string>();
    const all: NodeOption[] = [];
    for (const mode of Object.values(DIAGRAM_MODES)) {
        for (const node of mode.nodes) {
            if (!seen.has(node.id)) {
                seen.add(node.id);
                all.push(node);
            }
        }
    }
    return all;
};

// Hilfsfunktion: Knoten für einen bestimmten Modus
export const getNodesForMode = (mode: DiagramMode): NodeOption[] => {
    if (mode === "free") {
        return getAllNodeTypes();
    }
    return DIAGRAM_MODES[mode]?.nodes || [];
};