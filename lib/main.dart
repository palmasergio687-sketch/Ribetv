
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const WorldTV());
}

class WorldTV extends StatelessWidget {
  const WorldTV({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WORLD TV PARAGUAY',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF101418),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF20C9B9),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeTV(),
    );
  }
}

class HomeTV extends StatelessWidget {
  const HomeTV({super.key});

  final List<Map<String, String>> channels = const [
    {'name': 'Paraguay', 'category': 'Nacionales', 'url': 'https://www.youtube.com/results?search_query=television+paraguay+en+vivo'},
    {'name': 'Argentina', 'category': 'Nacionales', 'url': 'https://www.youtube.com/results?search_query=canales+argentina+en+vivo'},
    {'name': 'Uruguay', 'category': 'Nacionales', 'url': 'https://www.youtube.com/results?search_query=television+uruguay+en+vivo'},
    {'name': 'Brasil', 'category': 'Nacionales', 'url': 'https://www.youtube.com/results?search_query=television+brasil+ao+vivo'},
    {'name': 'Chile', 'category': 'Nacionales', 'url': 'https://www.youtube.com/results?search_query=television+chile+en+vivo'},
    {'name': 'Deportes Paraguay', 'category': 'Deportes', 'url': 'https://www.youtube.com/results?search_query=deportes+paraguay+en+vivo'},
    {'name': 'Fútbol internacional', 'category': 'Deportes', 'url': 'https://www.youtube.com/results?search_query=futbol+en+vivo+oficial'},
    {'name': 'ESPN', 'category': 'Premium', 'url': 'https://www.espn.com/watch/'},
    {'name': 'Tigo Sports', 'category': 'Premium', 'url': 'https://www.tigosports.com.py/'},
  ];

  Future<void> openChannel(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF101418),
        title: const Text(
          'WORLD TV PARAGUAY',
          style: TextStyle(
            color: Color(0xFF20C9B9),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(12),
            child: Icon(Icons.live_tv, color: Color(0xFF20C9B9)),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF087F79), Color(0xFF172C39)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TELEVISIÓN EN VIVO',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Tus canales favoritos en un solo lugar'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          for (final category in ['Nacionales', 'Deportes', 'Premium']) ...[
            Text(
              category == 'Nacionales'
                  ? '🌎 CANALES POR PAÍS'
                  : category == 'Deportes'
                      ? '⚽ DEPORTES EN VIVO'
                      : '⭐ SERVICIOS PREMIUM',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF20C9B9),
              ),
            ),
            const SizedBox(height: 12),
            ...channels.where((c) => c['category'] == category).map(
              (channel) => Card(
                color: const Color(0xFF202930),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF087F79),
                    child: Icon(Icons.live_tv, color: Colors.white),
                  ),
                  title: Text(
                    channel['name']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    category == 'Premium'
                        ? 'Acceso con tu propia suscripción'
                        : 'Abrir señal o transmisión disponible',
                  ),
                  trailing: const Icon(
                    Icons.play_circle_fill,
                    color: Color(0xFF20C9B9),
                    size: 32,
                  ),
                  onTap: () => openChannel(channel['url']!),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
          const Center(
            child: Text(
              'WORLD TV PARAGUAY • 2026',
              style: TextStyle(color: Colors.white54),
            ),
          ),
        ],
      ),
    );
  }
}
