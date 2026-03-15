"use client";

import { useState, useCallback } from "react";
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
  Handle,
  Position,
} from "reactflow";
import "reactflow/dist/style.css";

interface DiagramToolProps {
  onSave: (data: string) => void;
}

// ============================================
// UML-AKTIVITÄTSDIAGRAMM NODES
// ============================================

// Aktivität (Rechteck mit Titel und Beschreibung)
const ActivityNode = ({ data }: { data: { label: string; description?: string } }) => (
  <div className="bg-white border-2 border-blue-500 rounded-lg shadow-md min-w-[140px] max-w-[200px]">
    <Handle type="target" position={Position.Top} id="top" className="w-2 h-2" />
    <Handle type="source" position={Position.Bottom} id="bottom" className="w-2 h-2" />
    <Handle type="target" position={Position.Left} id="left" className="w-2 h-2" />
    <Handle type="source" position={Position.Right} id="right" className="w-2 h-2" />
    <div className="px-3 py-1 bg-blue-50 border-b border-blue-300 rounded-t-lg">
      <span className="text-sm font-bold text-blue-800">{data.label}</span>
    </div>
    {data.description && (
      <div className="px-3 py-2">
        <span className="text-xs text-gray-600 whitespace-pre-wrap">{data.description}</span>
      </div>
    )}
  </div>
);

// Aktion (abgerundet mit Titel und Beschreibung)
const ActionNode = ({ data }: { data: { label: string; description?: string } }) => (
  <div className="bg-blue-50 border-2 border-blue-600 rounded-2xl shadow-md min-w-[120px] max-w-[200px]">
    <Handle type="target" position={Position.Top} id="top" className="w-2 h-2" />
    <Handle type="source" position={Position.Bottom} id="bottom" className="w-2 h-2" />
    <Handle type="target" position={Position.Left} id="left" className="w-2 h-2" />
    <Handle type="source" position={Position.Right} id="right" className="w-2 h-2" />
    <div className="px-3 py-1 border-b border-blue-300">
      <span className="text-sm font-bold text-blue-800">{data.label}</span>
    </div>
    {data.description && (
      <div className="px-3 py-2">
        <span className="text-xs text-gray-600 whitespace-pre-wrap">{data.description}</span>
      </div>
    )}
  </div>
);

// Entscheidung (Raute)
const DecisionNode = ({ data }: { data: { label: string } }) => (
  <div className="relative w-20 h-20">
    <Handle type="target" position={Position.Top} id="top" className="w-2 h-2" style={{ top: -3 }} />
    <Handle type="source" position={Position.Bottom} id="bottom" className="w-2 h-2" style={{ bottom: -3 }} />
    <Handle type="target" position={Position.Left} id="left" className="w-2 h-2" style={{ left: -3 }} />
    <Handle type="source" position={Position.Right} id="right" className="w-2 h-2" style={{ right: -3 }} />
    <div
      className="absolute inset-0 bg-white border-2 border-orange-500 shadow-md"
      style={{ transform: "rotate(45deg)", transformOrigin: "center" }}
    />
    <span className="absolute inset-0 flex items-center justify-center text-xs font-medium text-center px-1">
      {data.label}
    </span>
  </div>
);

// Start (gefüllter Kreis)
const StartNode = () => (
  <div className="w-10 h-10 bg-black rounded-full shadow-md flex items-center justify-center">
    <Handle type="source" position={Position.Top} id="top" className="w-2 h-2" />
    <Handle type="source" position={Position.Bottom} id="bottom" className="w-2 h-2" />
    <Handle type="source" position={Position.Left} id="left" className="w-2 h-2" />
    <Handle type="source" position={Position.Right} id="right" className="w-2 h-2" />
  </div>
);

// Ende (doppelter Kreis)
const EndNode = () => (
  <div className="w-12 h-12 bg-white border-4 border-black rounded-full shadow-md flex items-center justify-center">
    <Handle type="target" position={Position.Top} id="top" className="w-2 h-2" />
    <Handle type="target" position={Position.Bottom} id="bottom" className="w-2 h-2" />
    <Handle type="target" position={Position.Left} id="left" className="w-2 h-2" />
    <Handle type="target" position={Position.Right} id="right" className="w-2 h-2" />
    <div className="w-6 h-6 bg-black rounded-full" />
  </div>
);

