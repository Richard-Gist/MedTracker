import Foundation

struct MedicineLog: Codable, Sendable {
    var entries: [Date]
}

actor MedicineManager {
    private let fileName = "med_log.json"
    
    private var fileURL: URL {
        let currentDirectory = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
        return currentDirectory.appendingPathComponent(fileName)
    }
    
    private func loadLog() -> MedicineLog {
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(MedicineLog.self, from: data)
        } catch {
            return MedicineLog(entries: [])
        }
    }
    
    private func saveLog(_ log: MedicineLog) {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(log)
            try data.write(to: fileURL)
        } catch {
            print("Error saving log: \(error)")
        }
    }
    
    func logPill() -> Bool {
        var log = loadLog()
        let now = Date()
        
        // Check if already taken today
        if isTakenToday() {
            return false
        }
        
        log.entries.append(now)
        saveLog(log)
        return true
    }
    
    func isTakenToday() -> Bool {
        let log = loadLog()
        guard let lastEntry = log.entries.last else { return false }
        return Calendar.current.isDate(lastEntry, inSameDayAs: Date())
    }
    
    func getLastTaken() -> Date? {
        let log = loadLog()
        return log.entries.last
    }
    
    func getHistory() -> [Date] {
        return loadLog().entries.reversed()
    }
}
