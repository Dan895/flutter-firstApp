import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'First App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  // muestra la siguietne palabra
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  // This code add fucntionallity to 'like' button,to save the favorites words. This is the enterprise logic
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //<-1
    var appState = context.watch<MyAppState>(); // <- 2
    //this was added to avoid complexity in the app
    //is a good practice to manage the complexity.
    var pair = appState.current;

    // This is the solution of the tutorial
    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      // <-3
      body: Center(
        child: Column(
          // <-4
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // This is all the interface
            // that the app contains

            // Text('A random AWESOME idea:'), // <-5
            // This line was modified to avoid complexity
            // Text(appState.current.asLowerCase), // <-6
            // this is the change of the line above,
            // BigCard is a refactor (click derecho -> Refactor -> Extract Widget)
            BigCard(pair: pair),
            // This widget give an space between BigCard and ElevatedButton
            SizedBox(
              height: 80,
            ),
            // This is a button, in  the section
            // childrend inside column of the app

            // This is the interface for
            // the 'like' button, to do
            // this, the button 'Next'
            // need to join to a widget called 'Row', to scope this
            // need to refactor -> Wrap with row

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ElevatedButton(
                //   onPressed: () {
                //     appState.toggleFavorite();
                //   },
                //   child: Icon(Icons.favorite),
                // ),

                // This is my solution, but this not change
                // the color of the heart.
                // TextButton.icon(
                //   onPressed: () {
                //     appState.toggleFavorite();
                //   },
                //   label: Text('Like'),
                //   icon: Icon(Icons.favorite),
                // ),

                // This is the solution of the tutorial
                // to include an icon, in the tutorial 7
                // we need to erase all in the MyHomePage,
                // I created other file to continue
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Like'),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    // print('button pressed!');
                    appState.getNext();
                  },
                  child: Text('Next'),
                ),
              ],
            )
          ], // <- 7
        ),
      ),
    );
  }
}

// This is the new class refactored in the class MyHomePage
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // this access the global theme of the app,
    // and displayMedium! is a property to display
    // visualization text, that are our case,
    // The "!" (bang operator) ensures that Dart you
    // know that I do, in this case this value isn't 'null' value
    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.onPrimary, fontFamily: 'Arial');

    return Card(
      elevation: 15,
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          // Add functionality for screen readers
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
