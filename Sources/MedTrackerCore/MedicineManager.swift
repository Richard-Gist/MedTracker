import Foundation

// MedicineManager.swift
// This is the core logic of the application, shared across Windows, Linux, and CLI.
//
// Key Concepts:
// 1. Actor: We use an 'actor' to ensure thread safety. Since this class manages
//    state (the medicine log) that can be accessed from multiple threads (UI, background tasks),
//    the actor guarantees that only one method runs at a time. This avoids race conditions
//    without needing manual locks/mutexes.
// 2. Codable: We use Swift's Codable protocol to easily serialize the log to JSON.
// 3. FileManager: We use standard Foundation APIs to find the Documents directory.
//    On Windows, this maps to C:\Users\User\Documents.
//    On Linux, this maps to /home/user/Documents (or similar).

public actor MedicineManager {
    private let medicineLogFileName = "med_log.json"
    private var medicineLog: MedicineLog

    public init() {
        if let loadedLog = Self.loadMedicineLog(from: medicineLogFileName) {
            self.medicineLog = loadedLog
        } else {
            self.medicineLog = MedicineLog(entries: [])
        }
    }

    public func logPill() -> Bool {
        if isTakenToday() {
            return false
        }
        medicineLog.entries.append(Date())
        saveMedicineLog()
        return true
    }

    public func isTakenToday() -> Bool {
        guard let lastTaken = medicineLog.entries.last else {
            return false
        }
        return Calendar.current.isDateInToday(lastTaken)
    }

    public func getLastTaken() -> Date? {
        medicineLog.entries.last
    }

    public func getHistory() -> [Date] {
        medicineLog.entries.sorted(by: >)
    }

    private func saveMedicineLog() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(medicineLog)
            if let url = Self.getMedicineLogURL(for: medicineLogFileName) {
                try data.write(to: url)
            }
        } catch {
            print("Error saving medicine log: \(error)")
        }
    }

    private static func loadMedicineLog(from fileName: String) -> MedicineLog? {
        guard let url = getMedicineLogURL(for: fileName) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(MedicineLog.self, from: data)
        } catch {
            print("Error loading medicine log: \(error)")
            return nil
        }
    }

    private static func getMedicineLogURL(for fileName: String) -> URL? {
        // FileManager.default.urls(for: .documentDirectory, ...) works on both Windows and Linux.
        // It abstracts away the platform-specific path differences.
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsDirectory.appendingPathComponent(fileName)
    }
}

struct MedicineLog: Codable {
    var entries: [Date]
}