// Kreis (Start/Ende mit Label)
const CircleNode = ({ data }: { data: { label: string } }) => (
  <div className="w-16 h-16 bg-white border-2 border-green-500 rounded-full shadow-md flex items-center justify-center">
    <Handle type="target" position={Position.Top} id="top" className="w-2 h-2" />
    <Handle type="source" position={Position.Bottom} id="bottom" className="w-2 h-2" />
    <Handle type="target" position={Position.Left} id="left" className="w-2 h-2" />
    <Handle type="source" position={Position.Right} id="right" className="w-2 h-2" />
    <span className="text-xs font-medium">{data.label}</span>
  </div>
);

// Parallelisierung (Balken)
const ForkNode = () => (
  <div className="w-40 h-2 bg-black rounded">
    <Handle type="target" position={Position.Top} id="top" className="w-2 h-2" />
    <Handle type="source" position={Position.Bottom} id="bottom-left" className="w-2 h-2" style={{ left: "25%" }} />
    <Handle type="source" position={Position.Bottom} id="bottom-right" className="w-2 h-2" style={{ left: "75%" }} />
    <Handle type="target" position={Position.Left} id="left" className="w-2 h-2" />
    <Handle type="source" position={Position.Right} id="right" className="w-2 h-2" />
  </div>
);

// Synchronisation (Balken)
const JoinNode = () => (
  <div className="w-40 h-2 bg-black rounded">
    <Handle type="target" position={Position.Top} id="top-left" className="w-2 h-2" style={{ left: "25%" }} />
    <Handle type="target" position={Position.Top} id="top-right" className="w-2 h-2" style={{ left: "75%" }} />
    <Handle type="source" position={Position.Bottom} id="bottom" className="w-2 h-2" />
    <Handle type="target" position={Position.Left} id="left" className="w-2 h-2" />
    <Handle type="source" position={Position.Right} id="right" className="w-2 h-2" />
  </div>
);

// Signal senden
const SendSignalNode = ({ data }: { data: { label: string } }) => (
  <div className="relative">
    <Handle type="target" position={Position.Top} id="top" className="w-2 h-2" />
    <Handle type="source" position={Position.Bottom} id="bottom" className="w-2 h-2" />
    <Handle type="target" position={Position.Left} id="left" className="w-2 h-2" />
    <Handle type="source" position={Position.Right} id="right" className="w-2 h-2" />
    <div className="px-4 py-2 bg-green-100 border-2 border-green-600 shadow-md"
      style={{ clipPath: "polygon(0 0, 80% 0, 100% 50%, 80% 100%, 0 100%)" }}>
      <span className="text-sm font-medium text-green-800 pr-4">{data.label}</span>
    </div>
  </div>
);

// Signal empfangen
const ReceiveSignalNode = ({ data }: { data: { label: string } }) => (
  <div className="relative">
    <Handle type="target" position={Position.Top} id="top" className="w-2 h-2" />
    <Handle type="source" position={Position.Bottom} id="bottom" className="w-2 h-2" />
    <Handle type="target" position={Position.Left} id="left" className="w-2 h-2" />
    <Handle type="source" position={Position.Right} id="right" className="w-2 h-2" />
    <div className="px-4 py-2 bg-yellow-100 border-2 border-yellow-600 shadow-md"
      style={{ clipPath: "polygon(20% 0, 100% 0, 100% 100%, 20% 100%, 0 50%)" }}>
      <span className="text-sm font-medium text-yellow-800 pl-4">{data.label}</span>
    </div>
  </div>
);

