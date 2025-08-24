import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/routing/app_router.dart';

import 'routina_app.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();

  // setUpGetIt();
  // To fix the issue of ScreenUtil texts begin hidden
  await ScreenUtil.ensureScreenSize();
  // await checkIfUserLoggedIn();

  runApp(Routina(appRouter: AppRouter()));
  }

// checkIfUserLoggedIn() async {
//   String? userToken = await SharedPrefHelper.getSecuredString(
//     SharedPrefKeys.userToken,
//   );
//   if (!userToken.isNullOrEmpty()) {
//     isLoggedInUser = true;
//   } else {
//     isLoggedInUser = false;
//   }
// }
