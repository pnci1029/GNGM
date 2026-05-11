import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../providers/offer_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/request.dart';
import '../../models/offer.dart';

class OfferManagement extends StatelessWidget {
  final Request request;
  final Function(String) onAcceptOffer;
  final Function(String) onRejectOffer;

  const OfferManagement({
    super.key,
    required this.request,
    required this.onAcceptOffer,
    required this.onRejectOffer,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<OfferProvider, AuthProvider>(
      builder: (context, offerProvider, authProvider, child) {
        final currentUserId = authProvider.user?.id;
        final isOwner = request.user.id == currentUserId;
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.local_offer_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '제안 현황',
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${offerProvider.offers.length}개',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              if (offerProvider.isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (offerProvider.offers.isEmpty)
                _buildEmptyState()
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: offerProvider.offers.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final offer = offerProvider.offers[index];
                    return _buildOfferCard(offer, isOwner);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 32,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              '아직 제안이 없습니다',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferCard(Offer offer, bool isOwner) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getOfferBackgroundColor(offer.status),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getOfferBorderColor(offer.status),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryLight,
                child: Icon(
                  Icons.person,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          offer.provider.name,
                          style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getStatusColor(offer.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getStatusText(offer.status),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 12,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '4.8 (12건)',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (offer.offeredFee != null)
                Text(
                  '${offer.offeredFee!.toStringAsFixed(0)}원',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          if (offer.message != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                offer.message!,
                style: AppTextStyles.caption.copyWith(
                  height: 1.4,
                ),
              ),
            ),
          ],
          if (isOwner && offer.status == 'pending') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onRejectOffer(offer.id),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.error),
                      minimumSize: const Size(0, 36),
                    ),
                    child: Text(
                      '거절',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => onAcceptOffer(offer.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(0, 36),
                    ),
                    child: Text(
                      '승인',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getOfferBackgroundColor(String status) {
    switch (status) {
      case 'accepted':
        return AppColors.success.withOpacity(0.1);
      case 'rejected':
        return AppColors.error.withOpacity(0.1);
      default:
        return AppColors.white;
    }
  }

  Color _getOfferBorderColor(String status) {
    switch (status) {
      case 'accepted':
        return AppColors.success.withOpacity(0.3);
      case 'rejected':
        return AppColors.error.withOpacity(0.3);
      default:
        return AppColors.border;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.warning;
      case 'accepted':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return '대기중';
      case 'accepted':
        return '승인됨';
      case 'rejected':
        return '거절됨';
      default:
        return '알 수 없음';
    }
  }
}