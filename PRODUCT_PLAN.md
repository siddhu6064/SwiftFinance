# NuatisFinance Product Plan (macOS .dmg + Mac App Store)

## Vision
Build a personal-use, macOS-native finance platform inspired by QuickBooks/ADP that covers:
- Invoicing
- Expense tracking
- People management
- HR records
- Payroll processing
- Financial reporting

The product should run as a standalone desktop app distributed via `.dmg` and optionally submitted to the Mac App Store.

---

## Recommended Product Strategy

### 1) Start with an offline-first macOS app
For personal usage, begin with a single-user app that stores data locally and can sync later.

**Suggested stack**
- UI: **SwiftUI**
- Local storage: **SwiftData** (or Core Data if you need broader compatibility)
- PDF/CSV exports: native Apple frameworks
- Charts: Swift Charts

### 2) Add secure data and accounting integrity from day one
- Use double-entry bookkeeping concepts for all money movements.
- Encrypt sensitive records at rest.
- Keep immutable audit logs for edits/deletes to financial records.

### 3) Build in phases
#### Phase 1 (MVP: 8–12 weeks)
- Company profile + chart of accounts
- Customer/vendor management
- Invoices (draft, sent, paid, overdue)
- Expense capture and categorization
- Core reports: P&L, cash flow, expense by category
- Data export: CSV and PDF

#### Phase 2
- Payroll engine (salary, hourly, allowances, deductions)
- Employee records and leave tracking
- Basic HR workflows
- Tax/withholding templates (country-specific plugin approach)

#### Phase 3
- Bank feed import (CSV first, then direct integrations)
- Reconciliation workflow
- Multi-entity and role-based access
- App sync/backup service

---

## Core Modules

## 1) Invoicing
- Invoice templates with branding
- Recurring invoices
- Credit notes
- Payment status timeline
- Reminder scheduling

## 2) Expense Tracking
- Manual expense entry
- Receipt attachments
- Category/tax tagging
- Reimbursable flags
- Vendor analytics

## 3) People + HR
- Employee profile, role, salary
- Offer/start/end dates
- Leave balances and attendance hooks
- Document storage (contracts, IDs)

## 4) Payroll
- Pay schedules (monthly/bi-weekly)
- Gross-to-net calculation pipeline
- Deductions, taxes, employer contributions
- Payslip generation (PDF)
- Payroll journal posting to ledger

## 5) Financial Reporting
- Profit & Loss
- Balance Sheet
- Cash Flow
- Aging reports (AR/AP)
- Payroll cost summary

---

## High-Level Data Model (first cut)
- `Account`
- `JournalEntry`
- `JournalLine`
- `Customer`
- `Vendor`
- `Invoice`
- `InvoiceLine`
- `Expense`
- `Employee`
- `PayrollRun`
- `Payslip`
- `Attachment`

All business operations should eventually post to `JournalEntry`/`JournalLine` to maintain consistent books.

---

## Mac Distribution Plan

## A) Personal distribution via `.dmg`
1. Build app archive in Xcode.
2. Sign with Developer ID certificate.
3. Notarize with Apple notarization service.
4. Package `.app` into `.dmg`.
5. Distribute directly.

## B) Mac App Store distribution
1. Use Mac App ID + provisioning profile.
2. Ensure sandbox compatibility and entitlements are minimal.
3. Implement privacy disclosures (especially payroll/HR data).
4. Upload via Xcode Organizer.
5. Pass App Review (stability, privacy policy, account deletion if cloud accounts exist).

---

## Compliance + Privacy Notes
- Payroll and HR data are highly sensitive; design for least privilege.
- Keep clear consent and retention settings for personal data.
- If adding cloud sync later, include account deletion and data export features.
- Maintain change logs for payroll and financial adjustments.

---

## Suggested 30-Day Execution Plan

### Week 1
- Define feature scope for MVP
- Finalize data model + bookkeeping rules
- Build app shell and navigation

### Week 2
- Implement invoicing and customer module
- Implement expense entry and categories

### Week 3
- Build reporting engine (P&L + cash summary)
- Add CSV/PDF exports

### Week 4
- Harden validation and audit logs
- Add backups/import-export
- Prepare notarized `.dmg` release

---

## MVP Success Criteria
- Create and track invoices end-to-end
- Record/categorize expenses
- Generate P&L and cash reports
- Export data safely
- Install and run from notarized `.dmg`

