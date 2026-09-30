import React, { useState } from 'react';
import { usePetContext } from '../../context/PetContext';
import { Modal } from '../common/Modal';

export const AddWeightModal = ({ isOpen, onClose }) => {
  const { activePet, addWeightLog } = usePetContext();
  const [weight, setWeight] = useState(activePet?.weight || '');
  const [note, setNote] = useState('Routine checkup scale weigh-in');

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!weight) return;
    addWeightLog(activePet.id, parseFloat(weight), note);
    onClose();
  };

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title="Record Weight Measurement"
      subtitle={`Track ${activePet?.name}'s weight development in kilograms`}
    >
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-xs font-bold text-slate-700 mb-1">
            Weight ({activePet?.weightUnit || 'kg'}) <span className="text-rose-500">*</span>
          </label>
          <input
            type="number"
            step="0.05"
            required
            placeholder="e.g. 32.5"
            value={weight}
            onChange={(e) => setWeight(e.target.value)}
            className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
          />
        </div>

        <div>
          <label className="block text-xs font-bold text-slate-700 mb-1">Measurement Note</label>
          <input
            type="text"
            placeholder="e.g. Post-exercise, morning empty stomach, vet visit"
            value={note}
            onChange={(e) => setNote(e.target.value)}
            className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
          />
        </div>

        <div className="pt-4 border-t border-slate-100 flex items-center justify-end gap-3">
          <button
            type="button"
            onClick={onClose}
            className="px-4 py-2 text-xs font-bold text-slate-600 hover:bg-slate-100 rounded-xl transition-colors cursor-pointer"
          >
            Cancel
          </button>
          <button
            type="submit"
            className="px-5 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-xl shadow-xs transition-colors cursor-pointer"
          >
            Save Weight Entry
          </button>
        </div>
      </form>
    </Modal>
  );
};
