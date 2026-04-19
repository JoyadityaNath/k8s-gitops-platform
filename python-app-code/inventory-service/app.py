from flask import Flask

app = Flask(__name__)

# Service root mapped to /inventory/
@app.route("/inventory/")
def home():
    return "Inventory Service Home"

# Functional endpoint
@app.route("/inventory/list")
def inventory():
    return "Inventory endpoint accessed successfully"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5003)