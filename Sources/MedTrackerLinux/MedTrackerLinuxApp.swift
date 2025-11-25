import Adwaita
import MedTrackerCore
import Foundation

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
