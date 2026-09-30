import React, { useState } from 'react';
import { usePetContext } from '../../context/PetContext';
import { Modal } from '../common/Modal';

export const AddVaccineModal = ({ isOpen, onClose }) => {
  const { activePet, addVaccine } = usePetContext();

  const [formData, setFormData] = useState({
    name: '',
    type: 'Core',
    administeredDate: new Date().toISOString().split('T')[0],
    dueDate: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
    status: 'Completed',
    veterinarian: 'Dr. Emily Vance, DVM',
    clinic: 'Cascade Animal Hospital',
    batchNumber: '',
    notes: '',
  });

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!formData.name.trim()) return;

    addVaccine(activePet.id, {
      ...formData,
      batchNumber: formData.batchNumber.trim() || `VAX-${Math.floor(10000 + Math.random() * 90000)}`,
    });
    onClose();
    setFormData({
      name: '',
      type: 'Core',
      administeredDate: new Date().toISOString().split('T')[0],
      dueDate: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
      status: 'Completed',
      veterinarian: 'Dr. Emily Vance, DVM',
      clinic: 'Cascade Animal Hospital',
      batchNumber: '',
      notes: '',
    });
  };

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title="Record Vaccination Dose"
      subtitle={`Add an official vaccine entry to ${activePet?.name}'s passport`}
    >
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-xs font-bold text-slate-700 mb-1">
            Vaccine Name <span className="text-rose-500">*</span>
          </label>
          <input
            type="text"
            required
            placeholder="e.g. Rabies 3-Year, DHPP, Bordetella Oral"
            value={formData.name}
            onChange={(e) => setFormData({ ...formData, name: e.target.value })}
            className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
          />
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Vaccine Class</label>
            <select
              value={formData.type}
              onChange={(e) => setFormData({ ...formData, type: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20 bg-white"
            >
              <option value="Core">Core Vaccine</option>
              <option value="Lifestyle">Lifestyle / Non-Core</option>
            </select>
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Status</label>
            <select
              value={formData.status}
              onChange={(e) => setFormData({ ...formData, status: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20 bg-white"
            >
              <option value="Completed">Completed</option>
              <option value="Due Soon">Due Soon</option>
              <option value="Overdue">Overdue</option>
            </select>
          </div>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Date Administered</label>
            <input
              type="date"
              value={formData.administeredDate}
              onChange={(e) => setFormData({ ...formData, administeredDate: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
            />
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Next Booster Due</label>
            <input
              type="date"
              value={formData.dueDate}
              onChange={(e) => setFormData({ ...formData, dueDate: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
            />
          </div>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Veterinarian Name</label>
            <input
              type="text"
              placeholder="e.g. Dr. Emily Vance, DVM"
              value={formData.veterinarian}
              onChange={(e) => setFormData({ ...formData, veterinarian: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
            />
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Clinic Name</label>
            <input
              type="text"
              placeholder="e.g. Cascade Animal Hospital"
              value={formData.clinic}
              onChange={(e) => setFormData({ ...formData, clinic: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
            />
          </div>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Batch / Lot Number</label>
            <input
              type="text"
              placeholder="e.g. RB-98402X"
              value={formData.batchNumber}
              onChange={(e) => setFormData({ ...formData, batchNumber: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
            />
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Clinical Notes</label>
            <input
              type="text"
              placeholder="e.g. Subcutaneous right shoulder"
              value={formData.notes}
              onChange={(e) => setFormData({ ...formData, notes: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
            />
          </div>
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
            Save Vaccine Record
          </button>
        </div>
      </form>
    </Modal>
  );
};
