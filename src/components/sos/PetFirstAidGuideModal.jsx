import React from 'react';
import { Modal } from '../common/Modal';
import { emergencyFirstAidGuide } from '../../data/mockPetData';
import { AlertOctagon, HeartPulse, Flame, ShieldAlert, Check } from 'lucide-react';

export const PetFirstAidGuideModal = ({ isOpen, onClose }) => {
  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title="Veterinary Emergency First Aid Protocols"
      subtitle="Immediate lifesaving actions to take while en route to an emergency animal hospital"
      maxWidth="max-w-3xl"
    >
      <div className="space-y-6">
        <div className="p-4 bg-rose-50 border border-rose-200 rounded-2xl flex items-start gap-3">
          <AlertOctagon className="w-5 h-5 text-rose-600 shrink-0 mt-0.5" />
          <div className="text-xs text-rose-950">
            <span className="font-bold block mb-0.5">PRIORITY EMERGENCY RULE:</span>
            Always call ahead to the emergency clinic so the trauma surgical team can prepare oxygen cages, blood units, and anti-venom before arrival.
          </div>
        </div>

        <div className="space-y-4">
          {emergencyFirstAidGuide.map((guide, idx) => (
            <div key={idx} className="p-5 rounded-2xl border border-slate-200 bg-slate-50/60">
              <div className="flex items-center justify-between mb-2">
                <h4 className="text-sm font-bold text-slate-900 flex items-center gap-2">
                  <ShieldAlert className="w-4 h-4 text-emerald-600" />
                  <span>{guide.title}</span>
                </h4>
                <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-rose-100 text-rose-800">
                  {guide.category}
                </span>
              </div>

              <p className="text-xs font-bold text-rose-700 mb-3">{guide.alert}</p>

              <ul className="space-y-2 text-xs text-slate-700">
                {guide.items.map((item, itemIdx) => (
                  <li key={itemIdx} className="flex items-start gap-2">
                    <span className="w-4 h-4 rounded-full bg-emerald-100 text-emerald-800 flex items-center justify-center shrink-0 mt-0.5 font-bold text-[10px]">
                      {itemIdx + 1}
                    </span>
                    <span className="leading-relaxed">{item}</span>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>

        <div className="pt-4 border-t border-slate-100 flex justify-end">
          <button
            onClick={onClose}
            className="px-5 py-2.5 bg-slate-900 hover:bg-slate-800 text-white text-xs font-bold rounded-xl transition-colors cursor-pointer"
          >
            Close Guide
          </button>
        </div>
      </div>
    </Modal>
  );
};
