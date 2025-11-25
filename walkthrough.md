# MedTracker - Native Windows GUI Walkthrough

This document outlines the features and usage of the Native Windows GUI version of the Medicine Tracker application, built using `SwiftWin32`.

## Features

- **Native Window**: Runs as a standalone Windows application.
- **Status Display**: Shows whether medicine has been taken today and the last taken time.
- **Take Medicine**: A button to log medicine intake. Updates the status immediately.
- **History**: A button to view the last 10 entries in a native Alert dialog.

## Prerequisites

- Swift for Windows installed.
- `SwiftWin32` library (configured as a local dependency in this project).

## Building the Application

To build the application, run the following command in the project root:

```powershell
swift build
```

## Running the Application

To run the application:

```powershell
swift run
```

Or execute the binary directly:

```powershell
.\.build\debug\MedTracker.exe
```

## Verification Results

- **Build**: Successful.
- **Launch**: Verified that the application launches without crashing.
- **UI**:
    - **Status Label**: Displays current status.
    - **Take Button**: Logs medicine and updates status.
    - **History Button**: Shows an alert with history.
    - **Concurrency**: UI updates are safely handled on the main thread using `MainActor.run` and `Task`.

## Code Structure

- **MedTrackerApp.swift**: Contains the entry point (`@main`), `AppDelegate`, `SceneDelegate`, and `MedicineViewController`.
- **MedicineManager.swift**: Handles data persistence (`med_log.json`) and business logic.
- **Package.swift**: Configured with `SwiftWin32` dependency.
