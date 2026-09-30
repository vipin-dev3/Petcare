import React, { useState } from 'react';
import { usePetContext } from '../../context/PetContext';
import { Modal } from '../common/Modal';
import { PawPrint, Image as ImageIcon, Sparkles } from 'lucide-react';

export const AddPetModal = ({ isOpen, onClose }) => {
  const { addPet } = usePetContext();

  const [formData, setFormData] = useState({
    name: '',
    species: 'Dog',
    breed: '',
    age: '1 year',
    birthDate: '2025-01-01',
    gender: 'Male',
    weight: 10.0,
    microchipId: '',
    photo: '',
    allergies: '',
    diet: '',
  });

  const photoPresets = {
    Dog: 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?auto=format&fit=crop&w=800&q=80',
    Cat: 'https://images.unsplash.com/photo-1533738363-b7f9aef128ce?auto=format&fit=crop&w=800&q=80',
    Bird: 'https://images.unsplash.com/photo-1552728089-57bdde30beb3?auto=format&fit=crop&w=800&q=80',
    Rabbit: 'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?auto=format&fit=crop&w=800&q=80',
    Other: 'https://images.unsplash.com/photo-1425082661705-1834bfd09dca?auto=format&fit=crop&w=800&q=80',
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!formData.name.trim()) return;

    const petWeight = parseFloat(formData.weight) || 5.0;
    const petToAdd = {
      ...formData,
      weight: petWeight,
      idealWeightRange: [petWeight * 0.9, petWeight * 1.1],
      weightUnit: 'kg',
      photo: formData.photo.trim() || photoPresets[formData.species] || photoPresets.Dog,
      microchipId: formData.microchipId.trim() || `985${Math.floor(100000000000 + Math.random() * 900000000000)}`,
      allergies: formData.allergies
        ? formData.allergies.split(',').map((s) => s.trim()).filter(Boolean)
        : [],
    };

    addPet(petToAdd);
    onClose();
    // Reset form
    setFormData({
      name: '',
      species: 'Dog',
      breed: '',
      age: '1 year',
      birthDate: '2025-01-01',
      gender: 'Male',
      weight: 10.0,
      microchipId: '',
      photo: '',
      allergies: '',
      diet: '',
    });
  };

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title="Register New Pet Patient"
      subtitle="Create a digital health profile, passport, and QR collar identity"
    >
      <form onSubmit={handleSubmit} className="space-y-4">
        {/* Name and Species */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">
              Pet Name <span className="text-rose-500">*</span>
            </label>
            <input
              type="text"
              required
              placeholder="e.g. Bella, Simba, Charlie"
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
            />
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Species</label>
            <select
              value={formData.species}
              onChange={(e) => {
                const sp = e.target.value;
                setFormData({
                  ...formData,
                  species: sp,
                  photo: formData.photo || photoPresets[sp] || '',
                });
              }}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20 bg-white"
            >
              <option value="Dog">Dog 🐕</option>
              <option value="Cat">Cat 🐈</option>
              <option value="Bird">Bird 🦜</option>
              <option value="Rabbit">Rabbit 🐰</option>
              <option value="Other">Other Species 🐾</option>
            </select>
          </div>
        </div>

        {/* Breed and Gender */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Breed / Mix</label>
            <input
              type="text"
              placeholder="e.g. Golden Retriever, Siberian"
              value={formData.breed}
              onChange={(e) => setFormData({ ...formData, breed: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
            />
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Gender</label>
            <select
              value={formData.gender}
              onChange={(e) => setFormData({ ...formData, gender: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20 bg-white"
            >
              <option value="Male (Neutered)">Male (Neutered)</option>
              <option value="Male">Male (Intact)</option>
              <option value="Female (Spayed)">Female (Spayed)</option>
              <option value="Female">Female (Intact)</option>
            </select>
          </div>
        </div>

        {/* Age and Weight */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Age String</label>
            <input
              type="text"
              placeholder="e.g. 2 years 4 mos"
              value={formData.age}
              onChange={(e) => setFormData({ ...formData, age: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
            />
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Weight (kg)</label>
            <input
              type="number"
              step="0.1"
              value={formData.weight}
              onChange={(e) => setFormData({ ...formData, weight: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
            />
          </div>
        </div>

        {/* Photo URL & Microchip */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Photo Image URL</label>
            <input
              type="url"
              placeholder="https://... (or leave empty for default)"
              value={formData.photo}
              onChange={(e) => setFormData({ ...formData, photo: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
            />
          </div>

          <div>
            <label className="block text-xs font-bold text-slate-700 mb-1">Microchip Number (Optional)</label>
            <input
              type="text"
              placeholder="Auto-generated if empty"
              value={formData.microchipId}
              onChange={(e) => setFormData({ ...formData, microchipId: e.target.value })}
              className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
            />
          </div>
        </div>

        {/* Allergies and Diet */}
        <div>
          <label className="block text-xs font-bold text-slate-700 mb-1">Known Allergies (comma separated)</label>
          <input
            type="text"
            placeholder="e.g. Chicken protein, Wheat, Bee venom"
            value={formData.allergies}
            onChange={(e) => setFormData({ ...formData, allergies: e.target.value })}
            className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
          />
        </div>

        <div>
          <label className="block text-xs font-bold text-slate-700 mb-1">Dietary Routine / Brand</label>
          <input
            type="text"
            placeholder="e.g. Royal Canin Medium Adult, twice daily with fresh water"
            value={formData.diet}
            onChange={(e) => setFormData({ ...formData, diet: e.target.value })}
            className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
          />
        </div>

        {/* Action Buttons */}
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
            Register Patient
          </button>
        </div>
      </form>
    </Modal>
  );
};
