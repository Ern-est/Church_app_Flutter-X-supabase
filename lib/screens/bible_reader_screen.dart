import 'package:flutter/material.dart';

class BibleReaderScreen extends StatefulWidget {
  final List<dynamic> bibleData;

  const BibleReaderScreen({super.key, required this.bibleData});

  @override
  State<BibleReaderScreen> createState() => _BibleReaderScreenState();
}

class _BibleReaderScreenState extends State<BibleReaderScreen> {
  int selectedBookIndex = 0;
  int selectedChapterIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentBook = widget.bibleData[selectedBookIndex];
    final bookName = currentBook['name'];
    final chapters = currentBook['chapters'];
    final currentChapter = chapters[selectedChapterIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('$bookName ${selectedChapterIndex + 1}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.book),
            tooltip: "Select Book",
            onPressed: () => _showBookPicker(context),
          ),
          IconButton(
            icon: const Icon(Icons.menu_book),
            tooltip: "Select Chapter",
            onPressed: () => _showChapterPicker(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: currentChapter.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${index + 1}. ${currentChapter[index]}'),
                );
              },
            ),
          ),
          Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed:
                      selectedChapterIndex > 0
                          ? () => setState(() => selectedChapterIndex--)
                          : null,
                  icon: const Icon(Icons.chevron_left),
                  label: const Text('Previous'),
                ),
                ElevatedButton.icon(
                  onPressed:
                      selectedChapterIndex < chapters.length - 1
                          ? () => setState(() => selectedChapterIndex++)
                          : null,
                  icon: const Icon(Icons.chevron_right),
                  label: const Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBookPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView.builder(
          itemCount: widget.bibleData.length,
          itemBuilder: (context, index) {
            final book = widget.bibleData[index];
            return ListTile(
              title: Text(book['name']),
              onTap: () {
                setState(() {
                  selectedBookIndex = index;
                  selectedChapterIndex = 0;
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _showChapterPicker(BuildContext context) {
    final chapters = widget.bibleData[selectedBookIndex]['chapters'];
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView.builder(
          itemCount: chapters.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Chapter ${index + 1}'),
              onTap: () {
                setState(() {
                  selectedChapterIndex = index;
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }
}
