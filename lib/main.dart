import 'package:flutter/material.dart';
import 'package:flutter_grid_graph/app/locator.dart';
import 'package:flutter_grid_graph/views/grid_view/grid_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
    int _counter = 0;
    int test = _counter.hashCode;
    return Scaffold(
      backgroundColor: Color.fromRGBO(155, 190, 200, 1),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemCount: 30,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: GridGraph(),
          ),
        ],
      ),
    );
  }
}
