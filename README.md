# MedTracker

A simple medicine tracking application built with Swift.

## Features
-   **Cross-Platform**: Runs on Windows (SwiftWin32), Linux (Adwaita), and CLI.
-   **Core Logic**: Shared `MedicineManager` handles data persistence.
-   **UI**: Native Windows UI, Adwaita/GTK Linux UI, and interactive CLI.

## Prerequisites

### Windows
-   Swift 5.10+
-   Visual Studio 2022 with C++ Desktop Development workload.

### Linux (WSL/Ubuntu)
-   Swift 5.10+
-   GTK4 and LibAdwaita development libraries (`libgtk-4-dev`, `libadwaita-1-dev`).

## Installation

To clone the repository and its dependencies (including submodules):

```bash
git clone --recursive https://github.com/Richard-Gist/MedTracker.git
cd MedTracker
```

If you have already cloned it without `--recursive`, run:
```bash
git submodule update --init --recursive
```

## Building & Running

### Windows
```powershell
# GUI
swift build --product MedTrackerWin
.\.build\x86_64-unknown-windows-msvc\debug\MedTrackerWin.exe

# CLI
swift build --product MedTrackerCLI
.\.build\x86_64-unknown-windows-msvc\debug\MedTrackerCLI.exe
```

### Linux
```bash
# GUI
swift build --product MedTrackerLinux
.build/debug/MedTrackerLinux

# CLI
swift build --product MedTrackerCLI
.build/debug/MedTrackerCLI
```
