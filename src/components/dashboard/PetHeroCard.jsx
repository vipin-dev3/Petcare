import React from 'react';
import { usePetContext } from '../../context/PetContext';
import {
  ShieldAlert,
  Dna,
  Scale,
  Calendar,
  Sparkles,
  QrCode,
  Tag,
  Heart,
  ChevronRight,
  AlertCircle
} from 'lucide-react';
import { Badge } from '../common/Badge';

export const PetHeroCard = () => {
  const { activePet, setActiveTab } = usePetContext();

  if (!activePet) return null;

  return (
    <div className="relative overflow-hidden bg-white rounded-3xl border border-slate-200/80 shadow-md">
      {/* Decorative gradient banner */}
      <div className="h-32 bg-gradient-to-r from-emerald-600 via-teal-600 to-emerald-800 relative">
        <div className="absolute inset-0 opacity-10 bg-[radial-gradient(#fff_1px,transparent_1px)] [background-size:16px_16px]" />
        <div className="absolute top-4 right-4 flex items-center gap-2">
          <button
            onClick={() => setActiveTab('lostfound')}
            className="flex items-center gap-1.5 px-3 py-1.5 bg-white/20 hover:bg-white/30 backdrop-blur-md text-white text-xs font-bold rounded-xl transition-all border border-white/20 cursor-pointer shadow-xs"
          >
            <QrCode className="w-3.5 h-3.5" />
            <span>Collar QR: {activePet.qrCodeId}</span>
          </button>
        </div>
      </div>

      <div className="px-6 pb-6 pt-0">
        <div className="flex flex-col md:flex-row md:items-end justify-between -mt-16 gap-4 mb-6">
          {/* Avatar & Key Names */}
          <div className="flex items-end gap-5">
            <div className="relative">
              <img
                src={activePet.photo}
                alt={activePet.name}
                className="w-28 h-28 rounded-2xl object-cover ring-4 ring-white shadow-xl shadow-slate-900/10"
              />
              <span className="absolute bottom-1 right-1 w-5 h-5 rounded-full bg-emerald-500 ring-2 ring-white flex items-center justify-center">
                <Heart className="w-3 h-3 text-white fill-white" />
              </span>
            </div>

            <div>
              <div className="flex items-center gap-2.5">
                <h1 className="text-2xl sm:text-3xl font-black text-slate-900 tracking-tight">
                  {activePet.name}
                </h1>
                <Badge variant="emerald" size="md">
                  {activePet.species}
                </Badge>
                {activePet.status && (
                  <Badge variant={activePet.status === 'Healthy' ? 'emerald' : 'amber'} size="md">
                    {activePet.status}
                  </Badge>
                )}
              </div>
              <p className="text-sm font-semibold text-slate-500 mt-0.5">
                {activePet.breed} • {activePet.gender}
              </p>
            </div>
          </div>

          {/* Quick Action Buttons */}
          <div className="flex items-center gap-2.5 self-start md:self-auto">
            <button
              onClick={() => setActiveTab('passport')}
              className="flex items-center gap-1.5 px-4 py-2 bg-emerald-50 hover:bg-emerald-100 text-emerald-800 text-xs font-bold rounded-xl border border-emerald-200 transition-colors cursor-pointer"
            >
              <span>View Passport</span>
              <ChevronRight className="w-3.5 h-3.5" />
            </button>
            <button
              onClick={() => setActiveTab('booking')}
              className="flex items-center gap-1.5 px-4 py-2 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-xl shadow-xs transition-colors cursor-pointer"
            >
              <span>Book Appointment</span>
            </button>
          </div>
        </div>

        {/* Pet Vitals & Key Identifiers Bar */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 p-4 bg-slate-50/80 rounded-2xl border border-slate-100 mb-5">
          <div>
            <span className="text-[11px] font-semibold text-slate-400 uppercase tracking-wider block">Age</span>
            <span className="text-sm font-bold text-slate-800">{activePet.age}</span>
          </div>
          <div>
            <span className="text-[11px] font-semibold text-slate-400 uppercase tracking-wider block">Current Weight</span>
            <span className="text-sm font-bold text-slate-800">
              {activePet.weight} {activePet.weightUnit}
            </span>
          </div>
          <div>
            <span className="text-[11px] font-semibold text-slate-400 uppercase tracking-wider block">Microchip ID</span>
            <span className="text-sm font-mono font-bold text-slate-800 truncate block">
              {activePet.microchipId}
            </span>
          </div>
          <div>
            <span className="text-[11px] font-semibold text-slate-400 uppercase tracking-wider block">Blood Group</span>
            <span className="text-sm font-bold text-slate-800">{activePet.bloodType || 'N/A'}</span>
          </div>
        </div>

        {/* Allergy and Health Warnings Banner */}
        {activePet.allergies && activePet.allergies.length > 0 && (
          <div className="flex items-start gap-3 p-3.5 rounded-xl bg-amber-50/70 border border-amber-200/80">
            <AlertCircle className="w-4 h-4 text-amber-700 shrink-0 mt-0.5" />
            <div className="flex-1">
              <span className="text-xs font-bold text-amber-900 block">Allergy & Dietary Cautions:</span>
              <div className="flex flex-wrap gap-1.5 mt-1">
                {activePet.allergies.map((allergy, i) => (
                  <span
                    key={i}
                    className="inline-block px-2 py-0.5 rounded-md bg-white/90 text-amber-900 text-[11px] font-semibold border border-amber-200"
                  >
                    ⚠️ {allergy}
                  </span>
                ))}
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};
