import 'package:flutter/material.dart';
import './widgets/chart.dart';
// import 'package:flutter/services.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() {
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expenz',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          errorColor: Colors.red,
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: TextStyle(color: Colors.white)),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [];
  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime selectedDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: selectedDate,
      id: DateTime.now().toString(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }
  List <Widget> _whenLandscape(MediaQueryData mediaQuery,AppBar appBar,Widget txWidget){
    return [Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Switch(
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    },
                  ),  
                  Text("Show Chart"),
                ],
              ),_showChart == true
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          .65,
                      child: Chart(_recentTransactions))
                  : //with the help of getter function we are able to get the specific values required her i.e only the recent transactions
                  txWidget];
  }

  List<Widget> _whenportrait(
      MediaQueryData mediaQuery, AppBar appBar, Widget txWidget) {
    return [
      Container(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              .30,
          child: Chart(_recentTransactions)),
      txWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      title: Text('Expenz'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );
    final isLandScape = mediaQuery.orientation == Orientation.landscape;
    final txWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandScape)
              ..._whenLandscape(mediaQuery,appBar,txWidget),
            if (!isLandScape)
              ..._whenportrait(
                mediaQuery,
                appBar,
                txWidget,
              ),
            // if (!isLandScape) txWidget,
            // if (isLandScape)
            //   _showChart == true
            //       ? Container(
            //           height: (mediaQuery.size.height -
            //                   appBar.preferredSize.height -
            //                   mediaQuery.padding.top) *
            //               .65,
            //           child: Chart(_recentTransactions))
            //       : //with the help of getter function we are able to get the specific values required her i.e only the recent transactions
            //       txWidget,
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
