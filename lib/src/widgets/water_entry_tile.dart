import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_copy/models/drink.dart';
import '../global_blocs/app_bloc.dart';

class WaterEntryTile extends StatelessWidget {
  const WaterEntryTile({
    Key key,
    @required this.drink,
  }) : super(key: key);

  final Drink drink;

  @override
  Widget build(BuildContext context) {
    final drinkBloc = Provider.of<AppBloc>(context).drinkBloc;
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      // Can implement undo feature
      onDismissed: (direction) => drinkBloc.removeDrink(drink),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade900 : Colors.grey.shade300,
            ),
          ),
        ),
        child: ListTile(
          title: Text(drink.amount.toString()),
          subtitle: Text(drink.date.toString().substring(0, 10)),
        ),
      ),
    );
  }
}
