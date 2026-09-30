import React, { createContext, useContext, useState, useEffect } from 'react';
import {
  initialPets,
  initialVaccines,
  initialMedicalRecords,
  initialWeightHistory,
  initialExpenses,
  initialAppointments,
} from '../data/mockPetData';

const PetContext = createContext(null);

export const PetProvider = ({ children }) => {
  // 1. Pets State
  const [pets, setPets] = useState(() => {
    try {
      const saved = localStorage.getItem('petpulse_pets');
      return saved ? JSON.parse(saved) : initialPets;
    } catch {
      return initialPets;
    }
  });

  // 2. Active Pet State
  const [activePetId, setActivePetId] = useState(() => {
    try {
      const saved = localStorage.getItem('petpulse_active_pet_id');
      if (saved && initialPets.some(p => p.id === saved)) return saved;
      return initialPets[0]?.id || '';
    } catch {
      return initialPets[0]?.id || '';
    }
  });

  // 3. Vaccines State
  const [vaccines, setVaccines] = useState(() => {
    try {
      const saved = localStorage.getItem('petpulse_vaccines');
      return saved ? JSON.parse(saved) : initialVaccines;
    } catch {
      return initialVaccines;
    }
  });

  // 4. Medical Records State
  const [medicalRecords, setMedicalRecords] = useState(() => {
    try {
      const saved = localStorage.getItem('petpulse_records');
      return saved ? JSON.parse(saved) : initialMedicalRecords;
    } catch {
      return initialMedicalRecords;
    }
  });

  // 5. Weight History State
  const [weightHistory, setWeightHistory] = useState(() => {
    try {
      const saved = localStorage.getItem('petpulse_weight_history');
      return saved ? JSON.parse(saved) : initialWeightHistory;
    } catch {
      return initialWeightHistory;
    }
  });

  // 6. Expenses State
  const [expenses, setExpenses] = useState(() => {
    try {
      const saved = localStorage.getItem('petpulse_expenses');
      return saved ? JSON.parse(saved) : initialExpenses;
    } catch {
      return initialExpenses;
    }
  });

  // 7. Appointments State
  const [appointments, setAppointments] = useState(() => {
    try {
      const saved = localStorage.getItem('petpulse_appointments');
      return saved ? JSON.parse(saved) : initialAppointments;
    } catch {
      return initialAppointments;
    }
  });

  // 8. Navigation & Global UI State
  const [activeTab, setActiveTab] = useState('dashboard');
  const [searchQuery, setSearchQuery] = useState('');
  const [toast, setToast] = useState(null);

  // Sync to LocalStorage
  useEffect(() => {
    localStorage.setItem('petpulse_pets', JSON.stringify(pets));
  }, [pets]);

  useEffect(() => {
    localStorage.setItem('petpulse_active_pet_id', activePetId);
  }, [activePetId]);

  useEffect(() => {
    localStorage.setItem('petpulse_vaccines', JSON.stringify(vaccines));
  }, [vaccines]);

  useEffect(() => {
    localStorage.setItem('petpulse_records', JSON.stringify(medicalRecords));
  }, [medicalRecords]);

  useEffect(() => {
    localStorage.setItem('petpulse_weight_history', JSON.stringify(weightHistory));
  }, [weightHistory]);

  useEffect(() => {
    localStorage.setItem('petpulse_expenses', JSON.stringify(expenses));
  }, [expenses]);

  useEffect(() => {
    localStorage.setItem('petpulse_appointments', JSON.stringify(appointments));
  }, [appointments]);

  // Derived current active pet
  const activePet = pets.find((p) => p.id === activePetId) || pets[0] || null;

  // Toast Helper
  const showToast = (message, type = 'success') => {
    setToast({ message, type, id: Date.now() });
    setTimeout(() => {
      setToast(null);
    }, 3800);
  };

  // Actions
  const addPet = (petData) => {
    const newPet = {
      ...petData,
      id: `pet-${Date.now()}`,
      status: 'Healthy',
      qrCodeId: `PULSE-${(petData.name || 'PET').toUpperCase()}-${Math.floor(10000 + Math.random() * 90000)}`,
      owner: petData.owner || {
        name: 'Vipin Sharma',
        phone: '+1 (555) 382-9014',
        email: 'vipin.dev@petcare.io',
        address: '742 Evergreen Terrace, Springfield, OR',
        emergencyContact: 'Sarah Sharma (+1 555-382-9015)',
      },
    };

    setPets((prev) => [newPet, ...prev]);
    setActivePetId(newPet.id);

    // Initialize mock entries for new pet
    setVaccines((prev) => ({
      ...prev,
      [newPet.id]: [
        {
          id: `vax-${Date.now()}`,
          name: 'Core Rabies Initial Vaccine',
          type: 'Core',
          administeredDate: new Date().toISOString().split('T')[0],
          dueDate: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
          status: 'Completed',
          veterinarian: 'Dr. Emily Vance, DVM',
          clinic: 'Cascade Animal Hospital',
          batchNumber: `RB-${Math.floor(10000 + Math.random() * 90000)}`,
          notes: 'Initial registration vaccination dose.',
        },
      ],
    }));

    setWeightHistory((prev) => ({
      ...prev,
      [newPet.id]: [
        {
          date: 'Current',
          weight: Number(newPet.weight) || 5.0,
          idealMin: (Number(newPet.weight) || 5.0) * 0.9,
          idealMax: (Number(newPet.weight) || 5.0) * 1.1,
          note: 'Initial intake baseline',
        },
      ],
    }));

    setExpenses((prev) => ({
      ...prev,
      [newPet.id]: [
        { month: 'Current', food: 50, vet: 40, grooming: 30, accessories: 25, total: 145 },
      ],
    }));

    showToast(`Welcome! ${newPet.name} was successfully registered.`);
  };

  const updatePet = (updatedPet) => {
    setPets((prev) => prev.map((p) => (p.id === updatedPet.id ? updatedPet : p)));
    showToast(`${updatedPet.name}'s profile updated!`);
  };

  const deletePet = (petId) => {
    if (pets.length <= 1) {
      showToast('Cannot delete the only pet in the system.', 'error');
      return;
    }
    const targetPet = pets.find((p) => p.id === petId);
    const remaining = pets.filter((p) => p.id !== petId);
    setPets(remaining);
    if (activePetId === petId) {
      setActivePetId(remaining[0].id);
    }
    showToast(`${targetPet?.name || 'Pet'} record removed.`, 'info');
  };

  const addVaccine = (petId, vaccineData) => {
    const newVax = {
      ...vaccineData,
      id: `vax-${Date.now()}`,
    };
    setVaccines((prev) => ({
      ...prev,
      [petId]: [newVax, ...(prev[petId] || [])],
    }));
    showToast(`Vaccination record for "${newVax.name}" added!`);
  };

  const toggleVaccineStatus = (petId, vaccineId) => {
    setVaccines((prev) => {
      const list = prev[petId] || [];
      const updated = list.map((v) => {
        if (v.id === vaccineId) {
          const nextStatus = v.status === 'Completed' ? 'Due Soon' : 'Completed';
          return { ...v, status: nextStatus };
        }
        return v;
      });
      return { ...prev, [petId]: updated };
    });
    showToast('Vaccine status updated!');
  };

  const addMedicalRecord = (petId, recordData) => {
    const newRecord = {
      ...recordData,
      id: `rec-${Date.now()}`,
      date: recordData.date || new Date().toISOString().split('T')[0],
    };
    setMedicalRecords((prev) => ({
      ...prev,
      [petId]: [newRecord, ...(prev[petId] || [])],
    }));
    showToast(`Medical record "${newRecord.title}" saved.`);
  };

  const addWeightLog = (petId, weightVal, noteVal = 'Regular check-in') => {
    const pet = pets.find((p) => p.id === petId);
    const minVal = pet?.idealWeightRange ? pet.idealWeightRange[0] : weightVal * 0.9;
    const maxVal = pet?.idealWeightRange ? pet.idealWeightRange[1] : weightVal * 1.1;

    const newLog = {
      date: new Date().toLocaleDateString('en-US', { month: 'short', day: 'numeric' }),
      weight: parseFloat(weightVal),
      idealMin: minVal,
      idealMax: maxVal,
      note: noteVal,
    };

    setWeightHistory((prev) => ({
      ...prev,
      [petId]: [...(prev[petId] || []), newLog],
    }));

    // Update pet's current weight
    setPets((prev) =>
      prev.map((p) => (p.id === petId ? { ...p, weight: parseFloat(weightVal) } : p))
    );

    showToast(`Weight entry (${weightVal} kg) recorded!`);
  };

  const addExpense = (petId, category, amount) => {
    const month = new Date().toLocaleDateString('en-US', { month: 'short' });
    setExpenses((prev) => {
      const currentList = prev[petId] || [];
      const updated = currentList.map((item, idx) => {
        if (idx === currentList.length - 1) {
          const catKey = category.toLowerCase();
          const newAmt = (item[catKey] || 0) + parseFloat(amount);
          return {
            ...item,
            [catKey]: newAmt,
            total: (item.total || 0) + parseFloat(amount),
          };
        }
        return item;
      });
      return { ...prev, [petId]: updated };
    });
    showToast(`Expense of $${amount} added to ${category}!`);
  };

  const addAppointment = (apptData) => {
    const newAppt = {
      ...apptData,
      id: `apt-${Date.now()}`,
      status: 'Confirmed',
    };
    setAppointments((prev) => [newAppt, ...prev]);
    showToast(`Appointment booked for ${newAppt.date} at ${newAppt.time}! 🎉`);
  };

  const cancelAppointment = (apptId) => {
    setAppointments((prev) =>
      prev.map((a) => (a.id === apptId ? { ...a, status: 'Cancelled' } : a))
    );
    showToast('Appointment cancelled.', 'info');
  };

  // Reset to sample defaults
  const resetToDefaults = () => {
    localStorage.clear();
    setPets(initialPets);
    setActivePetId(initialPets[0].id);
    setVaccines(initialVaccines);
    setMedicalRecords(initialMedicalRecords);
    setWeightHistory(initialWeightHistory);
    setExpenses(initialExpenses);
    setAppointments(initialAppointments);
    showToast('Platform reset to realistic mock dataset.');
  };

  return (
    <PetContext.Provider
      value={{
        pets,
        activePetId,
        setActivePetId,
        activePet,
        addPet,
        updatePet,
        deletePet,
        vaccines: vaccines[activePetId] || [],
        allVaccines: vaccines,
        addVaccine,
        toggleVaccineStatus,
        medicalRecords: medicalRecords[activePetId] || [],
        addMedicalRecord,
        weightHistory: weightHistory[activePetId] || [],
        addWeightLog,
        expenses: expenses[activePetId] || [],
        addExpense,
        appointments,
        petAppointments: appointments.filter((a) => a.petId === activePetId),
        addAppointment,
        cancelAppointment,
        activeTab,
        setActiveTab,
        searchQuery,
        setSearchQuery,
        toast,
        showToast,
        resetToDefaults,
      }}
    >
      {children}
    </PetContext.Provider>
  );
};

export const usePetContext = () => {
  const context = useContext(PetContext);
  if (!context) {
    throw new Error('usePetContext must be used within a PetProvider');
  }
  return context;
};
