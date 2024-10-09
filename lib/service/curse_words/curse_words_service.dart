import 'dart:convert';
import 'dart:typed_data';
import 'curses.dart';

class CurseWordService {
  List<String> _badWords = [];

  CurseWordService() {
    final Uint8List bytes = base64.decode(curses);
    final String badWords = utf8.decode(bytes);
    final Map jsonBadWords = json.decode(badWords);
    _badWords = jsonBadWords['badwords'].cast<String>();
  }

  bool containsCurseWord(String text) {
    final String filteredText = _removeAnySeparators(text);
    List<String> words = filteredText.split(' ');

    words = words.map((word) => _replaceRepeatedChars(word)).toList();

    for (String word in words) {
      if (_isCurseWord(word)) {
        return true;
      }
    }

    return false;
  }

  bool _isCurseWord(String word) {
    for (String badWord in _badWords) {
      if (word.toLowerCase().contains(badWord.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  String _removeAnySeparators(String text) {
    return text.replaceAll(RegExp(r'[^\w\s]+'), ' ');
  }

  String _replaceRepeatedChars(String input) {
    final RegExp regExp = RegExp(r'(.)\1+');
    final String result = input.replaceAllMapped(regExp, (Match match) {
      return match.group(1)!;
    });
    return result;
  }
}
