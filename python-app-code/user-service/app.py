from flask import Flask

app = Flask(__name__)

# Service root mapped to /users/
@app.route("/users/")
def home():
    return "User Service Home"

# Functional endpoint
@app.route("/users/list")
def users():
    return "Users endpoint accessed successfully"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001)