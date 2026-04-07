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

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Myskintoneidentificationpage(title: 'Flutter Demo Home Page'),
    );
  }
}

class Myskintoneidentificationpage extends StatefulWidget {
  const Myskintoneidentificationpage({super.key, required this.title});



  final String title;

  @override
  State<Myskintoneidentificationpage> createState() => _MyskintoneidentificationpageState();
}

class _MyskintoneidentificationpageState extends State<Myskintoneidentificationpage> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}
