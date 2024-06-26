import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/models.dart';

class CreateUpdateUserSuccessPage extends StatelessWidget {
  static const String route = '/user/create/success';
  const CreateUpdateUserSuccessPage({super.key, this.userModel});

  final UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Color(0xFFFB6D3A), shape: BoxShape.circle),
            height: 99.r,
            width: 99.r,
            child: Center(
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 50.sp,
              ),
            ),
          ),
          28.verticalSpace,
          Text(
            userModel != null ? 'Update Successful' : 'Create Successful',
            style: GoogleFonts.poppins(
              fontSize: 22.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          22.verticalSpace,
          Padding(
            padding: REdgeInsets.symmetric(horizontal: 24),
            child: InkWell(
              onTap: () {
                context.pop(true);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7622),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                width: double.infinity,
                child: Center(
                  child: Padding(
                    padding: REdgeInsets.symmetric(vertical: 18),
                    child: Text(
                      'Ok',
                      style: GoogleFonts.sen(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
