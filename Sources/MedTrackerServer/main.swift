import FlyingFox
import MedTrackerCore
import Foundation

// MedTrackerServer/main.swift
// A simple web server using FlyingFox.

let manager = MedicineManager()
let server = HTTPServer(port: 8080)

// 1. Serve the Home Page
await server.appendRoute("GET /") { request in
    let isTaken = await manager.isTakenToday()
    let lastTaken = await manager.getLastTaken()
    let html = WebRenderer.renderHome(isTaken: isTaken, lastTaken: lastTaken)
    return HTTPResponse(statusCode: .ok, body: html.data(using: .utf8)!)
}

// 2. Handle "Take Medicine" action (POST)
await server.appendRoute("POST /log") { request in
    _ = await manager.logPill()
    // Redirect back to home to show updated status
    return HTTPResponse(statusCode: .found, headers: [.location: "/"])
}

// 3. Serve the History Page
await server.appendRoute("GET /history") { request in
    let history = await manager.getHistory()
    let html = WebRenderer.renderHistory(entries: history)
    return HTTPResponse(statusCode: .ok, body: html.data(using: .utf8)!)
}

print("Starting MedTracker Server on http://localhost:8080")
try await server.start()
