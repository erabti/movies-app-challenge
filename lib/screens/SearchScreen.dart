///As name indicates, this handles search stuff.

import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:movie_challenge_averto/utils/api_handler.dart';
import 'package:movie_challenge_averto/models/MovieList.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

enum FilterOption { none, releaseDate, rating, popularity }

class _SearchScreenState extends State<SearchScreen> {
  var _controller = TextEditingController();
  bool isLoading;
  String selectedReleaseDate = "Any";
  FilterOption filterOption = FilterOption.none;

  Widget buildButton() {
    if (isLoading)
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: SpinKitRipple(
            itemBuilder: (_, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: index % 2 == 0 ? Colors.red : Colors.green,
                  shape: BoxShape.circle,
                ),
              );
            },
          ),
        ),
      );
    else
      return RaisedButton(
          onPressed: () async {
            if (this.mounted)
              setState(() {
                isLoading = true;
              });

            void showError(String errorText) {
              Flushbar()
                ..message = errorText
                ..icon = Icon(
                  Icons.info_outline,
                  size: 28.0,
                  color: Colors.red[300],
                )
                ..duration = Duration(seconds: 3)
                ..leftBarIndicatorColor = Colors.red[300]
                ..show(context);
            }

            String _searchText = _controller.text;
            FilterOption filterBy = filterOption;
            if (_searchText.isEmpty) {
              if (this.mounted)
                setState(() {
                  isLoading = false;
                });
              return showError("Search bar is empty!");
            } else {
              var result =
                  await searchMovie(_searchText, 1, selectedReleaseDate);
              if (this.mounted)
                setState(() {
                  isLoading = false;
                });

              if (result['total_results'] == 0) {
                showError("No Result Found!");
              } else if (result != null) {
                if (filterBy == FilterOption.rating) {
                  List results = result['results'];
                  results.sort((a, b) {
                    num vote1 = a['vote_average'];
                    num vote2 = b['vote_average'];
                    return vote2.compareTo(vote1);
                  });
                } else if (filterBy == FilterOption.popularity) {
                  List results = result['results'];
                  results.sort((a, b) {
                    num vote1 = a['popularity'];
                    num vote2 = b['popularity'];
                    return vote2.compareTo(vote1);
                  });
                } else if (filterBy == FilterOption.releaseDate) {
                  List results = result['results'];
                  results.sort((a, b) {
                    num vote1 = a['release_date'];
                    num vote2 = b['release_date'];
                    return vote2.compareTo(vote1);
                  });
                }
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchResultScreen(
                            result, _searchText, selectedReleaseDate)));
              }
            }
          },
          child: Text(
            "SEARCH",
            style: TextStyle(color: Colors.white),
          ),
          shape:
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.blueGrey);
  }

  @override
  void initState() {
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("Search"),
        backgroundColor: Colors.orange,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Card(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Search for movies...",
                    filled: true,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      " Filter By:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Radio(
                              groupValue: filterOption,
                              value: FilterOption.none,
                              onChanged: (FilterOption val) {
                                setState(() {
                                  filterOption = val;
                                });
                              },
                            ),
                            Text("None")
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio(
                              groupValue: filterOption,
                              value: FilterOption.rating,
                              onChanged: (FilterOption val) {
                                setState(() {
                                  filterOption = val;
                                });
                              },
                            ),
                            Text("Rating")
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio(
                              groupValue: filterOption,
                              value: FilterOption.popularity,
                              onChanged: (FilterOption val) {
                                setState(() {
                                  filterOption = val;
                                });
                              },
                            ),
                            Text("Popularity")
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio(
                              groupValue: filterOption,
                              value: FilterOption.releaseDate,
                              onChanged: (FilterOption val) {
                                setState(() {
                                  filterOption = val;
                                });
                              },
                            ),
                            Text("Release Date")
                          ],
                        )
                      ],
                    )
                  ],
                ),
                Divider(
                  color: Colors.orangeAccent,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      " Release Date:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: FlatButton(
                        color: Colors.orangeAccent,
                        padding: EdgeInsets.all(12.0),
                        shape: CircleBorder(),
                        onPressed: () {
                          List pickerData = List.generate(100, (i) {
                            return 2025 - i;
                          });
                          pickerData.insert(0, "Any");
                          Picker(
                              adapter: PickerDataAdapter(
                                pickerdata: pickerData,
                              ),
                              delimiter: [
                                PickerDelimiter(
                                    child: Container(
                                  alignment: Alignment.center,
                                  child: Icon(Icons.apps),
                                ))
                              ],
                              hideHeader: true,
                              title: Text("Please Select Date"),
                              backgroundColor: Colors.white70,
                              onConfirm: (Picker picker, List value) {
                                setState(() {
                                  selectedReleaseDate =
                                      picker.getSelectedValues()[0].toString();
                                });
                              }).showDialog(context);
                        },
                        child: Text(selectedReleaseDate),
                      ),
                    ),
                  ],
                ),
                buildButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchResultScreen extends StatefulWidget {
  final result;
  final String searchText;
  final String selectedReleaseDate;

  SearchResultScreen(this.result, this.searchText, this.selectedReleaseDate);

  @override
  SearchResultScreenState createState() {
    return new SearchResultScreenState();
  }
}

class SearchResultScreenState extends State<SearchResultScreen> {
  var rightBtn, leftBtn;
  var result;

  void onLeftBtn() async {
    int gotoPage = result['page'] - 1;
    var rslt = await searchMovie(
        widget.searchText, gotoPage, widget.selectedReleaseDate);
    setState(() {
      result = rslt;
    });
  }

  void onRightBtn() async {
    int gotoPage = result['page'] + 1;
    var rslt = await searchMovie(
        widget.searchText, gotoPage, widget.selectedReleaseDate);
    setState(() {
      result = rslt;
    });
  }

  @override
  void initState() {
    result = widget.result;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    leftBtn = result['page'] == 1 ? null : onLeftBtn;
    rightBtn = result['page'] == result['total_pages'] ? null : onRightBtn;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.searchText.toUpperCase()),
          centerTitle: true,
          backgroundColor: Colors.purpleAccent,
          leading: GestureDetector(
            child: Icon(Icons.close),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  onPressed: leftBtn,
                  icon: Icon(Icons.keyboard_arrow_left),
                ),
                Text(
                  "${result['page']} / ${result['total_pages']}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: rightBtn,
                  icon: Icon(Icons.keyboard_arrow_right),
                )
              ],
            ),
            Expanded(
              child: MovieListPage(
                "Results: ${result['total_results']}",
                result['results'],
                key: PageStorageKey(result['page'].toString()),
              ),
            )
          ],
        ));
  }
}
