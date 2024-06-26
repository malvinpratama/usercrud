import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/models.dart';
import 'bloc/user_selected_bloc.dart';

class UserSelected extends StatelessWidget {
  const UserSelected({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserSelectedBloc, UserSelectedState>(
        builder: (context, state) {
      final bloc = context.read<UserSelectedBloc>();
      return BlocListener<UserSelectedBloc, UserSelectedState>(
        listenWhen: (previous, current) {
          return previous.selectedOption != current.selectedOption;
        },
        listener: (context, state) {
          if (state.selectedOption.isNotEmpty) {
            if (state.selectedOption == 'Unselect') {
              state.selectedUser?.delete().then(
                (_) {
                  bloc.resetSelectedOption();
                },
              );
            }
          }
        },
        child: Padding(
          padding: REdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total ${state.total} items',
                style: GoogleFonts.sen(
                  fontSize: 14.sp,
                  color: const Color(0xFF9C9BA6),
                ),
              ),
              20.verticalSpace,
              Expanded(
                child: ListView.separated(
                  controller: bloc.scrollController,
                  itemCount: state.userList.length,
                  separatorBuilder: (context, index) => 20.verticalSpace,
                  itemBuilder: (context, index) {
                    final user = state.userList[index];
                    return _buildUserListTile(user, bloc);
                  },
                ),
              ),
              20.verticalSpace,
            ],
          ),
        ),
      );
    });
  }

  Row _buildUserListTile(UserModel user, UserSelectedBloc bloc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Image.network(
                user.avatar ?? '',
                height: 102.r,
                width: 102.r,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: const Color(0xFF98A8B8),
                    ),
                    height: 102.r,
                    width: 102.r,
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: const Color(0xFF98A8B8),
                    ),
                    height: 102.r,
                    width: 102.r,
                  );
                },
              ),
            ),
            12.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: REdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    '${user.firstName} - ${user.lastName}',
                    style: GoogleFonts.sen(
                        fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  '${user.email}',
                  style: GoogleFonts.sen(
                    fontSize: 14,
                    color: const Color(0xFFFF7622),
                  ),
                )
              ],
            ),
          ],
        ),
        PopupMenuButton(
          icon: const Icon(Icons.more_horiz_outlined),
          iconSize: 24.sp,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          onSelected: (value) {
            bloc.onChangeSelectedOption(value, user);
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'Unselect',
              child: Text(
                'Unselect',
                style: GoogleFonts.sen(fontSize: 12.sp),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
