import 'package:asood/blocs/location/location_bloc.dart';
import 'package:asood/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../constants/constants.dart';

// کلاس یکپارچه شده نقشه که از Google Maps و BLoC استفاده می‌کند
class MapScreen extends StatefulWidget {
  final Function(LatLng)? selectedLocation;
  final bool isSelecting;
  final LocationModel initialLocation;

  const MapScreen({
    Key? key,
    this.isSelecting = false,
    this.initialLocation = const LocationModel(lat: 35.6783, lon: 51.4161),
    this.selectedLocation,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocationBloc(),
      child: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state.status == Status.loaded && state.selectedLocation != null) {
            // زمانی که موقعیت تغییر کرده و انتخاب شده است
            if (widget.selectedLocation != null) {
              final googleLatLng = LocationBloc.convertToGoogleMaps(state.selectedLocation!);
              widget.selectedLocation!(googleLatLng);
            }
            
            // بروزرسانی نشانگرها
            _updateMarkers(state.selectedLocation!);
            
            // اگر کنترلر نقشه ایجاد شده باشد، نمای دوربین را به موقعیت انتخاب شده تغییر می‌دهیم
            _mapController?.animateCamera(
              CameraUpdate.newLatLngZoom(
                LocationBloc.convertToGoogleMaps(state.selectedLocation!), 
                16
              ),
            );
          } else if (state.status == Status.error && state.errorMessage != null) {
            // نمایش خطا
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // نقشه گوگل
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.initialLocation.lat, widget.initialLocation.lon),
                    zoom: 16,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapToolbarEnabled: false,
                  zoomControlsEnabled: false,
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  onTap: widget.isSelecting 
                    ? (position) {
                        // تبدیل LatLng گوگل به نوع مورد استفاده در بلاک
                        final convertedPosition = LocationBloc.convertFromGoogleMaps(position);
                        context.read<LocationBloc>().add(SelectLocationEvent(convertedPosition));
                      }
                    : null,
                ),
                
                // نمایش لودینگ هنگام دریافت موقعیت
                if (state.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                
                // دکمه موقعیت فعلی
                if (widget.isSelecting)
                  Positioned(
                    bottom: Dimensions.height * 0.01,
                    right: Dimensions.width * 0.05,
                    child: Container(
                      width: Dimensions.width * 0.1,
                      height: Dimensions.height * 0.05,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colora.primaryColor,
                      ),
                      child: IconButton(
                        onPressed: () {
                          context.read<LocationBloc>().add(GetCurrentLocationEvent());
                        },
                        icon: Icon(
                          Icons.my_location,
                          color: Colora.scaffold,
                          size: Dimensions.width * 0.05,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // بروزرسانی نشانگرهای روی نقشه
  void _updateMarkers(LatLng position) {
    final googlePosition = LocationBloc.convertToGoogleMaps(position);
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: googlePosition,
          infoWindow: const InfoWindow(title: 'موقعیت انتخابی'),
        ),
      };
    });
  }
}