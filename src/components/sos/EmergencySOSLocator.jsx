import React, { useState } from 'react';
import { usePetContext } from '../../context/PetContext';
import { emergencyClinics } from '../../data/mockPetData';
import {
  AlertOctagon,
  PhoneCall,
  Navigation,
  Clock,
  MapPin,
  HeartPulse,
  ShieldAlert,
  HelpCircle,
  ExternalLink,
  Flame,
  CheckCircle2
} from 'lucide-react';
import { Badge } from '../common/Badge';
import { PetFirstAidGuideModal } from './PetFirstAidGuideModal';

export const EmergencySOSLocator = () => {
  const { activePet } = usePetContext();
  const [isFirstAidModalOpen, setIsFirstAidModalOpen] = useState(false);

  return (
    <div className="space-y-6">
      {/* High Visibility Emergency Header */}
      <div className="p-6 sm:p-8 bg-gradient-to-r from-rose-600 via-rose-700 to-rose-900 rounded-3xl text-white shadow-xl shadow-rose-900/10">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-6">
          <div>
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-white/20 text-xs font-black uppercase tracking-wider mb-2">
              <AlertOctagon className="w-4 h-4 animate-pulse" />
              <span>24/7 Rapid Veterinary Emergency Dispatch</span>
            </div>
            <h1 className="text-2xl sm:text-3xl font-black tracking-tight">
              Trauma Centers & Emergency Hospital Locator
            </h1>
            <p className="text-xs sm:text-sm text-rose-100 max-w-2xl mt-1">
              Immediate triage access for {activePet?.name}. Call ahead so clinical teams can prep oxygen chambers, blood products, and emergency ICU suites.
            </p>
          </div>

          <div className="flex flex-col sm:flex-row items-stretch sm:items-center gap-3">
            <button
              onClick={() => setIsFirstAidModalOpen(true)}
              className="flex items-center justify-center gap-2 px-4 py-3 bg-white text-rose-700 hover:bg-rose-50 text-xs font-black rounded-xl shadow-md transition-all cursor-pointer"
            >
              <HelpCircle className="w-4 h-4" />
              <span>Pet First Aid & Poison Guide</span>
            </button>

            <a
              href="tel:18002221222"
              className="flex items-center justify-center gap-2 px-5 py-3 bg-rose-950/80 hover:bg-rose-950 text-white text-xs font-black rounded-xl border border-rose-400/40 shadow-md transition-all text-center"
            >
              <PhoneCall className="w-4 h-4 text-rose-300" />
              <span>Poison Control: (800) 222-1222</span>
            </a>
          </div>
        </div>
      </div>

      {/* Emergency Clinics List */}
      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <h3 className="text-base font-bold text-slate-900 flex items-center gap-2">
            <MapPin className="w-4 h-4 text-rose-600" />
            <span>Verified 24/7 Emergency Care Clinics Near Springfield, OR</span>
          </h3>
          <span className="text-xs text-slate-400 font-semibold">Triage GPS Radius: 5 miles</span>
        </div>

        <div className="grid grid-cols-1 gap-4">
          {emergencyClinics.map((clinic) => (
            <div
              key={clinic.id}
              className="p-6 bg-white rounded-3xl border border-slate-200/80 hover:border-rose-300 shadow-xs hover:shadow-md transition-all flex flex-col lg:flex-row lg:items-center justify-between gap-6"
            >
              <div className="space-y-3 flex-1">
                {/* Status & Trauma Badges */}
                <div className="flex flex-wrap items-center gap-2">
                  <span
                    className={`inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-black ${
                      clinic.isOpen24
                        ? 'bg-emerald-100 text-emerald-800 border border-emerald-300'
                        : 'bg-amber-100 text-amber-900 border border-amber-300'
                    }`}
                  >
                    <span className="w-2 h-2 rounded-full bg-emerald-600 animate-pulse" />
                    {clinic.status}
                  </span>

                  <span className="px-3 py-1 rounded-full text-xs font-bold bg-rose-50 text-rose-700 border border-rose-200">
                    {clinic.traumaLevel}
                  </span>

                  <span className="text-xs font-bold text-slate-500 flex items-center gap-1">
                    <Clock className="w-3.5 h-3.5 text-slate-400" />
                    {clinic.waitTime}
                  </span>
                </div>

                {/* Clinic Name and Address */}
                <div>
                  <h4 className="text-lg font-bold text-slate-900">{clinic.name}</h4>
                  <p className="text-xs text-slate-600 font-medium flex items-center gap-1.5 mt-1">
                    <MapPin className="w-3.5 h-3.5 text-slate-400 shrink-0" />
                    <span>{clinic.address}</span>
                    <span className="font-bold text-emerald-700">({clinic.distance})</span>
                  </p>
                </div>

                {/* Equipment Highlights */}
                <div className="flex flex-wrap gap-1.5 pt-1">
                  {clinic.specialties.map((spec, i) => (
                    <span
                      key={i}
                      className="px-2.5 py-0.5 rounded-lg bg-slate-100 text-slate-700 text-[11px] font-semibold"
                    >
                      ✓ {spec}
                    </span>
                  ))}
                </div>
              </div>

              {/* Action Buttons: Direct Call & Google Maps Directions */}
              <div className="flex flex-col sm:flex-row lg:flex-col gap-2.5 shrink-0 min-w-[200px]">
                <a
                  href={`tel:${clinic.phone}`}
                  className="flex items-center justify-center gap-2 py-3 px-5 bg-rose-600 hover:bg-rose-700 text-white text-xs font-black rounded-xl shadow-xs transition-colors cursor-pointer text-center"
                >
                  <PhoneCall className="w-4 h-4" />
                  <span>Call Hospital: {clinic.phone}</span>
                </a>

                <a
                  href={clinic.mapsUrl}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="flex items-center justify-center gap-2 py-3 px-5 bg-slate-900 hover:bg-slate-800 text-white text-xs font-black rounded-xl shadow-xs transition-colors cursor-pointer text-center"
                >
                  <Navigation className="w-4 h-4 text-emerald-400" />
                  <span>Get Directions (Maps)</span>
                  <ExternalLink className="w-3.5 h-3.5 text-slate-400" />
                </a>
              </div>
            </div>
          ))}
        </div>
      </div>

      <PetFirstAidGuideModal
        isOpen={isFirstAidModalOpen}
        onClose={() => setIsFirstAidModalOpen(false)}
      />
    </div>
  );
};
