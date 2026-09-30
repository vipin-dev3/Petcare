import React from 'react';
import { usePetContext } from '../../context/PetContext';
import {
  Syringe,
  CalendarCheck,
  Scale,
  AlertTriangle,
  ArrowRight,
  CheckCircle,
  Clock,
  MapPin
} from 'lucide-react';

export const QuickStatsRow = () => {
  const { activePet, vaccines, appointments, setActiveTab } = usePetContext();

  // 1. Next Vaccine Due
  const upcomingVaccine =
    vaccines.find((v) => v.status === 'Due Soon' || v.status === 'Overdue') ||
    vaccines.find((v) => v.status === 'Completed') ||
    null;

  const isOverdue = upcomingVaccine?.status === 'Overdue';

  // 2. Upcoming Appointment
  const nextAppt = appointments.find(
    (a) => a.petId === activePet?.id && a.status === 'Confirmed'
  );

  // 3. Weight Status
  const currentWeight = activePet?.weight || 0;
  const [minIdeal, maxIdeal] = activePet?.idealWeightRange || [currentWeight * 0.9, currentWeight * 1.1];
  const isWeightIdeal = currentWeight >= minIdeal && currentWeight <= maxIdeal;

  return (
    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 my-6">
      
      {/* 1. Next Vaccine Due */}
      <div
        onClick={() => setActiveTab('passport')}
        className="group relative p-5 bg-white rounded-2xl border border-slate-200/80 shadow-xs hover:shadow-md hover:border-emerald-300 transition-all cursor-pointer flex flex-col justify-between"
      >
        <div>
          <div className="flex items-center justify-between mb-3">
            <span className="text-[11px] font-bold uppercase tracking-wider text-slate-400">
              Next Vaccine Due
            </span>
            <div
              className={`w-9 h-9 rounded-xl flex items-center justify-center ${
                isOverdue ? 'bg-rose-100 text-rose-600' : 'bg-emerald-100 text-emerald-700'
              }`}
            >
              <Syringe className="w-4 h-4" />
            </div>
          </div>

          {upcomingVaccine ? (
            <div>
              <h4 className="text-sm font-bold text-slate-900 group-hover:text-emerald-700 transition-colors line-clamp-1">
                {upcomingVaccine.name}
              </h4>
              <p className="text-xs text-slate-500 mt-1 flex items-center gap-1.5">
                <Clock className="w-3.5 h-3.5 text-slate-400" />
                <span>Due: {upcomingVaccine.dueDate}</span>
              </p>
              <div className="mt-2.5">
                <span
                  className={`inline-block text-[10px] font-bold px-2 py-0.5 rounded-full ${
                    isOverdue
                      ? 'bg-rose-50 text-rose-700 border border-rose-200'
                      : 'bg-emerald-50 text-emerald-700 border border-emerald-200'
                  }`}
                >
                  {isOverdue ? '⚠️ Overdue for Booster' : '✓ Scheduled in timeline'}
                </span>
              </div>
            </div>
          ) : (
            <p className="text-xs text-slate-500 font-medium">All vaccinations up to date!</p>
          )}
        </div>

        <div className="pt-3 border-t border-slate-100 mt-3 flex items-center justify-between text-[11px] font-bold text-slate-400 group-hover:text-emerald-700">
          <span>Manage Timeline</span>
          <ArrowRight className="w-3 h-3 group-hover:translate-x-1 transition-transform" />
        </div>
      </div>

      {/* 2. Upcoming Appointment */}
      <div
        onClick={() => setActiveTab('booking')}
        className="group relative p-5 bg-white rounded-2xl border border-slate-200/80 shadow-xs hover:shadow-md hover:border-emerald-300 transition-all cursor-pointer flex flex-col justify-between"
      >
        <div>
          <div className="flex items-center justify-between mb-3">
            <span className="text-[11px] font-bold uppercase tracking-wider text-slate-400">
              Upcoming Visit
            </span>
            <div className="w-9 h-9 rounded-xl bg-teal-100 text-teal-700 flex items-center justify-center">
              <CalendarCheck className="w-4 h-4" />
            </div>
          </div>

          {nextAppt ? (
            <div>
              <h4 className="text-sm font-bold text-slate-900 group-hover:text-teal-700 transition-colors line-clamp-1">
                {nextAppt.service}
              </h4>
              <p className="text-xs text-slate-500 mt-1 flex items-center gap-1.5">
                <span>{nextAppt.date} • {nextAppt.time}</span>
              </p>
              <p className="text-[11px] font-medium text-teal-800 mt-2 truncate">
                🏥 {nextAppt.clinic}
              </p>
            </div>
          ) : (
            <div>
              <h4 className="text-sm font-bold text-slate-700">No visits booked</h4>
              <p className="text-xs text-slate-400 mt-1">Schedule routine checkup or spa</p>
            </div>
          )}
        </div>

        <div className="pt-3 border-t border-slate-100 mt-3 flex items-center justify-between text-[11px] font-bold text-slate-400 group-hover:text-teal-700">
          <span>{nextAppt ? 'View Details' : 'Book a Slot'}</span>
          <ArrowRight className="w-3 h-3 group-hover:translate-x-1 transition-transform" />
        </div>
      </div>

      {/* 3. Weight Status */}
      <div
        onClick={() => setActiveTab('analytics')}
        className="group relative p-5 bg-white rounded-2xl border border-slate-200/80 shadow-xs hover:shadow-md hover:border-emerald-300 transition-all cursor-pointer flex flex-col justify-between"
      >
        <div>
          <div className="flex items-center justify-between mb-3">
            <span className="text-[11px] font-bold uppercase tracking-wider text-slate-400">
              Weight & Body Status
            </span>
            <div className="w-9 h-9 rounded-xl bg-amber-100 text-amber-800 flex items-center justify-center">
              <Scale className="w-4 h-4" />
            </div>
          </div>

          <div>
            <div className="flex items-baseline gap-1.5">
              <span className="text-2xl font-black text-slate-900">{currentWeight}</span>
              <span className="text-xs font-bold text-slate-400">{activePet?.weightUnit}</span>
            </div>
            <p className="text-xs text-slate-500 mt-0.5">
              Breed Ideal: {minIdeal} - {maxIdeal} {activePet?.weightUnit}
            </p>
            <div className="mt-2">
              <span
                className={`inline-flex items-center gap-1 text-[10px] font-bold px-2 py-0.5 rounded-full ${
                  isWeightIdeal
                    ? 'bg-emerald-50 text-emerald-700 border border-emerald-200'
                    : 'bg-amber-50 text-amber-800 border border-amber-200'
                }`}
              >
                {isWeightIdeal ? (
                  <>
                    <CheckCircle className="w-3 h-3 text-emerald-600" />
                    <span>In Ideal Breed Target</span>
                  </>
                ) : (
                  <span>Weight monitor needed</span>
                )}
              </span>
            </div>
          </div>
        </div>

        <div className="pt-3 border-t border-slate-100 mt-3 flex items-center justify-between text-[11px] font-bold text-slate-400 group-hover:text-amber-700">
          <span>Progression Graph</span>
          <ArrowRight className="w-3 h-3 group-hover:translate-x-1 transition-transform" />
        </div>
      </div>

      {/* 4. SOS Emergency Button */}
      <div
        onClick={() => setActiveTab('sos')}
        className="group relative p-5 bg-gradient-to-br from-rose-500 to-rose-600 rounded-2xl text-white shadow-md shadow-rose-500/20 hover:shadow-lg hover:shadow-rose-500/30 transition-all cursor-pointer flex flex-col justify-between"
      >
        <div>
          <div className="flex items-center justify-between mb-3">
            <span className="text-[11px] font-bold uppercase tracking-wider text-rose-100">
              24/7 Emergency SOS
            </span>
            <div className="w-9 h-9 rounded-xl bg-white/20 backdrop-blur-xs flex items-center justify-center text-white">
              <AlertTriangle className="w-4 h-4 animate-bounce" />
            </div>
          </div>

          <div>
            <h4 className="text-sm font-extrabold text-white">Trauma ER Locator</h4>
            <p className="text-xs text-rose-100 mt-1 flex items-center gap-1">
              <MapPin className="w-3.5 h-3.5" />
              <span>Nearest: 1.2 miles (4 min)</span>
            </p>
            <div className="mt-2.5">
              <span className="inline-block text-[10px] font-extrabold px-2 py-0.5 rounded-md bg-white text-rose-700 shadow-xs">
                OPEN 24/7 NOW
              </span>
            </div>
          </div>
        </div>

        <div className="pt-3 border-t border-white/20 mt-3 flex items-center justify-between text-[11px] font-bold text-rose-100 group-hover:text-white">
          <span>Find Hospitals & First Aid</span>
          <ArrowRight className="w-3 h-3 group-hover:translate-x-1 transition-transform" />
        </div>
      </div>

    </div>
  );
};
