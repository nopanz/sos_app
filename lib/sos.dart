import 'package:flutter/material.dart';
import 'package:sos_app/welcome.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
// import 'package:speech_recognition/speech_recognition.dart';

class SosScreen extends StatefulWidget {
  @override
  _SosScreenState createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  bool _hasSpeech = false;
  String lastWords = "";
  String lastError = "";
  String lastStatus = "";

  SpeechToText _speech = SpeechToText();

  String resultText = '';

  @override
  void initState() {
    super.initState();
    // initSpeechRecognizer();
    initSpeechState();
  }

  void startListening() {
    lastWords = "";
    lastError = "";
    _speech.listen(onResult: resultListener);
    setState(() {});
  }

  void stopListening() {
    _speech.stop();
    setState(() {});
  }

  void cancelListening() {
    _speech.cancel();
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    checkWords(result.recognizedWords);
    setState(() {
      lastWords = "${result.recognizedWords} - ${result.finalResult}";
    });
  }

  void checkWords(String pattern) {
    if (pattern.contains('help')) {
      print('Call for Help');
    }
  }

  void statusListener(String status) {
    if (status == 'notListening') {
      startListening();
    }
    setState(() {
      lastStatus = "$status";
    });
  }

  void errorListener(SpeechRecognitionError error) {
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await _speech.initialize(
        onError: errorListener, onStatus: statusListener);

    if (!mounted) return;
    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOS'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'LOG OUT',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()));
            },
          )
        ],
      ),
      body: Container(
        child: Center(
          child: _hasSpeech
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FloatingActionButton(
                          heroTag: 'btn1',
                          child: Icon(Icons.cancel),
                          mini: true,
                          backgroundColor: Colors.blue,
                          onPressed: () {
                            cancelListening();
                          },
                        ),
                        FloatingActionButton(
                          heroTag: 'btn2',
                          child: Icon(Icons.mic),
                          onPressed: () {
                            startListening();
                          },
                        ),
                        FloatingActionButton(
                          heroTag: 'btn3',
                          child: Icon(Icons.stop),
                          backgroundColor: Colors.yellow,
                          mini: true,
                          onPressed: () {
                            stopListening();
                          },
                        )
                      ],
                    ),
                  ],
                )
              : Center(
                  child: Text('Speech recognition unavailable',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }
}
