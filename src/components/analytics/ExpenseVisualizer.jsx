import React, { useState } from 'react';
import { usePetContext } from '../../context/PetContext';
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer
} from 'recharts';
import { IndianRupee, Plus, PieChart, ShoppingBag, Stethoscope, Scissors, Sparkles } from 'lucide-react';
import { formatINR } from '../../utils/formatCurrency';
import { AddExpenseModal } from './AddExpenseModal';

export const ExpenseVisualizer = () => {
  const { activePet, expenses } = usePetContext();
  const [isAddModalOpen, setIsAddModalOpen] = useState(false);

  if (!activePet) return null;

  // Calculate totals
  const totalAllTime = expenses.reduce((acc, curr) => acc + (curr.total || 0), 0);
  const avgMonthly = expenses.length > 0 ? (totalAllTime / expenses.length).toFixed(0) : 0;

  // Breakdown across categories
  const totalsByCategory = expenses.reduce(
    (acc, curr) => ({
      food: acc.food + (curr.food || 0),
      vet: acc.vet + (curr.vet || 0),
      grooming: acc.grooming + (curr.grooming || 0),
      accessories: acc.accessories + (curr.accessories || 0),
    }),
    { food: 0, vet: 0, grooming: 0, accessories: 0 }
  );

  return (
    <div className="bg-white rounded-3xl border border-slate-200/80 p-6 shadow-xs mt-6">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-6 border-b border-slate-100">
        <div>
          <div className="flex items-center gap-2">
            <div className="p-2 rounded-xl bg-emerald-50 text-emerald-700">
              <IndianRupee className="w-5 h-5" />
            </div>
            <div>
              <h3 className="text-lg font-bold text-slate-900">Petcare Expense Visualizer</h3>
              <p className="text-xs text-slate-500">
                Monthly breakdown across food nutrition, vet clinical care, grooming, and supplies
              </p>
            </div>
          </div>
        </div>

        <div className="flex items-center gap-3">
          <div className="text-right hidden sm:block">
            <span className="text-[10px] font-bold uppercase text-slate-400 block">Avg Monthly Spend</span>
            <span className="text-lg font-black text-slate-900">{formatINR(avgMonthly)}/mo</span>
          </div>

          <button
            onClick={() => setIsAddModalOpen(true)}
            className="flex items-center gap-1.5 px-3.5 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-xl shadow-xs transition-colors cursor-pointer shrink-0"
          >
            <Plus className="w-3.5 h-3.5" />
            <span>Record Expense</span>
          </button>
        </div>
      </div>

      {/* Category Totals Pill Row */}
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 my-5">
        <div className="p-3.5 rounded-xl bg-slate-50 border border-slate-100">
          <span className="text-[10px] font-bold uppercase text-slate-400 flex items-center gap-1">
            <ShoppingBag className="w-3 h-3 text-emerald-600" />
            Food & Treats
          </span>
          <span className="text-base font-black text-slate-900 mt-1 block">
            {formatINR(totalsByCategory.food)}
          </span>
        </div>

        <div className="p-3.5 rounded-xl bg-slate-50 border border-slate-100">
          <span className="text-[10px] font-bold uppercase text-slate-400 flex items-center gap-1">
            <Stethoscope className="w-3 h-3 text-teal-600" />
            Veterinary & Meds
          </span>
          <span className="text-base font-black text-slate-900 mt-1 block">
            {formatINR(totalsByCategory.vet)}
          </span>
        </div>

        <div className="p-3.5 rounded-xl bg-slate-50 border border-slate-100">
          <span className="text-[10px] font-bold uppercase text-slate-400 flex items-center gap-1">
            <Scissors className="w-3 h-3 text-amber-600" />
            Spa & Grooming
          </span>
          <span className="text-base font-black text-slate-900 mt-1 block">
            {formatINR(totalsByCategory.grooming)}
          </span>
        </div>

        <div className="p-3.5 rounded-xl bg-slate-50 border border-slate-100">
          <span className="text-[10px] font-bold uppercase text-slate-400 flex items-center gap-1">
            <Sparkles className="w-3 h-3 text-indigo-600" />
            Toys & Gear
          </span>
          <span className="text-base font-black text-slate-900 mt-1 block">
            {formatINR(totalsByCategory.accessories)}
          </span>
        </div>
      </div>

      {/* RECHARTS STACKED BAR CHART */}
      <div className="h-72 w-full pt-4">
        <ResponsiveContainer width="100%" height="100%">
          <BarChart data={expenses} margin={{ top: 10, right: 10, left: -10, bottom: 0 }}>
            <CartesianGrid strokeDasharray="3 3" stroke="#f1f5f9" vertical={false} />
            <XAxis dataKey="month" stroke="#94a3b8" fontSize={11} tickLine={false} />
            <YAxis
              stroke="#94a3b8"
              fontSize={11}
              tickLine={false}
              tickFormatter={(v) => (v >= 1000 ? `₹${(v / 1000).toFixed(0)}k` : `₹${v}`)}
            />
            <Tooltip
              content={({ active, payload, label }) => {
                if (active && payload && payload.length) {
                  return (
                    <div className="bg-slate-900 text-white p-3 rounded-xl shadow-xl text-xs space-y-1">
                      <p className="font-bold text-emerald-400 mb-1">{label} Expenses</p>
                      {payload.map((entry, idx) => (
                        <div key={idx} className="flex justify-between gap-4 text-slate-200">
                          <span className="capitalize">{entry.name}:</span>
                          <span className="font-bold text-white">{formatINR(entry.value)}</span>
                        </div>
                      ))}
                      <div className="pt-1.5 border-t border-slate-700 flex justify-between font-black text-emerald-300">
                        <span>Total:</span>
                        <span>
                          {formatINR(payload.reduce((acc, curr) => acc + Number(curr.value || 0), 0))}
                        </span>
                      </div>
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
            <Bar dataKey="food" name="Food & Diet" fill="#10b981" radius={[4, 4, 0, 0]} stackId="a" />
            <Bar dataKey="vet" name="Vet & Pharmacy" fill="#0d9488" stackId="a" />
            <Bar dataKey="grooming" name="Grooming" fill="#f59e0b" stackId="a" />
            <Bar dataKey="accessories" name="Accessories" fill="#6366f1" radius={[4, 4, 0, 0]} stackId="a" />
          </BarChart>
        </ResponsiveContainer>
      </div>

      <AddExpenseModal isOpen={isAddModalOpen} onClose={() => setIsAddModalOpen(false)} />
    </div>
  );
};
