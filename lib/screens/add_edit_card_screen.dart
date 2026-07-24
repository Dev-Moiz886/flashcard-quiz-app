import 'package:flutter/material.dart';
import '../models/flashcard.dart';

class AddEditCardScreen extends StatefulWidget {
  final Flashcard? flashcard;

  const AddEditCardScreen({super.key, this.flashcard});

  @override
  State<AddEditCardScreen> createState() => _AddEditCardScreenState();
}

class _AddEditCardScreenState extends State<AddEditCardScreen> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.flashcard != null) {
      questionController.text = widget.flashcard!.question;
      answerController.text = widget.flashcard!.answer;
    }
  }

  void saveCard() {
    if (questionController.text.isEmpty ||
        answerController.text.isEmpty) {
      return;
    }

    Navigator.pop(
      context,
      Flashcard(
        question: questionController.text,
        answer: answerController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.flashcard == null
              ? "Add Flashcard"
              : "Edit Flashcard",
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: questionController,
              decoration: const InputDecoration(
                labelText: "Question",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: answerController,
              decoration: const InputDecoration(
                labelText: "Answer",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: saveCard,
                child: const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}