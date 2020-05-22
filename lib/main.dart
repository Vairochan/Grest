import 'package:flutter/material.dart';
import 'package:grest/ui/home.dart';


void main(){
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Grest',

    home: HelloRectangle(),

  ));
}


class HelloRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: buildText(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.black));
            } else {
              return Home();
            }
          },
        ),
      ),
    );
  }

  Future buildText() {
    return new Future.delayed(
        const Duration(seconds: 2), () => print('waiting'));
  }
}