import React, { useState } from 'react';
import { usePetContext } from '../../context/PetContext';
import {
  Calendar,
  Clock,
  UserCheck,
  Building,
  MapPin,
  XCircle,
  Plus,
  CheckCircle2,
  AlertCircle
} from 'lucide-react';
import { Badge } from '../common/Badge';

export const UpcomingBookingsList = ({ onBookNew }) => {
  const { appointments, cancelAppointment, pets } = usePetContext();
  const [filterStatus, setFilterStatus] = useState('All');

  const filtered = appointments.filter((a) => {
    if (filterStatus === 'All') return true;
    return a.status === filterStatus;
  });

  return (
    <div className="bg-white rounded-3xl border border-slate-200/80 p-6 sm:p-8 shadow-xs">
      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-6 border-b border-slate-100">
        <div>
          <h3 className="text-lg font-bold text-slate-900">Upcoming & Confirmed Bookings</h3>
          <p className="text-xs text-slate-500">Live booking ledger saved in LocalStorage</p>
        </div>

        <div className="flex items-center gap-2">
          {/* Status filter */}
          <div className="flex bg-slate-100 p-1 rounded-xl">
            {['All', 'Confirmed', 'Pending', 'Cancelled'].map((st) => (
              <button
                key={st}
                onClick={() => setFilterStatus(st)}
                className={`px-3 py-1 text-xs font-bold rounded-lg transition-colors cursor-pointer ${
                  filterStatus === st ? 'bg-white text-slate-900 shadow-2xs' : 'text-slate-500 hover:text-slate-800'
                }`}
              >
                {st}
              </button>
            ))}
          </div>

          <button
            onClick={onBookNew}
            className="flex items-center gap-1.5 px-3.5 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-xl transition-colors cursor-pointer shrink-0"
          >
            <Plus className="w-3.5 h-3.5" />
            <span>New Booking</span>
          </button>
        </div>
      </div>

      <div className="pt-6 space-y-4">
        {filtered.length === 0 ? (
          <div className="text-center py-12 px-4 rounded-2xl bg-slate-50 border border-dashed border-slate-200">
            <Calendar className="w-8 h-8 text-slate-300 mx-auto mb-2" />
            <p className="text-xs font-bold text-slate-600">No appointments matching this filter.</p>
            <button
              onClick={onBookNew}
              className="mt-3 px-4 py-2 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-xl transition-colors cursor-pointer"
            >
              Book New Appointment
            </button>
          </div>
        ) : (
          filtered.map((appt) => {
            const petObj = pets.find((p) => p.id === appt.petId);

            return (
              <div
                key={appt.id}
                className="p-5 rounded-2xl border border-slate-200/80 bg-slate-50/50 hover:bg-white hover:shadow-xs transition-all flex flex-col md:flex-row md:items-center justify-between gap-4"
              >
                <div className="flex items-start gap-4">
                  {/* Date badge */}
                  <div className="w-14 h-14 rounded-2xl bg-emerald-50 border border-emerald-100 flex flex-col items-center justify-center shrink-0">
                    <span className="text-[10px] font-bold uppercase text-emerald-700 tracking-wider">
                      {new Date(appt.date).toLocaleDateString('en-US', { month: 'short' })}
                    </span>
                    <span className="text-lg font-black text-emerald-950 leading-tight">
                      {new Date(appt.date).getDate() || '18'}
                    </span>
                  </div>

                  <div>
                    <div className="flex items-center gap-2 mb-1">
                      <h4 className="text-sm font-bold text-slate-900">{appt.service}</h4>
                      <Badge
                        variant={
                          appt.status === 'Confirmed'
                            ? 'emerald'
                            : appt.status === 'Cancelled'
                            ? 'rose'
                            : 'amber'
                        }
                        size="sm"
                      >
                        {appt.status}
                      </Badge>
                    </div>

                    <p className="text-xs text-slate-600 font-medium">
                      Patient: <strong className="text-slate-900">{appt.petName}</strong> {petObj ? `(${petObj.breed})` : ''} • Specialist: {appt.provider}
                    </p>

                    <div className="flex flex-wrap items-center gap-3 text-xs text-slate-400 mt-2">
                      <span className="flex items-center gap-1 text-slate-600 font-semibold">
                        <Clock className="w-3.5 h-3.5 text-slate-400" />
                        {appt.time}
                      </span>
                      <span>•</span>
                      <span className="flex items-center gap-1">
                        <Building className="w-3.5 h-3.5 text-slate-400" />
                        {appt.clinic}
                      </span>
                    </div>

                    {appt.notes && (
                      <p className="text-[11px] text-slate-500 italic mt-1.5">Note: "{appt.notes}"</p>
                    )}
                  </div>
                </div>

                <div className="flex items-center gap-3 self-end md:self-center">
                  <div className="text-right">
                    <span className="text-[10px] text-slate-400 block font-semibold">Fee</span>
                    <span className="text-lg font-black text-slate-900">${appt.cost}</span>
                  </div>

                  {appt.status !== 'Cancelled' ? (
                    <button
                      onClick={() => cancelAppointment(appt.id)}
                      className="px-3 py-1.5 border border-rose-200 text-rose-700 hover:bg-rose-50 text-xs font-bold rounded-xl transition-colors cursor-pointer"
                    >
                      Cancel Visit
                    </button>
                  ) : (
                    <span className="text-xs font-bold text-slate-400">Cancelled</span>
                  )}
                </div>
              </div>
            );
          })
        )}
      </div>
    </div>
  );
};
