import 'package:bethsaida_app/screens/bible_reader_screen.dart';
import 'package:bethsaida_app/services/bible_loader.dart';
import 'package:flutter/material.dart';
import '../data/bible_versions.dart';
import '../models/bible_version.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

class BibleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        child: Column(
          children: [
            Text(
              "Choose Bible Version",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: CarouselSlider.builder(
                itemCount: bibleVersions.length,
                slideBuilder: (index) {
                  final version = bibleVersions[index];
                  return GestureDetector(
                    onTap: () async {
                      final bibleData = await loadBibleVersion(version.file);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => BibleReaderScreen(bibleData: bibleData),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pinkAccent.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          version.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.pink,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
                slideTransform: const CubeTransform(),
                scrollDirection: Axis.vertical,
                enableAutoSlider: true,
                /*autoSliderDelay: const Duration(seconds: 3),*/
                viewportFraction: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
