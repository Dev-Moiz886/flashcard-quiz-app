import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../models/flashcard.dart';
import '../widgets/flashcard_widget.dart';
import 'add_edit_card_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final List<Flashcard> flashcards = [
    Flashcard(
      question: "What is Flutter?",
      answer: "Flutter is Google's UI toolkit for building beautiful applications.",
    ),
    Flashcard(
      question: "Who developed Dart?",
      answer: "Google developed the Dart programming language.",
    ),
    Flashcard(
      question: "What is OOP?",
      answer: "Object-Oriented Programming.",
    ),
  ];

  int currentIndex = 0;
  bool showAnswer = false;

  Flashcard get currentCard => flashcards[currentIndex];

  //------------------------------------------
  // Next Card
  //------------------------------------------

  void nextCard() {
    if (currentIndex < flashcards.length - 1) {
      setState(() {
        currentIndex++;
        showAnswer = false;
      });
    }
  }

  //------------------------------------------
  // Previous Card
  //------------------------------------------

  void previousCard() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        showAnswer = false;
      });
    }
  }

  //------------------------------------------
  // Toggle Answer
  //------------------------------------------

  void toggleAnswer() {
    setState(() {
      showAnswer = !showAnswer;
    });
  }

  //------------------------------------------
  // Add Card
  //------------------------------------------

  Future<void> addFlashcard() async {

    final Flashcard? card = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddEditCardScreen(),
      ),
    );

    if (card != null) {

      setState(() {
        flashcards.add(card);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Flashcard Added Successfully"),
          ),
        );
      }
    }
  }

  //------------------------------------------
  // Edit Card
  //------------------------------------------

  Future<void> editFlashcard() async {

    final Flashcard? updatedCard = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditCardScreen(
          flashcard: currentCard,
        ),
      ),
    );

    if (updatedCard != null) {

      setState(() {
        flashcards[currentIndex] = updatedCard;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text("Flashcard Updated"),
          ),
        );
      }
    }
  }

  //------------------------------------------
  // Delete Card
  //------------------------------------------

  void deleteFlashcard() {

    if (flashcards.isEmpty) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(

        title: const Text("Delete Flashcard"),

        content: const Text(
          "Are you sure you want to delete this flashcard?",
        ),

        actions: [

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),

          FilledButton(
            onPressed: () {

              Navigator.pop(context);

              setState(() {

                flashcards.removeAt(currentIndex);

                if (currentIndex >= flashcards.length &&
                    currentIndex > 0) {
                  currentIndex--;
                }

                showAnswer = false;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  content: Text("Flashcard Deleted"),
                ),
              );

            },
            child: const Text("Delete"),
          )

        ],
      ),
    );
  }


   @override
  Widget build(BuildContext context) {

    if (flashcards.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("📚 FlashCard Quiz"),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: addFlashcard,
          icon: const Icon(Icons.add),
          label: const Text("Add Card"),
        ),
        body: const Center(
          child: Text(
            "No Flashcards Available\nPress + to Add One",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Scaffold(

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "📚 FlashCard Quiz",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: editFlashcard,
          ),

          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: deleteFlashcard,
          ),

        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: addFlashcard,
        icon: const Icon(Icons.add),
        label: const Text("Add Card"),
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          child: Padding(

            padding: const EdgeInsets.all(20),

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const SizedBox(height: 10),

                const Text(
                  "Welcome Back 👋",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Let's study something new today.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade700,
                  ),
                ).animate().fade(delay: 200.ms),

                const SizedBox(height: 30),

                const SizedBox(height: 30),
                      
                Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),

                    child: FlashcardWidget(
                      key: ValueKey(currentIndex),

                      flashcard: currentCard,

                      showAnswer: showAnswer,

                      onToggleAnswer: toggleAnswer,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                Row(

                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    Expanded(

                      child: ElevatedButton.icon(

                        onPressed:
                            currentIndex == 0
                                ? null
                                : previousCard,

                        icon: const Icon(Icons.arrow_back),

                        label: const Text("Previous"),

                      ),

                    ),

                    const SizedBox(width: 20),

                    Expanded(

                      child: ElevatedButton.icon(

                        onPressed:
                            currentIndex ==
                                    flashcards.length - 1
                                ? null
                                : nextCard,

                        icon: const Icon(Icons.arrow_forward),

                        label: const Text("Next"),

                      ),

                    ),

                  ],

                ),

                const SizedBox(height: 30),

                Card(

                  elevation: 5,

                  shape: RoundedRectangleBorder(

                    borderRadius:
                        BorderRadius.circular(20),

                  ),

                  child: Padding(

                    padding: const EdgeInsets.all(20),

                    child: Row(

                      mainAxisAlignment:
                          MainAxisAlignment.spaceAround,

                      children: [

                        Column(

                          children: [

                            const Icon(
                              Icons.style,
                              color: Colors.deepPurple,
                              size: 30,
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "${flashcards.length}",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const Text("Total"),

                          ],

                        ),

                        Column(

                          children: [

                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 30,
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "${currentIndex + 1}",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const Text("Studied"),

                          ],

                        ),

                        Column(

                          children: [

                            const Icon(
                              Icons.pending_actions,
                              color: Colors.orange,
                              size: 30,
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "${flashcards.length - currentIndex - 1}",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const Text("Remaining"),

                          ],

                        ),

                      ],

                    ),

                  ),

                ).animate().fade(delay: 300.ms).slideY(),

                                         
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}