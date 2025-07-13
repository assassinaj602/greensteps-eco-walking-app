import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/auth_provider.dart';
import '../providers/app_provider.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2<AuthProvider, AppProvider>(
        builder: (context, authProvider, appProvider, child) {
          final user = authProvider.appUser;

          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              // Profile Header
              SliverAppBar(
                expandedHeight: 250,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: const Color(0xFF4CAF50),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),

                          // Profile Picture
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child:
                                  user.photoUrl != null
                                      ? Image.network(
                                        user.photoUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.person,
                                                  size: 50,
                                                  color: Color(0xFF4CAF50),
                                                ),
                                      )
                                      : const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Color(0xFF4CAF50),
                                      ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Name
                          Text(
                            user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // Email
                          Text(
                            user.email,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Member since
                          Text(
                            'Eco Walker since ${_formatDate(user.createdAt)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Eco Impact Summary
                      _buildEcoImpact(user),

                      const SizedBox(height: 24),

                      // Achievement Level
                      _buildAchievementLevel(user),

                      const SizedBox(height: 24),

                      // Recent Activities
                      _buildRecentActivities(),

                      const SizedBox(height: 24),

                      // Profile Settings
                      _buildProfileSettings(context, authProvider),

                      const SizedBox(
                        height: 100,
                      ), // Bottom padding for navigation
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEcoImpact(AppUser user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF81C784), Color(0xFF66BB6A)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(FontAwesomeIcons.leaf, color: Colors.white, size: 24),
              SizedBox(width: 12),
              Text(
                'Your Eco Impact',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildImpactItem(
                  icon: FontAwesomeIcons.route,
                  title: 'Distance Walked',
                  value: '${user.totalDistance.toStringAsFixed(1)} km',
                ),
              ),
              Expanded(
                child: _buildImpactItem(
                  icon: FontAwesomeIcons.seedling,
                  title: 'CO₂ Saved',
                  value: '${(user.totalDistance * 0.2).toStringAsFixed(1)} kg',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildImpactItem(
                  icon: FontAwesomeIcons.fire,
                  title: 'Calories Burned',
                  value: '${(user.totalDistance * 60).round()}',
                ),
              ),
              Expanded(
                child: _buildImpactItem(
                  icon: FontAwesomeIcons.tree,
                  title: 'Trees Equivalent',
                  value: '${(user.totalDistance * 0.01).toStringAsFixed(1)}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImpactItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAchievementLevel(AppUser user) {
    final level = _calculateLevel(user.ecoPoints);
    final currentLevelPoints = _getLevelThreshold(level);
    final nextLevelPoints = _getLevelThreshold(level + 1);
    final progress =
        (user.ecoPoints - currentLevelPoints) /
        (nextLevelPoints - currentLevelPoints);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber[400]!, Colors.amber[600]!],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  FontAwesomeIcons.trophy,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level $level - ${_getLevelName(level)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E2E2E),
                      ),
                    ),
                    Text(
                      '${user.ecoPoints} / $nextLevelPoints points',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber[600]!),
          ),

          const SizedBox(height: 8),

          Text(
            '${nextLevelPoints - user.ecoPoints} points to next level',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities() {
    // Mock recent activities
    final activities = [
      {
        'title': 'Completed eco route',
        'description': '2.5 km walk to Central Park',
        'points': '+25 points',
        'time': '2 hours ago',
        'icon': FontAwesomeIcons.route,
        'color': Colors.green,
      },
      {
        'title': 'Daily goal achieved',
        'description': 'Green Walker challenge',
        'points': '+20 points',
        'time': 'Yesterday',
        'icon': FontAwesomeIcons.flag,
        'color': Colors.orange,
      },
      {
        'title': 'New badge earned',
        'description': 'Eco Warrior milestone',
        'points': 'Badge',
        'time': '3 days ago',
        'icon': FontAwesomeIcons.award,
        'color': Colors.purple,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
          ),

          const SizedBox(height: 16),

          ...activities
              .map(
                (activity) => _buildActivityItem(
                  title: activity['title'] as String,
                  description: activity['description'] as String,
                  points: activity['points'] as String,
                  time: activity['time'] as String,
                  icon: activity['icon'] as IconData,
                  color: activity['color'] as Color,
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String description,
    required String points,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E2E2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                points,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSettings(
    BuildContext context,
    AuthProvider authProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E2E2E),
            ),
          ),

          const SizedBox(height: 16),

          _buildSettingsItem(
            icon: FontAwesomeIcons.bell,
            title: 'Notifications',
            subtitle: 'Manage your notification preferences',
            onTap: () {
              _showNotificationSettings(context);
            },
          ),

          _buildSettingsItem(
            icon: FontAwesomeIcons.shield,
            title: 'Privacy',
            subtitle: 'Control your privacy settings',
            onTap: () {
              _showPrivacySettings(context);
            },
          ),

          _buildSettingsItem(
            icon: FontAwesomeIcons.questionCircle,
            title: 'Help & Support',
            subtitle: 'Get help and contact support',
            onTap: () {
              _showHelpSupport(context);
            },
          ),

          _buildSettingsItem(
            icon: FontAwesomeIcons.infoCircle,
            title: 'About',
            subtitle: 'App version and information',
            onTap: () {
              _showAbout(context);
            },
          ),

          const SizedBox(height: 8),

          // Sign Out Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed:
                  authProvider.isLoading
                      ? null
                      : () => _signOut(context, authProvider),
              icon:
                  authProvider.isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : const Icon(FontAwesomeIcons.signOut),
              label: Text(
                authProvider.isLoading ? 'Signing Out...' : 'Sign Out',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, color: Colors.grey[600], size: 18),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2E2E2E),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  int _calculateLevel(int points) {
    if (points < 50) return 1;
    if (points < 100) return 2;
    if (points < 250) return 3;
    if (points < 500) return 4;
    if (points < 1000) return 5;
    return 5 + (points ~/ 1000);
  }

  int _getLevelThreshold(int level) {
    switch (level) {
      case 1:
        return 0;
      case 2:
        return 50;
      case 3:
        return 100;
      case 4:
        return 250;
      case 5:
        return 500;
      default:
        return 500 + ((level - 5) * 1000);
    }
  }

  String _getLevelName(int level) {
    switch (level) {
      case 1:
        return 'Green Starter';
      case 2:
        return 'Eco Walker';
      case 3:
        return 'Nature Friend';
      case 4:
        return 'Green Warrior';
      case 5:
        return 'Eco Champion';
      default:
        return 'Eco Legend';
    }
  }

  void _showNotificationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Notification Settings'),
            content: const Text(
              'Notification settings will be available in the next update.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showPrivacySettings(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Privacy Settings'),
            content: const Text(
              'Privacy settings will be available in the next update.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showHelpSupport(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Help & Support'),
            content: const Text(
              'For support, contact us at support@greensteps.com',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('About GreenSteps'),
            content: const Text(
              'GreenSteps v1.0.0\n\nBuilt with Flutter\nMade for eco-friendly walking and biking',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  Future<void> _signOut(BuildContext context, AuthProvider authProvider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sign Out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Sign Out'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await authProvider.signOut();
    }
  }
}
