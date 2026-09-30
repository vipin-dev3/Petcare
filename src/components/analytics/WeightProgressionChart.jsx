import React, { useState } from 'react';
import { usePetContext } from '../../context/PetContext';
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  ReferenceArea,
  Legend
} from 'recharts';
import { Scale, Plus, CheckCircle, TrendingUp } from 'lucide-react';
import { AddWeightModal } from './AddWeightModal';

export const WeightProgressionChart = () => {
  const { activePet, weightHistory } = usePetContext();
  const [isAddModalOpen, setIsAddModalOpen] = useState(false);

  if (!activePet) return null;

  const [minIdeal, maxIdeal] = activePet.idealWeightRange || [
    activePet.weight * 0.9,
    activePet.weight * 1.1,
  ];

  const currentWeight = activePet.weight;
  const isHealthy = currentWeight >= minIdeal && currentWeight <= maxIdeal;

  return (
    <div className="bg-white rounded-3xl border border-slate-200/80 p-6 shadow-xs">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-6 border-b border-slate-100">
        <div>
          <div className="flex items-center gap-2">
            <div className="p-2 rounded-xl bg-amber-50 text-amber-700">
              <Scale className="w-5 h-5" />
            </div>
            <div>
              <h3 className="text-lg font-bold text-slate-900">
                Weight Progression & Breed Ideal Benchmark
              </h3>
              <p className="text-xs text-slate-500">
                Tracking physical development against veterinary standards for {activePet.breed}
              </p>
            </div>
          </div>
        </div>

        <div className="flex items-center gap-3">
          <div className="text-right hidden sm:block">
            <span className="text-[10px] font-bold uppercase text-slate-400 block">Current Weight</span>
            <span className="text-lg font-black text-slate-900">
              {currentWeight} {activePet.weightUnit}
            </span>
          </div>

          <button
            onClick={() => setIsAddModalOpen(true)}
            className="flex items-center gap-1.5 px-3.5 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-xl shadow-xs transition-colors cursor-pointer shrink-0"
          >
            <Plus className="w-3.5 h-3.5" />
            <span>Log Weight</span>
          </button>
        </div>
      </div>

      {/* Benchmark Summary Pills */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-3 my-5">
        <div className="p-3.5 rounded-xl bg-slate-50 border border-slate-100">
          <span className="text-[10px] font-bold uppercase text-slate-400 block">Ideal Range Min</span>
          <span className="text-sm font-bold text-slate-800">
            {minIdeal.toFixed(1)} {activePet.weightUnit}
          </span>
        </div>

        <div className="p-3.5 rounded-xl bg-slate-50 border border-slate-100">
          <span className="text-[10px] font-bold uppercase text-slate-400 block">Ideal Range Max</span>
          <span className="text-sm font-bold text-slate-800">
            {maxIdeal.toFixed(1)} {activePet.weightUnit}
          </span>
        </div>

        <div className="p-3.5 rounded-xl bg-slate-50 border border-slate-100 flex items-center justify-between">
          <div>
            <span className="text-[10px] font-bold uppercase text-slate-400 block">Clinical Assessment</span>
            <span className="text-sm font-bold text-slate-900">
              {isHealthy ? 'Optimal Body Condition' : 'Weight Monitoring Required'}
            </span>
          </div>
          {isHealthy && <CheckCircle className="w-4 h-4 text-emerald-600" />}
        </div>
      </div>

      {/* RECHARTS LINE GRAPH */}
      <div className="h-72 w-full pt-4">
        <ResponsiveContainer width="100%" height="100%">
          <LineChart data={weightHistory} margin={{ top: 10, right: 20, left: -10, bottom: 0 }}>
            <CartesianGrid strokeDasharray="3 3" stroke="#f1f5f9" vertical={false} />
            <XAxis dataKey="date" stroke="#94a3b8" fontSize={11} tickLine={false} />
            <YAxis
              domain={['auto', 'auto']}
              stroke="#94a3b8"
              fontSize={11}
              tickLine={false}
              unit={` ${activePet.weightUnit}`}
            />
            <Tooltip
              content={({ active, payload }) => {
                if (active && payload && payload.length) {
                  const data = payload[0].payload;
                  return (
                    <div className="bg-slate-900 text-white p-3 rounded-xl shadow-xl text-xs space-y-1">
                      <p className="font-bold text-emerald-400">{data.date}</p>
                      <p className="font-black text-sm">
                        Weight: {data.weight} {activePet.weightUnit}
                      </p>
                      <p className="text-slate-300 text-[11px]">
                        Target Range: {data.idealMin} - {data.idealMax} {activePet.weightUnit}
                      </p>
                      {data.note && <p className="text-slate-400 italic text-[10px]">"{data.note}"</p>}
                    </div>
                  );
                }
                return null;
              }}
            />
            <Legend
              wrapperStyle={{ fontSize: '11px', paddingTop: '10px' }}
              iconType="circle"
            />
            {/* Ideal target range shaded area */}
            <ReferenceArea
              y1={minIdeal}
              y2={maxIdeal}
              fill="#10b981"
              fillOpacity={0.07}
              stroke="#10b981"
              strokeDasharray="3 3"
              strokeOpacity={0.4}
            />
            <Line
              type="monotone"
              name="Recorded Weight"
              dataKey="weight"
              stroke="#0d9488"
              strokeWidth={3}
              dot={{ r: 5, fill: '#0d9488', stroke: '#fff', strokeWidth: 2 }}
              activeDot={{ r: 7, fill: '#047857' }}
            />
          </LineChart>
        </ResponsiveContainer>
      </div>

      <AddWeightModal isOpen={isAddModalOpen} onClose={() => setIsAddModalOpen(false)} />
    </div>
  );
};
