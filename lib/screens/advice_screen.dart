import 'package:flutter/material.dart';
import 'advice_details_screen.dart';

class AdviceScreen extends StatelessWidget {
  final bool isDarkMode;
  final String weatherType; // добавили параметр

  const AdviceScreen({
    Key? key,
    required this.isDarkMode,
    required this.weatherType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    final List<Map<String, String>> allAdviceCards = [
      {
        'title': 'Защита от солнца',
        'image': 'assets/images/sun_protection.png',
        'advice': 'Используйте солнцезащитный крем и носите очки.',
        'weatherType': 'sunny',
      },
      {
        'title': 'Головной убор обязателен',
        'image': 'assets/images/hat.png',
        'advice': 'Чтобы избежать перегрева, надевайте шляпу или кепку.',
        'weatherType': 'sunny',
      },
      {
        'title': 'Ограничьте пребывание на солнце',
        'image': 'assets/images/shadow.png',
        'advice': 'Находясь на улице, ищите тень в полдень.',
        'weatherType': 'sunny',
      },
      {
        'title': 'Пейте больше воды',
        'image': 'assets/images/water.png',
        'advice': 'Солнечная погода требует поддержания водного баланса.',
        'weatherType': 'sunny',
      },

      {
        'title': 'Зонт всегда с собой',
        'image': 'assets/images/umbrella.png',
        'advice': 'Всегда держите зонт под рукой в дождливые дни.',
        'weatherType': 'rainy',
      },
      {
        'title': 'Непромокаемая обувь',
        'image': 'assets/images/rain_boots.png',
        'advice': 'Сохраняйте ноги в сухости – надевайте резиновые сапоги.',
        'weatherType': 'rainy',
      },
      {
        'title': 'Ограничьте поездки',
        'image': 'assets/images/traffic_rain.png',
        'advice': 'Дождь снижает видимость – по возможности оставайтесь дома.',
        'weatherType': 'rainy',
      },
      {
        'title': 'Следите за скользкими поверхностями',
        'image': 'assets/images/slippery.png',
        'advice': 'Будьте осторожны на лестницах и тротуарах.',
        'weatherType': 'rainy',
      },

      {
        'title': 'Теплая куртка — необходимость',
        'image': 'assets/images/wind_jacket.png',
        'advice': 'Ветер усиливает холод — одевайтесь по погоде.',
        'weatherType': 'windy',
      },
      {
        'title': 'Берегите глаза',
        'image': 'assets/images/wind_eyes.png',
        'advice': 'Используйте очки при сильном ветре.',
        'weatherType': 'windy',
      },
      {
        'title': 'Ограничьте открытые зоны тела',
        'image': 'assets/images/scarf.png',
        'advice': 'Закрывайте шею и руки от холодного ветра.',
        'weatherType': 'windy',
      },
      {
        'title': 'Осторожно с предметами на улице',
        'image': 'assets/images/flying_objects.png',
        'advice': 'Сильный ветер может повалить деревья и предметы.',
        'weatherType': 'windy',
      },

      {
        'title': 'Многослойная одежда',
        'image': 'assets/images/layers.png',
        'advice': 'Носите термобелье, свитер и куртку.',
        'weatherType': 'cold',
      },
      {
        'title': 'Не выходите надолго',
        'image': 'assets/images/house_cold.png',
        'advice': 'Ограничьте пребывание на улице при сильном морозе.',
        'weatherType': 'cold',
      },
      {
        'title': 'Утепляйте конечности',
        'image': 'assets/images/gloves.png',
        'advice': 'Носите перчатки и тёплую обувь.',
        'weatherType': 'cold',
      },
      {
        'title': 'Будьте внимательны на льду',
        'image': 'assets/images/ice_warning.png',
        'advice': 'Осторожно передвигайтесь по скользким поверхностям.',
        'weatherType': 'cold',
      },

      {
        'title': 'Ограничьте время на улице',
        'image': 'assets/images/fog_warning.png',
        'advice': 'В туман и при аллергии лучше оставаться в помещении.',
        'weatherType': 'allergy',
      },
      {
        'title': 'Носите маску',
        'image': 'assets/images/mask.png',
        'advice': 'Маска поможет при пыльце и загрязнении воздуха.',
        'weatherType': 'allergy',
      },
      {
        'title': 'Закрывайте окна',
        'image': 'assets/images/window.png',
        'advice': 'Держите окна закрытыми, чтобы избежать пыльцы.',
        'weatherType': 'allergy',
      },
      {
        'title': 'Проветривайте с умом',
        'image': 'assets/images/air_purifier.png',
        'advice': 'Используйте очистители воздуха или проветривайте ранним утром.',
        'weatherType': 'allergy',
      },
    ];

    final filteredAdviceCards = allAdviceCards
        .where((card) => card['weatherType'] == weatherType)
        .toList();

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
                    itemCount: filteredAdviceCards.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.5 / 3,
                    ),
                    itemBuilder: (context, index) {
                      final card = filteredAdviceCards[index];
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
                                borderRadius:
                                const BorderRadius.vertical(top: Radius.circular(12)),
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
