import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(const RibetvApp());

class RibetvApp extends StatelessWidget {
  const RibetvApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Ribetv',
    theme: ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF101418),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF20C9B9), brightness: Brightness.dark),
    ),
    home: const HomePage(),
  );
}

class TvChannel {
  final String name, url;
  const TvChannel(this.name, this.url);
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const channels = [
    TvChannel('Telefuturo', 'https://www.telefuturo.com.py/envivo'),
    TvChannel('SNT', 'https://www.snt.com.py/envivo/'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('RIBETV PARAGUAY', style: TextStyle(color: Color(0xFF20C9B9), fontWeight: FontWeight.bold))),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF087F79), Color(0xFF172C39)]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text('TELEVISIÓN PARAGUAYA\nReproducción dentro de Ribetv', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
      ),
      const SizedBox(height: 24),
      const Text('🇵🇾 CANALES NACIONALES', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF20C9B9))),
      const SizedBox(height: 12),
      ...channels.map((c) => Card(
        color: const Color(0xFF202930),
        child: ListTile(
          leading: const CircleAvatar(backgroundColor: Color(0xFF087F79), child: Icon(Icons.live_tv, color: Colors.white)),
          title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text('Página oficial • señal en vivo si está disponible'),
          trailing: const Icon(Icons.play_circle_fill, color: Color(0xFF20C9B9), size: 32),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerPage(channel: c))),
        ),
      )),
      const SizedBox(height: 12),
      const Text('La reproducción depende de que cada emisora permita ver su señal desde aplicaciones externas. Ribetv no aloja ni retransmite señales.', style: TextStyle(color: Colors.white60, fontSize: 12)),
    ]),
  );
}

class PlayerPage extends StatefulWidget {
  final TvChannel channel;
  const PlayerPage({super.key, required this.channel});
  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late final WebViewController controller;
  bool loading = true;
  String? error;
  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) { if (mounted) setState(() { loading = true; error = null; }); },
        onPageFinished: (_) { if (mounted) setState(() => loading = false); },
        onWebResourceError: (e) {
          if (mounted && e.isForMainFrame == true) setState(() {
            loading = false;
            error = 'No se pudo cargar la señal. El canal puede limitar la reproducción integrada.';
          });
        },
      ))
      ..loadRequest(Uri.parse(widget.channel.url));
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.channel.name)),
    body: Stack(children: [
      WebViewWidget(controller: controller),
      if (loading) const Align(alignment: Alignment.topCenter, child: LinearProgressIndicator()),
      if (error != null) Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(error!, textAlign: TextAlign.center))),
    ]),
  );
}
