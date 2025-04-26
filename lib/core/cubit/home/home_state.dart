abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeSendingHelpState extends HomeState {}

class HomeSentHelpState extends HomeState {}

class HomeErrorState extends HomeState {
  final String errorMessage;

  HomeErrorState(this.errorMessage);
}
