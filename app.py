from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app) 

def get_bot_response(user_input):
    if 'hello' in user_input.lower():
        return "Hi there! How can I help you today?"
    elif 'how are you' in user_input.lower():
        return "I'm doing great! Thanks for asking. How can I assist you?"
    elif 'bye' in user_input.lower():
        return "Goodbye! Have a great day!"
    else:
        return "Sorry, I didn't understand that."

@app.route('/chat', methods=['POST'])
def chat():
    if request.is_json:
        user_input = request.json.get('message')
        if not user_input:
            return jsonify({'response': 'No message received!'}), 400

        bot_response = get_bot_response(user_input)
        return jsonify({"response": bot_response})  # Send bot's response

    return jsonify({'response': 'Content-Type must be application/json'}), 400

if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5000)
