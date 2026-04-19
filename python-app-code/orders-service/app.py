from flask import Flask
from flask import Flask

app = Flask(__name__)

# Service root mapped to /orders/
@app.route("/orders/")
def home():
    return "Order Service Home"

# Functional endpoint
@app.route("/orders/list")
def orders():
    return "Orders endpoint accessed successfully"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5002)