import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String dayLabel;
  final double dayExpenditure;
  final double percentageExpenditureOfDay;
  ChartBar(this.dayLabel, this.dayExpenditure, this.percentageExpenditureOfDay);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Column(
        children: <Widget>[
          Container(
              height: constraints.maxHeight * 0.14,
              child: FittedBox(
                  child: Text('\$${dayExpenditure.toStringAsFixed(0)}'))),
          SizedBox(
            height: constraints.maxHeight * 0.04,
          ),
          Container(
            height: (constraints.maxHeight) * 0.63,
            width: 10,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: percentageExpenditureOfDay,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.04,
          ),
          Container(
            child: FittedBox(
              child: Text('${dayLabel.toString()}'),
            ),
            height: constraints.maxHeight * 0.14,
          )
        ],
      );
    });
  }
}
