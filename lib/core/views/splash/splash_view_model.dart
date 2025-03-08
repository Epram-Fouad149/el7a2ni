import 'package:el7a2ni/core/cubit/splash/splash_cubit.dart';
import 'package:el7a2ni/core/utils/shared_prefs_helper.dart';

class SplashViewModel {
  final SplashCubit splashCubit;

  SplashViewModel(this.splashCubit);

  void startSplashNavigation() {
    Future.delayed(const Duration(seconds: 3), () {
      splashCubit.navigate();
    });
  }

  Future<bool> isUserLoggedIn() async {
    final sharedPrefsHelper = SharedPrefsHelper();
    final isLoggedIn = await sharedPrefsHelper.isUserLoggedIn();
    return isLoggedIn;
  }
}
