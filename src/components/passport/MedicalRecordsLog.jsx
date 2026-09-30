import React, { useState } from 'react';
import { usePetContext } from '../../context/PetContext';
import {
  FileText,
  Stethoscope,
  Pill,
  FlaskConical,
  Plus,
  Printer,
  Calendar,
  UserCheck,
  Building,
  Paperclip,
  Activity,
  Search
} from 'lucide-react';
import { Badge } from '../common/Badge';
import { AddRecordModal } from './AddRecordModal';
import { PrintablePassportModal } from './PrintablePassportModal';

export const MedicalRecordsLog = () => {
  const { activePet, medicalRecords } = usePetContext();
  const [selectedCategory, setSelectedCategory] = useState('All');
  const [filterKeyword, setFilterKeyword] = useState('');
  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [isPrintModalOpen, setIsPrintModalOpen] = useState(false);

  const categories = ['All', 'Vet Visit', 'Prescription', 'Lab Results', 'Surgery'];

  const filteredRecords = medicalRecords.filter((rec) => {
    if (selectedCategory !== 'All' && rec.category !== selectedCategory) return false;
    if (filterKeyword.trim()) {
      const q = filterKeyword.toLowerCase();
      const matchTitle = rec.title.toLowerCase().includes(q);
      const matchDoctor = rec.doctor.toLowerCase().includes(q);
      const matchDiagnosis = rec.diagnosis?.toLowerCase().includes(q);
      return matchTitle || matchDoctor || matchDiagnosis;
    }
    return true;
  });

  return (
    <div className="bg-white rounded-3xl border border-slate-200/80 p-6 shadow-xs mt-6">
      {/* Header and Action Controls */}
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-5 border-b border-slate-100">
        <div>
          <div className="flex items-center gap-2">
            <div className="p-2 rounded-xl bg-teal-50 text-teal-700">
              <FileText className="w-5 h-5" />
            </div>
            <div>
              <h2 className="text-lg font-bold text-slate-900">Clinical Encounters & Medical Log</h2>
              <p className="text-xs text-slate-500">
                Official diagnostic logs, prescriptions, and lab panels for {activePet?.name}
              </p>
            </div>
          </div>
        </div>

        <div className="flex items-center gap-2.5">
          {/* Printable Handover PDF Export Button */}
          <button
            onClick={() => setIsPrintModalOpen(true)}
            className="flex items-center gap-1.5 px-3 py-1.5 bg-slate-100 hover:bg-slate-200/80 text-slate-700 text-xs font-bold rounded-xl transition-colors cursor-pointer"
          >
            <Printer className="w-3.5 h-3.5 text-slate-600" />
            <span>Print / Export PDF</span>
          </button>

          <button
            onClick={() => setIsAddModalOpen(true)}
            className="flex items-center gap-1.5 px-3.5 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-xl shadow-xs transition-colors cursor-pointer"
          >
            <Plus className="w-3.5 h-3.5" />
            <span>Add Record</span>
          </button>
        </div>
      </div>

      {/* Filter and Search Bar */}
      <div className="flex flex-col sm:flex-row items-center justify-between gap-3 pt-5 pb-4">
        {/* Category Pills */}
        <div className="flex items-center gap-1.5 overflow-x-auto w-full sm:w-auto pb-1 sm:pb-0">
          {categories.map((cat) => (
            <button
              key={cat}
              onClick={() => setSelectedCategory(cat)}
              className={`px-3 py-1 rounded-xl text-xs font-bold transition-all cursor-pointer whitespace-nowrap ${
                selectedCategory === cat
                  ? 'bg-slate-900 text-white shadow-xs'
                  : 'bg-slate-100 text-slate-600 hover:bg-slate-200/70'
              }`}
            >
              {cat}
            </button>
          ))}
        </div>

        {/* Search input */}
        <div className="relative w-full sm:w-64">
          <Search className="w-3.5 h-3.5 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
          <input
            type="text"
            placeholder="Search diagnosis or doctor..."
            value={filterKeyword}
            onChange={(e) => setFilterKeyword(e.target.value)}
            className="w-full pl-8 pr-3 py-1.5 bg-slate-50 border border-slate-200 text-xs rounded-xl focus:outline-hidden focus:border-emerald-500"
          />
        </div>
      </div>

      {/* Records Cards List */}
      <div className="space-y-4 pt-2">
        {filteredRecords.length === 0 ? (
          <div className="text-center py-12 px-4 rounded-2xl bg-slate-50 border border-dashed border-slate-200">
            <FileText className="w-8 h-8 text-slate-300 mx-auto mb-2" />
            <p className="text-xs font-bold text-slate-600">No medical encounter records found.</p>
            <p className="text-[11px] text-slate-400 mt-1">Try switching category or log a new checkup</p>
          </div>
        ) : (
          filteredRecords.map((rec) => (
            <div
              key={rec.id}
              className="p-5 rounded-2xl border border-slate-200/80 bg-slate-50/50 hover:bg-white hover:shadow-xs transition-all"
            >
              {/* Card Header */}
              <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2 mb-3">
                <div className="flex items-center gap-2.5">
                  <span className="p-2 rounded-xl bg-white border border-slate-100 text-emerald-700 shadow-2xs">
                    {rec.category === 'Prescription' ? (
                      <Pill className="w-4 h-4 text-amber-600" />
                    ) : rec.category === 'Lab Results' ? (
                      <FlaskConical className="w-4 h-4 text-teal-600" />
                    ) : (
                      <Stethoscope className="w-4 h-4 text-emerald-600" />
                    )}
                  </span>
                  <div>
                    <h3 className="text-sm font-bold text-slate-900">{rec.title}</h3>
                    <p className="text-[11px] text-slate-400 flex items-center gap-2 mt-0.5">
                      <span className="flex items-center gap-1">
                        <Calendar className="w-3 h-3" />
                        {rec.date}
                      </span>
                      <span>•</span>
                      <span className="flex items-center gap-1">
                        <UserCheck className="w-3 h-3" />
                        {rec.doctor}
                      </span>
                      <span>•</span>
                      <span className="flex items-center gap-1">
                        <Building className="w-3 h-3" />
                        {rec.clinic}
                      </span>
                    </p>
                  </div>
                </div>

                <Badge variant={rec.category === 'Prescription' ? 'amber' : 'emerald'} size="sm">
                  {rec.category}
                </Badge>
              </div>

              {/* Diagnosis block */}
              <div className="p-3.5 rounded-xl bg-white border border-slate-100 my-3">
                <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider block mb-1">
                  Diagnosis & Findings
                </span>
                <p className="text-xs text-slate-800 font-medium leading-relaxed">{rec.diagnosis}</p>
                {rec.notes && <p className="text-[11px] text-slate-500 mt-2 italic">Note: {rec.notes}</p>}
              </div>

              {/* Prescriptions Pill Row */}
              {rec.prescriptions && rec.prescriptions.length > 0 && (
                <div className="mt-3">
                  <span className="text-[10px] font-bold text-slate-400 uppercase tracking-wider block mb-1.5">
                    Prescribed Medications:
                  </span>
                  <div className="flex flex-wrap gap-2">
                    {rec.prescriptions.map((rx, idx) => (
                      <div
                        key={idx}
                        className="flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-amber-50 text-amber-900 border border-amber-200/80 text-xs font-semibold"
                      >
                        <Pill className="w-3 h-3 text-amber-700 shrink-0" />
                        <span>{rx.name}</span>
                        <span className="text-[10px] text-amber-700/80 font-normal">
                          ({rx.dosage} • {rx.frequency})
                        </span>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {/* Vitals Summary Pill */}
              {rec.vitals && (
                <div className="flex items-center gap-4 mt-3 text-[11px] text-slate-500 pt-2 border-t border-slate-100">
                  <span className="font-semibold text-slate-700 flex items-center gap-1">
                    <Activity className="w-3 h-3 text-emerald-600" />
                    Vitals:
                  </span>
                  {rec.vitals.temp && <span>Temp: {rec.vitals.temp}</span>}
                  {rec.vitals.heartRate && <span>Pulse: {rec.vitals.heartRate}</span>}
                  {rec.vitals.weight && <span>Weight: {rec.vitals.weight}</span>}
                  {rec.fileAttachmentName && (
                    <span className="ml-auto flex items-center gap-1 text-emerald-700 font-bold hover:underline cursor-pointer">
                      <Paperclip className="w-3 h-3" />
                      {rec.fileAttachmentName}
                    </span>
                  )}
                </div>
              )}
            </div>
          ))
        )}
      </div>

      {/* Add Record Modal */}
      <AddRecordModal isOpen={isAddModalOpen} onClose={() => setIsAddModalOpen(false)} />

      {/* Printable Passport Modal */}
      <PrintablePassportModal
        isOpen={isPrintModalOpen}
        onClose={() => setIsPrintModalOpen(false)}
      />
    </div>
  );
};
