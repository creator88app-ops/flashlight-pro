import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

void main() {
  runApp(const FlashLightProApp());
}

class FlashLightProApp extends StatelessWidget {
  const FlashLightProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlashLight Pro',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0F14),
      ),
      home: const FlashLightHome(),
    );
  }
}

class FlashLightHome extends StatefulWidget {
  const FlashLightHome({super.key});

  @override
  State<FlashLightHome> createState() => _FlashLightHomeState();
}

class _FlashLightHomeState extends State<FlashLightHome> {
  bool _isOn = false;
  double _intensity = 1.0;
  bool _intensitySupported = true;

  Future<void> _toggleFlash() async {
    try {
      if (_isOn) {
        await TorchLight.disableTorch();
      } else {
        await TorchLight.enableTorch();
      }
      setState(() => _isOn = !_isOn);
    } on Exception {
      setState(() => _intensitySupported = false);
    }
  }

  Future<void> _setIntensity(double value) async {
    setState(() => _intensity = value);
    try {
      await TorchLight.enableTorch();
    } catch (_) {
      setState(() => _intensitySupported = false);
    }
  }

  @override
  void dispose() {
    TorchLight.disableTorch();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: _toggleFlash,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isOn
                          ? Colors.yellow.withOpacity(0.9)
                          : Colors.grey.shade800,
                      boxShadow: [
                        if (_isOn)
                          BoxShadow(
                            color: Colors.yellow.withOpacity(0.7),
                            blurRadius: 60,
                            spreadRadius: 20,
                          ),
                      ],
                    ),
                    child: Icon(
                      Icons.power_settings_new,
                      size: 100,
                      color: _isOn ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            if (_intensitySupported)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Text(
                      "Intensity",
                      style: TextStyle(color: Colors.white70),
                    ),
                    Slider(
                      value: _intensity,
                      min: 0.1,
                      max: 1.0,
                      onChanged: _isOn ? _setIntensity : null,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: IconButton(
                iconSize: 40,
                color: Colors.white70,
                icon: const Icon(Icons.flashlight_on),
                onPressed: _toggleFlash,
              ),
            )
          ],
        ),
      ),
    );
  }
}
