import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import '../../widgets/request/request_detail_info.dart';
import '../../widgets/request/offer_management.dart';
import '../../widgets/request/offer_creation_dialog.dart';
import '../../widgets/request/request_detail_actions.dart';
import '../../providers/request_provider.dart';
import '../../providers/offer_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/request.dart';

class RequestDetailScreen extends StatefulWidget {
  final String requestId;

  const RequestDetailScreen({
    super.key,
    required this.requestId,
  });

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadRequestDetail();
  }

  void _loadRequestDetail() {
    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
    final offerProvider = Provider.of<OfferProvider>(context, listen: false);
    
    requestProvider.loadRequestById(widget.requestId);
    offerProvider.loadOffersForRequest(widget.requestId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: Consumer<RequestProvider>(
        builder: (context, requestProvider, child) {
          if (requestProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (requestProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    requestProvider.error!,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadRequestDetail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          if (requestProvider.selectedRequest == null) {
            return const Center(
              child: Text('요청 정보를 찾을 수 없습니다.'),
            );
          }

          return _buildBody(context, requestProvider.selectedRequest!);
        },
      ),
      bottomNavigationBar: Consumer<RequestProvider>(
        builder: (context, requestProvider, child) {
          if (requestProvider.selectedRequest != null) {
            return RequestDetailActions(
              request: requestProvider.selectedRequest!,
              onStartChat: () => _startChat(context),
              onMakeOffer: () => _makeOffer(context, requestProvider.selectedRequest!),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      leading: Container(
        margin: const EdgeInsets.only(left: 8),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.textPrimary,
              size: 16,
            ),
          ),
        ),
      ),
      title: Text(
        '요청 상세',
        style: AppTextStyles.title.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: () => _showOptionsMenu(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.more_vert,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, Request request) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RequestDetailInfo(request: request),
          const SizedBox(height: 24),
          OfferManagement(
            request: request,
            onAcceptOffer: _acceptOffer,
            onRejectOffer: _rejectOffer,
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }











  void _acceptOffer(String offerId) async {
    final offerProvider = Provider.of<OfferProvider>(context, listen: false);
    final requestProvider = Provider.of<RequestProvider>(context, listen: false);
    
    final success = await offerProvider.acceptOffer(
      requestId: widget.requestId,
      offerId: offerId,
    );

    if (success) {
      requestProvider.loadRequestById(widget.requestId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제안을 승인했습니다')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(offerProvider.error ?? '제안 승인에 실패했습니다'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _rejectOffer(String offerId) async {
    final offerProvider = Provider.of<OfferProvider>(context, listen: false);
    
    final success = await offerProvider.rejectOffer(
      requestId: widget.requestId,
      offerId: offerId,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제안을 거절했습니다')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(offerProvider.error ?? '제안 거절에 실패했습니다'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }


  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('공유하기'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.report_outlined),
              title: const Text('신고하기'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfile(BuildContext context) {
    
  }

  void _startChat(BuildContext context) {
    
  }

  void _makeOffer(BuildContext context, Request request) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (!authProvider.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그인이 필요합니다')),
      );
      return;
    }

    if (request.user.id == authProvider.user?.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('본인의 요청에는 제안할 수 없습니다')),
      );
      return;
    }

    _showOfferDialog(context, request);
  }

  void _showOfferDialog(BuildContext context, Request request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => OfferCreationDialog(
        request: request,
        onSubmitOffer: (requestId, message, offeredFee) {
          _submitOffer(context, requestId, message, offeredFee);
        },
      ),
    );
  }

  void _submitOffer(
    BuildContext context,
    String requestId,
    String? message,
    int? offeredFee,
  ) async {
    final offerProvider = Provider.of<OfferProvider>(context, listen: false);

    final success = await offerProvider.createOffer(
      requestId: requestId,
      message: message,
      offeredFee: offeredFee,
    );

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('제안을 성공적으로 보냈습니다')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(offerProvider.error ?? '제안 전송에 실패했습니다'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }


}