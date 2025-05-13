import 'package:flutter/material.dart';
import 'advice_details_screen.dart';
import 'package:provider/provider.dart';
import '../models/main_weather_model.dart';

class AdviceScreen extends StatelessWidget {
  final bool isDarkMode;

  const AdviceScreen({
    Key? key,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    final List<Map<String, dynamic>> allAdviceCards = [
      {
        'title': 'Защита от солнца',
        'image': 'assets/images/sun_protection.png',
        'advice': 'Используйте солнцезащитный крем и носите очки.',
        'weatherType': ['Ясно'],
      },
      {
        'title': 'Головной убор обязателен',
        'image': 'assets/images/hat.png',
        'advice': 'Чтобы избежать перегрева, надевайте шляпу или кепку.',
        'weatherType': ['Ясно'],
      },
      {
        'title': 'Ограничьте пребывание на солнце',
        'image': 'assets/images/shadow.jpg',
        'advice': 'Находясь на улице, ищите тень в полдень.',
        'weatherType': ['Ясно'],
      },
      {
        'title': 'Пейте больше воды',
        'image': 'assets/images/water.jpg',
        'advice': 'Солнечная погода требует поддержания водного баланса.',
        'weatherType': ['Ясно'],
      },

      {
        'title': 'Зонт всегда с собой',
        'image': 'assets/images/umbrella.png',
        'advice': 'Всегда держите зонт под рукой в дождливые дни.',
        'weatherType': ['Дождь', 'Ливень', 'Гроза'],
      },
      {
        'title': 'Непромокаемая обувь',
        'image': 'assets/images/rain_boots.png',
        'advice': 'Сохраняйте ноги в сухости - надевайте резиновые сапоги.',
        'weatherType': ['Дождь', 'Ливень'],
      },
      {
        'title': 'Ограничьте поездки',
        'image': 'assets/images/traffic_rain.png',
        'advice': 'Дождь снижает видимость - по возможности оставайтесь дома.',
        'weatherType': ['Дождь', 'Ливень', 'Гроза'],
      },
      {
        'title': 'Следите за скользкими поверхностями',
        'image': 'assets/images/slippery.png',
        'advice': 'Будьте осторожны на лестницах и тротуарах.',
        'weatherType': ['Дождь', 'Ливень', 'Снег'],
      },

      {
        'title': 'Теплая куртка - необходимость',
        'image': 'assets/images/wind_jacket.png',
        'advice': 'Ветер усиливает холод - одевайтесь по погоде.',
        'weatherType': ['Переменная облачность'],
      },
      {
        'title': 'Берегите глаза',
        'image': 'assets/images/wind_eyes.png',
        'advice': 'Используйте очки при сильном ветре.',
        'weatherType': ['Переменная облачность'],
      },
      {
        'title': 'Ограничьте открытые зоны тела',
        'image': 'assets/images/scarf.png',
        'advice': 'Закрывайте шею и руки от холодного ветра.',
        'weatherType': ['Переменная облачность'],
      },
      {
        'title': 'Осторожно с предметами на улице',
        'image': 'assets/images/flying_objects.jpg',
        'advice': 'Сильный ветер может повалить деревья и предметы.',
        'weatherType': ['Переменная облачность', 'Гроза'],
      },

      {
        'title': 'Многослойная одежда',
        'image': 'assets/images/layers.jpg',
        'advice': 'Носите термобелье, свитер и куртку.',
        'weatherType': ['Снег'],
      },
      {
        'title': 'Не выходите надолго',
        'image': 'assets/images/house_cold.jpg',
        'advice': 'Ограничьте пребывание на улице при сильном морозе.',
        'weatherType': ['Снег'],
      },
      {
        'title': 'Утепляйте конечности',
        'image': 'assets/images/gloves.jpg',
        'advice': 'Носите перчатки и тёплую обувь.',
        'weatherType': ['Снег'],
      },
      {
        'title': 'Будьте внимательны на льду',
        'image': 'assets/images/ice_warning.jpg',
        'advice': 'Осторожно передвигайтесь по скользким поверхностям.',
        'weatherType': ['Снег', 'Дождь'],
      },

      {
        'title': 'Ограничьте время на улице',
        'image': 'assets/images/fog_warning.jpg',
        'advice': 'В туман и при аллергии лучше оставаться в помещении.',
        'weatherType': ['Туман'],
      },
      {
        'title': 'Носите маску',
        'image': 'assets/images/mask.jpg',
        'advice': 'Маска поможет при пыльце и загрязнении воздуха.',
        'weatherType': ['Туман'],
      },
      {
        'title': 'Закрывайте окна',
        'image': 'assets/images/window.jpg',
        'advice': 'Держите окна закрытыми, чтобы избежать пыльцы.',
        'weatherType': ['Туман'],
      },
      {
        'title': 'Проветривайте с умом',
        'image': 'assets/images/air_purifier.jpg',
        'advice': 'Используйте очистители воздуха или проветривайте ранним утром.',
        'weatherType': ['Туман'],
      },
    ];

    final filteredAdviceCards = allAdviceCards
        .where((card) => (card['weatherType'] as List<String>).contains(
        Provider.of<MainWeatherModel>(context, listen: false).weatherDesc))
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
