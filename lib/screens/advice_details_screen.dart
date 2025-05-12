import 'package:flutter/material.dart';

class AdviceDetailScreen extends StatelessWidget {
  final String title;
  final String image;
  final String advice;
  final bool isDarkMode;

  const AdviceDetailScreen({
    Key? key,
    required this.title,
    required this.image,
    required this.advice,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final bgImage = isDarkMode
        ? 'assets/images/darkTheme.png'
        : 'assets/images/lightTheme.png';

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              bgImage,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.15),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: IconThemeData(color: textColor),
                  title: Text(title, style: TextStyle(color: textColor)),
                  centerTitle: true,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              image,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          advice,
                          style: TextStyle(fontSize: 16, color: textColor),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
