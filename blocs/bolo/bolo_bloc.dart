import 'package:flutter_bloc/flutter_bloc.dart';
import 'bolo_state.dart';
import 'bolo_event.dart';

class BoloBloc extends Bloc<BoloEvent, BoloState> {
  BoloBloc() : super(BoloLoading());

  @override
  Stream<BoloState> mapEventToState(BoloEvent event) async* {
    if (event is kya) {}
  }
}
