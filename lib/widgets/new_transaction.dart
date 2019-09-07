import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  DateTime selectedDate;
  final amountController = TextEditingController();

  void submitData() {
    if (amountController.text.isEmpty) return;
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || selectedDate == null) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      selectedDate,
    );
    Navigator.of(context).pop(); //automatically closing modal sheet when done
  }

  void datePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2020),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: titleController,
                onSubmitted: (_) => submitData(),
                // onChanged: (val) {
                //   titleInput = val;
                // },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
                // onChanged: (val) => amountInput = val,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(selectedDate == null
                            ? "No Date Selected"
                            : "Date Seleted : ${DateFormat.yMMMd().format(selectedDate)}")),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        "Select Date",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: datePicker,
                    )
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Add Transaction'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
