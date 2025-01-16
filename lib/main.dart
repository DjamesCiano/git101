import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For parsing JSON

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatbot App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];

  // Function to send the message to Flask API and get the bot's response
  Future<void> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/chat'), // Replace with your server IP
        headers: {
          "Content-Type":
              "application/json", // Ensure the Content-Type is set to application/json
        },
        body: json.encode({"message": message}), // Send message in JSON format
      );

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        String botResponse = data['response'] ?? 'No response from bot';

        // Update the chat screen with bot's response
        setState(() {
          // Add the user's message and the bot's response to the list of messages
          // messages.add({"user": message});
          messages.add({"bot": botResponse});
        });
      } else {
        print('Failed to get response from the server');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message.values.first!),
                  tileColor: message.keys.first == 'user'
                      ? Colors.lightBlue[50]
                      : Colors.green[50],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String userMessage = _controller.text;
                    if (userMessage.isNotEmpty) {
                      setState(() {
                        messages.add({"user": userMessage});
                      });
                      _controller.clear();
                      sendMessage(
                          userMessage); // Send the message to the Flask API
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