// Notiz
const NoteNode = ({ data }: { data: { label: string } }) => (
  <div className="bg-yellow-100 border border-yellow-400 shadow-sm p-3 min-w-[100px] max-w-[200px]"
    style={{ clipPath: "polygon(0 0, calc(100% - 15px) 0, 100% 15px, 100% 100%, 0 100%)" }}>
    <Handle type="target" position={Position.Top} id="top" className="w-2 h-2" />
    <Handle type="source" position={Position.Bottom} id="bottom" className="w-2 h-2" />
    <Handle type="target" position={Position.Left} id="left" className="w-2 h-2" />
    <Handle type="source" position={Position.Right} id="right" className="w-2 h-2" />
    <span className="text-xs text-gray-700 whitespace-pre-wrap">{data.label}</span>
  </div>
);

// Schwimmbahn
const SwimlaneNode = ({ data }: { data: { label: string } }) => (
  <div className="bg-gray-50 border-2 border-gray-400 rounded-lg shadow-sm min-w-[200px] min-h-[300px]">
    <Handle type="target" position={Position.Top} id="top" className="w-2 h-2" />
    <Handle type="source" position={Position.Bottom} id="bottom" className="w-2 h-2" />
    <Handle type="target" position={Position.Left} id="left" className="w-2 h-2" />
    <Handle type="source" position={Position.Right} id="right" className="w-2 h-2" />
    <span className="text-sm font-bold text-gray-700">{data.label}</span>
  </div>
);

// Bedingung / Guard
const GuardNode = ({ data }: { data: { label: string } }) => (
  <div className="relative px-2 py-1 bg-gray-100 border border-gray-400 rounded text-xs">
    <Handle type="target" position={Position.Top} id="top" className="w-2 h-2" />
    <Handle type="source" position={Position.Bottom} id="bottom" className="w-2 h-2" />
    <Handle type="target" position={Position.Left} id="left" className="w-2 h-2" />
    <Handle type="source" position={Position.Right} id="right" className="w-2 h-2" />
    [{data.label}]
  </div>
);

// ============================================
// ER-DIAGRAMM NODES
// ============================================

// Entity (Rechteck für ER-Diagramm)
const EntityNode = ({ data }: { data: { label: string; description?: string } }) => (
  <div className="bg-white border-2 border-indigo-600 shadow-md min-w-[120px]">
    <Handle type="target" position={Position.Top} id="top" className="w-2 h-2" />
    <Handle type="source" position={Position.Bottom} id="bottom" className="w-2 h-2" />
    <Handle type="target" position={Position.Left} id="left" className="w-2 h-2" />
    <Handle type="source" position={Position.Right} id="right" className="w-2 h-2" />
    <div className="px-4 py-2 bg-indigo-100 border-b border-indigo-300 text-center">
      <span className="font-bold text-indigo-900">{data.label}</span>
    </div>
    {data.description && (
      <div className="px-3 py-2 text-xs text-gray-700 whitespace-pre-wrap">
        {data.description}
      </div>
    )}
  </div>
);

// Relationship (Raute für ER-Diagramm)
const RelationshipNode = ({ data }: { data: { label: string } }) => (
  <div className="relative w-28 h-16 flex items-center justify-center">
    <Handle type="target" position={Position.Top} id="top" className="w-2 h-2" />
    <Handle type="source" position={Position.Bottom} id="bottom" className="w-2 h-2" />
    <Handle type="target" position={Position.Left} id="left" className="w-2 h-2" />
    <Handle type="source" position={Position.Right} id="right" className="w-2 h-2" />
    <div
      className="absolute inset-1 bg-white border-2 border-green-600 shadow-md"
      style={{ transform: "rotate(45deg)", transformOrigin: "center" }}
    />
    <span className="relative z-10 text-xs font-bold text-green-800 text-center">
      {data.label}
    </span>
  </div>
);

// Attribut (Oval für ER-Diagramm)
const AttributeNode = ({ data }: { data: { label: string; description?: string } }) => (
  <div className={`px-4 py-2 rounded-full border-2 shadow-sm min-w-[80px] text-center
    ${data.description === 'pk' ? 'bg-yellow-50 border-yellow-500' : 'bg-white border-gray-400'}`}>
    <Handle type="target" position={Position.Top} id="top" className="w-2 h-2" />
    <Handle type="source" position={Position.Bottom} id="bottom" className="w-2 h-2" />
    <Handle type="target" position={Position.Left} id="left" className="w-2 h-2" />
    <Handle type="source" position={Position.Right} id="right" className="w-2 h-2" />
    <span className={`text-xs ${data.description === 'pk' ? 'underline font-bold' : ''}`}>
      {data.label}
    </span>
  </div>
);

