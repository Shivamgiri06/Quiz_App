import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset("assets/images/background.jpg",
              fit: BoxFit.cover),
          ),
          Center(
            child: Image.asset("assets/images/logo.png"),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Center(
                child: InkWell(
                  onTap: () {
                        Navigator.pushNamed(context, "/Home");
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 120),
                    width: MediaQuery.of(context).size.width/1.8,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent.shade400,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        "Start Playing",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
