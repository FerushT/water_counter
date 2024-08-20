import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class WaterCounter extends StatefulWidget {
  const WaterCounter({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WaterCounterState createState() => _WaterCounterState();
}

class _WaterCounterState extends State<WaterCounter> {
  int _counter = 0;
  String _lastDate = ""; // Hiermit wird das Datum gespeichert.

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  // Lädt den Zähler und das Datum des letzten Zählers aus den Shared Preferences
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedDate = prefs.getString("lastDate") ?? "";
    int storedCounter = prefs.getInt('counter') ?? 0;

    // Überprüft, ob das gespeicherte Datum mit dem aktuellen Datum übereinstimmt.
    String currentDate = DateFormat("dd.MM.yyyy").format(DateTime.now());
    if (storedDate != currentDate) {
      await _resetCounter(); // Setzt den Zähler zurück, wenn das Datum nicht übereinstimmt.
    } else {
      if (mounted) {
        setState(() {
          _counter = storedCounter;
          _lastDate = storedDate; // Aktualisierung des Datums.
        });
      }
    }
  }

  // Aktualisiert den Zähler in den Shared Preferences.
  _updateCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentDate = DateFormat("dd.MM.yyyy").format(DateTime.now());
    await prefs.setInt('counter', _counter);
    await prefs.setString('lastDate', currentDate);
  }

  // Setzt den Zähler auf 0 zurück und speichert das aktuelle Datum.
  Future<void> _resetCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentDate = DateFormat("dd.MM.yyyy").format(DateTime.now());

    await prefs.setInt("counter", 0);
    await prefs.setString("lastDate", currentDate);

    if (mounted) {
      setState(() {
        _counter = 0;
        _lastDate = currentDate; // Setzt das Datum zurück.
      });
    }
  }

  // Inkrementiert den Zähler. (Aufzählung)
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _updateCounter();
  }

  // Manuelles Zurücksetzen des Zählers.
  void _manualReset() {
    _resetCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Water Counter"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Du hast so oft Wasser getrunken:",
              style: TextStyle(fontSize: 20),
            ),
            Text(
              '$_counter',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "Letztes Zähler-Datum: $_lastDate", // Datum anzeigen.
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text("Wenn getrunken, dann drücken"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _manualReset,
              child: const Text("Zähler zurücksetzen"),
            ),
          ],
        ),
      ),
    );
  }
}
