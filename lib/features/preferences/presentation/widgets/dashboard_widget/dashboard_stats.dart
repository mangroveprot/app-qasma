import 'package:flutter/material.dart';

class DashboardStats extends StatelessWidget {
  const DashboardStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.7, // Increased from 1.6 to give more height
      children: [
        buildStatCard(
          icon: Icons.people,
          iconColor: const Color(0xFF3B82F6), // Blue
          title: 'Total Patients',
          value: '245',
          backgroundColor: Colors.white,
          onTap: () => _handleStatCardTap('Total Patients'),
        ),
        buildStatCard(
          icon: Icons.person_add,
          iconColor: const Color(0xFF10B981), // Green
          title: 'New Patients',
          value: '42',
          backgroundColor: Colors.white,
          onTap: () => _handleStatCardTap('New Patients'),
        ),
        buildStatCard(
          icon: Icons.calendar_today,
          iconColor: const Color(0xFF8B5CF6), // Purple
          title: "Today's Appointments",
          value: '8',
          backgroundColor: Colors.white,
          onTap: () => _handleStatCardTap('Today\'s Appointments'),
        ),
        buildStatCard(
          icon: Icons.notifications,
          iconColor: const Color(0xFFF59E0B), // Orange
          title: 'Notifications',
          value: '5',
          backgroundColor: Colors.white,
          onTap: () => _handleStatCardTap('Notifications'),
        ),
      ],
    );
  }

  void _handleStatCardTap(String cardType) {
    // Handle different card taps here
    print('Tapped on: $cardType');
    // You can navigate to different screens or show dialogs based on cardType
    // Example:
    // switch (cardType) {
    //   case 'Total Patients':
    //     Navigator.pushNamed(context, '/patients');
    //     break;
    //   case 'New Patients':
    //     Navigator.pushNamed(context, '/new-patients');
    //     break;
    //   case 'Today\'s Appointments':
    //     Navigator.pushNamed(context, '/appointments');
    //     break;
    //   case 'Notifications':
    //     Navigator.pushNamed(context, '/notifications');
    //     break;
    // }
  }

  Widget buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10), // Reduced from 12 to 10
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6), // Reduced from 8 to 6
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 16, // Reduced from 18 to 16
              ),
            ),
            const SizedBox(height: 6), // Reduced from 8 to 6
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 10, // Reduced from 11 to 10
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                        height: 1.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 2), // Reduced from 4 to 2
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20, // Reduced from 22 to 20
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
