import Adwaita
import MedTrackerCore
import Foundation

// MedTrackerLinuxApp.swift
// This is the entry point for the Linux version, using the Adwaita library.
//
// Key Concepts:
// 1. Adwaita: A Swift wrapper for LibAdwaita/GTK4. It allows us to build GNOME apps
//    using a declarative syntax very similar to SwiftUI.
// 2. App Protocol: Just like SwiftUI, the entry point is a struct conforming to `App`.
// 3. Window: We define the window and its content in the `scene` property.
// 4. State Management: We use `@State` to manage UI updates. When `statusMessage` changes,
//    the view automatically re-renders. This is a reactive pattern, unlike the imperative
//    UIKit/Win32 style.

@main
struct MedTrackerLinux: App {
    let id = "com.richardgist.medtracker"
    var app: GTUIApp!
    
    var scene: Scene {
        Window(id: "main") { _ in
            ContentView()
        }
    }
}

struct ContentView: View {
    // @State properties trigger UI updates when modified.
    @State private var statusMessage: String = "Welcome to MedTracker"
    @State private var historyMessage: String = ""
    @State private var showHistory: Bool = false
    
    private let manager = MedicineManager()
    
    var view: Body {
        VStack {
            Text("MedTracker Linux")
                .style("title-1")
                .padding()
            
            Text(statusMessage)
                .style("title-2")
                .padding()
            
            Button("Take Medicine") {
                Task {
                    await takeMedicine()
                }
            }
            .style("suggested-action")
            .padding()
            
            Button("View History") {
                Task {
                    await loadHistory()
                    showHistory = true
                }
            }
            .padding()
            
            if showHistory {
                Text(historyMessage)
                    .style("body")
                    .padding()
            }
        }
        .padding()
    }
    
    private func takeMedicine() async {
        let success = await manager.logPill()
        if success {
            statusMessage = "Medicine Taken!"
        } else {
            statusMessage = "Already taken today."
        }
    }
    
    private func loadHistory() async {
        let history = await manager.getHistory()
        if history.isEmpty {
            historyMessage = "No history yet."
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            
            let entries = history.prefix(5).map { formatter.string(from: $0) }
            historyMessage = "Recent History:\n" + entries.joined(separator: "\n")
        }
    }
}
