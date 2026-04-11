import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/camera_bloc.dart';
import '../bloc/camera_event.dart';
import '../bloc/camera_state.dart';
import '../widgets/recognition_box.dart';
import 'package:camera/camera.dart';

class PantryDashboardPage extends StatelessWidget {
  const PantryDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Camera Layer (The HUD)
          const CameraHUD(),

          // 2. Minimalist Dashboard Overlay (Draggable Scrollable Sheet)
          const PantryListSheet(),
          
          // 3. Top Action Bar
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PANTRY PLANNER',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Trigger Gemini Nano Recipe Generation
        },
        backgroundColor: Colors.greenAccent,
        label: const Text('WASTE-FREE MEAL', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.auto_awesome, color: Colors.black),
      ),
    );
  }
}

class CameraHUD extends StatelessWidget {
  const CameraHUD({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraBloc, CameraState>(
      builder: (context, state) {
        if (state is CameraReady || state is CameraScanning) {
          final controller = (state is CameraReady) 
              ? state.controller 
              : (state as CameraScanning).controller;
          
          final recognitions = (state is CameraScanning) ? state.recognitions : [];
          final previewSize = controller.value.previewSize;

          return Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(controller),
              // Bounding Boxes Overlay - only show if previewSize is available
              if (previewSize != null)
                ...recognitions.map((rec) => RecognitionBox(
                      recognition: rec,
                      previewSize: previewSize,
                      screenSize: MediaQuery.of(context).size,
                    )),
              // Scanning Indicator
              if (state is CameraScanning)
                const Positioned(
                  bottom: 150,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.greenAccent),
                  ),
                ),
            ],
          );
        }
        
        if (state is CameraFailure) {
          return Center(child: Text(state.message));
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class PantryListSheet extends StatelessWidget {
  const PantryListSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.15,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 2),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'MY INVENTORY',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      '3 items expiring soon',
                      style: TextStyle(color: Colors.red[400], fontSize: 12),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: 5, // Placeholder
                  itemBuilder: (context, index) {
                    return const PantryItemTile();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PantryItemTile extends StatelessWidget {
  const PantryItemTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.apple, color: Colors.red),
      ),
      title: const Text('Red Apples', style: TextStyle(fontWeight: FontWeight.w600)),
      subtitle: const Text('Expires in 2 days'),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red[400],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'CRITICAL',
          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
