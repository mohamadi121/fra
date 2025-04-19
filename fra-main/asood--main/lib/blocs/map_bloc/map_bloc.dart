import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

part 'map_event.dart';
part 'map_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationState.initial()) {
    on<DetermineCurrentPosition>(_onDetermineCurrentPosition);
    on<UpdateSelectedLocation>(_onUpdateSelectedLocation);
    on<SaveLocation>(_onSaveLocation);
    on<ReadSavedLocation>(_onReadSavedLocation);
  }

  // A function that handles determining the current position. It takes in an event of type DetermineCurrentPosition
  // and an Emitter of type LocationState as parameters. It updates the state to loading, tries to get the current
  // position using Geolocator, and updates the state with the location and status loaded if successful. If there's an
  // error, it updates the state with status error and the error message.
  Future<void> _onDetermineCurrentPosition(
      DetermineCurrentPosition event, Emitter<LocationState> emit) async {
    emit(state.copyWith(status: Status.loading));
    try {
      Position position = await Geolocator.getCurrentPosition();
      emit(state.copyWith(
          location: LatLng(position.latitude, position.longitude),
          status: Status.loaded));
    } catch (e) {
      emit(state.copyWith(status: Status.error, message: e.toString()));
    }
  }

  void _onUpdateSelectedLocation(
      UpdateSelectedLocation event, Emitter<LocationState> emit) {
    emit(state.copyWith(
        status: Status.loaded, location: event.location, isSelected: true));
  }

  Future<void> _onSaveLocation(
      SaveLocation event, Emitter<LocationState> emit) async {
    if (state.status == Status.loaded) {
      final loadedState = state;

      /*   await GetStorage('agahi').write("location",
          "${loadedState.location.latitude},${loadedState.location.longitude}"); */
      emit(state.copyWith(
          status: Status.loaded,
          location: loadedState.location,
          isSelected: true));
    }
  }

  Future<void> _onReadSavedLocation(
      ReadSavedLocation event, Emitter<LocationState> emit) async {
    emit(state.copyWith(status: Status.loading));
    try {
      //final a = GetStorage('agahi').read("location");
      if (true /* a != null */) {
        const lat = 0.0;
        const lang = 0.0;
        /*  final numbersList = a.split(',');
        final lat = double.parse(numbersList[0]);
        final lang = double.parse(numbersList[1]); */
        emit(state.copyWith(
            location: const LatLng(lat, lang), isSelected: true));
        // ignore: dead_code
      } else {
        emit(state.copyWith(status: Status.initial));
      }
    } catch (e) {
      emit(state.copyWith(status: Status.error, message: e.toString()));
    }
  }
}
