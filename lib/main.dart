import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
        title: Text(widget.title),
      ),
      body: Center(
        
        child: OrientationBuilder(builder: (context, orientation) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: Wrap(
                  spacing: 10,
                  children: [
                    Text("D: Date limite de désinscription aux cours sans mention au bulletin"),
                    Text("Élec: Journée des Élections"),
                    Text("L: Horaire du Lundi"),
                    Text("C: Congé"),
                    Text("TP: Journée de travail personnel pour les étudiant.e.s"),
                    Text("A: Date limite pour abandonner un cours sans mention d'échec"),
                    Text("PO: Portes ouvertes (horaire des cours habituel)"),
                    Text("EUF: Épreuve uniforme de français"),
                    Text("EC: Évaluation commune"),
                  ],
                )
              ),
               Flexible(
                flex: 9,
                child: Text("") //Replace with CalenderBody() when ready
              )
            ],
          );
        })
      ),
    );
  }
}
