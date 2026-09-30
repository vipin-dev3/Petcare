# 🐾 PetPulse — Modern Petcare Management Platform

[![React](https://img.shields.io/badge/React-18.3.1-blue?logo=react)](https://react.dev/)
[![Vite](https://img.shields.io/badge/Vite-6.0.3-646CFF?logo=vite)](https://vitejs.dev/)
[![TailwindCSS](https://img.shields.io/badge/TailwindCSS-3.4.16-38B2AC?logo=tailwind-css)](https://tailwindcss.com/)
[![Framer Motion](https://img.shields.io/badge/Framer_Motion-11.15.0-black?logo=framer)](https://www.framer.com/motion/)
[![Recharts](https://img.shields.io/badge/Recharts-2.15.0-22c55e)](https://recharts.org/)

**PetPulse** is a modern, responsive, client-side Petcare Management Platform engineered with **React, Vite, Tailwind CSS, Framer Motion, and Recharts**. It provides companion animal guardians and veterinary teams with a single dashboard to track vaccinations, schedule clinical appointments, analyze weight progression against breed standards, simulate collar QR lost & found rescues, and locate 24/7 emergency trauma hospitals.

All application data is completely decoupled into `src/data/mockPetData.js` and persists across sessions via **LocalStorage**.

---

## 🚀 Key Modules & Capabilities

### 1. 🧭 Dashboard Header & Pet Switcher
- **Sticky Glassmorphism Navbar**: Persistent branding, global search bar filtering medical records, real-time pet switcher dropdown (*Max - Golden Retriever*, *Luna - Persian Cat*, *Milo - French Bulldog*, *Kiwi - Sun Conure*), and instant **"+ New Pet"** modal.
- **Dynamic Pet Hero Banner**: Covers patient vitals (Age, Current Weight, Microchip ISO, Blood Group), known allergies alerts, chronic condition warnings, and dietary notes.
- **Quick Stats Row**:
  - **Next Vaccine Due**: Tracks next scheduled dose with countdown and overdue warnings.
  - **Upcoming Appointment**: Highlights next confirmed clinical encounter.
  - **Weight Status**: Evaluates whether current weight falls within the breed's ideal veterinary range.
  - **Emergency SOS Quick Tile**: One-tap trigger showing distance to the nearest verified 24/7 animal trauma ER.

### 2. 🛡️ Digital Pet Passport & Medical History
- **Interactive Vaccination Timeline**:
  - Filterable by *All*, *Completed*, *Due Soon*, and *Overdue*.
  - Status badges with one-click **"Mark Completed / Mark Pending"** state toggles.
  - Full dose metadata including administering veterinarian, clinic, and batch lot numbers.
  - **Add Vaccine Modal** to register new immunization doses directly into LocalStorage.
- **Medical Records Log**:
  - Filterable clinical feed across *Vet Visits*, *Prescriptions*, *Lab Results*, and *Surgery*.
  - Search by diagnosis keyword or doctor name.
  - Detailed prescriptions pills with dosages, frequencies, and vitals recording (Temperature, Heart Rate, Weight).
- **Printable / Export PDF View**:
  - Client-side print-formatted modal summary for veterinary handovers and international transit.
  - Includes pet photo, owner contact, microchip barcode, immunization ledger, clinical history, and official attending vet signature stamp box.
  - Print/PDF trigger via `window.print()` with custom print stylesheets.

### 3. 📅 Interactive Appointment Booking Simulator
- **Multi-Step Scheduling Wizard**:
  1. **Select Service**: Clinical Checkup, Luxury Spa & Grooming, Vaccination Shield, Dental Scaling, Boarding, or Dog Walking.
  2. **Select Specialist**: Board-certified doctors and certified styling directors with star ratings and clinic locations.
  3. **Pick Date & Time Slot**: Interactive date picker and real-time available time slots.
  4. **Review & Confirm**: Summary review card calculating estimated fees and committing the booking directly to LocalStorage.
- **Upcoming Bookings Tab**:
  - Live ledger of confirmed, pending, and completed visits with one-tap cancellation support.

### 4. 🏷️ Lost & Found QR Profile Simulator
- **Physical Collar Smart Tag Preview**: Anodized collar tag rendering pet name, microchip ID, and QR code.
- **Rescuer Mobile Screen Simulation**:
  - Shows the exact mobile viewport a stranger sees when scanning the pet's collar QR code in the field.
  - High-visibility **LOST PET RECOVERY ALERT** banner.
  - Direct **Call Owner Now** (`tel:`) and **Send SMS** (`sms:`) actions.
  - Critical medical instructions (severe allergies, daily medications, behavioral handling).
  - Simulated **"Share Current Location"** button transmitting satellite coordinates (`37.7749° N, 122.4194° W`) with live confirmation feedback.

### 5. 📈 Health & Weight Analytics
- **Weight Progression Chart (`recharts`)**:
  - Interactive line graph plotting historical weight check-ins against the breed's ideal min/max reference area.
  - Hover tooltips displaying exact weights, dates, and check-in notes.
  - **"+ Log Weight"** modal to record new scale weigh-ins.
- **Monthly Expense Visualizer (`recharts`)**:
  - Stacked bar chart breaking down expenditures across *Food & Treats*, *Veterinary & Pharmacy*, *Spa & Grooming*, and *Toys & Gear*.
  - Average monthly spend calculation and category total pills.
  - **"+ Record Expense"** modal.

### 6. 🚨 24/7 Emergency SOS Locator
- **Verified Trauma Center Listings**:
  - Proximity radius feed showing distance, status pills (*Open 24/7*, *Closing Soon*), current triage wait times, and trauma verification levels (Level 1 Trauma Verified).
  - One-tap **Direct Phone Dialer** to alert trauma surgical teams before arrival.
  - Direct **Google Maps Navigation** action buttons.
- **Veterinary First Aid Guide Modal**:
  - Lifesaving protocols for toxic ingestion (Xylitol, Lilies, Dark Chocolate, NSAIDs, Grapes).
  - Canine & feline CPR resuscitation steps.
  - Heatstroke emergency cool-down procedures.

---

## 📁 Clean Modular Architecture

```text
src/
├── main.jsx                           # Application entry point
├── App.jsx                            # Core container & Framer Motion tab router
├── index.css                          # Tailwind directives & print media styles
├── context/
│   └── PetContext.jsx                 # Global state management & LocalStorage persistence
├── data/
│   └── mockPetData.js                 # Complete decoupled seed data (pets, vaccines, records, vets, ERs)
└── components/
    ├── common/
    │   ├── Badge.jsx                  # Status badges with semantic variants
    │   ├── Modal.jsx                  # Framer Motion animated modal dialog
    │   └── Toast.jsx                  # Animated system feedback toast
    ├── layout/
    │   ├── Navbar.jsx                 # Sticky header with global search & pet switcher dropdown
    │   ├── Sidebar.jsx                # Horizontal tab bar with dynamic counter badges
    │   └── Footer.jsx                 # Footer with hotline, platform sitemap & emergency numbers
    ├── dashboard/
    │   ├── PetHeroCard.jsx            # Active pet cover banner, vitals & allergies
    │   ├── QuickStatsRow.jsx          # Next vaccine, upcoming visit, weight status & SOS card
    │   ├── UpcomingSummary.jsx        # Quick appointments card with direct booking link
    │   ├── RecentHealthFeed.jsx       # Recent clinical diagnoses and prescriptions
    │   └── AddPetModal.jsx            # Multi-field new pet registration modal
    ├── passport/
    │   ├── VaccinationTimeline.jsx    # Interactive timeline with completed toggles
    │   ├── MedicalRecordsLog.jsx      # Filterable clinical encounter feed
    │   ├── PrintablePassportModal.jsx # Client-side print formatted PDF handover summary
    │   ├── AddVaccineModal.jsx        # Vaccine dose registration modal
    │   └── AddRecordModal.jsx         # Clinical encounter & prescription logging modal
    ├── booking/
    │   ├── AppointmentBookingWizard.jsx # Multi-step booking flow (Service -> Vet -> Slot -> Confirm)
    │   └── UpcomingBookingsList.jsx   # List of bookings saved in LocalStorage
    ├── lostfound/
    │   └── CollarQRSimulator.jsx      # Collar tag preview & stranger mobile rescue screen
    ├── analytics/
    │   ├── WeightProgressionChart.jsx # Recharts line chart with breed ideal reference area
    │   ├── ExpenseVisualizer.jsx      # Recharts stacked bar chart across 4 categories
    │   ├── AddWeightModal.jsx         # Weight log recording modal
    │   └── AddExpenseModal.jsx        # Expense entry modal
    └── sos/
        ├── EmergencySOSLocator.jsx    # Verified 24/7 emergency clinics & map links
        └── PetFirstAidGuideModal.jsx  # Pet CPR, heatstroke, and poison guides
```

---

## 🛠️ Local Development Setup

### Prerequisites
- **Node.js**: v18.0.0 or higher
- **npm**: v9.0.0 or higher

### Installation & Run

1. **Clone the repository**:
   ```bash
   git clone https://github.com/vipin-dev3/Petcare.git
   cd Petcare
   ```

2. **Install dependencies**:
   ```bash
   npm install
   ```

3. **Start the local development server**:
   ```bash
   npm run dev
   ```
   Open [http://localhost:3000](http://localhost:3000) (or the port indicated in your terminal) in your browser.

4. **Build production bundle**:
   ```bash
   npm run build
   ```

5. **Preview production build locally**:
   ```bash
   npm run preview
   ```

---

## 🌐 Static Deployment Guide

Because **PetPulse** is a fully client-side single-page application with LocalStorage persistence, it can be deployed for free in seconds on any static hosting provider:

### Option A: Deploy to Vercel (Recommended)
1. Install Vercel CLI:
   ```bash
   npm install -g vercel
   ```
2. Run deployment:
   ```bash
   vercel
   ```
   *(Or push to GitHub and connect repository to [Vercel](https://vercel.com) — framework will be auto-detected as **Vite** with build output directory `dist`)*.

### Option B: Deploy to Netlify
1. Build the production assets:
   ```bash
   npm run build
   ```
2. Deploy via Netlify CLI:
   ```bash
   npx netlify-cli deploy --prod --dir=dist
   ```
   *(Or link your GitHub repo on [Netlify](https://www.netlify.com); set Build command to `npm run build` and Publish directory to `dist`)*.

### Option C: Deploy to GitHub Pages
1. Install `gh-pages`:
   ```bash
   npm install -D gh-pages
   ```
2. In `vite.config.js`, set `base: '/Petcare/'` (matching your repo name).
3. In `package.json`, add:
   ```json
   "scripts": {
     "deploy": "vite build && gh-pages -d dist"
   }
   ```
4. Run:
   ```bash
   npm run deploy
   ```

---

## 🎨 Design System & Color Palette

- **Primary**: Emerald & Teal (`#059669`, `#0d9488`, `#10b981`)
- **Accent**: Warm Amber & Orange (`#f59e0b`, `#d97706`)
- **Neutrals**: Slate Canvas & Porcelain (`#f8fafc`, `#f1f5f9`, `#0f172a`)
- **Emergency**: Vibrant Crimson & Rose (`#e11d48`, `#be123c`)
- **Typography**: Plus Jakarta Sans
