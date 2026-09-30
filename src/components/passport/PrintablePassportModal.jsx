import React from 'react';
import { usePetContext } from '../../context/PetContext';
import { Modal } from '../common/Modal';
import { Printer, Shield, Check, QrCode, AlertTriangle, FileCheck } from 'lucide-react';

export const PrintablePassportModal = ({ isOpen, onClose }) => {
  const { activePet, vaccines, medicalRecords } = usePetContext();

  const handlePrint = () => {
    window.print();
  };

  if (!activePet) return null;

  return (
    <Modal
      isOpen={isOpen}
      onClose={onClose}
      title="Official Pet Passport & Vet Handover Document"
      subtitle="Client-side print formatted summary ready for veterinary handovers and international travel"
      maxWidth="max-w-4xl"
    >
      <div className="space-y-6">
        {/* Print Action Bar */}
        <div className="flex items-center justify-between p-3.5 bg-emerald-50 rounded-xl border border-emerald-200 no-print">
          <div className="flex items-center gap-2">
            <FileCheck className="w-4 h-4 text-emerald-700" />
            <span className="text-xs font-bold text-emerald-900">
              Formatted for standard A4 / Letter paper. Press Print or Save as PDF.
            </span>
          </div>
          <button
            onClick={handlePrint}
            className="flex items-center gap-2 px-4 py-2 bg-emerald-700 hover:bg-emerald-800 text-white text-xs font-bold rounded-xl shadow-xs transition-colors cursor-pointer"
          >
            <Printer className="w-4 h-4" />
            <span>Print / Save PDF</span>
          </button>
        </div>

        {/* PRINTABLE PASSPORT DOCUMENT CONTAINER */}
        <div className="printable-card p-8 bg-white border border-slate-300 rounded-2xl shadow-sm text-slate-900 space-y-6">
          
          {/* Official Document Header */}
          <div className="flex items-start justify-between border-b-2 border-slate-900 pb-5">
            <div>
              <div className="flex items-center gap-2 mb-1">
                <span className="w-7 h-7 rounded-lg bg-slate-900 flex items-center justify-center text-white font-black text-sm">
                  🐾
                </span>
                <span className="text-xl font-black tracking-tight text-slate-900 uppercase">
                  PETPULSE COMPANION HEALTH PASSPORT
                </span>
              </div>
              <p className="text-xs text-slate-600 font-semibold tracking-wider uppercase">
                Official Veterinary Medical Handover & Immunization Certificate
              </p>
              <p className="text-[11px] text-slate-500 mt-1">
                Generated: {new Date().toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })} • Valid for transit & clinical admission
              </p>
            </div>

            {/* QR Stamp */}
            <div className="text-center p-3 border border-slate-300 rounded-xl bg-slate-50 shrink-0">
              <div className="w-16 h-16 bg-white p-1 border border-slate-200 mx-auto flex items-center justify-center">
                <QrCode className="w-12 h-12 text-slate-900" />
              </div>
              <span className="text-[10px] font-mono font-bold block mt-1 text-slate-700">
                {activePet.qrCodeId}
              </span>
            </div>
          </div>

          {/* Patient Profile & Owner Data Grid */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            
            {/* Pet Photo & Identity */}
            <div className="flex gap-4">
              <img
                src={activePet.photo}
                alt={activePet.name}
                className="w-24 h-24 rounded-xl object-cover border border-slate-300 shadow-2xs shrink-0"
              />
              <div>
                <h3 className="text-lg font-black text-slate-900">{activePet.name}</h3>
                <p className="text-xs font-semibold text-slate-600">{activePet.species} • {activePet.breed}</p>
                <p className="text-xs text-slate-500 mt-1">{activePet.gender}</p>
                <p className="text-xs text-slate-500">Weight: <span className="font-bold text-slate-900">{activePet.weight} kg</span></p>
              </div>
            </div>

            {/* Microchip & Legal IDs */}
            <div className="p-3 bg-slate-50 rounded-xl border border-slate-200 text-xs space-y-1.5">
              <span className="text-[10px] font-bold uppercase tracking-wider text-slate-500 block">
                Identification Credentials
              </span>
              <p>
                <span className="font-semibold text-slate-600">Microchip ISO:</span>{' '}
                <span className="font-mono font-bold text-slate-900">{activePet.microchipId}</span>
              </p>
              <p>
                <span className="font-semibold text-slate-600">Blood Type:</span>{' '}
                <span className="font-bold text-slate-900">{activePet.bloodType || 'DEA 1.1 Standard'}</span>
              </p>
              <p>
                <span className="font-semibold text-slate-600">Policy:</span>{' '}
                <span className="text-slate-800 font-medium">{activePet.insurancePolicy || 'Private Insured'}</span>
              </p>
            </div>

            {/* Guardian & Emergency Contacts */}
            <div className="p-3 bg-slate-50 rounded-xl border border-slate-200 text-xs space-y-1.5">
              <span className="text-[10px] font-bold uppercase tracking-wider text-slate-500 block">
                Registered Guardian Info
              </span>
              <p className="font-bold text-slate-900">{activePet.owner?.name}</p>
              <p className="text-slate-700">Phone: {activePet.owner?.phone}</p>
              <p className="text-slate-700">ER Contact: {activePet.owner?.emergencyContact}</p>
              <p className="text-[11px] text-slate-500 truncate">{activePet.owner?.address}</p>
            </div>
          </div>

          {/* Medical Cautions & Allergies */}
          <div className="p-3.5 bg-amber-50/80 border border-amber-300 rounded-xl text-xs">
            <span className="font-bold text-amber-900 flex items-center gap-1.5 mb-1">
              <AlertTriangle className="w-4 h-4 text-amber-700" />
              CRITICAL HEALTH & ALLERGY WARNINGS:
            </span>
            <p className="text-amber-950 font-medium">
              {activePet.allergies?.length > 0
                ? activePet.allergies.join(', ')
                : 'No known drug or food allergies.'}
            </p>
            {activePet.chronicConditions && (
              <p className="text-amber-900 text-[11px] mt-1">
                Chronic notes: {activePet.chronicConditions.join(', ')}
              </p>
            )}
          </div>

          {/* OFFICIAL VACCINATION TABLE */}
          <div>
            <h4 className="text-xs font-bold uppercase tracking-wider text-slate-900 mb-2">
              Immunization Ledger & Booster Records
            </h4>
            <div className="overflow-x-auto border border-slate-300 rounded-xl">
              <table className="w-full text-left text-xs">
                <thead className="bg-slate-100 text-slate-700 font-bold border-b border-slate-300">
                  <tr>
                    <th className="p-2.5">Vaccine Description</th>
                    <th className="p-2.5">Class</th>
                    <th className="p-2.5">Administered Date</th>
                    <th className="p-2.5">Booster Due</th>
                    <th className="p-2.5">Lot / Batch</th>
                    <th className="p-2.5">Status</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-200 font-medium">
                  {vaccines.map((vax) => (
                    <tr key={vax.id} className="hover:bg-slate-50">
                      <td className="p-2.5 font-bold text-slate-900">{vax.name}</td>
                      <td className="p-2.5 text-slate-600">{vax.type}</td>
                      <td className="p-2.5 text-slate-800">{vax.administeredDate || 'Pending'}</td>
                      <td className="p-2.5 font-bold text-slate-900">{vax.dueDate}</td>
                      <td className="p-2.5 font-mono text-slate-600">{vax.batchNumber}</td>
                      <td className="p-2.5">
                        <span
                          className={`inline-block px-2 py-0.5 rounded-sm font-bold text-[10px] ${
                            vax.status === 'Completed'
                              ? 'bg-emerald-100 text-emerald-800'
                              : 'bg-amber-100 text-amber-900'
                          }`}
                        >
                          {vax.status}
                        </span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>

          {/* RECENT CLINICAL ENCOUNTERS */}
          <div>
            <h4 className="text-xs font-bold uppercase tracking-wider text-slate-900 mb-2">
              Recent Clinical Findings & Diagnoses
            </h4>
            <div className="space-y-2">
              {medicalRecords.slice(0, 2).map((rec) => (
                <div key={rec.id} className="p-3 bg-slate-50 border border-slate-200 rounded-xl text-xs">
                  <div className="flex items-center justify-between font-bold text-slate-900 mb-1">
                    <span>{rec.title} ({rec.category})</span>
                    <span className="text-slate-500 font-normal">{rec.date} • {rec.doctor}</span>
                  </div>
                  <p className="text-slate-700">{rec.diagnosis}</p>
                </div>
              ))}
            </div>
          </div>

          {/* SIGNATURE / STAMP VET HANDOVER BLOCK */}
          <div className="grid grid-cols-2 gap-8 pt-6 border-t-2 border-slate-200 mt-6 text-xs">
            <div>
              <p className="text-[11px] text-slate-500 mb-8">
                I hereby certify that the companion animal identified above has been examined and vaccination records verified authentic.
              </p>
              <div className="border-t border-slate-400 pt-1.5 flex justify-between text-slate-600">
                <span>Attending Veterinarian Signature</span>
                <span>Date: ____ / ____ / ________</span>
              </div>
            </div>

            <div className="flex flex-col items-center justify-center p-4 border border-dashed border-slate-300 rounded-xl bg-slate-50/50">
              <span className="text-[10px] uppercase font-bold text-slate-400 tracking-widest">
                Official Clinical Seal / Stamp
              </span>
            </div>
          </div>

        </div>
      </div>
    </Modal>
  );
};
