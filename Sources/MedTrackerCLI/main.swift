import Foundation
import MedTrackerCore

// main.swift (CLI)
// This is the entry point for the Command Line Interface.
//
// Key Concepts:
// 1. Top-Level Code: Unlike the GUI apps that use @main and structs, simple CLIs
//    often use top-level executable code. The code in this file runs sequentially.
// 2. readLine(): Standard Swift function to read input from stdin.
// 3. exit(0): Used to terminate the process cleanly.

let manager = MedicineManager()
print("Welcome to MedTracker CLI")
print("-----------------------")

while true {
    print("\nOptions:")
    print("1. Take Medicine")
    print("2. View History")
    print("3. Exit")
    print("Enter choice: ", terminator: "")
    
    guard let input = readLine(), let choice = Int(input) else {
        print("Invalid input. Please enter a number.")
        continue
    }
    
    switch choice {
    case 1:
        let success = await manager.logPill()
        if success {
            print("✅ Medicine Taken!")
        } else {
            print("⚠️  Already taken today.")
        }
        
    case 2:
        let history = await manager.getHistory()
        if history.isEmpty {
            print("No history yet.")
        } else {
            print("\nRecent History:")
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .medium
            
            for date in history.prefix(10) {
                print("- \(formatter.string(from: date))")
            }
        }
        
    case 3:
        print("Goodbye!")
        exit(0)
        
    default:
        print("Unknown option.")
    }
}
