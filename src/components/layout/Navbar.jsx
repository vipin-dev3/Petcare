import React, { useState } from 'react';
import { usePetContext } from '../../context/PetContext';
import {
  PawPrint,
  Search,
  Plus,
  ChevronDown,
  AlertTriangle,
  RotateCcw,
  Sparkles,
  HeartHandshake
} from 'lucide-react';
import { AddPetModal } from '../dashboard/AddPetModal';

export const Navbar = () => {
  const {
    pets,
    activePetId,
    setActivePetId,
    activePet,
    searchQuery,
    setSearchQuery,
    setActiveTab,
    resetToDefaults,
  } = usePetContext();

  const [isPetDropdownOpen, setIsPetDropdownOpen] = useState(false);
  const [isAddPetModalOpen, setIsAddPetModalOpen] = useState(false);

  return (
    <>
      <header className="sticky top-0 z-40 w-full bg-white/95 backdrop-blur-md border-b border-slate-200/80 shadow-xs">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex items-center justify-between h-16 gap-3 sm:gap-6">
            
            {/* Logo */}
            <div
              onClick={() => setActiveTab('dashboard')}
              className="flex items-center gap-2.5 cursor-pointer select-none group shrink-0"
            >
              <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-emerald-600 to-teal-500 flex items-center justify-center text-white shadow-md shadow-emerald-500/20 group-hover:scale-105 transition-transform">
                <PawPrint className="w-5 h-5 transition-transform group-hover:rotate-12" />
              </div>
              <div className="hidden sm:block">
                <div className="flex items-center gap-1.5">
                  <span className="font-extrabold text-xl tracking-tight text-slate-900">
                    Pet<span className="text-emerald-600">Pulse</span>
                  </span>
                  <span className="text-[10px] font-bold px-1.5 py-0.5 rounded-md bg-amber-100 text-amber-800 tracking-wider">
                    PRO
                  </span>
                </div>
                <p className="text-[11px] font-medium text-slate-400 -mt-0.5">Care Management Hub</p>
              </div>
            </div>

            {/* Global Search Bar */}
            <div className="flex-1 max-w-md hidden md:block">
              <div className="relative">
                <Search className="w-4 h-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" />
                <input
                  type="text"
                  placeholder="Search vaccines, treatments, appointments, or vets..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="w-full pl-9 pr-4 py-2 bg-slate-100/80 hover:bg-slate-100 focus:bg-white text-xs font-medium text-slate-800 placeholder-slate-400 rounded-xl border border-transparent focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20 transition-all"
                />
                {searchQuery && (
                  <button
                    onClick={() => setSearchQuery('')}
                    className="absolute right-3 top-1/2 -translate-y-1/2 text-xs font-bold text-slate-400 hover:text-slate-600"
                  >
                    Clear
                  </button>
                )}
              </div>
            </div>

            {/* Right Action Tools: Pet Switcher, Add Pet, SOS Button */}
            <div className="flex items-center gap-2 sm:gap-3">
              
              {/* Pet Switcher Dropdown */}
              <div className="relative">
                <button
                  onClick={() => setIsPetDropdownOpen(!isPetDropdownOpen)}
                  className="flex items-center gap-2 px-2.5 sm:px-3 py-1.5 rounded-xl border border-slate-200 bg-white hover:border-emerald-400 hover:bg-slate-50 transition-all text-left shadow-xs cursor-pointer"
                >
                  <img
                    src={activePet?.photo}
                    alt={activePet?.name}
                    className="w-7 h-7 rounded-lg object-cover ring-2 ring-emerald-500/30"
                  />
                  <div className="hidden sm:block">
                    <p className="text-xs font-bold text-slate-900 leading-tight flex items-center gap-1">
                      {activePet?.name}
                      <span className="text-[10px] text-slate-400 font-normal">({activePet?.species})</span>
                    </p>
                    <p className="text-[10px] text-slate-500 truncate max-w-[100px]">{activePet?.breed}</p>
                  </div>
                  <ChevronDown className="w-3.5 h-3.5 text-slate-400 ml-0.5" />
                </button>

                {/* Dropdown Menu */}
                {isPetDropdownOpen && (
                  <>
                    <div
                      className="fixed inset-0 z-20"
                      onClick={() => setIsPetDropdownOpen(false)}
                    />
                    <div className="absolute right-0 mt-2 w-64 bg-white rounded-2xl shadow-2xl border border-slate-100 py-2 z-30 animate-in fade-in zoom-in-95 duration-150">
                      <div className="px-3 py-1.5 border-b border-slate-100 mb-1">
                        <p className="text-[11px] font-bold uppercase tracking-wider text-slate-400">Switch Patient</p>
                      </div>
                      <div className="max-h-56 overflow-y-auto px-1 space-y-0.5">
                        {pets.map((pet) => (
                          <button
                            key={pet.id}
                            onClick={() => {
                              setActivePetId(pet.id);
                              setIsPetDropdownOpen(false);
                            }}
                            className={`w-full flex items-center gap-3 px-3 py-2 rounded-xl text-left transition-colors cursor-pointer ${
                              pet.id === activePetId
                                ? 'bg-emerald-50 text-emerald-900 font-semibold'
                                : 'hover:bg-slate-100/70 text-slate-700'
                            }`}
                          >
                            <img
                              src={pet.photo}
                              alt={pet.name}
                              className="w-8 h-8 rounded-lg object-cover ring-1 ring-slate-200"
                            />
                            <div className="flex-1 min-w-0">
                              <p className="text-xs font-bold leading-tight truncate">{pet.name}</p>
                              <p className="text-[11px] text-slate-400 truncate">{pet.breed} • {pet.age}</p>
                            </div>
                            {pet.id === activePetId && (
                              <div className="w-2 h-2 rounded-full bg-emerald-600" />
                            )}
                          </button>
                        ))}
                      </div>

                      <div className="border-t border-slate-100 mt-1 pt-1.5 px-2">
                        <button
                          onClick={() => {
                            setIsPetDropdownOpen(false);
                            setIsAddPetModalOpen(true);
                          }}
                          className="w-full flex items-center justify-center gap-1.5 py-1.5 text-xs font-bold text-emerald-700 hover:bg-emerald-50 rounded-xl transition-colors cursor-pointer"
                        >
                          <Plus className="w-3.5 h-3.5" />
                          Add New Pet Profile
                        </button>
                      </div>
                    </div>
                  </>
                )}
              </div>

              {/* Add Pet Button */}
              <button
                onClick={() => setIsAddPetModalOpen(true)}
                className="hidden sm:inline-flex items-center gap-1.5 px-3 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-xl shadow-xs transition-all hover:shadow-emerald-600/20 hover:shadow-md cursor-pointer"
              >
                <Plus className="w-4 h-4" />
                <span>New Pet</span>
              </button>

              {/* SOS Emergency Button */}
              <button
                onClick={() => setActiveTab('sos')}
                className="inline-flex items-center gap-1 px-2.5 sm:px-3 py-1.5 bg-rose-50 hover:bg-rose-100 text-rose-700 border border-rose-200 text-xs font-bold rounded-xl transition-all cursor-pointer animate-pulse hover:animate-none"
              >
                <AlertTriangle className="w-3.5 h-3.5 text-rose-600" />
                <span>SOS</span>
              </button>

              {/* Reset Data to defaults */}
              <button
                onClick={resetToDefaults}
                title="Reset local changes to mock defaults"
                className="p-1.5 text-slate-400 hover:text-slate-700 hover:bg-slate-100 rounded-xl transition-colors cursor-pointer"
              >
                <RotateCcw className="w-4 h-4" />
              </button>
            </div>
          </div>
        </div>
      </header>

      {/* Add Pet Modal */}
      <AddPetModal
        isOpen={isAddPetModalOpen}
        onClose={() => setIsAddPetModalOpen(false)}
      />
    </>
  );
};
