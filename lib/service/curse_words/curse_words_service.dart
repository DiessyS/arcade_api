import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

//https://github.com/Kuyoku-san/Badwords
class CurseWordService {
  List<String> _badWords = [];

  CurseWordService() {
    _loadCurseWords();
  }

  _loadCurseWords() {
    final File file = File('assets/badwords.b64');
    final Uint8List bytes = base64.decode(file.readAsStringSync());
    final String badWords = utf8.decode(bytes);
    final Map jsonBadWords = json.decode(badWords);
    _badWords = jsonBadWords['words'].cast<String>();
  }

  bool containsCurseWord(String text) {
    text = _normalizeText(text);
    return _haveCurseWord(text) || _haveCurseWordInLeetSpeak(text);
  }

  String _normalizeText(String text) {
    text = _removeAnySeparators(text);
    text = _replaceRepeatedChars(text);
    return text.toLowerCase();
  }

  bool _haveCurseWord(String text) {
    for (String badWord in _badWords) {
      if (text.contains(badWord.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  bool _haveCurseWordInLeetSpeak(String text) {
    for (String badWord in _badWords) {
      final String badWordLeet = _turnIntoLeetSpeak(badWord);
      if (text.contains(badWordLeet.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  String _turnIntoLeetSpeak(String word) {
    return word
        .replaceAll('a', '4')
        .replaceAll('e', '3')
        .replaceAll('i', '1')
        .replaceAll('o', '0')
        .replaceAll('s', '5')
        .replaceAll('t', '7');
  }

  String _removeAnySeparators(String text) {
    return text.replaceAll(RegExp(r'[^\w\s]+'), ' ');
  }

  String _replaceRepeatedChars(String input) {
    final RegExp regExp = RegExp(r'(.)\1+');
    return input.replaceAllMapped(regExp, (Match match) {
      return match.group(1)!;
    });
  }
}
