import 'package:flutter/material.dart';

class StationDetailScreen extends StatelessWidget {
  final String stationId;
  
  const StationDetailScreen({super.key, required this.stationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Station Details')),
      body: const Center(child: Text('Station Detail Screen')),
    );
  }
}
