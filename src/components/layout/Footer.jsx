import React from 'react';
import { PawPrint, Heart, Shield, Activity, PhoneCall } from 'lucide-react';
import { usePetContext } from '../../context/PetContext';

export const Footer = () => {
  const { setActiveTab } = usePetContext();

  return (
    <footer className="mt-20 border-t border-slate-200 bg-white/60 text-slate-500 py-10 text-xs">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8 mb-8">
          <div>
            <div className="flex items-center gap-2 mb-3">
              <div className="w-8 h-8 rounded-lg bg-emerald-600 flex items-center justify-center text-white">
                <PawPrint className="w-4 h-4" />
              </div>
              <span className="font-extrabold text-slate-900 text-base">
                Pet<span className="text-emerald-600">Pulse</span>
              </span>
            </div>
            <p className="text-slate-500 leading-relaxed text-xs">
              Modern digital health passport, real-time veterinary appointment scheduling, and collar QR locator system.
            </p>
          </div>

          <div>
            <h4 className="font-bold text-slate-900 mb-3 uppercase tracking-wider text-[11px]">Platform Sections</h4>
            <ul className="space-y-2">
              <li>
                <button onClick={() => setActiveTab('dashboard')} className="hover:text-emerald-600 cursor-pointer">
                  Dashboard Overview
                </button>
              </li>
              <li>
                <button onClick={() => setActiveTab('passport')} className="hover:text-emerald-600 cursor-pointer">
                  Digital Pet Passport & Vaccines
                </button>
              </li>
              <li>
                <button onClick={() => setActiveTab('booking')} className="hover:text-emerald-600 cursor-pointer">
                  Appointment Booking Simulator
                </button>
              </li>
              <li>
                <button onClick={() => setActiveTab('lostfound')} className="hover:text-emerald-600 cursor-pointer">
                  Lost & Found Collar QR
                </button>
              </li>
            </ul>
          </div>

          <div>
            <h4 className="font-bold text-slate-900 mb-3 uppercase tracking-wider text-[11px]">Clinical Tools</h4>
            <ul className="space-y-2">
              <li>
                <button onClick={() => setActiveTab('analytics')} className="hover:text-emerald-600 cursor-pointer">
                  Weight Progression & Breed Target
                </button>
              </li>
              <li>
                <button onClick={() => setActiveTab('analytics')} className="hover:text-emerald-600 cursor-pointer">
                  Monthly Expense Visualizer
                </button>
              </li>
              <li>
                <button onClick={() => setActiveTab('sos')} className="hover:text-rose-600 font-semibold cursor-pointer">
                  24/7 Emergency SOS Vet Locator
                </button>
              </li>
            </ul>
          </div>

          <div>
            <h4 className="font-bold text-slate-900 mb-3 uppercase tracking-wider text-[11px]">Emergency Hotline</h4>
            <p className="text-slate-600 mb-2">Pet Poison & Trauma Triage Line:</p>
            <a
              href="tel:18002221222"
              className="inline-flex items-center gap-2 font-bold text-rose-600 text-sm hover:underline"
            >
              <PhoneCall className="w-4 h-4" />
              +1 (800) 222-1222
            </a>
            <p className="text-[11px] text-slate-400 mt-2">Available 24 hours a day, 365 days a year.</p>
          </div>
        </div>

        <div className="pt-6 border-t border-slate-100 flex flex-col sm:flex-row items-center justify-between gap-4 text-[11px] text-slate-400">
          <p>© {new Date().getFullYear()} PetPulse Health Management Platform. All records local-first.</p>
          <div className="flex items-center gap-1">
            <span>Built with care for animal companions worldwide</span>
            <Heart className="w-3.5 h-3.5 text-rose-500 fill-rose-500 inline" />
          </div>
        </div>
      </div>
    </footer>
  );
};
