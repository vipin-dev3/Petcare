import React, { useState } from 'react';
import { usePetContext } from '../../context/PetContext';
import { servicesCatalog, vetDirectory } from '../../data/mockPetData';
import {
  Calendar,
  Clock,
  UserCheck,
  CheckCircle2,
  ChevronRight,
  ChevronLeft,
  Sparkles,
  Stethoscope,
  Scissors,
  Smile,
  Home,
  Footprints,
  Syringe,
  Star,
  MapPin
} from 'lucide-react';
import { UpcomingBookingsList } from './UpcomingBookingsList';

export const AppointmentBookingWizard = () => {
  const { activePet, addAppointment, appointments } = usePetContext();
  const [activeSubTab, setActiveSubTab] = useState('wizard'); // 'wizard' or 'list'

  // Wizard Step State (1: Service, 2: Provider, 3: Date/Time, 4: Confirm)
  const [step, setStep] = useState(1);
  const [selectedService, setSelectedService] = useState(servicesCatalog[0]);
  const [selectedProvider, setSelectedProvider] = useState(vetDirectory[0]);
  const [selectedDate, setSelectedDate] = useState(() => {
    const d = new Date();
    d.setDate(d.getDate() + 3);
    return d.toISOString().split('T')[0];
  });
  const [selectedTime, setSelectedTime] = useState(vetDirectory[0]?.availableSlots[0] || '10:00 AM');
  const [visitNotes, setVisitNotes] = useState('');

  const getServiceIcon = (category) => {
    switch (category) {
      case 'Vet Visit':
        return <Stethoscope className="w-5 h-5 text-emerald-600" />;
      case 'Grooming':
        return <Scissors className="w-5 h-5 text-teal-600" />;
      case 'Vaccine':
        return <Syringe className="w-5 h-5 text-emerald-600" />;
      case 'Dental':
        return <Smile className="w-5 h-5 text-amber-600" />;
      case 'Boarding':
        return <Home className="w-5 h-5 text-indigo-600" />;
      case 'Dog Walking':
        return <Footprints className="w-5 h-5 text-teal-600" />;
      default:
        return <Sparkles className="w-5 h-5 text-emerald-600" />;
    }
  };

  const handleConfirmBooking = () => {
    const newAppointment = {
      petId: activePet.id,
      petName: activePet.name,
      service: selectedService.title,
      serviceCategory: selectedService.category,
      provider: selectedProvider.name,
      clinic: selectedProvider.clinic,
      date: selectedDate,
      time: selectedTime,
      cost: selectedService.price,
      notes: visitNotes || 'Standard care visit requested via PetPulse booking wizard.',
    };

    addAppointment(newAppointment);
    setStep(1);
    setVisitNotes('');
    setActiveSubTab('list');
  };

  return (
    <div className="space-y-6">
      {/* Top Toggle: Booking Wizard vs Scheduled Bookings */}
      <div className="flex items-center justify-between bg-white p-2 rounded-2xl border border-slate-200/80 shadow-xs">
        <div className="flex items-center gap-2">
          <button
            onClick={() => setActiveSubTab('wizard')}
            className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-bold transition-all cursor-pointer ${
              activeSubTab === 'wizard'
                ? 'bg-emerald-600 text-white shadow-xs'
                : 'text-slate-600 hover:bg-slate-100'
            }`}
          >
            <Calendar className="w-4 h-4" />
            <span>Schedule New Appointment</span>
          </button>

          <button
            onClick={() => setActiveSubTab('list')}
            className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-bold transition-all cursor-pointer ${
              activeSubTab === 'list'
                ? 'bg-emerald-600 text-white shadow-xs'
                : 'text-slate-600 hover:bg-slate-100'
            }`}
          >
            <Clock className="w-4 h-4" />
            <span>Upcoming Bookings ({appointments.length})</span>
          </button>
        </div>

        <span className="hidden sm:inline-block text-xs font-semibold text-slate-400 pr-3">
          Booking for: <strong className="text-slate-800">{activePet?.name}</strong> ({activePet?.breed})
        </span>
      </div>

      {activeSubTab === 'list' ? (
        <UpcomingBookingsList onBookNew={() => setActiveSubTab('wizard')} />
      ) : (
        <div className="bg-white rounded-3xl border border-slate-200/80 p-6 sm:p-8 shadow-xs">
          
          {/* Multi-Step Wizard Progress Bar */}
          <div className="mb-8">
            <div className="flex items-center justify-between max-w-2xl mx-auto">
              {[
                { num: 1, label: 'Choose Service' },
                { num: 2, label: 'Select Specialist' },
                { num: 3, label: 'Date & Slot' },
                { num: 4, label: 'Confirm' },
              ].map((s, idx) => (
                <div key={s.num} className="flex items-center gap-2">
                  <div
                    className={`w-8 h-8 rounded-full flex items-center justify-center font-bold text-xs transition-colors ${
                      step >= s.num
                        ? 'bg-emerald-600 text-white ring-4 ring-emerald-100'
                        : 'bg-slate-100 text-slate-400'
                    }`}
                  >
                    {step > s.num ? <CheckCircle2 className="w-4 h-4" /> : s.num}
                  </div>
                  <span
                    className={`hidden md:inline text-xs font-bold ${
                      step >= s.num ? 'text-slate-900' : 'text-slate-400'
                    }`}
                  >
                    {s.label}
                  </span>
                  {idx < 3 && <div className="hidden sm:block w-8 lg:w-16 h-0.5 bg-slate-200 mx-2" />}
                </div>
              ))}
            </div>
          </div>

          {/* STEP 1: Select Service */}
          {step === 1 && (
            <div className="space-y-4">
              <div>
                <h3 className="text-lg font-bold text-slate-900">Step 1: Select Required Care Service</h3>
                <p className="text-xs text-slate-500">Choose from clinical exams, routine vaccines, or luxury styling</p>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 pt-2">
                {servicesCatalog.map((svc) => {
                  const isSelected = selectedService.id === svc.id;

                  return (
                    <div
                      key={svc.id}
                      onClick={() => setSelectedService(svc)}
                      className={`p-5 rounded-2xl border transition-all cursor-pointer flex flex-col justify-between ${
                        isSelected
                          ? 'border-emerald-500 bg-emerald-50/40 ring-2 ring-emerald-500/20 shadow-xs'
                          : 'border-slate-200/80 hover:border-slate-300 hover:bg-slate-50/60'
                      }`}
                    >
                      <div>
                        <div className="flex items-center justify-between mb-3">
                          <div className="p-2.5 rounded-xl bg-white border border-slate-100 shadow-2xs">
                            {getServiceIcon(svc.category)}
                          </div>
                          {svc.popular && (
                            <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-amber-100 text-amber-800">
                              Popular
                            </span>
                          )}
                        </div>

                        <h4 className="text-sm font-bold text-slate-900 mb-1">{svc.title}</h4>
                        <p className="text-xs text-slate-500 leading-relaxed mb-4">{svc.description}</p>
                      </div>

                      <div className="pt-3 border-t border-slate-100 flex items-center justify-between">
                        <span className="text-xs font-semibold text-slate-400">Duration: {svc.duration}</span>
                        <span className="text-lg font-black text-slate-900">${svc.price}</span>
                      </div>
                    </div>
                  );
                })}
              </div>

              <div className="pt-6 flex justify-end">
                <button
                  onClick={() => setStep(2)}
                  className="flex items-center gap-2 px-6 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-xl shadow-xs transition-colors cursor-pointer"
                >
                  <span>Continue to Specialist</span>
                  <ChevronRight className="w-4 h-4" />
                </button>
              </div>
            </div>
          )}

          {/* STEP 2: Choose Provider */}
          {step === 2 && (
            <div className="space-y-4">
              <div>
                <h3 className="text-lg font-bold text-slate-900">Step 2: Choose Attending Veterinarian / Specialist</h3>
                <p className="text-xs text-slate-500">Board-certified doctors and certified grooming directors</p>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4 pt-2">
                {vetDirectory.map((vet) => {
                  const isSelected = selectedProvider.id === vet.id;

                  return (
                    <div
                      key={vet.id}
                      onClick={() => {
                        setSelectedProvider(vet);
                        if (vet.availableSlots?.length) {
                          setSelectedTime(vet.availableSlots[0]);
                        }
                      }}
                      className={`p-5 rounded-2xl border transition-all cursor-pointer flex gap-4 ${
                        isSelected
                          ? 'border-emerald-500 bg-emerald-50/40 ring-2 ring-emerald-500/20 shadow-xs'
                          : 'border-slate-200/80 hover:border-slate-300 hover:bg-slate-50/60'
                      }`}
                    >
                      <img
                        src={vet.photo}
                        alt={vet.name}
                        className="w-20 h-20 rounded-2xl object-cover ring-2 ring-slate-100 shrink-0"
                      />
                      <div className="flex-1">
                        <div className="flex items-start justify-between">
                          <div>
                            <h4 className="text-sm font-bold text-slate-900">{vet.name}</h4>
                            <p className="text-xs font-semibold text-emerald-700 mt-0.5">{vet.specialty}</p>
                          </div>
                          <div className="flex items-center gap-1 text-xs font-bold text-amber-600 bg-amber-50 px-2 py-0.5 rounded-md">
                            <Star className="w-3 h-3 fill-amber-500 text-amber-500" />
                            <span>{vet.rating}</span>
                          </div>
                        </div>

                        <p className="text-xs text-slate-500 flex items-center gap-1 mt-2">
                          <MapPin className="w-3 h-3 text-slate-400" />
                          <span>{vet.clinic}</span>
                        </p>
                        <p className="text-[11px] text-slate-400 mt-1">Available today for booking</p>
                      </div>
                    </div>
                  );
                })}
              </div>

              <div className="pt-6 flex justify-between">
                <button
                  onClick={() => setStep(1)}
                  className="flex items-center gap-2 px-5 py-2 text-xs font-bold text-slate-600 hover:bg-slate-100 rounded-xl transition-colors cursor-pointer"
                >
                  <ChevronLeft className="w-4 h-4" />
                  <span>Back to Services</span>
                </button>
                <button
                  onClick={() => setStep(3)}
                  className="flex items-center gap-2 px-6 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-xl shadow-xs transition-colors cursor-pointer"
                >
                  <span>Select Date & Time</span>
                  <ChevronRight className="w-4 h-4" />
                </button>
              </div>
            </div>
          )}

          {/* STEP 3: Pick Date & Time Slot */}
          {step === 3 && (
            <div className="space-y-6">
              <div>
                <h3 className="text-lg font-bold text-slate-900">Step 3: Pick Appointment Date & Preferred Time Slot</h3>
                <p className="text-xs text-slate-500">Real-time availability with {selectedProvider.name}</p>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <label className="block text-xs font-bold text-slate-700 mb-2">Select Date</label>
                  <input
                    type="date"
                    min={new Date().toISOString().split('T')[0]}
                    value={selectedDate}
                    onChange={(e) => setSelectedDate(e.target.value)}
                    className="w-full px-4 py-3 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
                  />
                  <p className="text-[11px] text-slate-400 mt-2">Clinic operates Monday to Saturday 8:00 AM - 6:00 PM</p>
                </div>

                <div>
                  <label className="block text-xs font-bold text-slate-700 mb-2">Available Time Slots</label>
                  <div className="grid grid-cols-2 gap-2">
                    {selectedProvider.availableSlots.map((slot) => {
                      const isSelected = selectedTime === slot;

                      return (
                        <button
                          key={slot}
                          type="button"
                          onClick={() => setSelectedTime(slot)}
                          className={`p-3 text-xs font-bold rounded-xl border transition-all text-center cursor-pointer ${
                            isSelected
                              ? 'bg-emerald-600 text-white border-emerald-600 shadow-xs'
                              : 'bg-slate-50 text-slate-700 border-slate-200 hover:bg-slate-100'
                          }`}
                        >
                          {slot}
                        </button>
                      );
                    })}
                  </div>
                </div>
              </div>

              <div>
                <label className="block text-xs font-bold text-slate-700 mb-1">
                  Reason for Visit / Special Instructions
                </label>
                <textarea
                  rows="2"
                  placeholder="e.g. Max has been itching his left ear frequently; sensitive to loud barking."
                  value={visitNotes}
                  onChange={(e) => setVisitNotes(e.target.value)}
                  className="w-full px-4 py-2.5 rounded-xl border border-slate-200 text-sm focus:border-emerald-500 focus:outline-hidden focus:ring-2 focus:ring-emerald-500/20"
                />
              </div>

              <div className="pt-4 flex justify-between">
                <button
                  onClick={() => setStep(2)}
                  className="flex items-center gap-2 px-5 py-2 text-xs font-bold text-slate-600 hover:bg-slate-100 rounded-xl transition-colors cursor-pointer"
                >
                  <ChevronLeft className="w-4 h-4" />
                  <span>Back</span>
                </button>
                <button
                  onClick={() => setStep(4)}
                  className="flex items-center gap-2 px-6 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-bold rounded-xl shadow-xs transition-colors cursor-pointer"
                >
                  <span>Review Booking</span>
                  <ChevronRight className="w-4 h-4" />
                </button>
              </div>
            </div>
          )}

          {/* STEP 4: Review & Confirm */}
          {step === 4 && (
            <div className="space-y-6">
              <div>
                <h3 className="text-lg font-bold text-slate-900">Step 4: Review & Confirm Appointment</h3>
                <p className="text-xs text-slate-500">Please verify details before saving to LocalStorage</p>
              </div>

              <div className="p-6 bg-slate-50 rounded-2xl border border-slate-200 space-y-4">
                <div className="flex items-center justify-between pb-4 border-b border-slate-200">
                  <div className="flex items-center gap-3">
                    <img
                      src={activePet.photo}
                      alt={activePet.name}
                      className="w-12 h-12 rounded-xl object-cover ring-2 ring-emerald-500"
                    />
                    <div>
                      <h4 className="text-sm font-bold text-slate-900">{activePet.name}</h4>
                      <p className="text-xs text-slate-500">{activePet.species} • {activePet.breed}</p>
                    </div>
                  </div>
                  <div className="text-right">
                    <span className="text-[11px] text-slate-400 block font-semibold">Total Estimated Fee</span>
                    <span className="text-2xl font-black text-emerald-700">${selectedService.price}</span>
                  </div>
                </div>

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-4 text-xs">
                  <div>
                    <span className="text-slate-400 block text-[10px] uppercase font-bold">Selected Service</span>
                    <span className="font-bold text-slate-900">{selectedService.title}</span>
                    <span className="text-slate-500 block mt-0.5">{selectedService.duration}</span>
                  </div>

                  <div>
                    <span className="text-slate-400 block text-[10px] uppercase font-bold">Doctor / Specialist</span>
                    <span className="font-bold text-slate-900">{selectedProvider.name}</span>
                    <span className="text-slate-500 block mt-0.5">{selectedProvider.clinic}</span>
                  </div>

                  <div>
                    <span className="text-slate-400 block text-[10px] uppercase font-bold">Scheduled Date & Time</span>
                    <span className="font-bold text-emerald-800 text-sm">
                      📅 {selectedDate} at {selectedTime}
                    </span>
                  </div>

                  <div>
                    <span className="text-slate-400 block text-[10px] uppercase font-bold">Guardian Contact</span>
                    <span className="font-medium text-slate-800">{activePet.owner?.name} ({activePet.owner?.phone})</span>
                  </div>
                </div>

                {visitNotes && (
                  <div className="p-3 bg-white rounded-xl border border-slate-200 text-xs">
                    <span className="font-bold text-slate-700 block mb-0.5">Special Care Notes:</span>
                    <p className="text-slate-600 italic">"{visitNotes}"</p>
                  </div>
                )}
              </div>

              <div className="pt-4 flex justify-between">
                <button
                  onClick={() => setStep(3)}
                  className="flex items-center gap-2 px-5 py-2 text-xs font-bold text-slate-600 hover:bg-slate-100 rounded-xl transition-colors cursor-pointer"
                >
                  <ChevronLeft className="w-4 h-4" />
                  <span>Modify Date / Time</span>
                </button>
                <button
                  onClick={handleConfirmBooking}
                  className="flex items-center gap-2 px-7 py-3 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-black rounded-xl shadow-md shadow-emerald-600/30 transition-all hover:scale-102 cursor-pointer"
                >
                  <CheckCircle2 className="w-4 h-4" />
                  <span>Confirm & Save Appointment</span>
                </button>
              </div>
            </div>
          )}

        </div>
      )}
    </div>
  );
};
