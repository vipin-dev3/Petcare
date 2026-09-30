import React, { useState } from 'react';
import { usePetContext } from '../../context/PetContext';
import { Modal } from '../common/Modal';

export const AddRecordModal = ({ isOpen, onClose }) => {
  const { activePet, addMedicalRecord } = usePetContext();

  const [formData, setFormData] = useState({
    title: '',
    category: 'Vet Visit',
    date: new Date().toISOString().split('T')[0],
    doctor: 'Dr. Emily Vance, DVM',
    clinic: 'Cascade Animal Hospital',
    diagnosis: '',
    prescriptionName: '',
    prescriptionDosage: '',
    temp: '101.4 °F',
    heartRate: '90 bpm',
    weight: activePet ? `${activePet.weight} kg` : '10 kg',
    notes: '',
  });

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!formData.title.trim()) return;

    const prescriptions = formData.prescriptionName.trim()
      ? [
          {
            name: formData.prescriptionName.trim(),
            dosage: formData.prescriptionDosage.trim() || 'Standard Dose',
            frequency: 'Daily',
            duration: 'As instructed',
          },
        ]
      : [];

    addMedicalRecord(activePet.id, {
      title: formData.title.trim(),
      category: formData.category,
      date: formData.date,
      doctor: formData.doctor.trim(),
      clinic: formData.clinic.trim(),
      diagnosis: formData.diagnosis.trim() || 'Normal clinical examination.',
      prescriptions,
      vitals: {
        temp: formData.temp,
        heartRate: formData.heartRate,
        weight: formData.weight,
      },
      notes: formData.notes.trim(),
      fileAttachmentName: `${activePet.name}_Record_${formData.date}.pdf`,
    });

    onClose();
  };

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title="Add Medical Encounter Record"
      subtitle={`Log examination findings, diagnosis, and prescriptions for ${activePet?.name}`}
    >
      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">
              Encounter Title <span className="text-rose-500">*</span>
            </label>
            <input
              type="text"
              required
              placeholder="e.g. Annual Dental Exam, Ear Infection Followup"
              value={formData.title}
              onChange={(e) => setFormData({ ...formData, title: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
            />
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Category</label>
            <select
              value={formData.category}
              onChange={(e) => setFormData({ ...formData, category: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20 bg-white"
            >
              <option value="Vet Visit">Vet Visit</option>
              <option value="Prescription">Prescription</option>
              <option value="Lab Results">Lab Results</option>
              <option value="Surgery">Surgery / Dental</option>
            </select>
          </div>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Date</label>
            <input
              type="date"
              value={formData.date}
              onChange={(e) => setFormData({ ...formData, date: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
            />
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Attending Doctor</label>
            <input
              type="text"
              value={formData.doctor}
              onChange={(e) => setFormData({ ...formData, doctor: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
            />
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Clinic Name</label>
            <input
              type="text"
              value={formData.clinic}
              onChange={(e) => setFormData({ ...formData, clinic: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
            />
          </div>
        </div>

        <div>
          <label className="block text-xs font-bold text-slate-700 mb-1">
            Clinical Diagnosis & Findings <span className="text-rose-500">*</span>
          </label>
          <textarea
            rows="3"
            required
            placeholder="Describe clinical findings, physical exam observations..."
            value={formData.diagnosis}
            onChange={(e) => setFormData({ ...formData, diagnosis: e.target.value })}
            className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
          />
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Prescription Medication (Optional)</label>
            <input
              type="text"
              placeholder="e.g. Amoxicillin, Apoquel"
              value={formData.prescriptionName}
              onChange={(e) => setFormData({ ...formData, prescriptionName: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
            />
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Dosage & Frequency</label>
            <input
              type="text"
              placeholder="e.g. 250mg twice daily for 10 days"
              value={formData.prescriptionDosage}
              onChange={(e) => setFormData({ ...formData, prescriptionDosage: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
            />
          </div>
        </div>

        <div className="grid grid-cols-3 gap-3">
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Vitals Temp</label>
            <input
              type="text"
              value={formData.temp}
              onChange={(e) => setFormData({ ...formData, temp: e.target.value })}
              className="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs"
            />
          </div>
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Heart Rate</label>
            <input
              type="text"
              value={formData.heartRate}
              onChange={(e) => setFormData({ ...formData, heartRate: e.target.value })}
              className="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs"
            />
          </div>
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Weight</label>
            <input
              type="text"
              value={formData.weight}
              onChange={(e) => setFormData({ ...formData, weight: e.target.value })}
              className="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs"
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
            Save Encounter Record
          </button>
        </div>
      </form>
    </Modal>
  );
};
