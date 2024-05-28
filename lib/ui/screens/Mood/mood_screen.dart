import 'package:flutter/material.dart';
import 'package:moodify/ui/screens/mood/moods.dart';
import 'package:moodify/ui/widgets/mood_grid.dart';
import 'package:moodify/data/dummy_data.dart';
import 'package:moodify/models/mood.dart';


class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  void _selectMood(BuildContext context, Mood mood) {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => Moods(mood: mood)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.black87,
      //   title: const Text('Mood'),
      // ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 160),
            const Text('Select Your Mood', style: TextStyle(color: Colors.white54, fontSize: 24)),
            const SizedBox(height: 20),
            Expanded(
              child: GridView(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.8,
                  crossAxisSpacing: 17,
                  mainAxisSpacing: 20,
                ),
                children: [
                  for (final mood in availableCategories)
                    MoodGrid(
                      mood: mood,
                      onSelectCategory: () => _selectMood(context, mood),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
