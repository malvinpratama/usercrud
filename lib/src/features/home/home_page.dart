import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../repositories/repositories.dart';
import '../../services/services.dart';
import '../pages.dart';
import 'components/user_non_selected/bloc/user_non_selected_bloc.dart';
import 'components/user_non_selected/user_non_selected.dart';
import 'components/user_selected/bloc/user_selected_bloc.dart';
import 'components/user_selected/user_selected.dart';

class HomePage extends StatelessWidget {
  static const String route = '/home';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RepositoryProvider<UsersRepository>(
        create: (context) => UsersRepository(NetworkService.client),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<UserNonSelectedBloc>(
              create: (context) =>
                  UserNonSelectedBloc(context.read<UsersRepository>()),
            ),
            BlocProvider<UserSelectedBloc>(
              create: (context) =>
                  UserSelectedBloc(context.read<UsersRepository>()),
            ),
          ],
          child: BlocBuilder<UserNonSelectedBloc, UserNonSelectedState>(
              builder: (context, stateUserNonSelectedState) {
            return BlocBuilder<UserSelectedBloc, UserSelectedState>(
                builder: (context, stateUserSelectedState) {
              return DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    _buildAppbar(context),
                    _buildTabbar(
                      context.read<UserNonSelectedBloc>(),
                      context.read<UserSelectedBloc>(),
                    ),
                    24.verticalSpace,
                    const Expanded(
                      child: TabBarView(
                        children: [
                          UserNonSelected(),
                          UserSelected(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            });
          }),
        ),
      ),
    );
  }

  Widget _buildTabbar(UserNonSelectedBloc userNonSelectedBloc,
      UserSelectedBloc userSelectedBloc) {
    return TabBar(
      labelColor: const Color(0xFFFB6D3A),
      indicatorColor: const Color(0xFFFB6D3A),
      labelStyle: GoogleFonts.sen(
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: GoogleFonts.sen(
        fontSize: 14,
      ),
      isScrollable: true,
      indicatorSize: TabBarIndicatorSize.tab,
      tabAlignment: TabAlignment.start,
      onTap: (value) {
        if (value == 0) {
          userNonSelectedBloc.init();
        } else {
          userSelectedBloc.init();
        }
      },
      tabs: [
        SizedBox(
          width: 106.w,
          child: const Tab(
            text: 'Non Selected',
          ),
        ),
        SizedBox(
          width: 106.w,
          child: const Tab(
            text: 'Selected',
          ),
        ),
      ],
    );
  }

  Column _buildAppbar(BuildContext context) {
    return Column(
      children: [
        50.verticalSpace,
        Padding(
          padding: REdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'User List',
                style: GoogleFonts.sen(fontSize: 17.sp),
              ),
              BlocBuilder<UserNonSelectedBloc, UserNonSelectedState>(
                  builder: (context, state) {
                final bloc = context.read<UserNonSelectedBloc>();
                return InkWell(
                  onTap: () {
                    context.pushNamed<bool>(CreateUserPage.route).then(
                      (result) {
                        if (result ?? false) {
                          bloc.init();
                        }
                      },
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFECF0F4),
                    ),
                    child: Padding(
                      padding: REdgeInsets.all(16),
                      child: Icon(
                        Icons.add,
                        size: 20.sp,
                      ),
                    ),
                  ),
                );
              })
            ],
          ),
        ),
        32.verticalSpace,
      ],
    );
  }
}
