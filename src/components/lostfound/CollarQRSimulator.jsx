import React, { useState } from 'react';
import { usePetContext } from '../../context/PetContext';
import {
  QrCode,
  PhoneCall,
  MessageSquare,
  MapPin,
  AlertTriangle,
  Heart,
  CheckCircle2,
  Shield,
  Smartphone,
  Navigation,
  Share2
} from 'lucide-react';
import { Badge } from '../common/Badge';

export const CollarQRSimulator = () => {
  const { activePet, showToast } = usePetContext();
  const [hasSharedLocation, setHasSharedLocation] = useState(false);
  const [isSendingPing, setIsSendingPing] = useState(false);

  const handleSimulateGPS = () => {
    setIsSendingPing(true);
    setTimeout(() => {
      setIsSendingPing(false);
      setHasSharedLocation(true);
      showToast(`📍 GPS Coordinates sent to ${activePet?.owner?.name}!`);
    }, 1200);
  };

  if (!activePet) return null;

  return (
    <div className="space-y-6">
      {/* Intro Banner */}
      <div className="p-6 bg-gradient-to-r from-amber-500 via-amber-600 to-amber-700 rounded-3xl text-white shadow-md">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
          <div>
            <div className="flex items-center gap-2 mb-2">
              <span className="p-1.5 bg-white/20 rounded-lg backdrop-blur-md">
                <QrCode className="w-5 h-5 text-white" />
              </span>
              <span className="text-xs font-black tracking-widest uppercase">
                Emergency Collar QR System
              </span>
            </div>
            <h2 className="text-2xl font-black tracking-tight">
              Lost & Found Rescue Portal Simulator
            </h2>
            <p className="text-xs text-amber-100 max-w-xl mt-1">
              Test what a rescuer or bystander sees when scanning {activePet.name}'s smart collar tag in the field.
            </p>
          </div>

          <div className="flex items-center gap-2 self-start sm:self-auto">
            <span className="text-xs font-bold px-3 py-1.5 rounded-xl bg-white text-amber-900 shadow-xs">
              Tag ID: {activePet.qrCodeId}
            </span>
          </div>
        </div>
      </div>

      {/* Two Column Grid: Physical Tag View (Left) & Mobile Scanner Stranger Screen (Right) */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-8">
        
        {/* Left: Physical Collar Tag & QR Specs */}
        <div className="lg:col-span-5 space-y-6">
          <div className="bg-white rounded-3xl border border-slate-200/80 p-6 shadow-xs">
            <h3 className="text-sm font-bold text-slate-900 mb-1">Physical Collar Smart Tag</h3>
            <p className="text-xs text-slate-400 mb-6">Laser-engraved anodized collar attachment</p>

            {/* Tag Simulation Badge */}
            <div className="relative mx-auto w-64 h-64 rounded-full bg-gradient-to-tr from-slate-900 to-slate-800 p-3 shadow-2xl flex flex-col items-center justify-center text-white border-4 border-amber-400/80">
              <div className="w-3 h-3 rounded-full bg-slate-950 border border-amber-400 mb-2" />
              <div className="w-28 h-28 bg-white rounded-2xl p-2.5 shadow-inner flex items-center justify-center">
                <QrCode className="w-full h-full text-slate-950" />
              </div>
              <span className="text-xs font-black tracking-wider uppercase mt-3 text-amber-300">
                {activePet.name.toUpperCase()}
              </span>
              <span className="text-[10px] font-mono text-slate-300 mt-0.5">
                SCAN IF LOST
              </span>
              <span className="text-[9px] text-slate-400 mt-1 font-semibold">
                {activePet.owner?.phone}
              </span>
            </div>

            <div className="mt-8 pt-6 border-t border-slate-100 space-y-3 text-xs text-slate-600">
              <div className="flex items-center justify-between">
                <span className="text-slate-400">Microchip ISO 11784:</span>
                <span className="font-mono font-bold text-slate-800">{activePet.microchipId}</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-slate-400">Collar Color:</span>
                <span className="font-semibold text-slate-800">{activePet.collarColor || 'Emerald Green'}</span>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-slate-400">Registered Owner:</span>
                <span className="font-semibold text-slate-800">{activePet.owner?.name}</span>
              </div>
            </div>
          </div>
        </div>

        {/* Right: Stranger's Mobile Phone Live View Simulator */}
        <div className="lg:col-span-7">
          <div className="bg-slate-900 rounded-[2.5rem] p-4 sm:p-5 shadow-2xl border-4 border-slate-700/60 max-w-md mx-auto">
            {/* Phone Notch */}
            <div className="w-32 h-4.5 bg-slate-800 rounded-full mx-auto mb-3 flex items-center justify-center">
              <div className="w-2.5 h-2.5 rounded-full bg-slate-900 mr-2" />
              <div className="w-8 h-1 rounded-full bg-slate-700" />
            </div>

            {/* Mobile Web Browser View */}
            <div className="bg-white rounded-3xl overflow-hidden shadow-inner text-slate-900 min-h-[580px] flex flex-col justify-between">
              
              {/* Emergency Alert Banner */}
              <div className="bg-rose-600 text-white p-4 text-center">
                <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-white/20 text-xs font-black uppercase tracking-wider mb-1">
                  <AlertTriangle className="w-3.5 h-3.5" />
                  <span>LOST PET RECOVERY ALERT</span>
                </div>
                <h3 className="text-base font-black">Thank you for helping find {activePet.name}!</h3>
                <p className="text-[11px] text-rose-100">Please contact the guardian immediately below.</p>
              </div>

              {/* Stranger Content Area */}
              <div className="p-5 space-y-4 flex-1">
                {/* Photo and Core Info */}
                <div className="flex items-center gap-4">
                  <img
                    src={activePet.photo}
                    alt={activePet.name}
                    className="w-20 h-20 rounded-2xl object-cover ring-2 ring-rose-500 shadow-md shrink-0"
                  />
                  <div>
                    <h2 className="text-xl font-black text-slate-900">{activePet.name}</h2>
                    <p className="text-xs font-semibold text-slate-600">{activePet.breed} • {activePet.gender}</p>
                    <p className="text-xs text-slate-500 mt-1">Weight: {activePet.weight} kg</p>
                    <Badge variant="rose" size="sm" className="mt-1.5">
                      Reported Missing
                    </Badge>
                  </div>
                </div>

                {/* Primary Call / SMS Actions */}
                <div className="grid grid-cols-2 gap-2 pt-2">
                  <a
                    href={`tel:${activePet.owner?.phone}`}
                    className="flex items-center justify-center gap-2 py-3 px-3 bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-black rounded-xl shadow-xs transition-colors text-center"
                  >
                    <PhoneCall className="w-4 h-4" />
                    <span>Call Owner Now</span>
                  </a>

                  <a
                    href={`sms:${activePet.owner?.phone}?body=Hi%20${activePet.owner?.name},%20I%20have%20found%20your%20pet%20${activePet.name}!`}
                    className="flex items-center justify-center gap-2 py-3 px-3 bg-slate-900 hover:bg-slate-800 text-white text-xs font-black rounded-xl shadow-xs transition-colors text-center"
                  >
                    <MessageSquare className="w-4 h-4" />
                    <span>Send SMS</span>
                  </a>
                </div>

                {/* GPS Location Ping Button */}
                <div className="p-4 rounded-2xl bg-teal-50/80 border border-teal-200">
                  <div className="flex items-start justify-between gap-2 mb-2">
                    <div>
                      <h4 className="text-xs font-black text-teal-950 flex items-center gap-1.5">
                        <Navigation className="w-3.5 h-3.5 text-teal-700" />
                        <span>Send Exact Found Location</span>
                      </h4>
                      <p className="text-[11px] text-teal-800/80 mt-0.5">
                        Transmits browser GPS pin directly to guardian's phone.
                      </p>
                    </div>
                  </div>

                  <button
                    onClick={handleSimulateGPS}
                    disabled={isSendingPing || hasSharedLocation}
                    className={`w-full py-2 px-3 text-xs font-bold rounded-xl flex items-center justify-center gap-2 transition-all cursor-pointer ${
                      hasSharedLocation
                        ? 'bg-emerald-100 text-emerald-800 border border-emerald-300'
                        : 'bg-teal-700 hover:bg-teal-800 text-white shadow-xs'
                    }`}
                  >
                    {isSendingPing ? (
                      <span>Acquiring GPS Satellite Pin...</span>
                    ) : hasSharedLocation ? (
                      <>
                        <CheckCircle2 className="w-4 h-4 text-emerald-600" />
                        <span>Location Sent (37.7749° N, 122.4194° W)</span>
                      </>
                    ) : (
                      <>
                        <MapPin className="w-4 h-4" />
                        <span>Simulate "Share Current Location"</span>
                      </>
                    )}
                  </button>
                </div>

                {/* Critical Health Alerts */}
                <div className="p-3.5 rounded-xl bg-amber-50 border border-amber-200 text-xs">
                  <span className="font-bold text-amber-900 block mb-1 flex items-center gap-1">
                    <AlertTriangle className="w-3.5 h-3.5 text-amber-700" />
                    Medical & Handling Instructions:
                  </span>
                  <p className="text-amber-950 font-medium">
                    {activePet.allergies?.length > 0
                      ? `⚠️ ALLERGIES: ${activePet.allergies.join(', ')}`
                      : 'No severe food allergies.'}
                  </p>
                  <p className="text-amber-800 text-[11px] mt-1 font-semibold">
                    Behavior: Very friendly. Approach calmly with a leash or treat.
                  </p>
                </div>

                {/* Microchip ISO Code */}
                <div className="text-center pt-2">
                  <span className="text-[10px] uppercase font-bold text-slate-400 tracking-wider block">
                    Certified Microchip Registry ISO:
                  </span>
                  <span className="font-mono text-xs font-bold text-slate-800">
                    {activePet.microchipId}
                  </span>
                </div>
              </div>

              {/* Bottom Phone Bar */}
              <div className="p-3 bg-slate-50 border-t border-slate-100 text-center text-[10px] text-slate-400 font-semibold">
                Protected by PetPulse 24/7 Rapid Lost Pet Recovery Network
              </div>
            </div>
          </div>
        </div>

      </div>
    </div>
  );
};
