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
};

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
                edges: parsed?.edges || [],
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
                    style: { stroke: modeConfig.color, strokeWidth: 2 },
                    markerEnd: { type: MarkerType.ArrowClosed, color: modeConfig.color },
                },
                edges
            );
            setEdges(nextEdges);
            setTimeout(() => persist(nodes, nextEdges), 0);
        },
        [setEdges, nodes, edges, persist, modeConfig.color]
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
                    border: 1px solid rgba(10,10,15,0.08);
                    border-radius: 12px;
                    overflow: hidden;
                    background: #FFFFFF;
                    margin-bottom: 14px;
                    font-family: 'Inter Tight', system-ui, sans-serif;
                }

                /* HEADER */
                .dt-header {
                    padding: 12px 16px;
                    background: #FAFAF9;
                    border-bottom: 1px solid rgba(10,10,15,0.08);
                    display: flex;
                    align-items: center;
                    gap: 12px;
                    flex-wrap: wrap;
                }
                .dt-header-pill {
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 11px;
                    font-weight: 700;
                    letter-spacing: 0.5px;
                    text-transform: uppercase;
                    padding: 4px 10px;
                    border-radius: 6px;
                    color: ${modeConfig.color};
                    background: ${modeConfig.color}10;
                    border: 1px solid ${modeConfig.color}30;
                }
                .dt-header-title {
                    font-size: 14px;
                    font-weight: 600;
                    color: #0A0A0F;
                    flex: 1;
                }
                .dt-header-desc {
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 10px;
                    color: #8A8A92;
                    letter-spacing: 0.3px;
                }

                /* TOOLBAR */
                .dt-toolbar {
                    padding: 10px 14px;
                    background: #FFFFFF;
                    border-bottom: 1px solid rgba(10,10,15,0.05);
                    display: flex;
                    align-items: center;
                    gap: 6px;
                    flex-wrap: wrap;
                }
                .dt-toolbar-label {
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 10px;
                    font-weight: 700;
                    letter-spacing: 1px;
                    text-transform: uppercase;
                    color: #8A8A92;
                    margin-right: 4px;
                }

                .dt-node-btn {
                    width: 36px;
                    height: 36px;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    border-radius: 7px;
                    border: 1px solid rgba(10,10,15,0.08);
                    background: #FFFFFF;
                    color: #55555F;
                    cursor: pointer;
                    transition: all 0.15s;
                    font-size: 14px;
                    font-weight: 600;
                }
                .dt-node-btn:hover {
                    border-color: ${modeConfig.color};
                    color: ${modeConfig.color};
                    background: ${modeConfig.color}08;
                }
                .dt-node-btn.active {
                    background: ${modeConfig.color};
                    color: #FFFFFF;
                    border-color: ${modeConfig.color};
                    box-shadow: 0 2px 8px ${modeConfig.color}40;
                }

                .dt-divider {
                    width: 1px;
                    height: 24px;
                    background: rgba(10,10,15,0.08);
                    margin: 0 6px;
                }

                .dt-action-btn {
                    padding: 7px 14px;
                    border-radius: 7px;
                    border: 1px solid rgba(10,10,15,0.08);
                    background: #FFFFFF;
                    color: #55555F;
                    cursor: pointer;
                    transition: all 0.15s;
                    font-size: 12px;
                    font-weight: 600;
                    display: inline-flex;
                    align-items: center;
                    gap: 6px;
                }
                .dt-action-btn:hover {
                    color: #0A0A0F;
                    border-color: rgba(10,10,15,0.16);
                    background: #FAFAF9;
                }
                .dt-action-btn.primary {
                    background: ${modeConfig.color};
                    color: #FFFFFF;
                    border-color: ${modeConfig.color};
                }
                .dt-action-btn.primary:hover {
                    transform: translateY(-1px);
                    box-shadow: 0 4px 12px ${modeConfig.color}40;
                    background: ${modeConfig.color};
                }
                .dt-action-btn.danger:hover {
                    color: #B91C1C;
                    border-color: #DC2626;
                    background: rgba(220,38,38,0.04);
                }

                /* HINT */
                .dt-hint {
                    padding: 8px 14px;
                    background: ${modeConfig.color}06;
                    border-bottom: 1px solid ${modeConfig.color}20;
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 11px;
                    color: #55555F;
                    line-height: 1.5;
                }

                /* CANVAS */
                .dt-canvas {
                    height: 500px;
                    background: #FAFAF9;
                }

                /* FOOTER-HILFE */
                .dt-footer {
                    padding: 10px 14px;
                    background: #FAFAF9;
                    border-top: 1px solid rgba(10,10,15,0.05);
                    font-family: 'JetBrains Mono', monospace;
                    font-size: 11px;
                    color: #8A8A92;
                    line-height: 1.5;
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
                    fitView
                    snapToGrid
                    snapGrid={[15, 15]}
                    defaultEdgeOptions={{
                        type: "smoothstep",
                        style: { stroke: modeConfig.color, strokeWidth: 2 },
                        markerEnd: { type: MarkerType.ArrowClosed, color: modeConfig.color },
                    }}
                >
                    <Controls />
                    <Background gap={15} size={1} color="rgba(10,10,15,0.08)" />
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