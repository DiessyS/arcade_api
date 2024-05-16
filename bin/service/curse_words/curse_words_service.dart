import 'dart:convert';
import 'curses.dart';

class CurseWordService {
  Map _jsonBadWords = {};

  CurseWordService() {
    String badWords = base64.decode(curses).toString();
    _jsonBadWords = json.decode(badWords);
  }

  bool containsCurseWord(String text) {
    for (String word in _jsonBadWords['badwords']) {
      if (text.toLowerCase().contains(word)) {
        return true;
      }
    }
    return false;
  }
}
