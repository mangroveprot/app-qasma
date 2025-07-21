import 'package:flutter/material.dart';

import '../../../../common/widgets/toast/custom_toast.dart';
import '../../../../common/widgets/toast/toast_enums.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Toast Usage Examples'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Basic Toast Types',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Success Toast
            ElevatedButton.icon(
              onPressed: () {
                CustomToast.success(
                  context: context,
                  message: 'Operation completed successfully!',
                );
              },
              icon: const Icon(Icons.check_circle),
              label: const Text('Show Success Toast'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
            const SizedBox(height: 8),

            // Error Toast
            ElevatedButton.icon(
              onPressed: () {
                CustomToast.error(
                  context: context,
                  message: 'Something went wrong. Please try again.',
                );
              },
              icon: const Icon(Icons.error),
              label: const Text('Show Error Toast'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            const SizedBox(height: 8),

            // Warning Toast
            ElevatedButton.icon(
              onPressed: () {
                CustomToast.warning(
                  context: context,
                  message: 'This action cannot be undone!',
                );
              },
              icon: const Icon(Icons.warning),
              label: const Text('Show Warning Toast'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
            const SizedBox(height: 8),

            // Info Toast
            ElevatedButton.icon(
              onPressed: () {
                CustomToast.info(
                  context: context,
                  message: 'New update available for download.',
                );
              },
              icon: const Icon(Icons.info),
              label: const Text('Show Info Toast'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const Text(
              'Toast Positions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Top Right
            ElevatedButton(
              onPressed: () {
                CustomToast.info(
                  context: context,
                  message: 'Toast at top right',
                  position: ToastPosition.topRight,
                );
              },
              child: const Text('Top Right'),
            ),
            const SizedBox(height: 8),

            // Top Center
            ElevatedButton(
              onPressed: () {
                CustomToast.info(
                  context: context,
                  message: 'Toast at top center',
                  position: ToastPosition.topCenter,
                );
              },
              child: const Text('Top Center'),
            ),
            const SizedBox(height: 8),

            // Center
            ElevatedButton(
              onPressed: () {
                CustomToast.info(
                  context: context,
                  message: 'Toast at center',
                  position: ToastPosition.center,
                );
              },
              child: const Text('Center'),
            ),
            const SizedBox(height: 8),

            // Bottom Center
            ElevatedButton(
              onPressed: () {
                CustomToast.info(
                  context: context,
                  message: 'Toast at bottom center',
                  position: ToastPosition.bottomCenter,
                );
              },
              child: const Text('Bottom Center'),
            ),
            const SizedBox(height: 8),

            // Bottom Right (default)
            ElevatedButton(
              onPressed: () {
                CustomToast.info(
                  context: context,
                  message: 'Toast at bottom right (default)',
                  position: ToastPosition.bottomRight,
                );
              },
              child: const Text('Bottom Right (Default)'),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const Text(
              'Advanced Features',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Custom Duration
            ElevatedButton(
              onPressed: () {
                CustomToast.info(
                  context: context,
                  message: 'This toast stays for 10 seconds',
                  duration: const Duration(seconds: 10),
                );
              },
              child: const Text('Long Duration (10s)'),
            ),
            const SizedBox(height: 8),

            // With Action Button
            ElevatedButton(
              onPressed: () {
                CustomToast.warning(
                  context: context,
                  message: 'File will be deleted permanently',
                  actionLabel: 'UNDO',
                  onAction: () {
                    // Handle undo action
                    CustomToast.success(
                      context: context,
                      message: 'Action undone!',
                    );
                  },
                );
              },
              child: const Text('Toast with Action'),
            ),
            const SizedBox(height: 8),

            // Without Close Button
            ElevatedButton(
              onPressed: () {
                CustomToast.info(
                  context: context,
                  message: 'This toast has no close button',
                  showCloseButton: false,
                );
              },
              child: const Text('No Close Button'),
            ),
            const SizedBox(height: 8),

            // Custom Icon using show() method
            ElevatedButton(
              onPressed: () {
                CustomToast.show(
                  context,
                  message: 'Custom heart icon toast',
                  icon: Icons.favorite,
                  type: ToastType.success,
                );
              },
              child: const Text('Custom Icon'),
            ),
            const SizedBox(height: 8),

            // Multiple Toasts
            ElevatedButton(
              onPressed: () {
                // Show multiple toasts rapidly
                for (int i = 1; i <= 5; i++) {
                  Future.delayed(Duration(milliseconds: i * 200), () {
                    CustomToast.info(
                      context: context,
                      message: 'Toast #$i',
                      duration: const Duration(seconds: 2),
                    );
                  });
                }
              },
              child: const Text('Show Multiple Toasts'),
            ),
            const SizedBox(height: 8),

            // Long Message Toast
            ElevatedButton(
              onPressed: () {
                CustomToast.info(
                  context: context,
                  message:
                      'This is a very long toast message that demonstrates how the toast handles longer text content and wrapping behavior.',
                );
              },
              child: const Text('Long Message'),
            ),

            const SizedBox(height: 24),
            const Divider(),
            const Text(
              'Complete Example',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Complete example with all features
            ElevatedButton.icon(
              onPressed: () {
                CustomToast.show(
                  context,
                  message: 'Download completed successfully!',
                  icon: Icons.download_done,
                  duration: const Duration(seconds: 5),
                  position: ToastPosition.topCenter,
                  type: ToastType.success,
                  actionLabel: 'VIEW',
                  onAction: () {
                    CustomToast.info(
                      context: context,
                      message: 'Opening downloaded file...',
                    );
                  },
                  showCloseButton: true,
                );
              },
              icon: const Icon(Icons.download),
              label: const Text('Complete Example'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            ),

            const SizedBox(height: 32),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Usage:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('// Import the toast'),
                    Text("import 'custom_toast.dart';"),
                    SizedBox(height: 8),
                    Text('// Simple usage'),
                    Text('CustomToast.success('),
                    Text('  context: context,'),
                    Text('  message: "Success!",'),
                    Text(');'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
