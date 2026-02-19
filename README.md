# NuatisFinance (macOS)

NuatisFinance is a macOS finance tracker built with SwiftUI and Core Data.  
Current focus: clean architecture (Repository pattern), testable data layer, and an Invoice/Expense workflow.

---

## Features (Current)
- Core Data persistence
- Repository pattern for data access
- Invoice model + basic CRUD
- Unit tests for repository behavior (in-memory Core Data)

## Planned
- Expense tracking
- Categories / tags
- Search + filters + sorting
- CSV export
- Monthly summary dashboard

---

## Tech Stack
- **SwiftUI** (macOS)
- **Core Data**
- **Swift Package Manager** (SPM) executable target
- **XCTest** for unit tests

---

## Requirements
- macOS 14+
- Xcode 15+ (Swift 5.9)
- Swift Package Manager (comes with Xcode)

---

## Project Structure

> Paths below match the SwiftPM targets in `Package.swift`.

- `Sources/NuatisFinance/`
  - `FinanceApp/`  
    - `Resources/` (assets, Core Data model, etc.)
    - `App/` (SwiftUI entry + app composition)
    - `Data/` (Core Data stack, repositories)
    - `Domain/` (models, repository protocols, use cases)
    - `UI/` (views + view models)
- `Tests/NuatisFinanceTests/`
  - Repository tests (Core Data in-memory)
  - Test utilities / fixtures

---

## Build & Run (Xcode)

1. Open the repo in Xcode:
   - File → Open → select the folder containing `Package.swift`
2. Select scheme **NuatisFinanceApp**
3. Run (⌘R)

---

## Build & Run (CLI)

From the repo root:

```bash
swift build
swift run NuatisFinanceApp
