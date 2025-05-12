import 'package:flutter/material.dart';
import 'advice_details_screen.dart';

class AdviceScreen extends StatelessWidget {
  final bool isDarkMode;

  const AdviceScreen({Key? key, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    final List<Map<String, String>> adviceCards = [
      {
        'title': 'Одежда по погоде',
        'image': 'assets/images/clothing.png',
        'advice': 'Носите теплую одежду в ветреную погоду.'
      },
      {
        'title': 'Укрытие от дождя',
        'image': 'assets/images/darkTheme.png',
        'advice': 'Не забудьте зонт или дождевик.'
      },
      {
        'title': 'Защита от солнца',
        'image': 'assets/images/darkTheme.png',
        'advice': 'Используйте солнцезащитный крем и головной убор.'
      },
      {
        'title': 'Осторожность на дороге',
        'image': 'assets/images/darkTheme.png',
        'advice': 'Во время осадков тормозной путь увеличивается.'
      },
      {
        'title': 'Аллергия и пыльца',
        'image': 'assets/images/darkTheme.png',
        'advice': 'В пиковый сезон держите окна закрытыми.'
      },
      {
        'title': 'Здоровье и климат',
        'image': 'assets/images/darkTheme.png',
        'advice': 'Следите за самочувствием при резких перепадах погоды.'
      },
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              isDarkMode
                  ? 'assets/images/darkTheme.png'
                  : 'assets/images/lightTheme.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Container(
            color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Полезные советы',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: adviceCards.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.5 / 3,
                    ),
                    itemBuilder: (context, index) {
                      final card = adviceCards[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdviceDetailScreen(
                                title: card['title']!,
                                image: card['image']!,
                                advice: card['advice']!,
                                isDarkMode: isDarkMode,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: isDarkMode
                                ? Colors.black.withOpacity(0.4)
                                : Colors.white.withOpacity(0.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: AspectRatio(
                                  aspectRatio: 3 / 2,
                                  child: Image.asset(
                                    card['image']!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6),
                                child: Text(
                                  card['title']!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: textColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  card['advice']!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDarkMode ? Colors.white70 : Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
