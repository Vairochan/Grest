import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grest/ui/search.dart';
import 'package:http/http.dart' as http;



class Home extends StatelessWidget {
   description(content, position)async{
      return AlertDialog(
      title: Text("${content[position]["repo"]["name"]}"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Trending Repositories',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.black45,
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context){
                    return Search();
                  })),
              child: Icon(Icons.list,
              color: Colors.white,),
            )
          ],
        ),
        body: FutureBuilder(
        future: getRepos(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot){
          if(snapshot.hasData){
            List content = snapshot.data;
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                      itemCount: content.length,
                      itemBuilder: (BuildContext context, int position) {
                        return Container(
                          color: Colors.grey.withOpacity(0.4),
                          child: Column(
                            children: <Widget>[
                              Divider(
                                color: Colors.grey,
                                height: 5.5,
                              ),
                              Card(
                                elevation: 10,
                                child: ListTile(
//                                  onTap: description(content, position),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 30,
                                    child: Image.network("${content[position]["avatar"]}"),
                                  ),
                                  title: Text(
                                    " \t \t ${content[position]["repo"]["name"]}",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: ListTile(
                                      title: Text(
                                          "Description- \n \t \t ${content[position]["repo"]["description"]}"),
                                      subtitle: Text(" By- ${content[position]["name"]}")
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                )
              ],
            );
          }else{
            return Container();
          }
        },
        )
      )
    );
  }
  Future<List> getRepos() async {
    String apiUrl = 'https://github-trending-api.now.sh/developers?since=daily';

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
}











