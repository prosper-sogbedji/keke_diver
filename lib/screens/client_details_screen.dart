import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';

class ClientDetailsScreen extends StatelessWidget {
  const ClientDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey200,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Floating Header
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B364A),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Fermer',
                          style: TextStyle(color: AppColors.white, fontSize: 12.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8.w),
                        Icon(Icons.close_rounded, color: AppColors.white, size: 14.sp),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Document Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Client Details',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Prepared for: Your Name | "La Cliente Marine" | Date',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.textHint,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          
                          _buildSectionTitle('Introduction'),
                          _buildParagraph('Hi. "La Cliente Marine" (Client) & "Client\'s Name" . We love to solve problems and we\'re ready to collaborate with great people and brands. Our main objective is to solve digital applications and ensure that all aspects of delivering top flight digital friendly portals are.'),
                          _buildParagraph('In this document you\'ll find outlines by the key phases for delivering this project within the proposed schedule, timeline and budget outlined.'),
                          
                          SizedBox(height: 16.h),
                          _buildSectionTitle('Context'),
                          _buildParagraph('A brief about the company. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.'),
                          _buildParagraph('Goal & Vision: To create a neat, robust and dynamic platform for users. To achieve reaching goals with our UI/UX implementation.'),
                          
                          SizedBox(height: 16.h),
                          _buildSectionTitle('Project Approach & Scope of work'),
                          _buildParagraph('This is a summary of the industry standard UI/UX workflow. Each phase is simulated in detail further down:\n• Research\n• Design\n• Testing'),
                          
                          SizedBox(height: 16.h),
                          _buildSectionTitle('Phase 1: Research'),
                          _buildParagraph('In this phase UI / UX designers start off qualitative and quantitative research and define clearly the following:\n• Key users and their demographic criteria\n• The goals that your product needs for your users\n• The pain points your users may face while on the app\n• Provide exploratory directions for you to choose from\nThis phase is crucial! We believe that IT strategy without data is a recipe for disaster with a lot of resources wasted.'),
                          
                          SizedBox(height: 16.h),
                          _buildSectionTitle('Phase 2: Design'),
                          _buildParagraph('In this phase we start turning the data collected in the research phase into actionable items:\n• Low fidelity / High fidelity wireframes\n• Design elements for your overall brand identity\n• Functional prototypes ready for user testing'),
                          
                          SizedBox(height: 24.h),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Télécharger la facture',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Phase 3: Testing'),
                          _buildParagraph('In this phase it all relies heavily on the deliverables you provide. By our agency standard, any UI/UX strategy package comes a predefined standard. We will aim to execute any critical iterations to the UX strategy and product design. We will also perform A/B testing, focus groups, usability and QA performance.\nAt the end the results of all this process, data is passed on into a final product design handoff to your IT for dev side.'),
                          
                          SizedBox(height: 24.h),
                          _buildSectionTitle('Project Timeline'),
                          _buildParagraph('This table shows below the timeline parameters associated with this project. Assuming that the scope relies on the items above. Timeframes are preliminary and are subject to change depending on outside priority iterations or other project items.'),
                          
                          SizedBox(height: 16.h),
                          // Placeholder for table image or custom widget
                          Container(
                            height: 200.h,
                            decoration: BoxDecoration(
                              color: AppColors.grey50,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: AppColors.grey200),
                            ),
                            child: Center(
                              child: Text('Tableau Timeline', style: TextStyle(color: AppColors.textHint)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          color: AppColors.textHint,
          height: 1.5,
        ),
      ),
    );
  }
}
