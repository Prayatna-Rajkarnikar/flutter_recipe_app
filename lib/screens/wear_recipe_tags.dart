import 'package:flutter/material.dart';
import 'package:recipe_app/service/api_service.dart';
import 'package:watch_connectivity/watch_connectivity.dart';
import 'package:wear_plus/wear_plus.dart';

class WearRecipeTags extends StatefulWidget {
  const WearRecipeTags({super.key});

  @override
  State<WearRecipeTags> createState() => _WearRecipeTagsState();
}

class _WearRecipeTagsState extends State<WearRecipeTags> {
  late Future<List<String>> _recipeTags;
  late WatchConnectivity _watchConnectivity;

  @override
  void initState() {
    super.initState();
    _recipeTags = ApiService().fetchRecipeTags();
    _watchConnectivity = WatchConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return AmbientMode(
      builder:
          (context, mode, child) => Scaffold(
            body: Center(
              child: FutureBuilder<List<String>>(
                future: _recipeTags,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text("Failed to load tags");
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text("No tags available");
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      String tag = snapshot.data![index];
                      return ListTile(
                        title: Text(tag),
                        onTap: () async {
                          await _sendTagToMobileApp(tag);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
    );
  }

  Future<void> _sendTagToMobileApp(String tag) async {
    if (await _watchConnectivity.isSupported) {
      // Check if the mobile app is reachable
      if (await _watchConnectivity.isReachable) {
        await _watchConnectivity.sendMessage({'selectedTag': tag});
        print("Tag sent: $tag");
      } else {
        print("Mobile app is not reachable.");
      }
    } else {
      print("Watch connectivity is not supported.");
    }
  }
}
