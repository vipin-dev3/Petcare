import React from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { CheckCircle2, AlertCircle, Info, X } from 'lucide-react';
import { usePetContext } from '../../context/PetContext';

export const Toast = () => {
  const { toast } = usePetContext();

  const icons = {
    success: <CheckCircle2 className="w-5 h-5 text-emerald-500 shrink-0" />,
    error: <AlertCircle className="w-5 h-5 text-rose-500 shrink-0" />,
    info: <Info className="w-5 h-5 text-teal-500 shrink-0" />,
  };

  const borders = {
    success: 'border-emerald-200 bg-white text-slate-900',
    error: 'border-rose-200 bg-white text-slate-900',
    info: 'border-teal-200 bg-white text-slate-900',
  };

  return (
    <div className="fixed bottom-6 right-6 z-50 pointer-events-none">
      <AnimatePresence>
        {toast && (
          <motion.div
            key={toast.id}
            initial={{ opacity: 0, y: 20, scale: 0.9 }}
            animate={{ opacity: 1, y: 0, scale: 1 }}
            exit={{ opacity: 0, y: 20, scale: 0.9 }}
            className={`pointer-events-auto flex items-center gap-3 px-4 py-3 rounded-xl border shadow-xl ${
              borders[toast.type] || borders.success
            }`}
          >
            {icons[toast.type] || icons.success}
            <span className="text-sm font-semibold pr-2">{toast.message}</span>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};
