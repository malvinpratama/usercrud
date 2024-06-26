import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/models.dart';
import '../../repositories/repositories.dart';
import '../../services/services.dart';
import '../pages.dart';
import 'bloc/create_user_bloc.dart';

class CreateUserPage extends StatelessWidget {
  static const String route = '/user/create';
  const CreateUserPage({super.key, this.userModel});
  final UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => UsersRepository(NetworkService.client),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: BlocProvider(
          create: (context) =>
              CreateUserBloc(context.read<UsersRepository>(), userModel),
          child: BlocListener<CreateUserBloc, CreateUserState>(
            listener: (context, state) {
              final bloc = context.read<CreateUserBloc>();
              if (state.viewStatus == ViewStatusModel.success) {
                context.pushNamed<bool>(CreateUpdateUserSuccessPage.route, extra: userModel).then(
                  (value) {
                    context.pop(value);
                  },
                );
              } else if (state.viewStatus == ViewStatusModel.failure) {
                showAdaptiveDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      actionsAlignment: MainAxisAlignment.center,
                      alignment: Alignment.center,
                      buttonPadding:
                          REdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      title: Text(
                        'Failed Create User',
                        style: GoogleFonts.sen(
                            fontWeight: FontWeight.w600, fontSize: 16.sp),
                        textAlign: TextAlign.center,
                      ),
                      actions: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF7622),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            onPressed: () {
                              bloc.resetStatus();
                              context.pop();
                            },
                            child: Padding(
                              padding: REdgeInsets.symmetric(vertical: 4),
                              child: Center(
                                  child: Text(
                                'Ok',
                                style: GoogleFonts.sen(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                    color: Colors.white),
                              )),
                            ))
                      ],
                    );
                  },
                );
              }
            },
            child: BlocBuilder<CreateUserBloc, CreateUserState>(
              builder: (context, state) {
                final bloc = context.read<CreateUserBloc>();
                return Stack(
                  children: [
                    Padding(
                      padding: REdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          50.verticalSpace,
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  context.pop();
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFECF0F4),
                                  ),
                                  child: Padding(
                                    padding: REdgeInsets.all(16),
                                    child: Icon(
                                      Icons.close,
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                              ),
                              18.horizontalSpace,
                              Text(
                                userModel != null
                                    ? 'Update User'
                                    : 'Create User',
                                style: GoogleFonts.sen(
                                  fontSize: 17.sp,
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            child: _buildForm(context, bloc, state),
                          ),
                          InkWell(
                            onTap: () {
                              bloc.createUpdateUser();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: bloc.validate()
                                    ? const Color(0xFFFF7622)
                                    : const Color(0xFFA0A5BA),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              width: double.infinity,
                              child: Center(
                                child: Padding(
                                  padding: REdgeInsets.symmetric(vertical: 24),
                                  child: Text(
                                    userModel != null ? 'UPDATE' : 'CREATE',
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
                          34.verticalSpace,
                        ],
                      ),
                    ),
                    if (state.viewStatus == ViewStatusModel.submitting)
                      Material(
                        color: const Color(0xFFA0A5BA).withOpacity(0.8),
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                                32.verticalSpace,
                                Text(
                                  'Submitting',
                                  style: GoogleFonts.sen(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(
      BuildContext context, CreateUserBloc bloc, CreateUserState state) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          24.verticalSpace,
          Text(
            'First Name',
            style: GoogleFonts.sen(
              fontSize: 14.sp,
              color: const Color(0xFFA0A5BA),
            ),
          ),
          8.verticalSpace,
          TextFormField(
            controller: bloc.firstNameController,
            onChanged: bloc.onChangeFirstName,
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: REdgeInsets.all(20),
              fillColor: const Color(0xFFF0F5FA),
              filled: true,
              border: InputBorder.none,
              labelText: 'First Name',
              labelStyle: GoogleFonts.sen(fontSize: 16.sp),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              errorText: state.firstName.displayError != null
                  ? 'First Name cannot be empty'
                  : null,
            ),
          ),
          32.verticalSpace,
          Text(
            'Last Name',
            style: GoogleFonts.sen(
              fontSize: 14.sp,
              color: const Color(0xFFA0A5BA),
            ),
          ),
          8.verticalSpace,
          TextFormField(
            controller: bloc.lastNameController,
            onChanged: bloc.onChangeLastName,
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: REdgeInsets.all(20),
              fillColor: const Color(0xFFF0F5FA),
              filled: true,
              border: InputBorder.none,
              labelText: 'Last Name',
              labelStyle: GoogleFonts.sen(fontSize: 16.sp),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              errorText: state.lastName.displayError != null
                  ? 'Last Name cannot be empty'
                  : null,
            ),
            textAlignVertical: TextAlignVertical.center,
          ),
          32.verticalSpace,
          Text(
            'Email',
            style: GoogleFonts.sen(
              fontSize: 14.sp,
              color: const Color(0xFFA0A5BA),
            ),
          ),
          8.verticalSpace,
          TextFormField(
            controller: bloc.emailController,
            onChanged: bloc.onChangeEmail,
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: REdgeInsets.all(20),
              fillColor: const Color(0xFFF0F5FA),
              filled: true,
              border: InputBorder.none,
              labelText: 'Email',
              labelStyle: GoogleFonts.sen(fontSize: 16.sp),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              errorText: state.email.displayError != null
                  ? 'Please ensure the Email entered is valid'
                  : null,
            ),
            textAlignVertical: TextAlignVertical.center,
          ),
          32.verticalSpace,
          Text(
            'Job',
            style: GoogleFonts.sen(
              fontSize: 14.sp,
              color: const Color(0xFFA0A5BA),
            ),
          ),
          8.verticalSpace,
          InkWell(
            onTap: () {
              showModalBottomSheet<String>(
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: REdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        46.verticalSpace,
                        InkWell(
                          onTap: () {
                            context.pop('Front End');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Front End',
                                style: GoogleFonts.sen(fontSize: 20.sp),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 20.sp,
                              )
                            ],
                          ),
                        ),
                        24.verticalSpace,
                        InkWell(
                          onTap: () {
                            context.pop('Back End');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Back End',
                                style: GoogleFonts.sen(fontSize: 20.sp),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 20.sp,
                              )
                            ],
                          ),
                        ),
                        24.verticalSpace,
                        InkWell(
                          onTap: () {
                            context.pop('Data Analyst');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Data Analyst',
                                style: GoogleFonts.sen(fontSize: 20.sp),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 20.sp,
                              )
                            ],
                          ),
                        ),
                        24.verticalSpace,
                      ],
                    ),
                  );
                },
              ).then(
                (value) {
                  if (value != null) {
                    bloc.onChangeJob(value);
                  }
                },
              );
            },
            child: Container(
              color: const Color(0xFFF0F5FA),
              width: double.infinity,
              child: Padding(
                padding: REdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.job.isPure ? 'Job' : state.job.value,
                      style: GoogleFonts.sen(fontSize: 16.sp),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16.sp,
                    ),
                  ],
                ),
              ),
            ),
          ),
          32.verticalSpace,
        ],
      ),
    );
  }
}
