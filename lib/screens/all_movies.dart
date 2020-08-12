import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movievibhuti/data/json_mock_data.dart';
import 'package:movievibhuti/models/movie.dart';

import 'paymentscreen.dart';

class AllMovies extends StatefulWidget {
  @override
  _AllMoviesState createState() => _AllMoviesState();
}

class _AllMoviesState extends State<AllMovies> {
  List movies = [];
  String categoryValue='All movies',typeOfSearch='';

  List categories = ['Drama','Action','Crime','Adventure'];
  List<DropdownMenuItem> dropDownItem =[];
  bool showFilteredDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showFilteredDate = false;
    movies = data;
    categories.forEach((element) {
      dropDownItem.add(DropdownMenuItem(child: Text(element),value: element,));
    });
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(showFilteredDate?'Search results':'All movies'),
            actions: [
              showFilteredDate?IconButton(icon: Icon(Icons.cancel), onPressed: (){
                setState(() {
                  movies = data;
                  showFilteredDate = false;
                  categoryValue = 'All movies';
                });
              }):Container()
            ],
          ),
      body: Container(
          child: Column(
        children: [
          Text(typeOfSearch),
          DropdownButton(
              hint: Text(categoryValue),
              items: dropDownItem, onChanged: (category){
              print(category);
              movies = data;
              categoryValue = category;
            if(category.toString().toLowerCase()=='All movies'.toLowerCase())
              {
                return movies=data;
              }
            else{
              movies = movies.where((element) {
                print('${element['genres'][0]}');
                return element['genres'][0].toString().toLowerCase()==category.toString().toLowerCase();
                //return element;
              }).toList();
            }
            showFilteredDate = true;
            setState(() {

            });
          }),
          FlatButton(
              onPressed: () {
                movies.sort((a, b) {
                  return b['imdbRating']
                      .toString()
                      .toLowerCase()
                      .compareTo(a['imdbRating'].toString().toLowerCase());
                });
                showFilteredDate = true;
                setState(() {

                });
              },
              child: Text('Sort According to rating')),
          FlatButton(
              onPressed: () {
                movies = movies.where((element) {
                  return element['imdbRating']*98>700 && element['imdbRating']*98<800;
                  //return element;
                }).toList();
                showFilteredDate = true;
                setState(() {

                });
              },
              child: Text('Filter Price search')),
          Expanded(
              child: ListView.builder(
                  itemCount: movies.length,
                  itemBuilder: (_, index) {
                    MovieModel model = MovieModel.fromJson(movies[index]);
                    return movies.length==0?Text('No movie found') :InkWell(
                      onTap: (){


                      },
                      child: movieCard(model),
                    );
                  }))
        ],
      )),
    ));
  }

  Widget movieCard(MovieModel model) {
    return Container(
      color: Colors.black.withOpacity(0.1),
      margin: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 10,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                  height: 140,
                  width: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(),
                      ),
                    ],
                  )),
              Image.network(
                model.posterurl,
                width: 80,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(model.title),
                Text('Rating: ${model.imdbRating}' ),
                Text('Price: ${(model.imdbRating*98).toStringAsFixed(2)}'),
                Text(model.genres[0].toString()),
                FlatButton(onPressed: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => PaypalPayment(
                        onFinish: (number) async {
                          print('order id: '+number);
                          showDialog(context: context,builder: (_){
                            return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.green,
                                      radius: 35,
                                      child: Icon(Icons.done,size: 40,),
                                    ),
                                    Text("Success with id $number"),
                                  ],
                                )
                            );
                          });

                        },
                      ),
                    ),
                  );

                },
                   color: Colors.blue,
                  child: Text('Buy'),)
              ],
            ),
          )
        ],
      ),
    );
  }
}
