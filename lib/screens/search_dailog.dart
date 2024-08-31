import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/models/search_country_model.dart';
import 'package:weather_app/services/services.dart';

class SearchDialog extends StatefulWidget {
  const SearchDialog({Key? key}) : super(key: key);

  @override
  State<SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  final StreamController<List<SearchCountryModel>> _controller =
      StreamController<List<SearchCountryModel>>.broadcast();
  final TextEditingController _searchController = TextEditingController();

  void liveList(String value) async {
    final updateList = await Weather().searchCountryModel(value);
    _controller.add(updateList); // Add data to the stream
  }

  @override
  void dispose() {
    _controller.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.green,
      contentPadding: const EdgeInsets.only(left: 16, right: 16, top: 15),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              onChanged: (value) {
                liveList(value.isEmpty ? "n" : value);
              },
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  onPressed: () {
                    _searchController.clear();
                    liveList("n");
                  },
                  icon: const Icon(Icons.close, size: 18),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                String data = await getLocation();
                if (data.isNotEmpty) {
                  Navigator.of(context).pop(data);
                  print(data);
                }
              },
              child: const ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: Icon(Icons.location_on_outlined, color: Colors.green),
                title: Text("Get Current Location"),
              ),
            ),
            Flexible(
              child: StreamBuilder<List<SearchCountryModel>>(
                stream: _controller.stream,
                initialData: const [],
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final list = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: () {
                            // print(list[index].region);
                            // print(WeatherCubit.get(context).region);
                            Navigator.of(context).pop(list[index].region);
                          },
                          leading: const Icon(Icons.search),
                          title: Text(
                            list[index].region,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            "${list[index].city}, ${list[index].country}",
                            style: const TextStyle(color: Colors.grey),
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
