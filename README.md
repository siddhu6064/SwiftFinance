# NuatisFinance

NuatisFinance is a macOS-first finance management app with an enterprise UI language inspired by QuickBooks, ADP payroll systems, and modern fintech SaaS dashboards.

## Implemented UI architecture
- Fixed-width left navigation (240px)
- Top enterprise header bar with company selector, global search, quick actions, notifications, and user avatar
- Centered content canvas with max-width dashboard layout
- Reusable component system for cards, tables, charts, and sidebar items
- Native macOS materials, vibrancy, adaptive light/dark support, and subtle transitions

## Primary sections
- Dashboard
- Invoices
- Expenses
- Income
- Customers
- Vendors
- Payroll
- Employees
- Reports
- Taxes
- Settings

## Structure
```text
Sources/NuatisFinanceApp/
├── App.swift
├── MainWindow.swift
├── SidebarView.swift
└── FinanceApp/Views/
    ├── Components/
    │   ├── SidebarItem.swift
    │   ├── HeaderBar.swift
    │   ├── DashboardCard.swift
    │   ├── DataTable.swift
    │   └── ChartCard.swift
    ├── Shared/AppSection.swift
    ├── Dashboard/DashboardView.swift
    ├── Invoices/InvoicesView.swift
    ├── Expenses/ExpensesView.swift
    ├── Income/IncomeView.swift
    ├── Customers/CustomersView.swift
    ├── Vendors/VendorsView.swift
    ├── Payroll/PayrollView.swift
    ├── Employees/EmployeesView.swift
    ├── Reports/ReportsView.swift
    ├── Taxes/TaxesView.swift
    └── Settings/SettingsView.swift
```

See [`PRODUCT_PLAN.md`](./PRODUCT_PLAN.md) for broader product roadmap.
## Next-step architecture (now added)
- `FinanceApp/Data/CoreData/CoreDataStack.swift` for shared persistence bootstrap
- Per-module layering for business flow:
  - `Modules/<Section>/Repositories/`
  - `Modules/<Section>/UseCases/`
  - `Modules/<Section>/ViewModels/`
- Views now consume module view models instead of static hardcoded rows for invoices, expenses, customers, and vendors.
