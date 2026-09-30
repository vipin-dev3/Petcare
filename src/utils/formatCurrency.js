/**
 * Formats a number to Indian Rupee (INR) format using the Indian numbering system.
 * Example: 1200 -> ₹1,200; 150000 -> ₹1,50,000
 */
export const formatINR = (amount) => {
  if (amount === undefined || amount === null || isNaN(amount)) return '₹0';
  return '₹' + Number(amount).toLocaleString('en-IN');
};

export const parseINR = (str) => {
  if (!str) return 0;
  return parseFloat(String(str).replace(/[^\d.]/g, '')) || 0;
};
