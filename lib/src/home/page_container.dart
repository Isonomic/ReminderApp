import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_copy/models/user.dart';
import 'package:water_copy/src/enums/enums.dart';
import 'package:water_copy/src/global_blocs/auth/auth.dart';
import 'package:water_copy/src/global_blocs/theme_changer.dart';
import 'package:water_copy/src/home/pages/cups_page.dart';
import 'package:water_copy/src/home/pages/drink_page.dart';
import 'package:water_copy/src/home/pages/notifcation_page.dart';
import 'package:water_copy/src/pages/onboarding_page.dart';
import 'package:water_copy/src/widgets/popups/sync_account_popup.dart';


class PageContainer extends StatefulWidget {
  const PageContainer({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  _PageContainerState createState() => _PageContainerState();
}

class _PageContainerState extends State<PageContainer> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    CupsPage(),
    DrinkPage(),
    NotificationPage(),
  ];
  Auth auth;
  bool isAnonymous = false;

  @override
  void initState() {
    super.initState();
    delayedInit();
  }

  @override
  void didUpdateWidget(PageContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user.maxWaterPerDay != widget.user.maxWaterPerDay) {
      delayedInit();
    }
  }

  Future<void> delayedInit() async {
    if (widget.user.maxWaterPerDay == 1) {
      // Replace screen with onboarding page
      await Future.delayed(Duration.zero, () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => OnboardingPage(),
          ),
        );
      });
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    auth = Provider.of<Auth>(context);
    final firebaseUser = await auth.currentUser();
    setState(() {
      isAnonymous = firebaseUser.isAnonymous;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Water Reminder',
          style: Theme.of(context).textTheme.title,
        ),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (value) => onMenuSelection(value, auth),
            itemBuilder: (context) {
              return [
                const PopupMenuItem<PopupMenuChoices>(
                  value: PopupMenuChoices.signOut,
                  child: Text('sign out'),
                ),
                PopupMenuItem<PopupMenuChoices>(
                  value: PopupMenuChoices.themeChanger,
                  child: Text(
                    themeChanger.theme.brightness == Brightness.dark ? 'light mode' : 'dark mode',
                  ),
                ),
                if (isAnonymous)
                  const PopupMenuItem<PopupMenuChoices>(
                    value: PopupMenuChoices.syncPopup,
                    child: Text('sync account'),
                  ),
              ];
            },
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).accentColor,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink),
            title: Text('Cups'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            title: Text('Notification'),
          ),
        ],
      ),
    );
  }

  void onMenuSelection(PopupMenuChoices value, Auth auth) async {
    final themeChanger = Provider.of<ThemeChanger>(context);
    switch (value) {
      case PopupMenuChoices.signOut:
        auth.signOut();
        break;
      case PopupMenuChoices.themeChanger:
        themeChanger.switchTheme();
        break;
      case PopupMenuChoices.syncPopup:
        await showDialog(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return SyncAccountPopup();
          },
        );
        final firebaseUser = await auth.currentUser();
        setState(() {
          isAnonymous = firebaseUser.isAnonymous;
        });
        break;
      default:
    }
  }
}
