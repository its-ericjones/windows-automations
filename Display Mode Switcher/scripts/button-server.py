import serial
import time
from flask import Flask, Response

app = Flask(__name__)

try:
    ser = serial.Serial('/dev/ttyACM0', 9600, timeout=1)
    print("Connected to Arduino!")
except serial.SerialException as e:
    print(f"Error connecting to Arduino: {e}")
    print("Server will run, but button detection won't work")
    ser = None

@app.route('/')
def home():
    return """
    <!DOCTYPE html>
    <html>
    <head>
        <title>Arduino Button Monitor</title>
        <style>
            body {font-family: Arial, sans-serif; text-align: center; margin-top: 50px;}
            #status {font-size: 24px; margin: 20px; padding: 10px;}
            .waiting {color: blue;}
            .pressed {color: green; font-weight: bold;}
        </style>
    </head>
    <body>
        <h1>Arduino Button Monitor</h1>
        <div id="status" class="waiting">Waiting for button press...</div>
        
        <script>
            function checkButtonPress() {
                fetch('/wait_for_press')
                    .then(response => response.text())
                    .then(data => {
                        if(data === "PRESSED") {
                            document.getElementById("status").textContent = "Button was pressed! Refreshing...";
                            document.getElementById("status").className = "pressed";
                            
                            // Refresh the page after 1 second
                            setTimeout(() => {
                                window.location.reload();
                            }, 1000);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        // Retry if there's an error
                        setTimeout(checkButtonPress, 2000);
                    });
            }
            
            // Start checking for button press
            checkButtonPress();
        </script>
    </body>
    </html>
    """

@app.route('/button_status')
def button_status():
    if ser is None:
        return "ERROR: Arduino not connected"
        
    if ser.in_waiting > 0:
        line = ser.readline().decode('utf-8').rstrip()
        if line == "BUTTON_PRESSED":
            return "PRESSED"
    
    return "NOT_PRESSED"

@app.route('/wait_for_press')
def wait_for_press():
    # Long polling - wait for up to 30 seconds for a button press
    timeout = time.time() + 30  # 30 second timeout
    
    while time.time() < timeout:
        if ser is None:
            return "ERROR: Arduino not connected"
            
        if ser.in_waiting > 0:
            line = ser.readline().decode('utf-8').rstrip()
            if line == "BUTTON_PRESSED":
                return "PRESSED"
        
        time.sleep(0.1)  # Small delay to not hog CPU
    
    # Timeout occurred
    return "TIMEOUT"

if __name__ == '__main__':
    print("Starting button server on http://0.0.0.0:5000")
    app.run(host='0.0.0.0', port=5000, threaded=True)