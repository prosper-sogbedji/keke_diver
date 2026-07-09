import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(top: 12.h, bottom: 12.h),
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(24.w),
              children: [
                _buildReceivedMessage(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.',
                  '2:36',
                  'https://i.pravatar.cc/100?img=12',
                ),
                SizedBox(height: 16.h),
                _buildSentMessage(
                  'Ut enim ad minim veniam',
                  '2:38',
                ),
                SizedBox(height: 16.h),
                _buildSentMessage(
                  'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
                  '2:38',
                ),
              ],
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildReceivedMessage(String text, String time, String avatarUrl) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16.r,
          backgroundColor: AppColors.grey200,
          backgroundImage: NetworkImage(avatarUrl),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
                    bottomLeft: Radius.circular(4.r),
                  ),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 8.w),
        Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: Text(
            time,
            style: TextStyle(
              color: AppColors.textHint,
              fontSize: 10.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSentMessage(String text, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: Text(
            time,
            style: TextStyle(
              color: AppColors.textHint,
              fontSize: 10.sp,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: const BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(4.r),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Envoyez votre message',
                    hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14.sp),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              width: 48.w,
              height: 48.h,
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.send_rounded, color: AppColors.white, size: 20.sp),
                onPressed: () {
                  if (_messageController.text.isNotEmpty) {
                    _messageController.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
