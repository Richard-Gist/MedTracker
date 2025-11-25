import Foundation
import FlyingFox

let manager = MedicineManager()
let server = HTTPServer(port: 8080)

// Route: Home Page
await server.appendRoute("GET /") { request in
    let isTaken = await manager.isTakenToday()
    let lastTaken = await manager.getLastTaken()
    let html = WebRenderer.renderHome(isTaken: isTaken, lastTaken: lastTaken)
    return HTTPResponse(statusCode: .ok, body: html.data(using: .utf8)!)
}

// Route: Log Medicine (POST)
await server.appendRoute("POST /log") { request in
    _ = await manager.logPill()
    // Redirect back to home to show updated status
    return HTTPResponse(statusCode: .found, headers: [.location: "/"])
}

// Route: History Page
await server.appendRoute("GET /history") { request in
    let history = await manager.getHistory()
    let html = WebRenderer.renderHistory(entries: history)
    return HTTPResponse(statusCode: .ok, body: html.data(using: .utf8)!)
}

print("Starting MedTracker Web Server on http://localhost:8080")
try await server.run()