// Kardinalität (klein, für 1, n, m)
const CardinalityNode = ({ data }: { data: { label: string } }) => (
  <div className="px-2 py-1 bg-white border border-gray-300 rounded text-xs font-mono">
    <Handle type="target" position={Position.Top} id="top" className="w-1 h-1" />
    <Handle type="source" position={Position.Bottom} id="bottom" className="w-1 h-1" />
    <Handle type="target" position={Position.Left} id="left" className="w-1 h-1" />
    <Handle type="source" position={Position.Right} id="right" className="w-1 h-1" />
    {data.label}
  </div>
);

// ============================================
// UML-KLASSENDIAGRAMM NODES
// ============================================

// Klasse (3 Bereiche: Name, Attribute, Methoden)
const ClassNode = ({ data }: { data: { label: string; attributes?: string; methods?: string; description?: string } }) => (
  <div className="bg-white border-2 border-purple-600 shadow-md min-w-[160px]">
    <Handle type="target" position={Position.Top} id="top" className="w-2 h-2" />
    <Handle type="source" position={Position.Bottom} id="bottom" className="w-2 h-2" />
    <Handle type="target" position={Position.Left} id="left" className="w-2 h-2" />
    <Handle type="source" position={Position.Right} id="right" className="w-2 h-2" />
    {/* Klassenname */}
    <div className="px-3 py-2 bg-purple-100 border-b-2 border-purple-600 text-center">
      <span className="font-bold text-purple-900">{data.label}</span>
    </div>
    {/* Attribute */}
    <div className="px-3 py-2 border-b border-purple-300 min-h-[30px]">
      <span className="text-xs font-mono text-gray-700 whitespace-pre-wrap">
        {data.attributes || data.description?.split('---')[0] || ""}
      </span>
    </div>
    {/* Methoden */}
    <div className="px-3 py-2 min-h-[30px]">
      <span className="text-xs font-mono text-gray-700 whitespace-pre-wrap">
        {data.methods || data.description?.split('---')[1] || ""}
      </span>
    </div>
  </div>
);

// Interface
const InterfaceNode = ({ data }: { data: { label: string; description?: string } }) => (
  <div className="bg-white border-2 border-teal-600 border-dashed shadow-md min-w-[140px]">
    <Handle type="target" position={Position.Top} id="top" className="w-2 h-2" />
    <Handle type="source" position={Position.Bottom} id="bottom" className="w-2 h-2" />
    <Handle type="target" position={Position.Left} id="left" className="w-2 h-2" />
    <Handle type="source" position={Position.Right} id="right" className="w-2 h-2" />
    <div className="px-3 py-1 text-center text-xs text-teal-600">
      «interface»
    </div>
    <div className="px-3 py-2 bg-teal-50 border-b border-teal-300 text-center">
      <span className="font-bold text-teal-900">{data.label}</span>
    </div>
    <div className="px-3 py-2 min-h-[30px]">
      <span className="text-xs font-mono text-gray-700 whitespace-pre-wrap">
        {data.description || ""}
      </span>
    </div>
  </div>
);

// ============================================
// UML-ZUSTANDSDIAGRAMM NODES
// ============================================

// Zustand (abgerundetes Rechteck mit Trennlinie)
const StateNode = ({ data }: { data: { label: string; description?: string } }) => (
  <div className="bg-white border-2 border-amber-500 rounded-xl shadow-md min-w-[120px]">
    <Handle type="target" position={Position.Top} id="top" className="w-2 h-2" />
    <Handle type="source" position={Position.Bottom} id="bottom" className="w-2 h-2" />
    <Handle type="target" position={Position.Left} id="left" className="w-2 h-2" />
    <Handle type="source" position={Position.Right} id="right" className="w-2 h-2" />
    <div className="px-4 py-2 text-center border-b border-amber-300 rounded-t-xl bg-amber-50">
      <span className="font-bold text-amber-900">{data.label}</span>
    </div>
    {data.description && (
      <div className="px-3 py-2">
        <span className="text-xs text-gray-600 whitespace-pre-wrap">{data.description}</span>
      </div>
    )}
  </div>
);

