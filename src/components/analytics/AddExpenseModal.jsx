import React, { useState } from 'react';
import { usePetContext } from '../../context/PetContext';
import { Modal } from '../common/Modal';

export const AddExpenseModal = ({ isOpen, onClose }) => {
  const { activePet, addExpense } = usePetContext();
  const [category, setCategory] = useState('Food');
  const [amount, setAmount] = useState('');
  const [itemDesc, setItemDesc] = useState('');

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!amount || parseFloat(amount) <= 0) return;
    addExpense(activePet.id, category, parseFloat(amount));
    onClose();
    setAmount('');
    setItemDesc('');
  };

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title="Record Petcare Expense"
      subtitle={`Add expense expenditure for ${activePet?.name}`}
    >
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-xs font-bold text-slate-700 mb-1">Expense Category</label>
          <select
            value={category}
            onChange={(e) => setCategory(e.target.value)}
            className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20 bg-white"
          >
            <option value="Food">Food & Treats 🍖</option>
            <option value="Vet">Veterinary & Pharmacy 🩺</option>
            <option value="Grooming">Spa & Grooming ✂️</option>
            <option value="Accessories">Toys, Bedding & Gear 🎾</option>
          </select>
        </div>

        <div>
          <label className="block text-xs font-bold text-slate-700 mb-1">
            Amount (INR ₹) <span className="text-rose-500">*</span>
          </label>
          <input
            type="number"
            step="1"
            min="1"
            required
            placeholder="e.g. 1500"
            value={amount}
            onChange={(e) => setAmount(e.target.value)}
            className="w-full px-3.5 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
          />
        </div>

        <div>
          <label className="block text-xs font-bold text-slate-700 mb-1">Item Description (Optional)</label>
          <input
            type="text"
            placeholder="e.g. 15kg Bag Royal Canin, Allergy Chewables"
            value={itemDesc}
            onChange={(e) => setItemDesc(e.target.value)}
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
            Save Expense
          </button>
        </div>
      </form>
    </Modal>
  );
};
