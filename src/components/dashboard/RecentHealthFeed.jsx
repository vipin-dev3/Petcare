import React from 'react';
import { usePetContext } from '../../context/PetContext';
import { FileText, Pill, Stethoscope, FlaskConical, ChevronRight } from 'lucide-react';
import { Badge } from '../common/Badge';

export const RecentHealthFeed = () => {
  const { medicalRecords, setActiveTab } = usePetContext();

  const getCategoryIcon = (category) => {
    switch (category) {
      case 'Vet Visit':
        return <Stethoscope className="w-4 h-4 text-emerald-600" />;
      case 'Prescription':
        return <Pill className="w-4 h-4 text-amber-600" />;
      case 'Lab Results':
        return <FlaskConical className="w-4 h-4 text-teal-600" />;
      default:
        return <FileText className="w-4 h-4 text-slate-600" />;
    }
  };

  return (
    <div className="bg-white rounded-2xl border border-slate-200/80 p-5 shadow-xs">
      <div className="flex items-center justify-between mb-4">
        <div className="flex items-center gap-2">
          <div className="p-2 rounded-xl bg-emerald-50 text-emerald-700">
            <FileText className="w-4 h-4" />
          </div>
          <div>
            <h3 className="text-sm font-bold text-slate-900">Recent Medical Encounters</h3>
            <p className="text-[11px] text-slate-400">Clinical notes & lab findings</p>
          </div>
        </div>

        <button
          onClick={() => setActiveTab('passport')}
          className="flex items-center gap-1 text-xs font-bold text-emerald-700 hover:text-emerald-800 hover:bg-emerald-50 px-2.5 py-1.5 rounded-lg transition-colors cursor-pointer"
        >
          <span>Full History</span>
          <ChevronRight className="w-3.5 h-3.5" />
        </button>
      </div>

      {medicalRecords.length === 0 ? (
        <div className="text-center py-8 px-4 rounded-xl bg-slate-50 border border-dashed border-slate-200">
          <p className="text-xs font-semibold text-slate-600">No medical records on file</p>
          <p className="text-[11px] text-slate-400 mt-1">Add checkup findings or prescription logs</p>
        </div>
      ) : (
        <div className="space-y-3">
          {medicalRecords.slice(0, 3).map((rec) => (
            <div
              key={rec.id}
              onClick={() => setActiveTab('passport')}
              className="p-3.5 rounded-xl border border-slate-100 bg-slate-50/60 hover:bg-slate-50 hover:border-slate-200 transition-all cursor-pointer"
            >
              <div className="flex items-start justify-between gap-2">
                <div className="flex items-start gap-2.5">
                  <div className="p-2 rounded-lg bg-white border border-slate-100 shadow-2xs mt-0.5">
                    {getCategoryIcon(rec.category)}
                  </div>
                  <div>
                    <h4 className="text-xs font-bold text-slate-900 leading-snug">{rec.title}</h4>
                    <p className="text-[11px] text-slate-500 mt-0.5">{rec.diagnosis}</p>
                    <p className="text-[10px] text-slate-400 mt-1">
                      {rec.doctor} • {rec.date}
                    </p>
                  </div>
                </div>
                <Badge variant={rec.category === 'Prescription' ? 'amber' : 'emerald'} size="sm">
                  {rec.category}
                </Badge>
              </div>

              {rec.prescriptions && rec.prescriptions.length > 0 && (
                <div className="mt-2.5 pt-2 border-t border-slate-200/60 flex items-center gap-1.5 text-[11px] text-slate-600 font-medium">
                  <Pill className="w-3 h-3 text-amber-600 shrink-0" />
                  <span className="truncate">
                    Rx: {rec.prescriptions.map((p) => p.name).join(', ')}
                  </span>
                </div>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  );
};
