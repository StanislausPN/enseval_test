import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final VoidCallback signOut;
  HomePage({this.signOut});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String email = '';
  int value;
  RegExp regExp = RegExp(r'[^@]+',caseSensitive: false);

  String _greeting() {
    var hour = DateTime.now().hour;
    if (hour < 10 && hour > 2) {
      return 'Selamat Pagi ${regExp.stringMatch(email)}';
    } else if (hour < 14 && hour > 10) {
      return 'Selamat Siang ${regExp.stringMatch(email)}';
    } else if (hour < 17 && hour > 14) {
      return 'Selamat Sore ${regExp.stringMatch(email)}';
    } else {
      return 'Selamat Malam ${regExp.stringMatch(email)}';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss').format(dateTime);
  }

  String _timeString;
  @override
  void initState() {
    getPref();
    _timeString = _formatDateTime(DateTime.now());
    super.initState();
  }

  _logout() {
    setState(() {
      widget.signOut();
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString("email");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_timeString),
            Text(_greeting()),
            IconButton(tooltip: 'Logout',
                icon: Icon(Icons.power_settings_new),
                onPressed: () => _logout())
          ],
        ),
      ),
    );
  }
}
