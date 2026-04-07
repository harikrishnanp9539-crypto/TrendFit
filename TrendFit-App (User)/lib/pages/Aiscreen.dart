import 'package:flutter/material.dart';
import 'package:trendfitapp/Body%20measurment.dart';
import 'package:trendfitapp/Dress%20recommendation.dart';
import 'package:trendfitapp/DressFit.dart';
import 'package:trendfitapp/pages/dressrecommendation.dart';

import '../Dress combination identification.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Stylist',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF7F9F7),
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selected = '';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // Add bottom safe padding + 20px to avoid overlap
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;
    final extraBottomPadding = 20.0;
    final totalBottomPadding = bottomInset + extraBottomPadding;

    const borderRadius = 16.0;

    TextStyle titleStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Color(0xFF0D1B12),
    );
    TextStyle subtitleStyle = const TextStyle(
      fontSize: 14,
      color: Color(0xFF8F9A92),
      height: 1.3,
    );

    BoxDecoration paleBox = BoxDecoration(
      color: const Color(0xFFC0EAB7),
      borderRadius: BorderRadius.circular(borderRadius),
    );

    Widget bigCard({
      required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap,
      double height = 200,
    }) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          height: 180,
          decoration: paleBox,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 28, color: const Color(0xFF149B0C)),
              ),
              const SizedBox(height: 14),
              Text(title, style: titleStyle, textAlign: TextAlign.center),
              const SizedBox(height: 6),
              Text(subtitle, style: subtitleStyle, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    Widget smallCard({
      required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap,
    }) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          height: 170,
          decoration: paleBox,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 26, color: const Color(0xFF149B0C)),
              ),
              const SizedBox(height: 12),
              Text(title, style: titleStyle, textAlign: TextAlign.center),
              const SizedBox(height: 6),
              Text(subtitle, style: subtitleStyle, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'AI Stylist',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0D1B12),
            ),
          ),
          centerTitle: true,

        ),
        body: SingleChildScrollView(
          // IMPORTANT: include bottom padding = device safe inset + 20px to avoid overlap
          padding: EdgeInsets.fromLTRB(18, 20, 18, totalBottomPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // top title row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                ],
              ),
              const SizedBox(height: 18),
              bigCard(
                icon: Icons.straighten,
                title: 'Measure Size',
                subtitle: 'Get your body measurements',
                height: 160,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AiBodyMeasurementScreen(),));
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: smallCard(
                      icon: Icons.checkroom,
                      title: 'Dress\nCombination',
                      subtitle: 'Outfit suggestions',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>DressCombinations(title: '') ,));
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: smallCard(
                      icon: Icons.handshake,
                      title: 'Dress Fit',
                      subtitle: 'Virtual try-on',
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DressFit(title: ''),));
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              bigCard(
                icon: Icons.diamond,
                title: 'Dress Recommendations',
                subtitle: 'Personalized for you',
                height: 140,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UploadScreen(),));
                },
              ),
              // keep a bit of extra space to visually match screenshot
              SizedBox(height: width * 0.08),
            ],
          ),
        ),
      ),
    );
  }
}
