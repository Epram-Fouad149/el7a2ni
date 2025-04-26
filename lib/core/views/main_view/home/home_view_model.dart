import 'package:el7a2ni/core/cubit/home/home_cubit.dart';

class HomeViewModel {
  final HomeCubit homeCubit;

  HomeViewModel(this.homeCubit);

  void requestHelp() {
    homeCubit.sendHelpRequest();
  }
}
