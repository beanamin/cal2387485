import 'package:cal2387485/Widgets/calendarBody.dart';
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
          return 
          Padding(padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    child: Text(
                      "C : Congé | "
                      "D : Limite pour les désinscriptions | "
                      "A : Limite pour les abandons | "
                      "Elec: Élections | "
                      "TP: Journée TP | "
                      "PO: Journée portes ouvertes | "
                      "EUF: Épreuve Uniforme de Français | "
                      "EC: Évaluations Communes",
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ), 
                SizedBox(height: 10,),
                Flexible(
                  flex: 9,
                  child: CalendarBody()
                )
              ],
            )
          );
        })
      ),
    );
  }
}
