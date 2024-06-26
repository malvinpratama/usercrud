import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/models.dart';
import '../../../pages.dart';
import 'bloc/user_non_selected_bloc.dart';

class UserNonSelected extends StatelessWidget {
  const UserNonSelected({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserNonSelectedBloc, UserNonSelectedState>(
        builder: (context, state) {
      final bloc = context.read<UserNonSelectedBloc>();
      return BlocListener<UserNonSelectedBloc, UserNonSelectedState>(
        listenWhen: (previous, current) {
          return previous.selectedOption != current.selectedOption;
        },
        listener: (context, state) {
          if (state.selectedOption.isNotEmpty) {
            if (state.selectedOption == 'Delete') {
              showModalBottomSheet<bool>(
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: REdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        32.verticalSpace,
                        Text(
                          'Are You Sure?',
                          style: GoogleFonts.sen(
                            fontSize: 20.sp,
                          ),
                        ),
                        30.verticalSpace,
                        InkWell(
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
                                padding: REdgeInsets.symmetric(vertical: 22),
                                child: Text(
                                  'DELETE NOW',
                                  style: GoogleFonts.sen(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        30.verticalSpace,
                      ],
                    ),
                  );
                },
              ).then(
                (value) {
                  bloc.delete().then(
                    (value) {
                      context.pushNamed<bool>(DeleteUserSuccessPage.route).then(
                        (value) {
                           bloc.resetSelectedOption();
                          bloc.init();
                        },
                      );
                    },
                  );
                },
              );
            } else if (state.selectedOption == 'Update') {
              bloc.resetSelectedOption();
              context
                  .pushNamed<bool>(CreateUserPage.route,
                      extra: state.selectedUser)
                  .then(
                (result) {
                  if (result ?? false) {
                    bloc.init();
                  }
                },
              );
            } else if (state.selectedOption == 'Select') {
              state.selectedUser?.save().then(
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

  Row _buildUserListTile(UserModel user, UserNonSelectedBloc bloc) {
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
              value: 'Select',
              child: Text(
                'Select',
                style: GoogleFonts.sen(fontSize: 12.sp),
              ),
            ),
            PopupMenuItem<String>(
              value: 'Update',
              child: Text(
                'Update',
                style: GoogleFonts.sen(fontSize: 12.sp),
              ),
            ),
            PopupMenuItem<String>(
              value: 'Delete',
              child: Text(
                'Delete',
                style: GoogleFonts.sen(
                    fontSize: 12.sp, color: const Color(0xFFFF0606)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
