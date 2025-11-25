# Medicine Tracker Walkthrough

I have upgraded the application to a **Web-based GUI**.

## How to Build
Open a terminal in the `MedTracker` directory and run:
```powershell
swift build
```

## How to Run
1. Start the server:
   ```powershell
   .\.build\debug\MedTracker.exe
   ```
   You should see: `Starting MedTracker Web Server on http://localhost:8080`

2. Open your web browser and go to:
   **[http://localhost:8080](http://localhost:8080)**

## Using the App
- **Home Page**: Shows your status for today.
    - If you haven't taken your medicine, you'll see a big **"Take Medicine"** button.
    - If you have, it will show **"You have taken your medicine today"** in green.
- **History**: Click "View History" to see past records.

## Technical Details
- **Server**: Uses `FlyingFox` (Pure Swift HTTP Server).
- **Frontend**: Server-Side Rendered HTML (No client-side JavaScript logic).
- **Data**: Stored in `med_log.json`.
