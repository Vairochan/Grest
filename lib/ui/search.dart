import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


String userEntered;
class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {


  Future _gotoNextScreen(BuildContext context) async {
    Map results = await Navigator.push(context, MaterialPageRoute<Map>(
        builder: (BuildContext context ) {
          return SearchScreen();
        }
    ));

    if (results != null && results.containsKey('enter')){

      userEntered = results['enter'];
      print(userEntered);

    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => back(),
              icon: Icon(Icons.arrow_back),
            ),
            title: Text(userEntered == null ? "Search" : userEntered),

            backgroundColor: Colors.black45,
            actions: <Widget>[
              userEntered == null ? profile() : search(),

            ],
          ),
          body: Container(
              color: Colors.grey.withOpacity(0.4),
              child: updateTempWidget(userEntered)),
      ),
    );
  }
  Widget updateTempWidget(String user){
    return FutureBuilder(
      future: getUserRepos(user == null ? '' : user),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData){
          List content = snapshot.data;
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                    itemCount: content == null ? 0 : content.length,
                    itemBuilder: (BuildContext context, int position){
                      return Column(
                        children: <Widget>[
                          Divider(height: 10,),
                          Card(
                            elevation: 10,
                            child: ListTile(
                              title: Text("${content[position]["name"]}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),),
                              subtitle: Text("${content[position]["description"]}"),
                              leading: CircleAvatar(
                                radius: 25,
                                child: Text("${content[position]["name"][0]}",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white
                                ),
                                ),
                                backgroundColor: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      );
                    }
                ),
              )
            ],
          );
        }else{
          return Center(
            child: Container(
              margin: const EdgeInsets.fromLTRB(80, 200, 50, 200),
              child: Text('Enter username to view Repositories',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 30
                ),),
            ),
          );
        }
      },

    );
  }
  search(){
    return FlatButton(
      onPressed:()=> Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context){
            return Profile();
          }
      )),
      child: Icon(
        Icons.person,
        color: Colors.white,
      ),
    );

  }
  profile(){
    return FlatButton(
      onPressed:() => _gotoNextScreen(context),
      child: Icon(
        Icons.search,
        color: Colors.white,
      ),
    );

  }
  back(){
    Navigator.pop(context);
    userEntered = null;
  }


}
Future<List> getUserRepos(String user) async {
  String apiUrl = "https://api.github.com/users/$user/repos";
  http.Response response = await http.get(apiUrl);
  if (response.statusCode == 200) {
    try {
      print(response.body);

      return json.decode(response.body);
    } catch (e) {
      print(e);
    }
  } else {
    print(response.statusCode);
  }
}



class SearchScreen extends StatelessWidget {

  var _usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: Text('Search'),
        centerTitle: true,
      ),
      body: Container(

        child: Column(
          children: <Widget>[
            ListTile(
              title: TextField(
                decoration: InputDecoration(
                    hintText: 'Enter username',
                  labelText: 'Username',

                ),
                controller: _usernameController,
                keyboardType: TextInputType.text,
              ),
            ),
            ListTile(
              title: RaisedButton(
                onPressed: () => Navigator.pop(context, {
                  'enter': _usernameController.text
                }),
                child: Text('Get Repositories'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(userEntered == null ? "No user" : userEntered),
          centerTitle: true,
          backgroundColor: Colors.grey,
        ),
        body: updateProfileWidget(userEntered),
      ),
    );
  }
}

Widget updateProfileWidget(String user){
  return FutureBuilder(
    future: getProfile(user == null ? "" : user),
    builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
      if (snapshot.hasData){
        Map content = snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                height: 200,
                color: Colors.grey,
                child: Card(
                    elevation: 20,
                    child: Image.network(content == null ? 0 : content["avatar_url"])),
              ),
              SizedBox(
                height: 35,
              ),
              Container(
                color: Colors.grey,
                height: 300,
                width: 380,
                child: Card(
                  elevation: 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 25,),
                              Text("Username: ${content["login"]}",
                                style: style(),),
                              sizedBox(),
                              Text("Name: ${content["name"]}",
                                  style: style()),
                              sizedBox(),
                              Text("Followers: ${content["followers"]}",
                                  style: style()),
                              sizedBox(),
                              Text("Following: ${content["following"]}",
                                  style: style()),
                              sizedBox(),
                              Text("Location: ${content["location"]}",
                                  style: style()),
                              sizedBox(),
                              Text("Bio: ${content["bio"]}",
                                  style: style()),

                            ],
                          ),
                        ],
                      ),

                    ],
                  ),
                ),

              )


            ],
          ),
        );
      }else{
        return Center(
          child: Container(
            margin: const EdgeInsets.fromLTRB(80, 200, 50, 200),
            child: Text('Enter username to view Repositories',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 30
              ),),
          ),
        );
      }
    },

  );
}

Widget sizedBox(){
  return SizedBox(height: 1,
    width: 110,
    child: Container(
      
    ),);
}



TextStyle style(){
  return TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black54,
  );

}
Future<Map> getProfile(String user) async {
  String apiUrl = "https://api.github.com/users/$user";
  http.Response response = await http.get(apiUrl);
  if (response.statusCode == 200) {
    try {
      print(response.body);

      return json.decode(response.body);
    } catch (e) {
      print(e);
    }
  } else {
    print(response.statusCode);
  }
}