// ============================================
// TABELLEN NODE (für Normalformen)
// ============================================

// Tabelle (für Normalform-Darstellung)
const TableNode = ({ data }: { data: { label: string; description?: string } }) => (
  <div className="bg-white border-2 border-slate-600 shadow-md min-w-[150px]">
    <Handle type="target" position={Position.Top} id="top" className="w-2 h-2" />
    <Handle type="source" position={Position.Bottom} id="bottom" className="w-2 h-2" />
    <Handle type="target" position={Position.Left} id="left" className="w-2 h-2" />
    <Handle type="source" position={Position.Right} id="right" className="w-2 h-2" />
    {/* Tabellenname */}
    <div className="px-3 py-2 bg-slate-700 text-center">
      <span className="font-bold text-white">{data.label}</span>
    </div>
    {/* Spalten */}
    <div className="px-3 py-2 bg-slate-100">
      <span className="text-xs font-mono text-slate-800 whitespace-pre-wrap">
        {data.description || "id (PK)"}
      </span>
    </div>
  </div>
);

// ============================================
// NODE TYPES REGISTRIERUNG
// ============================================

const nodeTypes: NodeTypes = {
  // UML-Aktivität
  activity: ActivityNode,
  action: ActionNode,
  decision: DecisionNode,
  start: StartNode,
  end: EndNode,
  circle: CircleNode,
  fork: ForkNode,
  join: JoinNode,
  sendSignal: SendSignalNode,
  receiveSignal: ReceiveSignalNode,
  note: NoteNode,
  swimlane: SwimlaneNode,
  guard: GuardNode,
  // ER-Diagramm
  entity: EntityNode,
  relationship: RelationshipNode,
  attribute: AttributeNode,
  cardinality: CardinalityNode,
  // UML-Klassen
  class: ClassNode,
  interface: InterfaceNode,
  // Zustandsdiagramm
  state: StateNode,
  // Tabellen
  table: TableNode,
};

// ============================================
// MODALS
// ============================================

interface EditModalProps {
  isOpen: boolean;
  node: Node | null;
  onSave: (label: string, description: string) => void;
  onClose: () => void;
  hasDescription: boolean;
}

const EditModal = ({ isOpen, node, onSave, onClose, hasDescription }: EditModalProps) => {
  const [label, setLabel] = useState("");
  const [description, setDescription] = useState("");

  useState(() => {
    if (node) {
      setLabel(node.data.label || "");
      setDescription(node.data.description || "");
    }
  });

  if (!isOpen || !node) return null;

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg shadow-xl p-6 w-96">
        <h3 className="text-lg font-bold mb-4">Element bearbeiten</h3>
        
        <div className="mb-4">
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Titel / Name
          </label>
          <input
            type="text"
            value={label}
            onChange={(e) => setLabel(e.target.value)}
            className="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            autoFocus
          />
        </div>

        {hasDescription && (
          <div className="mb-4">
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Beschreibung / Attribute
            </label>
            <textarea
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              rows={5}
              className="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 resize-none font-mono text-sm"
              placeholder="Zeile 1&#10;Zeile 2&#10;---&#10;Methoden (bei Klassen)"
            />
          </div>
        )}

        <div className="flex justify-end gap-2">
          <button
            onClick={onClose}
            className="px-4 py-2 text-gray-600 hover:bg-gray-100 rounded-lg"
          >
            Abbrechen
          </button>
          <button
            onClick={() => onSave(label, description)}
            className="px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700"
          >
            Speichern
          </button>
        </div>
      </div>
    </div>
  );
};

