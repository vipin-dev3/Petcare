import React from 'react';
import { usePetContext } from '../../context/PetContext';
import {
  LayoutDashboard,
  ShieldCheck,
  CalendarDays,
  QrCode,
  Activity,
  AlertOctagon,
  Sparkles,
} from 'lucide-react';

export const Sidebar = () => {
  const { activeTab, setActiveTab, vaccines, appointments, activePet } = usePetContext();

  // Overdue count
  const overdueCount = vaccines.filter((v) => v.status === 'Overdue').length;
  // Upcoming appointments count
  const upcomingCount = appointments.filter(
    (a) => a.petId === activePet?.id && a.status === 'Confirmed'
  ).length;

  const navItems = [
    {
      id: 'dashboard',
      label: 'Dashboard',
      icon: LayoutDashboard,
      badge: null,
    },
    {
      id: 'passport',
      label: 'Pet Passport & Records',
      icon: ShieldCheck,
      badge: overdueCount > 0 ? `${overdueCount} alert` : null,
      badgeColor: 'bg-rose-100 text-rose-700',
    },
    {
      id: 'booking',
      label: 'Book Appointment',
      icon: CalendarDays,
      badge: upcomingCount > 0 ? `${upcomingCount}` : null,
      badgeColor: 'bg-emerald-100 text-emerald-700',
    },
    {
      id: 'lostfound',
      label: 'Collar QR Simulator',
      icon: QrCode,
      badge: 'Live',
      badgeColor: 'bg-amber-100 text-amber-800',
    },
    {
      id: 'analytics',
      label: 'Health & Weight Charts',
      icon: Activity,
      badge: null,
    },
    {
      id: 'sos',
      label: '24/7 Emergency SOS',
      icon: AlertOctagon,
      badge: 'ER',
      badgeColor: 'bg-rose-100 text-rose-700',
    },
  ];

  return (
    <nav className="w-full bg-white border-b border-slate-200/70 overflow-x-auto shadow-2xs">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center space-x-1 sm:space-x-2 py-2 min-w-max">
          {navItems.map((item) => {
            const Icon = item.icon;
            const isActive = activeTab === item.id;

            return (
              <button
                key={item.id}
                onClick={() => setActiveTab(item.id)}
                className={`flex items-center gap-2 px-3 sm:px-4 py-2 rounded-xl text-xs sm:text-sm font-bold transition-all cursor-pointer select-none ${
                  isActive
                    ? 'bg-emerald-600 text-white shadow-sm shadow-emerald-600/30'
                    : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100/80'
                }`}
              >
                <Icon className={`w-4 h-4 ${isActive ? 'text-white' : 'text-slate-400'}`} />
                <span>{item.label}</span>
                {item.badge && (
                  <span
                    className={`text-[10px] font-extrabold px-1.5 py-0.2 rounded-md ${
                      isActive ? 'bg-white/20 text-white' : item.badgeColor
                    }`}
                  >
                    {item.badge}
                  </span>
                )}
              </button>
            );
          })}
        </div>
      </div>
    </nav>
  );
};
