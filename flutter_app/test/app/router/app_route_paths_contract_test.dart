import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/shared/layout/vit_bottom_nav.dart';

import 'app_route_paths_contract_test_utils.dart';

void main() {
  routePathContractTest('defines stable core and shell route paths', [
    c(AppRoutePaths.authLogin, '/auth/login'),
    c(AppRoutePaths.authRegister, '/auth/register'),
    c(AppRoutePaths.authOtp, '/auth/otp'),
    c(AppRoutePaths.auth2faSetup, '/auth/2fa-setup'),
    c(AppRoutePaths.authForgotPassword, '/auth/forgot-password'),
    c(AppRoutePaths.authResetPassword, '/auth/reset-password'),
    c(AppRoutePaths.news, '/news'),
    c(VitBottomNavDestination.home.routePath, AppRoutePaths.home),
  ]);
}
