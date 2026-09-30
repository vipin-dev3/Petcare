import React from 'react';

export const Badge = ({ children, variant = 'emerald', size = 'md', className = '' }) => {
  const variantStyles = {
    emerald: 'bg-emerald-50 text-emerald-700 border-emerald-200/80',
    amber: 'bg-amber-50 text-amber-800 border-amber-200/80',
    teal: 'bg-teal-50 text-teal-700 border-teal-200/80',
    rose: 'bg-rose-50 text-rose-700 border-rose-200/80',
    indigo: 'bg-indigo-50 text-indigo-700 border-indigo-200/80',
    slate: 'bg-slate-100 text-slate-700 border-slate-200',
  };

  const sizeStyles = {
    sm: 'text-[11px] px-2 py-0.5',
    md: 'text-xs px-2.5 py-1',
    lg: 'text-sm px-3 py-1.5',
  };

  return (
    <span
      className={`inline-flex items-center gap-1.5 font-semibold rounded-full border shadow-xs ${variantStyles[variant] || variantStyles.emerald} ${sizeStyles[size]} ${className}`}
    >
      {children}
    </span>
  );
};
