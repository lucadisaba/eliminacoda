import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fullscreen_window/fullscreen_window.dart';
//import 'package:text_scroll/text_scroll.dart';
import 'package:scrolling_text/scrolling_text.dart';
//import 'package:auto_size_text_field/auto_size_text_field.dart';
//import 'package:auto_size_text/auto_size_text.dart';

// entrypoint
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application. Tutto ciò che noi vediamo
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elimina coda',
      // This is the theme of your application.
      theme: ThemeData(
        //colorScheme: ColorScheme. fromSeed(seedColor: Color.fromARGB(0, 255, 255, 255)),
        primaryColor: Colors.transparent,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'SERVIAMO IL NUMERO:'),
    );
  }
}

// Schermata di ingresso, nel caso è la homePage, la schermata da cui devi partire!
class MyHomePage extends StatefulWidget {
  // stateful vuol dire che ha uno stato suo interno
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //double _titleFontSize = 140.0;
  bool _isFullscreen = false;
  bool _isChangingColor = false;
  bool _startColorChange = false;
  bool _isEditing = false;
  int _colorChangeDuration = 0;
  int _nrOrdine = 0000;
  late final TextEditingController _textEditingController =
      TextEditingController(text: _nrOrdine.toString().padLeft(4, '0'));
  late FocusNode _focusNode;
  late FlutterTts flutterTts;
  //int _counterCharacters = 0;
  late String numbersInItalian;
  String _bottomScrollText =
      'SISTEMA CASSE TERABYTE SRLS - PER INFO CHIAMARE AL 3494289877 - SOFTWARE DEVELOPER: LUCA DI SABATINO -';
  String _title = 'SERVIAMO IL NUMERO';
  Timer? _colorChangeTimer;
  late bool _isAudioChiamata;
  late bool _isAudioRipetizione;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double appBarHeight = screenHeight * 0.25;
    double bodyHeight = screenHeight * 0.70;
    double bottomBarHeight = screenHeight * 0.05;

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: handleKeyPress,
      child: Scaffold(
        //appbar
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          toolbarHeight: appBarHeight,
          backgroundColor: const Color.fromARGB(255, 177, 202, 122),
          title: SizedBox(
            width: screenWidth,
            height: appBarHeight,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                _title, // Assicurati che _title sia una stringa valida
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 190,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
            ),
          ),
        ),
        backgroundColor: _isChangingColor ? Colors.white : Colors.black,

        //--------------------body-Stack----------------------
        body: Stack(children: <Widget>[
          Center(
            child: SizedBox(
              height: bodyHeight,
              width: double.infinity,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  _nrOrdine.toString().padLeft(4, '0'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _isChangingColor ? Colors.black : Colors.white,
                    fontSize: 400,
                    fontWeight: FontWeight.bold,
                    //letterSpacing: 20.0,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ),
          SizedBox(
            height: bodyHeight,
            width: double.infinity,
            child: TextField(
              autofocus: true,
              controller: _textEditingController,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLines: 1,
              readOnly: !_isEditing,
              showCursor: false,
              style: const TextStyle(
                  color: Colors.red,
                  //color: _isChangingColor ? Colors.white : Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              textInputAction: TextInputAction.continueAction,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                setState(() {
                  if (value.isEmpty) {
                    _nrOrdine = _nrOrdine;
                  } else if (int.parse(value) > 9999) {
                    _nrOrdine = 0000;
                    _textEditingController.clear();
                  } else {
                    _textEditingController.clear();
                    _nrOrdine = int.parse(value);
                    //_textEditingController.text =
                    //    _nrOrdine.toString().padLeft(4, '0');
                    _updateConfigFile(_nrOrdine.toString().padLeft(4, '0'));
                    _isEditing = false;
                    //_counterCharacters = 0;
                    if (_isAudioChiamata) {
                      _parla(_nrOrdine.toString());
                    }
                    _flashingBody(_startColorChange);
                  }
                });
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: bottomBarHeight,
              width: double.infinity,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ScrollingText(
                    onFinish: () {
                      var index = 0;
                      if (index < _bottomScrollText.length) {
                        index++;
                      } else {
                        index = 0;
                      }
                      setState(() {});
                    },
                    textStyle: const TextStyle(
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                        height: 1.0),
                    text: _bottomScrollText,
                  )
              ),
            ),
          ),
        ]),
      ),
    );
  }

  @override
  void initState() {
    _focusNode = FocusNode();
    _loadDataFromTextFile();
    //sintetizzatore vocale
    flutterTts = FlutterTts();
    flutterTts.setLanguage('it-IT');
    flutterTts.setSpeechRate(0.5);
    super.initState();
  }

  void _handleErrorAndExit(dynamic error, StackTrace stackTrace) {
    final errorMessage = 'Errore: $error\n$stackTrace';

    // Scrivi l'errore nel file di log
    File logFile = File('C:/ec/error_log.txt');
    logFile.writeAsStringSync(errorMessage);

    // Chiudi l'app
    exit(1);
  }

  Future<void> _loadDataFromTextFile() async {
    try {
      final file = File('C:/ec/Configurazione.txt');
      final lines = await file.readAsLines();

      for (final line in lines) {
        final parts = line.split('=');
        if (parts.length == 2) {
          final key = parts[0].trim();
          final value = parts[1].trim();

          if (key == 'titolo') {
            setState(() {
              _title = value;
            });
          } else if (key == 'ordine') {
            setState(() {
              _nrOrdine = int.tryParse(value) ?? 0000;
              _textEditingController.text =
                  _nrOrdine.toString().padLeft(4, '0');
            });
          } else if (key == 'testoScorrimento') {
            setState(() {
              _bottomScrollText = value;
            });
          } else if (key == 'audioChiamata') {
            setState(() {
              _isAudioChiamata = bool.parse(value);
            });
          } else if (key == 'audioRipetizione') {
            setState(() {
              _isAudioRipetizione = bool.parse(value);
            });
          }
        }
      }
    } catch (e, stackTrace) {
      _handleErrorAndExit(e, stackTrace);
    }
  }

  void _updateConfigFile(String newValue) async {
    try {
      final configFile = File('C:/ec/Configurazione.txt');
      final lines = await configFile.readAsLines();

      final updatedLines = lines.map((line) {
        final parts = line.split('=');
        if (parts.length == 2) {
          final key = parts[0].trim();

          if (key == 'ordine') {
            return '$key=$newValue';
          }
        }
        return line;
      }).toList();

      await configFile.writeAsString(updatedLines.join('\n'));
    } catch (e, stackTrace) {
      _handleErrorAndExit(e, stackTrace);
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    flutterTts.stop();
    super.dispose();
  }

  void handleKeyPress(RawKeyEvent event) {
    try {
      if (event is RawKeyDownEvent) {
        //print(event.logicalKey.debugName);
        int tastoCalcolatrice = 0x016000000b7;

        if (event.logicalKey.keyId == tastoCalcolatrice) {
          setState(() {
            _startColorChange = true;
            if (_isAudioRipetizione) {
              _parla(_nrOrdine.toString());
            }
            _flashingBody(_startColorChange);
          });
        }

        /*
        if (event.logicalKey.keyId >= LogicalKeyboardKey.digit0.keyId &&
                event.logicalKey.keyId <= LogicalKeyboardKey.digit9.keyId ||
            event.logicalKey.keyId >= LogicalKeyboardKey.numpad0.keyId &&
                event.logicalKey.keyId <= LogicalKeyboardKey.numpad9.keyId) {
          setState(() {
            _startColorChange = true;
            _isEditing = true;
            ++_counterCharacters;
            if (_counterCharacters == 1) {
              _textEditingController.clear();
            }
          });
        }
        */
        switch (event.logicalKey) {
          case LogicalKeyboardKey.numpadAdd:
          case LogicalKeyboardKey.add:
            // Esegui qui le azioni che vuoi fare quando premi il tasto '+'
            _incrementCounter();
            break;

          case LogicalKeyboardKey.numpadSubtract:
          case LogicalKeyboardKey.minus:
            // Esegui qui le azioni che vuoi fare quando premi il tasto '-'
            _decrementCounter();
            break;

          case LogicalKeyboardKey.numpadDecimal:
            // Abilita la modifica del testo quando viene premuto il tasto '.'
            setState(() {
              _startColorChange = true;
              _textEditingController.clear();
              _isEditing = true;
            });
            break;

          case LogicalKeyboardKey.numpadMultiply:
            // Esegui qui le azioni che vuoi fare quando premi il tasto '+'
            setState(() {
              _startColorChange = true;
            });
            if (_isAudioRipetizione) {
              _parla(_nrOrdine.toString());
            }
            _flashingBody(_startColorChange);
            break;

          case LogicalKeyboardKey.tab:
            _focusNode.previousFocus();
            break;

          case LogicalKeyboardKey.arrowLeft:
            // Riduci la dimensione del font del titolo
            setState(() {
              //_titleFontSize -= 10.0; // O qualsiasi altro valore che preferisci
            });
            break;

          case LogicalKeyboardKey.escape:
            setState(() {
              _isFullscreen = !_isFullscreen;
            });
            FullScreenWindow.setFullScreen(_isFullscreen);
            break;

          default:
            // Nessuna azione specifica per il tasto premuto
            break;
        }
      }
    } catch (e, stackTrace) {
      _handleErrorAndExit(e, stackTrace);
    }
  }

  void _decrementCounter() {
    setState(() {
      _startColorChange = true;
      --_nrOrdine;
      _checkNrOrdine(_nrOrdine);
      _textEditingController.clear();
      //_parla(_title + _textEditingController.text);
      if (_isAudioChiamata) {
        _parla(_nrOrdine.toString());
      }
      _flashingBody(_startColorChange);
      _updateConfigFile(_nrOrdine.toString().padLeft(4, '0'));
    });
  }

  void _incrementCounter() {
    setState(() {
      _startColorChange = true;
      ++_nrOrdine;
      _checkNrOrdine(_nrOrdine);
      _textEditingController.clear();
      //_parla(_title + _textEditingController.text);
      if (_isAudioChiamata) {
        _parla(_nrOrdine.toString());
      }
      _flashingBody(_startColorChange);
      _updateConfigFile(_nrOrdine.toString().padLeft(4, '0'));
    });
  }

  void _checkNrOrdine(int nrOrdine) {
    if (nrOrdine < 0 || nrOrdine > 9999) {
      setState(() {
        _nrOrdine = 0;
        _textEditingController.text = (nrOrdine).toString().padLeft(4, '0');
      });
    }
    setState(() {
      _textEditingController.text = (nrOrdine).toString().padLeft(4, '0');
    });
  }

  void _flashingBody(bool startColorChange) {
    if (startColorChange && _colorChangeTimer == null) {
      _colorChangeTimer =
          Timer.periodic(const Duration(milliseconds: 200), (timer) {
        setState(() {
          _isChangingColor = !_isChangingColor;
          _colorChangeDuration += 300;

          if (_colorChangeDuration >= 7000) {
            _colorChangeTimer?.cancel();
            _colorChangeTimer = null;
            _colorChangeDuration = 0;
            _isChangingColor = false;
          }
        });
      });
    }
  }

  Future<void> _parla(String text) async {
    String numeroSopraMille;
    try {
      if (int.parse(text) > 1000) {
        numeroSopraMille = convertiNumeroSopraMille(int.parse(text));
        await flutterTts.speak(_title + numeroSopraMille);
      } else {
        await flutterTts.speak(_title + text);
      }
    } catch (e, stackTrace) {
      _handleErrorAndExit(e, stackTrace);
    }
  }

  String convertiNumeroSopraMille(int numeroSopraMille) {
    final unita = [
      "",
      "uno",
      "due",
      "tre",
      "quattro",
      "cinque",
      "sei",
      "sette",
      "otto",
      "nove"
    ];
    final decine = [
      "",
      "dieci",
      "venti",
      "trenta",
      "quaranta",
      "cinquanta",
      "sessanta",
      "settanta",
      "ottanta",
      "novanta"
    ];
    final speciali = [
      "",
      "undici",
      "dodici",
      "tredici",
      "quattordici",
      "quindici",
      "sedici",
      "diciassette",
      "diciotto",
      "diciannove"
    ];
    const migliaia = 'mila';

    final int migliaiaPart = (numeroSopraMille ~/ 1000) % 10;
    final int centinaiaPart = (numeroSopraMille ~/ 100) % 10;
    final int decinePart = (numeroSopraMille ~/ 10) % 10;
    final int unitaPart = numeroSopraMille % 10;

    String risultato = '';

    // Gestione delle migliaia

    if (migliaiaPart == 1) {
      risultato += 'mille';
    } else {
      risultato += unita[migliaiaPart] + migliaia;
    }

    // Gestione delle centinaia
    if (centinaiaPart == 1) {
      risultato += 'cento';
      if (decinePart == 0 && unitaPart > 0) {
        risultato += unita[unitaPart];
      }
    } else if (centinaiaPart > 1) {
      risultato += '${unita[centinaiaPart]}cento';
      if (decinePart == 0 && unitaPart > 0) {
        risultato += unita[unitaPart];
      }
    }

    // Gestione delle decine e numeri speciali
    if (decinePart == 1 && unitaPart > 0) {
      risultato += speciali[unitaPart];
    } else if (decinePart == 1 && unitaPart == 0) {
      risultato += decine[decinePart];
    }

    //Gestione delle decine e unità
    if (decinePart > 1 && unitaPart > 0) {
      risultato += decine[decinePart] + unita[unitaPart];
    } else if (decinePart > 1 && unitaPart == 0) {
      risultato += decine[decinePart];
    }

    if (centinaiaPart == 0 && decinePart == 0 && unitaPart > 0) {
      risultato += unita[unitaPart];
    }

    return risultato;
  }
}
