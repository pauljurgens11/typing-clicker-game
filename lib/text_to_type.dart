import 'dart:math';

import 'package:flutter/material.dart';
import 'package:typing_game_frontend/palette.dart';
import 'package:universal_html/html.dart' as html;

import 'keyboard_listener.dart';

class TextToType extends StatefulWidget {
  const TextToType({Key? key}) : super(key: key);

  @override
  State<TextToType> createState() => _TextToTypeState();
}

class _TextToTypeState extends State<TextToType> {
  final Stopwatch _stopwatch = Stopwatch();
  late Future<List<String>> _englishWords;

  String _currentPage = " ";
  String _letterToType = " ";
  int _pageCharacterIndex = 0;

  String _lastWPM = "-";

  @override
  void initState() {
    super.initState();
    _getEnglishWords();
    _generateNewPage();
  }

  @override
  Widget build(BuildContext context) {
    return CustomKeyboardListener(
      letterEnteredFunction: letterEntered,
      child: Padding(
        padding: const EdgeInsets.only(left: 32.0, right: 24.0, top: 32.0),
        child: Stack(
          children: [
            Text(
              "Latest WPM: $_lastWPM",
              style: Palette.textToTypeStyle(),
            ),
            FutureBuilder(
                future: _englishWords,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return textToType();
                  }
                  return const CircularProgressIndicator();
                }),
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

  void _getEnglishWords() async {
    _englishWords = html.HttpRequest.getString('../assets/english_words.txt')
        .then((data) => data.split('\n'));
  }

  void _generateNewPage() async {
    List<String> words = await _englishWords;

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
