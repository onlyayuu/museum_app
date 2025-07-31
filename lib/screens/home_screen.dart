import 'package:flutter/material.dart';
import '../models/artwork.dart';
import '../services/api_service.dart';
import '../widgets/artwork_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Artwork>> artworksFuture;
  List<Artwork> allArtworks = [];
  List<Artwork> filteredArtworks = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    artworksFuture = ApiService.fetchArtworks();
    artworksFuture.then((data) {
      setState(() {
        allArtworks = data;
        filteredArtworks = data;
      });
    });
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredArtworks = allArtworks.where((artwork) {
        return artwork.title.toLowerCase().contains(searchQuery) ||
            artwork.artist.toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Museum Artworks')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: updateSearch,
              decoration: InputDecoration(
                hintText: 'Search artworks...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Artwork>>(
              future: artworksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (filteredArtworks.isEmpty) {
                  return const Center(child: Text('No artworks found.'));
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                    itemCount: filteredArtworks.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 250,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 3 / 4,
                    ),
                    itemBuilder: (context, index) => ArtworkCard(
                      artwork: filteredArtworks[index],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
