import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:typing_game_frontend/palette.dart';

import 'keyboard_listener.dart';

class TextToType extends StatefulWidget {
  const TextToType({Key? key}) : super(key: key);

  @override
  State<TextToType> createState() => _TextToTypeState();
}

class _TextToTypeState extends State<TextToType> {
  final Stopwatch _stopwatch = Stopwatch();
  List<String>? _englishWords;

  String _currentPage = " ";
  String _letterToType = " ";
  int _pageCharacterIndex = 0;

  String _lastWPM = "-";

  @override
  void initState() {
    super.initState();
    _loadEnglishWords();
  }

  @override
  Widget build(BuildContext context) {
    return CustomKeyboardListener(
      letterEnteredFunction: letterEntered,
      child: Padding(
        padding: const EdgeInsets.only(left: 32.0, right: 24.0, top: 32.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Text(
                "Latest WPM: $_lastWPM",
                style: Palette.textToTypeStyle(),
              ),
            ),
            _englishWords == null
                ? FutureBuilder(
                    future: _loadEnglishWords(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        _generateNewPage();
                        return textToType();
                      }
                      return const CircularProgressIndicator();
                    })
                : textToType(),
          ],
        ),
      ),
    );
  }

  Widget textToType() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: _currentPage.substring(0, _pageCharacterIndex),
          style: Palette.textToTypeStyle(color: Colors.grey, fontSize: 28.0),
          children: <TextSpan>[
            TextSpan(
              text: _currentPage.substring(
                  _pageCharacterIndex, _pageCharacterIndex + 1),
              style: Palette.textToTypeStyle(
                  color: Colors.black,
                  fontSize: 28.0,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: _currentPage.substring(
                  _pageCharacterIndex + 1, _currentPage.length),
              style: Palette.textToTypeStyle(
                  color: Colors.black,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>?> _loadEnglishWords() async {
    final response = await http.get(Uri.file('assets/english_words.txt'));
    if (response.statusCode == 200) {
      final data = response.body;
      _englishWords = data.split('\n');
    } else {
      print(response.reasonPhrase);
      _englishWords = <String>[];
    }
    return _englishWords;
  }

  void _generateNewPage() async {
    List<String>? words = _englishWords;

    if (words != null) {
      String newPage = "";
      Random random = Random();
      for (int i = 0; i < 18; i++) {
        int randomInt = random.nextInt(words.length);
        newPage += "${words[randomInt].toLowerCase()} ";
      }
      setState(() {
        _currentPage = newPage.substring(0, newPage.length - 1);
        _letterToType = _currentPage.substring(0, 1);
      });
    }
  }

  void _startTimer() {
    _stopwatch.start();
  }

  void _stopTimer(bool updateWPM) {
    _stopwatch.stop();
    if (updateWPM) {
      _lastWPM = (_currentPage.split(" ").length /
              (_stopwatch.elapsedMilliseconds / 60 / 1000))
          .toStringAsFixed(1);
    }
    _stopwatch.reset();
  }

  void _resetCurrentPage(bool keepPage) {
    _pageCharacterIndex = 0;
    if (!keepPage) {
      _generateNewPage();
    }
    _letterToType = _currentPage.substring(0, 1);
  }

  void letterEntered(String letter) {
    if (_letterToType == letter) {
      setState(() {
        _pageCharacterIndex++;

        if (_pageCharacterIndex == 1) {
          _startTimer();
        }

        if (_pageCharacterIndex == _currentPage.length) {
          _stopTimer(true);
          _resetCurrentPage(false);
        }

        _letterToType = _currentPage.substring(
            _pageCharacterIndex, _pageCharacterIndex + 1);
      });
    } else if ("escape" == letter) {
      setState(() {
        _stopTimer(false);
        _resetCurrentPage(true);
      });
    }
  }
}
