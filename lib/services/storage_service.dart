import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/flashcard.dart';

class StorageService {
  static const String flashcardKey = "flashcards";
  static Future<void> saveFlashcards(List<Flashcard> cards) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> data =
        cards.map((card) => jsonEncode(card.toJson())).toList();
    await prefs.setStringList(flashcardKey, data);
  }
  static Future<List<Flashcard>> loadFlashcards() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? data = prefs.getStringList(flashcardKey);
    if (data == null) return [];
    return data
        .map(
          (item) => Flashcard.fromJson(
            jsonDecode(item),
          ),
        )
        .toList();
  }
}
