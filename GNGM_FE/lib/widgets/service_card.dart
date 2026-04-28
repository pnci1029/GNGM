import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';

class ServiceCard extends StatelessWidget {
  final String userName;
  final double rating;
  final String title;
  final String location;
  final String time;
  final String price;
  final VoidCallback onTap;
  final VoidCallback onContact;

  const ServiceCard({
    Key? key,
    required this.userName,
    required this.rating,
    required this.title,
    required this.location,
    required this.time,
    required this.price,
    required this.onTap,
    required this.onContact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: GNGMColors.cleanWhite,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: GNGMColors.trustBlue,
                  child: Text(
                    userName[0],
                    style: GNGMTextStyles.bodyLarge.copyWith(
                      color: GNGMColors.cleanWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: GNGMTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: GNGMColors.warmOrange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: GNGMTextStyles.bodySmall.copyWith(
                              color: GNGMColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GNGMTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: GNGMColors.secondaryText,
                ),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: GNGMTextStyles.bodyMedium,
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: GNGMColors.secondaryText,
                ),
                const SizedBox(width: 4),
                Text(
                  time,
                  style: GNGMTextStyles.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '수고비: $price',
                  style: GNGMTextStyles.bodyLarge.copyWith(
                    color: GNGMColors.warmOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: onContact,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GNGMColors.trustBlue,
                    foregroundColor: GNGMColors.cleanWhite,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('연락하기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}