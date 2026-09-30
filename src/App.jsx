import React from 'react';
import { PetProvider, usePetContext } from './context/PetContext';
import { Navbar } from './components/layout/Navbar';
import { Sidebar } from './components/layout/Sidebar';
import { Footer } from './components/layout/Footer';
import { Toast } from './components/common/Toast';
import { PetHeroCard } from './components/dashboard/PetHeroCard';
import { QuickStatsRow } from './components/dashboard/QuickStatsRow';
import { UpcomingSummary } from './components/dashboard/UpcomingSummary';
import { RecentHealthFeed } from './components/dashboard/RecentHealthFeed';
import { VaccinationTimeline } from './components/passport/VaccinationTimeline';
import { MedicalRecordsLog } from './components/passport/MedicalRecordsLog';
import { AppointmentBookingWizard } from './components/booking/AppointmentBookingWizard';
import { CollarQRSimulator } from './components/lostfound/CollarQRSimulator';
import { WeightProgressionChart } from './components/analytics/WeightProgressionChart';
import { ExpenseVisualizer } from './components/analytics/ExpenseVisualizer';
import { EmergencySOSLocator } from './components/sos/EmergencySOSLocator';
import { motion, AnimatePresence } from 'framer-motion';

const MainAppContent = () => {
  const { activeTab, activePet } = usePetContext();

  const tabVariants = {
    initial: { opacity: 0, y: 10 },
    animate: { opacity: 1, y: 0, transition: { duration: 0.22, ease: 'easeOut' } },
    exit: { opacity: 0, y: -10, transition: { duration: 0.15 } },
  };

  return (
    <div className="min-h-screen flex flex-col bg-slate-50">
      {/* Sticky Header */}
      <Navbar />

      {/* Horizontal Navigation Tabs */}
      <Sidebar />

      {/* Main Interactive Work Area */}
      <main className="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-6">
        <AnimatePresence mode="wait">
          {/* TAB 1: DASHBOARD */}
          {activeTab === 'dashboard' && (
            <motion.div
              key="dashboard"
              variants={tabVariants}
              initial="initial"
              animate="animate"
              exit="exit"
              className="space-y-6"
            >
              <PetHeroCard />
              <QuickStatsRow />
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                <UpcomingSummary />
                <RecentHealthFeed />
              </div>
            </motion.div>
          )}

          {/* TAB 2: DIGITAL PET PASSPORT & MEDICAL HISTORY */}
          {activeTab === 'passport' && (
            <motion.div
              key="passport"
              variants={tabVariants}
              initial="initial"
              animate="animate"
              exit="exit"
              className="space-y-6"
            >
              <VaccinationTimeline />
              <MedicalRecordsLog />
            </motion.div>
          )}

          {/* TAB 3: APPOINTMENT BOOKING SIMULATOR */}
          {activeTab === 'booking' && (
            <motion.div
              key="booking"
              variants={tabVariants}
              initial="initial"
              animate="animate"
              exit="exit"
            >
              <AppointmentBookingWizard />
            </motion.div>
          )}

          {/* TAB 4: COLLAR QR SIMULATOR */}
          {activeTab === 'lostfound' && (
            <motion.div
              key="lostfound"
              variants={tabVariants}
              initial="initial"
              animate="animate"
              exit="exit"
            >
              <CollarQRSimulator />
            </motion.div>
          )}

          {/* TAB 5: HEALTH & WEIGHT ANALYTICS */}
          {activeTab === 'analytics' && (
            <motion.div
              key="analytics"
              variants={tabVariants}
              initial="initial"
              animate="animate"
              exit="exit"
              className="space-y-6"
            >
              <WeightProgressionChart />
              <ExpenseVisualizer />
            </motion.div>
          )}

          {/* TAB 6: 24/7 EMERGENCY SOS */}
          {activeTab === 'sos' && (
            <motion.div
              key="sos"
              variants={tabVariants}
              initial="initial"
              animate="animate"
              exit="exit"
            >
              <EmergencySOSLocator />
            </motion.div>
          )}
        </AnimatePresence>
      </main>

      {/* Global Notifications Toast */}
      <Toast />

      {/* Footer */}
      <Footer />
    </div>
  );
};

export default function App() {
  return (
    <PetProvider>
      <MainAppContent />
    </PetProvider>
  );
}
