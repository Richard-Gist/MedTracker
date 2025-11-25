import Foundation

struct WebRenderer {
    static func renderHome(isTaken: Bool, lastTaken: Date?) -> String {
        let statusText = isTaken ? "You have taken your medicine today." : "You haven't taken your medicine yet."
        let statusColor = isTaken ? "#4CAF50" : "#FF5722"
        let buttonHtml = isTaken 
            ? "<button class='btn disabled' disabled>Taken</button>" 
            : "<form action='/log' method='POST'><button class='btn pulse'>Take Medicine</button></form>"
        
        let lastTakenText = lastTaken.map { "Last taken: " + formatDate($0) } ?? "No record found."
        
        return """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>MedTracker</title>
            <style>
                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background-color: #f0f2f5;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                    margin: 0;
                }
                .card {
                    background: white;
                    padding: 2rem;
                    border-radius: 12px;
                    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                    text-align: center;
                    width: 300px;
                }
                h1 { color: #333; }
                .status {
                    font-size: 1.2rem;
                    color: \(statusColor);
                    margin-bottom: 1.5rem;
                    font-weight: bold;
                }
                .btn {
                    background-color: #007bff;
                    color: white;
                    border: none;
                    padding: 15px 32px;
                    text-align: center;
                    text-decoration: none;
                    display: inline-block;
                    font-size: 16px;
                    border-radius: 8px;
                    cursor: pointer;
                    transition: background-color 0.3s;
                    width: 100%;
                }
                .btn:hover { background-color: #0056b3; }
                .btn.disabled { background-color: #ccc; cursor: not-allowed; }
                .pulse {
                    animation: pulse-animation 2s infinite;
                }
                @keyframes pulse-animation {
                    0% { box-shadow: 0 0 0 0 rgba(0, 123, 255, 0.7); }
                    70% { box-shadow: 0 0 0 10px rgba(0, 123, 255, 0); }
                    100% { box-shadow: 0 0 0 0 rgba(0, 123, 255, 0); }
                }
                .footer {
                    margin-top: 2rem;
                    font-size: 0.9rem;
                    color: #666;
                }
                a { color: #007bff; text-decoration: none; }
            </style>
        </head>
        <body>
            <div class="card">
                <h1>MedTracker</h1>
                <div class="status">\(statusText)</div>
                \(buttonHtml)
                <div class="footer">
                    <p>\(lastTakenText)</p>
                    <p><a href="/history">View History</a></p>
                </div>
            </div>
        </body>
        </html>
        """
    }
    
    static func renderHistory(entries: [Date]) -> String {
        let listItems = entries.map { "<li>" + formatDate($0) + "</li>" }.joined()
        
        return """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>MedTracker History</title>
            <style>
                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    background-color: #f0f2f5;
                    padding: 2rem;
                    margin: 0;
                }
                .container {
                    max-width: 600px;
                    margin: 0 auto;
                    background: white;
                    padding: 2rem;
                    border-radius: 12px;
                    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                }
                h1 { color: #333; text-align: center; }
                ul { list-style-type: none; padding: 0; }
                li {
                    padding: 10px;
                    border-bottom: 1px solid #eee;
                    color: #555;
                }
                li:last-child { border-bottom: none; }
                .back-link {
                    display: block;
                    margin-top: 20px;
                    text-align: center;
                    color: #007bff;
                    text-decoration: none;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>History</h1>
                <ul>
                    \(listItems)
                </ul>
                <a href="/" class="back-link">← Back to Tracker</a>
            </div>
        </body>
        </html>
        """
    }
    
    private static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
