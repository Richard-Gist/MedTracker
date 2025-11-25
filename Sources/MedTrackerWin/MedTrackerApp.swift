import SwiftWin32
import WinSDK
import Foundation
import MedTrackerCore

// MedTrackerApp.swift (Windows)
// This is the entry point for the Windows version of the application.
//
// Key Concepts:
// 1. SwiftWin32: A Swift wrapper around the native Win32 API. It provides UIKit-like
//    classes (Application, Window, Button, Label) to make Windows development feel familiar to iOS devs.
// 2. WinSDK: The raw C interface to Windows APIs. We import this if we need to call
//    Win32 functions directly (like MessageBoxW).
// 3. @main: The entry point. SwiftWin32 provides the `ApplicationMain` logic, but here
//    we define the Delegate and SceneDelegate, similar to a UIKit app.

@main
final class MedTrackerAppDelegate: ApplicationDelegate {
    func application(_ application: Application, didFinishLaunchingWithOptions options: [Application.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func application(_ application: Application, configurationForConnecting connectingSceneSession: SceneSession, options: Scene.ConnectionOptions) -> SceneConfiguration {
        let config = SceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        config.delegateClass = MedTrackerSceneDelegate.self
        return config
    }
}

final class MedTrackerSceneDelegate: SceneDelegate {
    var window: Window?

    func scene(_ scene: Scene, willConnectTo session: SceneSession, options connectionOptions: Scene.ConnectionOptions) {
        guard let windowScene = scene as? WindowScene else { return }
        
        let window = Window(windowScene: windowScene)
        
        // Setting the window frame manually.
        // Unlike iOS, Windows apps run in free-floating windows, so we define an initial size.
        var frame = window.frame
        frame.origin.x = 100
        frame.origin.y = 100
        frame.size.width = 600
        frame.size.height = 400
        window.frame = frame
        
        window.backgroundColor = .white
        let viewController = MedicineViewController()
        
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        self.window = window
        
        print("MedTracker: Window frame: \(window.frame)")
    }
}

final class MedicineViewController: ViewController {
    private let manager = MedicineManager()
    
    private lazy var statusLabel: Label = {
        let label = Label(frame: .zero)
        label.text = "Checking status..."
        label.textAlignment = .center
        label.font = Font.systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var takeButton: Button = {
        let button = Button(frame: .zero)
        button.setTitle("Take Medicine", forState: .normal)
        button.addTarget(self, action: MedicineViewController.takeMedicine, for: .primaryActionTriggered)
        button.backgroundColor = .systemBlue
        return button
    }()
    
    private lazy var historyButton: Button = {
        let button = Button(frame: .zero)
        button.setTitle("View History", forState: .normal)
        button.addTarget(self, action: MedicineViewController.showHistory, for: .primaryActionTriggered)
        button.backgroundColor = .systemGray
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MedTracker: viewDidLoad called")
        view.backgroundColor = .white
        
        view.addSubview(statusLabel)
        view.addSubview(takeButton)
        view.addSubview(historyButton)
        
        // Manual frames using inference from view.bounds
        var frame = view.bounds
        
        // Status Label
        frame.origin.x = 50
        frame.origin.y = 50
        frame.size.width = 500
        frame.size.height = 30
        statusLabel.frame = frame
        
        // Take Button
        frame.origin.x = 200
        frame.origin.y = 100
        frame.size.width = 200
        frame.size.height = 44
        takeButton.frame = frame
        
        // History Button
        frame.origin.x = 200
        frame.origin.y = 160
        frame.size.width = 200
        frame.size.height = 44
        historyButton.frame = frame
        
        refreshStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("MedTracker: viewDidAppear. Frame: \(view.frame), Bounds: \(view.bounds)")
    }
    
    private func refreshStatus() {
        Task {
            let isTaken = await manager.isTakenToday()
            let lastTaken = await manager.getLastTaken()
            
            await MainActor.run {
                if isTaken {
                    self.statusLabel.text = "You have taken your medicine today."
                    // self.statusLabel.textColor = .green
                    self.takeButton.isUserInteractionEnabled = false
                } else {
                    self.statusLabel.text = "You haven't taken your medicine yet."
                    // self.statusLabel.textColor = .red
                    self.takeButton.isUserInteractionEnabled = true
                }
                
                if let last = lastTaken {
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    formatter.timeStyle = .short
                    self.statusLabel.text = (self.statusLabel.text ?? "") + "\nLast: " + formatter.string(from: last)
                }
            }
        }
    }
    
    private func takeMedicine() {
        print("MedTracker: takeMedicine action triggered")
        Task {
            _ = await manager.logPill()
            await refreshStatus()
        }
    }
    
    private func showHistory() {
        print("MedTracker: showHistory action triggered")
        Task {
            let history = await manager.getHistory()
            print("MedTracker: History fetched: \(history)")
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            
            let message = history.prefix(10).map { formatter.string(from: $0) }.joined(separator: "\n")
            let displayMessage = message.isEmpty ? "No history" : message
            
            await MainActor.run {
                // Use MessageBoxW directly as AlertController is not fully implemented
                _ = MessageBoxW(nil, displayMessage.wide, "History (Last 10)".wide, UINT(MB_OK | MB_ICONINFORMATION))
                print("MedTracker: MessageBox shown")
            }
        }
    }
}

extension MedicineViewController: @unchecked Sendable {}
