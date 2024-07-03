import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/models/search_country_model.dart';
import 'package:weather_app/services/services.dart';

class SearchDailog extends StatefulWidget {
  const SearchDailog({super.key});

  @override
  State<SearchDailog> createState() => _SearchDailogState();
}

class _SearchDailogState extends State<SearchDailog> {
  final StreamController<
      List<
          SearchCountryModel>> _controller = StreamController<
      List<
          SearchCountryModel>>.broadcast(); // Use broadcast for multiple listeners
  final TextEditingController _searchController = TextEditingController();

  void liveList(value) async {
    final updatelist = await Weather().searchCountryModel(value);
    _controller.add(updatelist); // Add data to the stream
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.close(); // Close the stream when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String data;
    // This will give you a new BuildContext that you can use to call setState and rebuild the AlertDialog
    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        surfaceTintColor: Colors.green,
        contentPadding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 15,
        ),
        // actionsPadding: EdgeInsets.all(0),
        content: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                //to prevent null error.
                if (value == "") {
                  value = "n";
                }
                // Now this (setState) refers to the StatefulBuilder
                // can't put in the function it won't work
                setState(() {
                  liveList(value);
                });
              },
              autofocus: true,
              decoration: InputDecoration(
                  labelText: 'Search',
                  // prefixIcon: IconButton(
                  //   onPressed: () async {
                  //     data = await getLocation();
                  //     Navigator.of(context).pop(data);
                  //   },
                  //   icon: Icon(
                  //     Icons.location_on_outlined,
                  //   ),
                  // ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _searchController.clear();
                      liveList("n");
                    },
                    icon: const Icon(
                      Icons.close,
                      size: 18,
                    ),
                  )),
            ),
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      data = await getLocation();
                      if (data != "") {
                        Navigator.of(context).pop(data);
                      }
                    },
                    child: const ListTile(
                      contentPadding: EdgeInsets.all(0),
                      leading: Icon(
                        Icons.location_on_outlined,
                        color: Colors.green,
                      ),
                      title: Text("Get Current Location"),
                    ),
                  ),
                  StreamBuilder<List<SearchCountryModel>>(
                    stream: _controller.stream,
                    initialData: const [],
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final list = snapshot.data!;
                        return Expanded(
                          flex: 2,
                          child: ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                //////////////.......new.......///////////......
                                padding: const EdgeInsets.all(0.0),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(0),
                                  onTap: () async {
                                    data = list[index].region;

                                    //send the data back to the screen
                                    Navigator.of(context).pop(data);
                                  },
                                  leading: const Icon(Icons.search),
                                  title: Text(
                                    list[index].region,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                      "${list[index].city} , ${list[index].country}",
                                      style:
                                          const TextStyle(color: Colors.grey)),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
