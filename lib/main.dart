import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

void main() {
  runApp(const FlashLightPro());
}

class FlashLightPro extends StatelessWidget {
  const FlashLightPro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlashLight Pro',
      theme: ThemeData.dark(),
      home: const FlashHomePage(),
    );
  }
}

class FlashHomePage extends StatefulWidget {
  const FlashHomePage({super.key});

  @override
  State<FlashHomePage> createState() => _FlashHomePageState();
}

class _FlashHomePageState extends State<FlashHomePage> {
  bool isOn = false;
  double intensity = 1.0;

  Future<void> toggleFlash() async {
    try {
      if (isOn) {
        await TorchLight.disableTorch();
      } else {
        await TorchLight.enableTorch();
      }
      setState(() {
        isOn = !isOn;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isOn ? Colors.white : Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 40),

            // Üst başlık
            Text(
              "FlashLight Pro",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isOn ? Colors.black : Colors.white,
              ),
            ),

            // Büyük güç butonu
            GestureDetector(
              onTap: toggleFlash,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOn ? Colors.yellow : Colors.grey[900],
                  boxShadow: [
                    BoxShadow(
                      color: isOn ? Colors.yellowAccent : Colors.black,
                      blurRadius: 40,
                      spreadRadius: 10,
                    )
                  ],
                ),
                child: Icon(
                  Icons.power_settings_new,
                  size: 100,
                  color: isOn ? Colors.black : Colors.white,
                ),
              ),
            ),

            // Işık şiddeti slider (görsel amaçlı)
            Column(
              children: [
                Text(
                  "Light Intensity",
                  style: TextStyle(
                    color: isOn ? Colors.black : Colors.white,
                    fontSize: 18,
                  ),
                ),
                Slider(
                  value: intensity,
                  onChanged: (value) {
                    setState(() {
                      intensity = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
