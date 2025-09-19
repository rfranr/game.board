import http.server
import socketserver

PORT = 8080
DIRECTORY = "../game-board-dist-html5"

class CustomHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=DIRECTORY, **kwargs)

    def end_headers(self):
        # Required for SharedArrayBuffer
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        self.send_header("Cross-Origin-Resource-Policy", "same-origin")
        # Correct MIME for .wasm
        if self.path.endswith(".wasm"):
            self.send_header("Content-Type", "application/wasm")
        super().end_headers()

with socketserver.TCPServer(("", PORT), CustomHandler) as httpd:
    print(f"Serving on http://localhost:{PORT}")
    httpd.serve_forever()
