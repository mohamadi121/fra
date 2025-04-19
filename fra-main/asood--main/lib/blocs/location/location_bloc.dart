import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

// رویدادهای مربوط به location
abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

// رویداد دریافت موقعیت فعلی
class GetCurrentLocationEvent extends LocationEvent {}

// رویداد انتخاب موقعیت روی نقشه
class SelectLocationEvent extends LocationEvent {
  final LatLng location;

  const SelectLocationEvent(this.location);

  @override
  List<Object?> get props => [location];
}

// وضعیت‌های bloc
class LocationState extends Equatable {
  final Status status;
  final LatLng? selectedLocation;
  final String? errorMessage;
  final bool isLoading;

  const LocationState({
    this.status = Status.initial,
    this.selectedLocation,
    this.errorMessage,
    this.isLoading = false,
  });

  LocationState copyWith({
    Status? status,
    LatLng? selectedLocation,
    String? errorMessage,
    bool? isLoading,
  }) {
    return LocationState(
      status: status ?? this.status,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      errorMessage: errorMessage,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [status, selectedLocation, errorMessage, isLoading];
}

// وضعیت‌های مختلف
enum Status { initial, loading, loaded, error }

// Bloc اصلی برای مدیریت موقعیت
class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final Location _location = Location();

  LocationBloc() : super(const LocationState()) {
    on<GetCurrentLocationEvent>(_onGetCurrentLocation);
    on<SelectLocationEvent>(_onSelectLocation);
  }

  Future<void> _onGetCurrentLocation(
    GetCurrentLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(state.copyWith(status: Status.loading, isLoading: true));

    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          emit(state.copyWith(
            status: Status.error,
            errorMessage: 'سرویس موقعیت‌یابی غیرفعال است',
            isLoading: false,
          ));
          return;
        }
      }

      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          emit(state.copyWith(
            status: Status.error,
            errorMessage: 'دسترسی به موقعیت‌یابی داده نشده است',
            isLoading: false,
          ));
          return;
        }
      }

      final locationData = await _location.getLocation();
      final newLocation = LatLng(
        locationData.latitude ?? 35.6783,
        locationData.longitude ?? 51.4161,
      );

      emit(state.copyWith(
        status: Status.loaded,
        selectedLocation: newLocation,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Status.error,
        errorMessage: 'خطا در دریافت موقعیت: $e',
        isLoading: false,
      ));
    }
  }

  void _onSelectLocation(
    SelectLocationEvent event,
    Emitter<LocationState> emit,
  ) {
    emit(state.copyWith(
      status: Status.loaded,
      selectedLocation: event.location,
    ));
  }

  // تبدیل LatLng از Google Maps به LatLng از Latlong2
  static LatLng convertFromGoogleMaps(gmaps.LatLng googleLatLng) {
    return LatLng(googleLatLng.latitude, googleLatLng.longitude);
  }

  // تبدیل LatLng از Latlong2 به LatLng از Google Maps
  static gmaps.LatLng convertToGoogleMaps(LatLng latLng) {
    return gmaps.LatLng(latLng.latitude, latLng.longitude);
  }
}