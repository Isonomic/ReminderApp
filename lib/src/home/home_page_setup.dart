import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_copy/models/user.dart';
import 'package:water_copy/src/global_blocs/app_bloc.dart';
import 'package:water_copy/src/home/page_container.dart';


class HomePageSetup extends StatefulWidget {
  @override
  _HomePageSetupState createState() => _HomePageSetupState();
}

class _HomePageSetupState extends State<HomePageSetup> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      final appBloc = Provider.of<AppBloc>(context);
      await appBloc.init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = Provider.of<AppBloc>(context).userBloc;
    return StreamBuilder<User>(
      stream: userBloc.outUser,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                snapshot.error.toString(),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          final user = snapshot.data;
          return PageContainer(user: user);
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