interface AddModalProps {
  isOpen: boolean;
  nodeType: string;
  onSave: (label: string, description: string) => void;
  onClose: () => void;
  hasDescription: boolean;
}

const AddModal = ({ isOpen, nodeType, onSave, onClose, hasDescription }: AddModalProps) => {
  const [label, setLabel] = useState("");
  const [description, setDescription] = useState("");

  if (!isOpen) return null;

  const handleSave = () => {
    onSave(label, description);
    setLabel("");
    setDescription("");
  };

  const getPlaceholder = () => {
    switch (nodeType) {
      case 'class':
        return "- attribut1: String\n- attribut2: int\n---\n+ methode1(): void\n+ methode2(): String";
      case 'entity':
        return "PK: id\nname\nemail\n(FK: foreign_id)";
      case 'table':
        return "id (PK)\nname\nemail\nuser_id (FK)";
      case 'state':
        return "entry / aktion\ndo / aktivität\nexit / aktion";
      default:
        return "Beschreibung...";
    }
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg shadow-xl p-6 w-96">
        <h3 className="text-lg font-bold mb-4">Neues Element hinzufügen</h3>
        
        <div className="mb-4">
          <label className="block text-sm font-medium text-gray-700 mb-1">
            Titel / Name
          </label>
          <input
            type="text"
            value={label}
            onChange={(e) => setLabel(e.target.value)}
            className="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
            autoFocus
          />
        </div>

        {hasDescription && (
          <div className="mb-4">
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Beschreibung / Attribute
            </label>
            <textarea
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              rows={5}
              className="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 resize-none font-mono text-sm"
              placeholder={getPlaceholder()}
            />
          </div>
        )}

        <div className="flex justify-end gap-2">
          <button
            onClick={onClose}
            className="px-4 py-2 text-gray-600 hover:bg-gray-100 rounded-lg"
          >
            Abbrechen
          </button>
          <button
            onClick={handleSave}
            className="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700"
          >
            Hinzufügen
          </button>
        </div>
      </div>
    </div>
  );
};

// ============================================
// HAUPTKOMPONENTE
// ============================================

