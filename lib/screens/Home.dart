import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/services.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool artliterature = true, geography = false, general = false, music = false, language = false, answernow = false;

  String? question, answer;

  List<String> option = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadQuiz("artliterature");
  }

  Future<void> loadQuiz(String category) async {
    setState(() {
      isLoading = true;
    });

    await fetchQuiz(category);
    await RestOption();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchQuiz(String category) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.api-ninjas.com/v1/trivia?category=$category'),
        headers: {
          'Content-Type': 'application/json',
          'X-Api-Key': APIKEY,
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        if (jsonData.isNotEmpty) {
          Map<String, dynamic> quiz = jsonData[0];
          question = quiz["question"];
          answer = quiz["answer"];
        }
      }
    } catch (e) {
      debugPrint("Error fetching quiz: $e");
    }
  }

  Future<void> RestOption() async {
    option.clear();

    while (option.length < 3) {
      try {
        final response = await http.get(
          Uri.parse('https://api.api-ninjas.com/v1/randomword'),
          headers: {
            'Content-Type': 'application/json',
            'X-Api-Key': APIKEY,
          },
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> jsonData = jsonDecode(response.body);
          if (jsonData.isNotEmpty) {
            String word = jsonData["word"].toString();
            word = word.replaceAll(RegExp(r'\[|\]'), '').trim();
            if (!option.contains(word)) {
              option.add(word);
            }
          }
        }
      } catch (e) {
        debugPrint("Error fetching random word: $e");
      }
    }


    if (answer != null) {
      String sanitizedAnswer = answer!.replaceAll(RegExp(r'\[|\]'), '').trim();
      option.add(sanitizedAnswer);
    }

    option.shuffle(Random());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset("assets/images/background.jpg", fit: BoxFit.cover),
          ),
          Container(
            margin: const EdgeInsets.only(top: 90, left: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      buildCategoryButton("Artliterature", artliterature, () {
                        switchCategory("artliterature");
                      }),
                      buildCategoryButton("Geography", geography, () {
                        switchCategory("geography");
                      }),
                      buildCategoryButton("General", general, () {
                        switchCategory("general");
                      }),
                      buildCategoryButton("Music", music, () {
                        switchCategory("music");
                      }),
                      buildCategoryButton("Language", language, () {
                        switchCategory("language");
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 90),
                buildQuizContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryButton(String title, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 20.0),
        width: 140,
        decoration: BoxDecoration(
          color: isActive ? Colors.purple.shade700 : Colors.purpleAccent.shade200,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void switchCategory(String category) async {
    setState(() {
      artliterature = category == "artliterature";
      geography = category == "geography";
      general = category == "general";
      music = category == "music";
      language = category == "language";
      answernow = false; // Reset answer state
    });
    await loadQuiz(category);
  }

  Widget buildQuizContent() {
    return question == null
        ? const Center(child: CircularProgressIndicator())
        : Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              question!,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 40),
          for (int i = 0; i < option.length; i++) buildOption(option[i]),
        ],
      ),
    );
  }

  Widget buildOption(String opt) {
    return GestureDetector(
      onTap: () {
        answernow = true;
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(
            color: answernow
                ? (answer == opt ? Colors.green : Colors.red.shade700)
                : Colors.black45,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            opt,
            style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
