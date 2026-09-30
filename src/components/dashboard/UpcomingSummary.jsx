import React from 'react';
import { usePetContext } from '../../context/PetContext';
import { Calendar, Plus, Clock, MapPin, XCircle, ArrowUpRight } from 'lucide-react';
import { Badge } from '../common/Badge';

export const UpcomingSummary = () => {
  const { petAppointments, cancelAppointment, setActiveTab } = usePetContext();

  return (
    <div className="bg-white rounded-2xl border border-slate-200/80 p-5 shadow-xs">
      <div className="flex items-center justify-between mb-4">
        <div className="flex items-center gap-2">
          <div className="p-2 rounded-xl bg-teal-50 text-teal-700">
            <Calendar className="w-4 h-4" />
          </div>
          <div>
            <h3 className="text-sm font-bold text-slate-900">Upcoming Care Bookings</h3>
            <p className="text-[11px] text-slate-400">Scheduled visits & wellness sessions</p>
          </div>
        </div>

        <button
          onClick={() => setActiveTab('booking')}
          className="flex items-center gap-1 text-xs font-bold text-emerald-700 hover:text-emerald-800 hover:bg-emerald-50 px-2.5 py-1.5 rounded-lg transition-colors cursor-pointer"
        >
          <Plus className="w-3.5 h-3.5" />
          <span>Book Visit</span>
        </button>
      </div>

      {petAppointments.length === 0 ? (
        <div className="text-center py-8 px-4 rounded-xl bg-slate-50 border border-dashed border-slate-200">
          <p className="text-xs font-semibold text-slate-600">No appointments scheduled</p>
          <p className="text-[11px] text-slate-400 mt-1">Book your pet's annual checkup, vaccine, or styling</p>
          <button
            onClick={() => setActiveTab('booking')}
            className="mt-3 px-3 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-xl transition-all cursor-pointer"
          >
            Launch Booking Wizard
          </button>
        </div>
      ) : (
        <div className="space-y-3">
          {petAppointments.slice(0, 3).map((appt) => (
            <div
              key={appt.id}
              className="p-3.5 rounded-xl border border-slate-100 bg-slate-50/60 hover:bg-slate-50 hover:border-slate-200 transition-all flex items-start justify-between gap-3"
            >
              <div className="flex-1">
                <div className="flex items-center gap-2 mb-1">
                  <h4 className="text-xs font-bold text-slate-900">{appt.service}</h4>
                  <Badge variant={appt.status === 'Confirmed' ? 'emerald' : 'amber'} size="sm">
                    {appt.status}
                  </Badge>
                </div>
                <p className="text-[11px] text-slate-500 flex items-center gap-1.5">
                  <Clock className="w-3 h-3 text-slate-400" />
                  <span>{appt.date} at {appt.time}</span>
                  <span>•</span>
                  <span>{appt.provider}</span>
                </p>
                <p className="text-[11px] text-slate-400 mt-1 flex items-center gap-1">
                  <MapPin className="w-3 h-3" />
                  <span>{appt.clinic}</span>
                </p>
              </div>

              {appt.status !== 'Cancelled' && (
                <button
                  onClick={() => cancelAppointment(appt.id)}
                  className="text-[11px] font-semibold text-slate-400 hover:text-rose-600 p-1 rounded-md hover:bg-rose-50 transition-colors"
                  title="Cancel Appointment"
                >
                  <XCircle className="w-4 h-4" />
                </button>
              )}
            </div>
          ))}

          {petAppointments.length > 3 && (
            <button
              onClick={() => setActiveTab('booking')}
              className="w-full text-center py-2 text-xs font-bold text-emerald-700 hover:underline flex items-center justify-center gap-1 cursor-pointer"
            >
              <span>View all {petAppointments.length} bookings</span>
              <ArrowUpRight className="w-3.5 h-3.5" />
            </button>
          )}
        </div>
      )}
    </div>
  );
};
