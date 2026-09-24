"use client";

import { useCallback, useMemo, useState } from "react";
import ReactFlow, {
    Node,
    Edge,
    addEdge,
    Connection,
    useNodesState,
    useEdgesState,
    Controls,
    Background,
    MarkerType,
    NodeTypes,
} from "reactflow";
import "reactflow/dist/style.css";

import { DiagramData, DiagramMode } from "@/data/exam-types";
import { DIAGRAM_MODES, getNodesForMode } from "./modes";
import EditModal from "./EditModal";
import ClassNode from "./nodes/ClassNode";

import {
    StartNode,
    EndNode,
    ActionNode,
    DecisionNode,
    ForkNode,
    JoinNode,
    NoteNode,
    InterfaceNode,
    StateNode,
} from "./nodes/ActivityNodes";

import {
    EntityNode,
    RelationshipNode,
    AttributeNode,
    CardinalityNode,
} from "./nodes/ERNodes";

import TableNode from "./nodes/TableNode";

import {
    ServerNode,
    FirewallNode,
    ZoneNode,
    InternetNode,
} from "./nodes/NetworkNodes";

import { LifelineNode, ActivationNode } from "./nodes/SequenceNodes";
import SequenceMessageEdge from "./edges/SequenceMessageEdge";

interface DiagramToolProps {
    data: DiagramData;
    value: string;                       // serialisierter State
    onChange: (value: string) => void;
}

// Aktuell nur ein Knoten-Typ registriert
const nodeTypes: NodeTypes = {
    // UML-Klasse
    class: ClassNode,
    interface: InterfaceNode,
    note: NoteNode,
    // UML-Aktivität
    start: StartNode,
    end: EndNode,
    action: ActionNode,
    decision: DecisionNode,
    fork: ForkNode,
    join: JoinNode,
    // UML-Zustand
    state: StateNode,
    // ER-Diagramm
    entity: EntityNode,
    relationship: RelationshipNode,
    attribute: AttributeNode,
    cardinality: CardinalityNode,
    // Tabellen
    table: TableNode,
    // Netzwerk
    server: ServerNode,
    firewall: FirewallNode,
    zone: ZoneNode,
    internet: InternetNode,
    // UML-Sequenz
    lifeline: LifelineNode,
    activation: ActivationNode,
};

// Edge types (für Sequenzdiagramme)
const edgeTypes = {
    "seq-message": SequenceMessageEdge,
};

// Kanten ohne feste Farbe: Strich ueber CSS (.react-flow__edge-path), Pfeilspitze
// ueber defaultMarkerColor. So landet kein Farbwert in der gespeicherten Antwort
// und die Marker-ID von reactflow bleibt ein einfacher String.
function ohneKantenfarbe(edge: Edge): Edge {
    const { stroke: _stroke, ...style } = (edge.style ?? {}) as { stroke?: string } & Record<string, unknown>;
    const markerEnd =
        edge.markerEnd && typeof edge.markerEnd === "object"
            ? (({ color: _color, ...rest }) => rest)(edge.markerEnd as { color?: string } & Record<string, unknown>)
            : edge.markerEnd;
    return { ...edge, style, markerEnd } as Edge;
}

// ============================================
// HAUPTKOMPONENTE
// ============================================

