import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/profile/profile_header.dart';
import '../../widgets/profile/profile_activity_summary.dart';
import '../../widgets/profile/profile_menu_section.dart';
import '../chat/chat_list_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const ProfileHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  if (!authProvider.isLoggedIn) {
                    return _buildGuestContent();
                  }
                  
                  return _buildUserContent(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuestContent() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.lock_outline,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            '로그인 후 이용 가능한 서비스',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '요청 관리, 활동 내역, 설정 등을\n확인하려면 로그인이 필요합니다',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserContent(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final unreadCount = chatProvider.totalUnreadCount;
        
        return Column(
          children: [
            const SizedBox(height: 20),
            const ProfileActivitySummary(),
            const SizedBox(height: 24),
            ProfileMenuSection(
              title: '내 활동',
              items: [
                ProfileMenuItem(
                  title: '내 요청',
                  subtitle: '등록한 요청을 확인하세요',
                  icon: Icons.assignment_outlined,
                  iconColor: AppColors.primary,
                  badge: '3',
                  onTap: () => _navigateToMyRequests(context),
                ),
                ProfileMenuItem(
                  title: '내 제안',
                  subtitle: '보낸 제안과 상태를 확인하세요',
                  icon: Icons.handshake_outlined,
                  iconColor: AppColors.success,
                  onTap: () => _navigateToMyOffers(context),
                ),
                ProfileMenuItem(
                  title: '채팅',
                  subtitle: '진행중인 대화를 확인하세요',
                  icon: Icons.chat_outlined,
                  iconColor: AppColors.warning,
                  badge: unreadCount > 0 ? '$unreadCount' : null,
                  onTap: () => _navigateToChats(context),
                ),
              ],
            ),
        const SizedBox(height: 24),
        ProfileMenuSection(
          title: '설정',
          items: [
            ProfileMenuItem(
              title: '알림 설정',
              subtitle: '푸시 알림을 관리하세요',
              icon: Icons.notifications_outlined,
              iconColor: AppColors.primary,
              onTap: () => _showNotificationSettings(context),
            ),
            ProfileMenuItem(
              title: '개인정보 처리방침',
              icon: Icons.privacy_tip_outlined,
              iconColor: AppColors.textSecondary,
              onTap: () => _showPrivacyPolicy(context),
            ),
            ProfileMenuItem(
              title: '서비스 이용약관',
              icon: Icons.description_outlined,
              iconColor: AppColors.textSecondary,
              onTap: () => _showTermsOfService(context),
            ),
            ProfileMenuItem(
              title: '고객센터',
              icon: Icons.support_agent_outlined,
              iconColor: AppColors.success,
              onTap: () => _showCustomerService(context),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ProfileMenuSection(
          title: '계정',
          items: [
            ProfileMenuItem(
              title: '로그아웃',
              icon: Icons.logout_outlined,
              iconColor: AppColors.error,
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        ),
            const SizedBox(height: 40),
          ],
        );
      },
    );
  }

  void _navigateToMyRequests(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('내 요청 화면 - 구현 예정')),
    );
  }

  void _navigateToMyOffers(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('내 제안 화면 - 구현 예정')),
    );
  }

  void _navigateToChats(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatListScreen(),
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('알림 설정 - 구현 예정')),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('개인정보 처리방침 - 구현 예정')),
    );
  }

  void _showTermsOfService(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('서비스 이용약관 - 구현 예정')),
    );
  }

  void _showCustomerService(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('고객센터 - 구현 예정')),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pop(context);
            },
            child: Text(
              '로그아웃',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}