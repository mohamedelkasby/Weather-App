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
  final FocusNode _searchFocusNode = FocusNode();

  void liveList(String value) async {
    final updateList = await Weather().searchCountryModel(value);
    _controller.add(updateList);
  }

  @override
  void dispose() {
    _controller.close();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 500),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search Header
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: (value) => liveList(value.isEmpty ? "n" : value),
                    autofocus: true,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      hintText: 'Search city or region...',
                      prefixIcon: Icon(Icons.search, color: theme.hintColor),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: theme.hintColor),
                              onPressed: () {
                                _searchController.clear();
                                liveList("n");
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDark
                          ? Colors.grey[800]!.withOpacity(0.4)
                          : Colors.grey[100]!,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Current Location Button
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  try {
                    final data = await getLocation();
                    if (data.isNotEmpty && context.mounted) {
                      Navigator.of(context).pop(data);
                    }
                  } catch (e) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(content: Text('Error getting location: $e')),
                    );
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.my_location, color: theme.primaryColor),
                      const SizedBox(width: 12),
                      Text(
                        "Use Current Location",
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 8),

            // Search Results
            Expanded(
              child: StreamBuilder<List<SearchCountryModel>>(
                stream: _controller.stream,
                initialData: const [],
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading results',
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    );
                  }

                  final results = snapshot.data!;

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = results[index];
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => Navigator.of(context).pop(item.region),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: theme.primaryColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.region,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${item.city}, ${item.country}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: theme.hintColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