export default function DiagramTool({ data, value, onChange }: DiagramToolProps) {
    const modeConfig = DIAGRAM_MODES[data.mode] || DIAGRAM_MODES["free"];
    const availableNodes = useMemo(() => getNodesForMode(data.mode), [data.mode]);

    // Initiale Werte aus value laden (NUR beim ersten Mount, nicht bei jedem Re-Render!)
    const initialState = useMemo(() => {
        try {
            const parsed = value ? JSON.parse(value) : null;
            return {
                nodes: parsed?.nodes || [],
                // Kantenfarbe kommt aus dem Theme (CSS), nicht aus der gespeicherten
                // Antwort: alte Antworten mit festem Indigo werden hier bereinigt.
                edges: (parsed?.edges || []).map(ohneKantenfarbe),
            };
        } catch {
            return { nodes: [], edges: [] };
        }
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []);  // <-- LEERES Dependency-Array (nur beim Mount)

    const [nodes, setNodes, onNodesChange] = useNodesState(initialState.nodes);
    const [edges, setEdges, onEdgesChange] = useEdgesState(initialState.edges);

    const [selectedNodeType, setSelectedNodeType] = useState<string>(
        availableNodes[0]?.id || "class"
    );
    const [editingNode, setEditingNode] = useState<Node | null>(null);

    // State -> JSON serialisieren
    const persist = useCallback(
        (newNodes: Node[], newEdges: Edge[]) => {
            onChange(JSON.stringify({ nodes: newNodes, edges: newEdges }));
        },
        [onChange]
    );

    const onConnect = useCallback(
        (params: Connection) => {
            const nextEdges = addEdge(
                {
                    ...params,
                    type: "smoothstep",
                    animated: false,
                    style: { strokeWidth: 2 },
                    markerEnd: { type: MarkerType.ArrowClosed },
                },
                edges
            );
            setEdges(nextEdges);
            setTimeout(() => persist(nodes, nextEdges), 0);
        },
        [setEdges, nodes, edges, persist]
    );

    const onNodeDoubleClick = useCallback(
        (_event: React.MouseEvent, node: Node) => {
            setEditingNode(node);
        },
        []
    );

    const handleEditSave = useCallback(
        (updates: { label: string; description?: string }) => {
            if (!editingNode) return;
            const nextNodes = nodes.map((n) =>
                n.id === editingNode.id
                    ? { ...n, data: { ...n.data, label: updates.label, description: updates.description || "" } }
                    : n
            );
            setNodes(nextNodes);
            setTimeout(() => persist(nextNodes, edges), 0);
            setEditingNode(null);
        },
        [editingNode, nodes, edges, setNodes, persist]
    );

    const addNode = useCallback(() => {
        const newNode: Node = {
            id: `${selectedNodeType}-${Date.now()}`,
            type: selectedNodeType,
            position: { x: 100 + Math.random() * 300, y: 100 + Math.random() * 200 },
            data: { label: "Neu", description: "" },
        };
        const nextNodes = [...nodes, newNode];
        setNodes(nextNodes);
        setTimeout(() => persist(nextNodes, edges), 0);
    }, [selectedNodeType, nodes, edges, setNodes, persist]);

    const deleteSelected = useCallback(() => {
        const nextNodes = nodes.filter((n) => !n.selected);
        const nextEdges = edges.filter((e) => !e.selected);
        setNodes(nextNodes);
        setEdges(nextEdges);
        setTimeout(() => persist(nextNodes, nextEdges), 0);
    }, [nodes, edges, setNodes, setEdges, persist]);

    const clearAll = useCallback(() => {
        if (!confirm("Alle Elemente löschen?")) return;
        setNodes([]);
        setEdges([]);
        setTimeout(() => persist([], []), 0);
    }, [setNodes, setEdges, persist]);

    return (
        <div className="dt-wrap">
            <style>{`
                .dt-wrap {
                    border: 1px solid var(--line);
                    border-radius: var(--r);
                    overflow: hidden;
                    background: var(--surface);
                    margin-bottom: 14px;
                    font-family: var(--font-sans);
                }

                /* HEADER */
                .dt-header {
                    padding: 12px 16px;
                    background: var(--bg-2);
                    border-bottom: 1px solid var(--line);
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    flex-wrap: wrap;
                }
                .dt-header-pill {
                    font-family: var(--font-mono);
                    font-size: 11px;
                    font-weight: 700;
                    letter-spacing: 0.5px;
                    text-transform: uppercase;
                    padding: 4px 10px;
                    border-radius: 6px;
                    color: ${modeConfig.color};
                    background: color-mix(in srgb, ${modeConfig.color} 8%, transparent);
                    border: 1px solid color-mix(in srgb, ${modeConfig.color} 30%, transparent);
                }
                .dt-header-title {
                    font-size: 14px;
                    font-weight: 600;
                    color: var(--text);
                    flex: 1;
                }
                .dt-header-desc {
                    font-family: var(--font-mono);
                    font-size: 10px;
                    color: var(--text-3);
                    letter-spacing: 0.3px;
                }

                /* TOOLBAR */
                .dt-toolbar {
                    padding: 10px 14px;
                    background: var(--surface);
                    border-bottom: 1px solid var(--line);
                    display: flex;
                    align-items: center;
                    gap: 6px;
                    flex-wrap: wrap;
                }
                .dt-toolbar-label {
                    font-family: var(--font-mono);
                    font-size: 10px;
                    font-weight: 700;
                    letter-spacing: 1px;
                    text-transform: uppercase;
                    color: var(--text-3);
                    margin-right: 4px;
                }

                .dt-node-btn {
                    width: 36px;
                    height: 36px;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    border-radius: var(--r-btn);
                    border: 1px solid var(--line);
                    background: var(--surface);
                    color: var(--text-2);
                    cursor: pointer;
                    transition: all 0.15s;
                    font-size: 14px;
                    font-weight: 600;
                }
                .dt-node-btn:hover {
                    border-color: ${modeConfig.color};
                    color: ${modeConfig.color};
                    background: color-mix(in srgb, ${modeConfig.color} 6%, transparent);
                }
                .dt-node-btn.active {
                    background: ${modeConfig.color};
                    color: #fff;
                    border-color: ${modeConfig.color};
                    box-shadow: 0 2px 8px color-mix(in srgb, ${modeConfig.color} 30%, transparent);
                }

                .dt-divider {
                    width: 1px;
                    height: 24px;
                    background: var(--line);
                    margin: 0 6px;
                }

                .dt-action-btn {
                    padding: 7px 14px;
                    border-radius: var(--r-btn);
                    border: 1px solid var(--line);
                    background: var(--surface);
                    color: var(--text-2);
                    cursor: pointer;
                    transition: all 0.15s;
                    font-size: 12px;
                    font-weight: 600;
                    display: inline-flex;
                    align-items: center;
                    gap: 6px;
                }
                .dt-action-btn:hover {
                    color: var(--text);
                    border-color: var(--line-2);
                    background: var(--bg-2);
                }
                .dt-action-btn.primary {
                    background: ${modeConfig.color};
                    color: #fff;
                    border-color: ${modeConfig.color};
                }
                .dt-action-btn.primary:hover {
                    transform: translateY(-1px);
                    box-shadow: 0 4px 12px color-mix(in srgb, ${modeConfig.color} 30%, transparent);
                    background: ${modeConfig.color};
                }
                .dt-action-btn.danger:hover {
                    color: var(--err);
                    border-color: var(--err);
                    background: var(--err-soft);
                }

                /* HINT */
                .dt-hint {
                    padding: 8px 14px;
                    background: color-mix(in srgb, ${modeConfig.color} 5%, transparent);
                    border-bottom: 1px solid color-mix(in srgb, ${modeConfig.color} 20%, transparent);
                    font-family: var(--font-mono);
                    font-size: 11px;
                    color: var(--text-2);
                    line-height: 1.5;
                }

                /* CANVAS */
                .dt-canvas {
                    height: 500px;
                    background: var(--bg-2);
                }

                /* FOOTER-HILFE */
                .dt-footer {
                    padding: 10px 14px;
                    background: var(--bg-2);
                    border-top: 1px solid var(--line);
                    font-family: var(--font-mono);
                    font-size: 11px;
                    color: var(--text-3);
                    line-height: 1.5;
                }

                /* REACTFLOW-OVERRIDES (Kanten, Controls, Attribution) */
                .dt-wrap .react-flow__edge-path { stroke: var(--accent); }
                .dt-wrap .react-flow__edge.selected .react-flow__edge-path { stroke: var(--accent-2); }
                .dt-canvas .react-flow__controls {
                    box-shadow: var(--shadow);
                    border: 1px solid var(--line);
                    border-radius: var(--r-btn);
                    overflow: hidden;
                }
                .dt-canvas .react-flow__controls button {
                    background: var(--surface);
                    color: var(--text);
                    border-bottom: 1px solid var(--line);
                    fill: var(--text);
                }
                .dt-canvas .react-flow__controls button:hover {
                    background: var(--surface-2);
                }
                .dt-canvas .react-flow__controls button svg {
                    fill: var(--text);
                }
                .dt-canvas .react-flow__minimap {
                    background: var(--surface);
                    border: 1px solid var(--line);
                }
                .dt-canvas .react-flow__attribution {
                    background: var(--surface);
                    color: var(--text-3);
                }
                .dt-canvas .react-flow__attribution a {
                    color: var(--text-3);
                }
            `}</style>

            {/* HEADER */}
            <div className="dt-header">
                <span className="dt-header-pill">{modeConfig.name}</span>
                <span className="dt-header-title">Diagramm-Editor</span>
                <span className="dt-header-desc">{nodes.length} Knoten · {edges.length} Verbindungen</span>
            </div>

            {/* HINWEIS */}
            {data.hintText && (
                <div className="dt-hint">→ {data.hintText}</div>
            )}

            {/* TOOLBAR */}
            <div className="dt-toolbar">
                <span className="dt-toolbar-label">Knoten:</span>

                {availableNodes.map((node) => (
                    <button
                        key={node.id}
                        title={node.description}
                        onClick={() => setSelectedNodeType(node.id)}
                        className={`dt-node-btn ${selectedNodeType === node.id ? "active" : ""}`}
                    >
                        {node.label}
                    </button>
                ))}

                <span className="dt-divider" />

                <button onClick={addNode} className="dt-action-btn primary">
                    + Hinzufügen
                </button>
                <button onClick={deleteSelected} className="dt-action-btn">
                    ⌫ Auswahl löschen
                </button>
                <button onClick={clearAll} className="dt-action-btn danger">
                    Alles löschen
                </button>
            </div>

            {/* CANVAS */}
            <div className="dt-canvas">
                <ReactFlow
                    nodes={nodes}
                    edges={edges}
                    onNodesChange={onNodesChange}
                    onEdgesChange={onEdgesChange}
                    onConnect={onConnect}
                    onNodeDoubleClick={onNodeDoubleClick}
                    nodeTypes={nodeTypes}
                    edgeTypes={edgeTypes}
                    fitView
                    snapToGrid
                    snapGrid={[15, 15]}
                    defaultEdgeOptions={{
                        type: "smoothstep",
                        style: { strokeWidth: 2 },
                        markerEnd: { type: MarkerType.ArrowClosed },
                    }}
                    defaultMarkerColor="var(--accent)"
                >
                    <Controls />
                    <Background gap={15} size={1} color="var(--line-2)" />
                </ReactFlow>

            </div>

            {/* EDIT-MODAL */}
            <EditModal
                node={editingNode}
                onSave={handleEditSave}
                onClose={() => setEditingNode(null)}
                color={modeConfig.color}
            />

            {/* HILFE-LEISTE */}
            <div className="dt-footer">
                Knoten-Symbol oben wählen → "Hinzufügen" · Knoten ziehen zum Verschieben · Linien per Drag von Punkt zu Punkt · <strong>Doppelklick</strong> zum Bearbeiten
            </div>
        </div>
    );
}