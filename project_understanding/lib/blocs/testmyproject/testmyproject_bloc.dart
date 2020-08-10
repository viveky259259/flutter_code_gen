import 'package:flutter_bloc/flutter_bloc.dart';
import 'testmyproject_state.dart';
import 'testmyproject_event.dart';

class TestmyprojectBloc extends Bloc<TestmyprojectEvent, TestmyprojectState> {
  TestmyprojectBloc() : super(TestmyprojectLoading());

  @override
  Stream<TestmyprojectState> mapEventToState(TestmyprojectEvent event) async* {
    if (event is StartTest) {}

    if (event is EndTest) {}
  }
}
