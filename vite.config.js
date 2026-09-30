import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  base: './', // Ensures relative asset paths for GitHub Pages and subpaths
  server: {
    port: 3000,
    open: false,
  },
  build: {
    outDir: 'dist',
  },
});
