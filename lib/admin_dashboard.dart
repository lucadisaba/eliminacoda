import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = screenHeight * 0.25;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 177, 202, 122),
        toolbarHeight: appBarHeight,
        title: const Text('ADMIN DASHBOARD'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Inserisci cosa vuoi servire',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .white), // Cambia il colore del bordo quando il campo non è in focus
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .white), // Cambia il colore del bordo quando il campo è in focus
                  ),
                ),
                maxLines: null, // Permette più righe di testo
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Inserisci il numero dell\'ordine',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .white), // Cambia il colore del bordo quando il campo non è in focus
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .white), // Cambia il colore del bordo quando il campo è in focus
                  ),
                ),
                maxLines: null, // Permette più righe di testo
              ),
            ),
            // Primo campo di testo per inserire un testo lungo
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Inserisci il testo dello sponsor',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .white), // Cambia il colore del bordo quando il campo non è in focus
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .white), // Cambia il colore del bordo quando il campo è in focus
                  ),
                ),
                maxLines: null, // Permette più righe di testo
              ),
            ),
            // Primo menu a tendina per True/False
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<bool>(
                style: const TextStyle(color: Colors.white),
                value: true, // Valore predefinito
                onChanged: (bool? newValue) {
                  // Implementa la logica per gestire la selezione
                },
                items: const [
                  DropdownMenuItem<bool>(
                    value: true,
                    child: Text('True'),
                  ),
                  DropdownMenuItem<bool>(
                    value: false,
                    child: Text('False'),
                  ),
                ],
                decoration: const InputDecoration(
                  labelText:
                      'Seleziona True o False per l\'audio della chiamata',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .white), // Cambia il colore del bordo quando il campo non è in focus
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .white), // Cambia il colore del bordo quando il campo è in focus
                  ),
                ),
                dropdownColor: Colors.black,
              ),
            ),
            // Secondo menu a tendina per True/False
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<bool>(
                style: const TextStyle(color: Colors.white),
                value: true, // Valore predefinito
                onChanged: (bool? newValue) {
                  // Implementa la logica per gestire la selezione
                },
                items: const [
                  DropdownMenuItem<bool>(
                    value: true,
                    child: Text(
                      'True',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DropdownMenuItem<bool>(
                      value: false,
                      child: Text(
                        'False',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
                decoration: const InputDecoration(
                  labelText:
                      'Seleziona True o False per l\'audio della ripetizione',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .white), // Cambia il colore del bordo quando il campo non è in focus
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .white), // Cambia il colore del bordo quando il campo è in focus
                  ),
                ),
                dropdownColor: Colors.black,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminDashboard()),
                );
              },
              child: const Text('Torna a servire!'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
