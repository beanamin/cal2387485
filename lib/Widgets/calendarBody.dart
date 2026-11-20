import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class CalendarService {
  static const _baseUrl =
      'https://us-central1-cegep-al.cloudfunctions.net/calendrier/A2026';

  // Temporaire! Au prochain cours, ce token sera géré par une session.
  static const _token = 'COLLEZ ICI VOTRE TOKEN';

  static Map<String, String> get _headers => {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      };

  Future<List<CalendarDay>> getDays() async {
    final response = await http.get(Uri.parse(_baseUrl), headers: _headers);

    if (response.statusCode != 200) {
      throw Exception('Erreur ${response.statusCode}');
    }

    final Map<String, dynamic> json =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

    final List<CalendarDay> days = json.entries
        .map<CalendarDay>((MapEntry<String, dynamic> e) =>
            CalendarDay.fromJson(e.key, e.value as Map<String, dynamic>))
        .toList();

    days.sort((CalendarDay a, CalendarDay b) => a.date.compareTo(b.date));
    return days;
  }
}

class CalendarDay{
  
  final DateTime date;
  final int? week;
  final int dayOfWeek;
  final String special;

  CalendarDay({
    required this.date,
    this.week,
    required this.dayOfWeek,
    required this.special,
  });

  factory CalendarDay.fromJson(String dateKey, Map<String, dynamic> json) {
    return CalendarDay(
      date: DateTime.parse(dateKey), // "2026-08-24" parses directly
      week: json['semaine'] as int?,
      dayOfWeek: json['jour_semaine'] as int,
      special: json['special'] as String,
    );
  }
  /*
  @override
  String toString() => 'CalendarDay($date, sem=$week, j=$dayOfWeek, "$special")';
  */
}

class CalendarBody extends StatefulWidget{
  const CalendarBody({super.key});

  @override
  State<CalendarBody> createState() => _CalendarBodyState();
}

class _CalendarBodyState extends State<CalendarBody> {
  final CalendarService _service = CalendarService();
  late final Future<List<CalendarDay>> _daysFuture;
  List<String> months = ["Janvier", "Février", "Mars", "Avril", "Mai", "Juin", "Juillet", "Aout", "Septembre", "Octobre", "Novembre", "Décembre"];

  @override
  void initState() {
    super.initState();
    _daysFuture = _service.getDays(); // called once, not on every rebuild
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cellwidth = width/6;
    return FutureBuilder<List<CalendarDay>>(
      future: _daysFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erreur : $snapshot'));
        }

        final days = snapshot.data!;
        debugPrint('${days.length} jours chargés');
        List<Widget> calendarRows = List.empty(growable: true);
        List<Widget> currentCells = List.empty(growable: true);
        int currentMonth = days.first.date.month;
        calendarRows.add(
          Container(
            height: cellwidth, 
            alignment: AlignmentGeometry.center,
            child: Text(months[currentMonth-1]),
          )
        );
        for (CalendarDay day in days){
          if(currentMonth != day.date.month){
            //Add dates to end of month
            Row currentColumn = Row(mainAxisAlignment: MainAxisAlignment.start, children: currentCells,);
            calendarRows.add(currentColumn);
            int emptySpaces = currentCells.length % 5;
            currentCells = List.empty(growable: true);

            //Add month spacer
            calendarRows.add(
              Container(
                height: cellwidth, 
                alignment: AlignmentGeometry.center,
                child: Text(months[day.date.month-1]),
              )
            );
            currentMonth = day.date.month;

            //Add empty spaces to start of month
            for(int i = 0; i < emptySpaces; i++){
              currentCells.add(
                Container(
                  padding: EdgeInsets.all(cellwidth/20),
                  margin: EdgeInsets.all(2),
                  decoration: BoxDecoration(border: BoxBorder.all(width: 1)),
                  width: cellwidth,
                  child: AspectRatio(
                    aspectRatio: 1,
                  ),
                )
              );
            }
          }

          if(day.date.weekday == 1 && currentCells.isNotEmpty){
            Row currentColumn = Row(mainAxisAlignment: MainAxisAlignment.start, children: currentCells,);
            calendarRows.add(currentColumn);
            currentCells = List.empty(growable: true);
          }

          Container dayCell = new Container(
            padding: EdgeInsets.all(cellwidth/20),
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(border: BoxBorder.all(width: 1)),
            width: cellwidth,
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  if(day.week != null)
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '${day.week}',
                        style: TextStyle(fontSize: cellwidth/5),
                      ),
                    ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '${day.dayOfWeek}',
                      style: TextStyle(fontSize: cellwidth/5),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      day.special,
                      style: TextStyle(fontSize: cellwidth/4),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      day.date.day.toString(),
                      style: TextStyle(fontSize: cellwidth/4),
                    ),
                  ),
                ],
              ),
            ),
          );
          currentCells.add(dayCell);
        }
        


        return ListView(
          children: [
            for (Widget row in calendarRows)
              row
          ],
        );
      },
    );
  }
}