"use client";

import { useState } from "react";

interface FillBlanksSQLProps {
  questionId: string;
}

export default function FillBlanksSQL({ questionId }: FillBlanksSQLProps) {
  const [answers, setAnswers] = useState({
    select: "",
    from: "",
    innerFrom: "",
    where1: "",
    where2: "",
  });

  const handleChange = (field: string, value: string) => {
    setAnswers((prev) => ({ ...prev, [field]: value }));
  };

  const inputClass = "bg-yellow-50 border-2 border-blue-400 rounded px-3 py-1 text-black focus:border-blue-600 focus:outline-none placeholder-gray-400";

  return (
    <div className="bg-gray-100 text-gray-900 p-6 rounded-lg font-mono text-sm border">
      <div className="space-y-3">
        {/* SELECT */}
        <div className="flex items-center gap-2">
          <span className="text-blue-600 font-bold w-24">SELECT</span>
          <input
            type="text"
            value={answers.select}
            onChange={(e) => handleChange("select", e.target.value)}
            className={`${inputClass} flex-1`}
            placeholder="Spalte(n) eingeben..."
          />
        </div>

        {/* FROM */}
        <div className="flex items-center gap-2">
          <span className="text-blue-600 font-bold w-24">FROM</span>
          <input
            type="text"
            value={answers.from}
            onChange={(e) => handleChange("from", e.target.value)}
            className={`${inputClass} flex-1`}
            placeholder="Tabelle eingeben..."
          />
        </div>

        {/* WHERE */}
        <div className="flex items-center gap-2">
          <span className="text-blue-600 font-bold w-24">WHERE</span>
          <span className="text-gray-700">Fahrzeug_Ladeplan.Fahrzeug_ID = 14</span>
        </div>

        {/* AND NOT EXISTS */}
        <div className="flex items-center gap-2 ml-8">
          <span className="text-blue-600 font-bold">AND NOT EXISTS</span>
        </div>

        {/* Unterabfrage */}
        <div className="ml-12 border-l-4 border-blue-300 pl-4 space-y-3 bg-white p-4 rounded">
          <div className="flex items-center gap-2">
            <span className="text-gray-500">(</span>
            <span className="text-blue-600 font-bold">SELECT</span>
            <span className="text-gray-700">*</span>
          </div>

          <div className="flex items-center gap-2">
            <span className="text-blue-600 font-bold w-20">FROM</span>
            <input
              type="text"
              value={answers.innerFrom}
              onChange={(e) => handleChange("innerFrom", e.target.value)}
              className={`${inputClass} w-48`}
              placeholder="Tabelle..."
            />
          </div>

          <div className="flex items-center gap-2 flex-wrap">
            <span className="text-blue-600 font-bold w-20">WHERE</span>
            <input
              type="text"
              value={answers.where1}
              onChange={(e) => handleChange("where1", e.target.value)}
              className={`${inputClass} w-64`}
              placeholder="Spalte eingeben..."
            />
            <span className="text-gray-700">= 521</span>
          </div>

          <div className="flex items-center gap-2 flex-wrap">
            <span className="text-blue-600 font-bold w-20">AND</span>
            <input
              type="text"
              value={answers.where2}
              onChange={(e) => handleChange("where2", e.target.value)}
              className={`${inputClass} w-48`}
              placeholder="Spalte eingeben..."
            />
            <span className="text-gray-700">= Fahrzeug_Ladeplan.Platz</span>
            <span className="text-gray-500">)</span>
          </div>
        </div>
      </div>
    </div>
  );
}