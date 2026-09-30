import React, { useState } from 'react';
import { usePetContext } from '../../context/PetContext';
import {
  Syringe,
  CheckCircle2,
  AlertCircle,
  Clock,
  Plus,
  Filter,
  Check
} from 'lucide-react';
import { Badge } from '../common/Badge';
import { AddVaccineModal } from './AddVaccineModal';

export const VaccinationTimeline = () => {
  const { activePet, vaccines, toggleVaccineStatus } = usePetContext();
  const [filter, setFilter] = useState('All');
  const [isAddModalOpen, setIsAddModalOpen] = useState(false);

  const filteredVaccines = vaccines.filter((v) => {
    if (filter === 'All') return true;
    return v.status === filter;
  });

  const getStatusBadge = (status) => {
    switch (status) {
      case 'Completed':
        return (
          <Badge variant="emerald" size="sm">
            <CheckCircle2 className="w-3 h-3 text-emerald-600" />
            <span>Completed</span>
          </Badge>
        );
      case 'Due Soon':
        return (
          <Badge variant="amber" size="sm">
            <Clock className="w-3 h-3 text-amber-600" />
            <span>Due Soon</span>
          </Badge>
        );
      case 'Overdue':
        return (
          <Badge variant="rose" size="sm">
            <AlertCircle className="w-3 h-3 text-rose-600" />
            <span>Overdue</span>
          </Badge>
        );
      default:
        return <Badge variant="slate" size="sm">{status}</Badge>;
    }
  };

  return (
    <div className="bg-white rounded-3xl border border-slate-200/80 p-6 shadow-xs">
      {/* Header and Controls */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-5 border-b border-slate-100">
        <div>
          <div className="flex items-center gap-2">
            <div className="p-2 rounded-xl bg-emerald-50 text-emerald-700">
              <Syringe className="w-5 h-5" />
            </div>
            <div>
              <h2 className="text-lg font-bold text-slate-900">Vaccination Immunization Ledger</h2>
              <p className="text-xs text-slate-500">
                Official vaccination history and booster schedule for {activePet?.name}
              </p>
            </div>
          </div>
        </div>

        <div className="flex items-center gap-2">
          {/* Status Filter Chips */}
          <div className="flex items-center bg-slate-100 p-1 rounded-xl">
            {['All', 'Completed', 'Due Soon', 'Overdue'].map((st) => (
              <button
                key={st}
                onClick={() => setFilter(st)}
                className={`px-2.5 py-1 text-xs font-bold rounded-lg transition-all cursor-pointer ${
                  filter === st
                    ? 'bg-white text-slate-900 shadow-2xs'
                    : 'text-slate-500 hover:text-slate-800'
                }`}
              >
                {st}
              </button>
            ))}
          </div>

          <button
            onClick={() => setIsAddModalOpen(true)}
            className="flex items-center gap-1.5 px-3 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-xl shadow-xs transition-colors cursor-pointer shrink-0"
          >
            <Plus className="w-3.5 h-3.5" />
            <span>Add Dose</span>
          </button>
        </div>
      </div>

      {/* Timeline Feed */}
      <div className="pt-6">
        {filteredVaccines.length === 0 ? (
          <div className="text-center py-12 px-4 rounded-2xl bg-slate-50 border border-dashed border-slate-200">
            <Syringe className="w-8 h-8 text-slate-300 mx-auto mb-2" />
            <p className="text-xs font-bold text-slate-600">No vaccination records found matching filter.</p>
          </div>
        ) : (
          <div className="relative pl-6 space-y-6 before:absolute before:left-2.5 before:top-3 before:bottom-3 before:w-0.5 before:bg-slate-200">
            {filteredVaccines.map((vax) => {
              const isCompleted = vax.status === 'Completed';

              return (
                <div key={vax.id} className="relative group">
                  {/* Timeline bullet dot */}
                  <div
                    className={`absolute -left-6 top-1 w-5 h-5 rounded-full border-2 border-white ring-2 flex items-center justify-center transition-transform group-hover:scale-110 ${
                      isCompleted
                        ? 'bg-emerald-500 ring-emerald-200 text-white'
                        : vax.status === 'Overdue'
                        ? 'bg-rose-500 ring-rose-200 text-white animate-pulse'
                        : 'bg-amber-500 ring-amber-200 text-white'
                    }`}
                  >
                    {isCompleted ? <Check className="w-3 h-3 stroke-[3]" /> : <span className="w-1.5 h-1.5 rounded-full bg-white" />}
                  </div>

                  {/* Card Content */}
                  <div className="bg-slate-50/80 hover:bg-slate-50 border border-slate-200/80 rounded-2xl p-4.5 transition-all">
                    <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 mb-2">
                      <div className="flex items-center gap-2">
                        <h4 className="text-sm font-bold text-slate-900">{vax.name}</h4>
                        <span className="text-[10px] font-bold px-2 py-0.5 rounded-md bg-slate-200/70 text-slate-700">
                          {vax.type}
                        </span>
                      </div>
                      <div className="flex items-center gap-2">
                        {getStatusBadge(vax.status)}
                        <button
                          onClick={() => toggleVaccineStatus(activePet.id, vax.id)}
                          className={`text-xs font-bold px-2.5 py-1 rounded-lg border transition-colors cursor-pointer ${
                            isCompleted
                              ? 'text-slate-500 border-slate-200 hover:bg-slate-100'
                              : 'text-emerald-700 bg-emerald-50 border-emerald-300 hover:bg-emerald-100'
                          }`}
                        >
                          {isCompleted ? 'Mark Pending' : 'Mark Completed'}
                        </button>
                      </div>
                    </div>

                    <div className="grid grid-cols-1 sm:grid-cols-3 gap-2 text-xs text-slate-500 py-2 border-y border-slate-200/60 my-2">
                      <div>
                        <span className="text-slate-400 block text-[10px] uppercase font-semibold">Administered</span>
                        <span className="font-medium text-slate-800">{vax.administeredDate || 'Not yet'}</span>
                      </div>
                      <div>
                        <span className="text-slate-400 block text-[10px] uppercase font-semibold">Next Booster Due</span>
                        <span className="font-bold text-slate-900">{vax.dueDate}</span>
                      </div>
                      <div>
                        <span className="text-slate-400 block text-[10px] uppercase font-semibold">Batch / Serial</span>
                        <span className="font-mono text-slate-700">{vax.batchNumber || 'N/A'}</span>
                      </div>
                    </div>

                    <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-1 text-[11px] text-slate-400 mt-2">
                      <span className="truncate">
                        🏥 {vax.clinic} • {vax.veterinarian}
                      </span>
                      {vax.notes && <span className="text-slate-500 italic">"{vax.notes}"</span>}
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

      <AddVaccineModal isOpen={isAddModalOpen} onClose={() => setIsAddModalOpen(false)} />
    </div>
  );
};