export default function DiagramTool({ onSave }: DiagramToolProps) {
  const [mode, setMode] = useState<"draw" | "upload">("draw");
  const [uploadedImage, setUploadedImage] = useState<string | null>(null);
  const [selectedNodeType, setSelectedNodeType] = useState<string>("activity");
  const [selectedCategory, setSelectedCategory] = useState<string>("uml-activity");

  const [nodes, setNodes, onNodesChange] = useNodesState([]);
  const [edges, setEdges, onEdgesChange] = useEdgesState([]);

  const [editModalOpen, setEditModalOpen] = useState(false);
  const [addModalOpen, setAddModalOpen] = useState(false);
  const [editingNode, setEditingNode] = useState<Node | null>(null);

  const onConnect = useCallback(
    (params: Connection) =>
      setEdges((eds) =>
        addEdge(
          {
            ...params,
            type: "smoothstep",
            animated: false,
            markerEnd: { type: MarkerType.ArrowClosed },
          },
          eds
        )
      ),
    [setEdges]
  );

  const onNodeDoubleClick = useCallback(
    (event: React.MouseEvent, node: Node) => {
      setEditingNode(node);
      setEditModalOpen(true);
    },
    []
  );

  const handleEditSave = (label: string, description: string) => {
    if (editingNode) {
      setNodes((nds) =>
        nds.map((n) =>
          n.id === editingNode.id
            ? { ...n, data: { ...n.data, label, description } }
            : n
        )
      );
    }
    setEditModalOpen(false);
    setEditingNode(null);
  };

  const openAddModal = () => {
    const needsLabel = !["start", "end", "fork", "join"].includes(selectedNodeType);
    if (needsLabel) {
      setAddModalOpen(true);
    } else {
      const newNode: Node = {
        id: `node-${Date.now()}`,
        type: selectedNodeType,
        position: { x: Math.random() * 300 + 100, y: Math.random() * 200 + 100 },
        data: { label: "", description: "" },
      };
      setNodes((nds) => [...nds, newNode]);
    }
  };

  const handleAddSave = (label: string, description: string) => {
    const newNode: Node = {
      id: `node-${Date.now()}`,
      type: selectedNodeType,
      position: { x: Math.random() * 300 + 100, y: Math.random() * 200 + 100 },
      data: { label: label || "Neu", description },
    };
    setNodes((nds) => [...nds, newNode]);
    setAddModalOpen(false);
  };

  const deleteSelected = () => {
    setNodes((nds) => nds.filter((node) => !node.selected));
    setEdges((eds) => eds.filter((edge) => !edge.selected));
  };

  const clearAll = () => {
    if (confirm("Alle Elemente löschen?")) {
      setNodes([]);
      setEdges([]);
    }
  };

  const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (event) => {
        const data = event.target?.result as string;
        setUploadedImage(data);
        onSave(data);
      };
      reader.readAsDataURL(file);
    }
  };

  // Kategorisierte Node-Optionen
  const nodeCategories = {
    "uml-activity": {
      label: "UML Aktivität",
      nodes: [
        { id: "start", label: "●", desc: "Start" },
        { id: "end", label: "◉", desc: "Ende" },
        { id: "activity", label: "▢", desc: "Aktivität" },
        { id: "action", label: "⬭", desc: "Aktion" },
        { id: "decision", label: "◇", desc: "Entscheidung" },
        { id: "fork", label: "━", desc: "Fork" },
        { id: "join", label: "═", desc: "Join" },
        { id: "swimlane", label: "▤", desc: "Swimlane" },
        { id: "guard", label: "[ ]", desc: "Guard" },
      ],
    },
    "uml-state": {
      label: "UML Zustand",
      nodes: [
        { id: "start", label: "●", desc: "Start" },
        { id: "end", label: "◉", desc: "Ende" },
        { id: "state", label: "▢", desc: "Zustand" },
        { id: "decision", label: "◇", desc: "Verzweigung" },
        { id: "guard", label: "[ ]", desc: "Guard" },
      ],
    },
    "uml-class": {
      label: "UML Klasse",
      nodes: [
        { id: "class", label: "☐", desc: "Klasse" },
        { id: "interface", label: "◇̲", desc: "Interface" },
        { id: "note", label: "📝", desc: "Notiz" },
      ],
    },
    "er": {
      label: "ER-Diagramm",
      nodes: [
        { id: "entity", label: "▣", desc: "Entity" },
        { id: "relationship", label: "◆", desc: "Beziehung" },
        { id: "attribute", label: "○", desc: "Attribut" },
        { id: "cardinality", label: "1:n", desc: "Kardinalität" },
      ],
    },
    "table": {
      label: "Tabellen",
      nodes: [
        { id: "table", label: "▦", desc: "Tabelle" },
        { id: "note", label: "📝", desc: "Notiz" },
      ],
    },
  };

  const hasDescription = (type: string) =>
    ["activity", "action", "state", "class", "interface", "entity", "table", "attribute", "note", "swimlane"].includes(type);

  const currentNodes = nodeCategories[selectedCategory as keyof typeof nodeCategories]?.nodes || [];

  return (
    <div className="border rounded-lg overflow-hidden">
      {/* Edit Modal */}
      <EditModal
        isOpen={editModalOpen}
        node={editingNode}
        onSave={handleEditSave}
        onClose={() => {
          setEditModalOpen(false);
          setEditingNode(null);
        }}
        hasDescription={editingNode ? hasDescription(editingNode.type || "") : false}
      />

      {/* Add Modal */}
      <AddModal
        isOpen={addModalOpen}
        nodeType={selectedNodeType}
        onSave={handleAddSave}
        onClose={() => setAddModalOpen(false)}
        hasDescription={hasDescription(selectedNodeType)}
      />

      {/* Tab-Auswahl: Zeichnen / Upload */}
      <div className="flex border-b">
        <button
          onClick={() => setMode("draw")}
          className={`flex-1 py-3 px-4 font-medium transition ${
            mode === "draw"
              ? "bg-blue-50 text-blue-700 border-b-2 border-blue-700"
              : "text-gray-600 hover:bg-gray-50"
          }`}
        >
          ✏️ Zeichnen
        </button>
        <button
          onClick={() => setMode("upload")}
          className={`flex-1 py-3 px-4 font-medium transition ${
            mode === "upload"
              ? "bg-blue-50 text-blue-700 border-b-2 border-blue-700"
              : "text-gray-600 hover:bg-gray-50"
          }`}
        >
          📷 Bild hochladen
        </button>
      </div>

      {mode === "draw" ? (
        <div>
          {/* Kategorie-Auswahl */}
          <div className="flex gap-1 p-2 bg-gray-100 border-b overflow-x-auto">
            {Object.entries(nodeCategories).map(([key, cat]) => (
              <button
                key={key}
                onClick={() => {
                  setSelectedCategory(key);
                  setSelectedNodeType(cat.nodes[0]?.id || "activity");
                }}
                className={`px-3 py-1.5 rounded text-sm font-medium whitespace-nowrap transition ${
                  selectedCategory === key
                    ? "bg-blue-600 text-white"
                    : "bg-white border hover:bg-gray-50"
                }`}
              >
                {cat.label}
              </button>
            ))}
          </div>

          {/* Werkzeugleiste */}
          <div className="flex items-center gap-1 p-2 bg-gray-50 border-b flex-wrap">
            {currentNodes.map((opt) => (
              <button
                key={opt.id}
                onClick={() => setSelectedNodeType(opt.id)}
                title={opt.desc}
                className={`w-9 h-9 rounded flex items-center justify-center text-sm transition ${
                  selectedNodeType === opt.id
                    ? "bg-blue-600 text-white"
                    : "bg-white border hover:bg-gray-100"
                }`}
              >
                {opt.label}
              </button>
            ))}

            <div className="w-px h-8 bg-gray-300 mx-2" />

            <button
              onClick={openAddModal}
              className="px-3 py-1.5 bg-green-100 text-green-700 rounded hover:bg-green-200 transition text-sm"
            >
              ➕ Hinzufügen
            </button>

            <button
              onClick={deleteSelected}
              className="px-3 py-1.5 bg-orange-100 text-orange-700 rounded hover:bg-orange-200 transition text-sm"
            >
              🗑️ Löschen
            </button>

            <button
              onClick={clearAll}
              className="px-3 py-1.5 bg-red-100 text-red-700 rounded hover:bg-red-200 transition text-sm"
            >
              🧹 Alles
            </button>
          </div>

          {/* React Flow Canvas */}
          <div style={{ height: "500px" }}>
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
            >
              <Controls />
              <Background gap={15} size={1} />
            </ReactFlow>
          </div>

          <div className="p-2 bg-gray-50 border-t text-sm text-gray-500">
            💡 Element wählen → Hinzufügen → Ziehen → Verbindungspunkte nutzen | Doppelklick = Bearbeiten
          </div>
        </div>
      ) : (
        <div className="p-8">
          {uploadedImage ? (
            <div className="space-y-4">
              <img
                src={uploadedImage}
                alt="Hochgeladenes Diagramm"
                className="max-w-full rounded border"
              />
              <button
                onClick={() => setUploadedImage(null)}
                className="px-4 py-2 bg-red-100 text-red-700 rounded hover:bg-red-200"
              >
                Bild entfernen
              </button>
            </div>
          ) : (
            <label className="flex flex-col items-center justify-center h-64 border-2 border-dashed border-gray-300 rounded-lg cursor-pointer hover:bg-gray-50 transition">
              <div className="text-center">
                <div className="text-4xl mb-2">📁</div>
                <p className="text-gray-600 font-medium">Klicken zum Hochladen</p>
                <p className="text-gray-400 text-sm mt-1">PNG, JPG oder GIF</p>
              </div>
              <input
                type="file"
                accept="image/*"
                onChange={handleFileUpload}
                className="hidden"
              />
            </label>
          )}
        </div>
      )}
    </div>
  );
}