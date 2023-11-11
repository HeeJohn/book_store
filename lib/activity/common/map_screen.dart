import 'dart:async';
import 'package:db/home/splash.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'notification.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double previousLcoation = 0;
  bool send = false;
  GoogleMapController? mapController;
  //latitude - 위도 , longitude - 경도
  static const LatLng companyLatLng = LatLng(
    37.5233273,
    126.921252,
  );
  static const CameraPosition initialPosition = CameraPosition(
    target: companyLatLng,
    zoom: 15,
  );
  static const double radius = 100;
  static final Circle withinCircle = Circle(
    circleId: const CircleId('withinCircle'),
    radius: radius,
    fillColor: Colors.blue.withOpacity(0.5),
    strokeColor: Colors.blue,
    strokeWidth: 1,
    center: companyLatLng,
  );
  static final Circle notWithinCircle = Circle(
    circleId: const CircleId('notWithinCircle'),
    radius: radius,
    fillColor: Colors.red.withOpacity(0.5),
    strokeColor: Colors.red,
    strokeWidth: 1,
    center: companyLatLng,
  );
  static final Circle checkDone = Circle(
    circleId: const CircleId('checkDone'),
    radius: radius,
    fillColor: Colors.blue.withOpacity(0.5),
    strokeColor: Colors.blue,
    strokeWidth: 1,
    center: companyLatLng,
  );
  static const Marker marker = Marker(
    markerId: MarkerId('marker'),
    position: companyLatLng,
  );
  @override
  void initState() {
    // 초기화
    FlutterLocalNotification.init();
    print('============================== request permission');
    // 3초 후 권한 요청
    requestPermssion();
    print('============================== request permission');
    super.initState();
  }

  void requestPermssion() async {
    await Future.delayed(const Duration(seconds: 1),
        FlutterLocalNotification.requestNotificationPermission());
    print('============================== request permission done');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: FutureBuilder(
        future: checkPermission(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: BottomCircleProgressBar(),
              ),
            );
          }
          if (snapshot.data ==
              'You allowd your authority of Location Information') {
            return StreamBuilder<Position>(
                stream: Geolocator.getPositionStream(),
                builder: (context, snapshot) {
                  bool notify = true;
                  bool isWithinCicle = false;
                  final myLocation = snapshot.data;

                  if (snapshot.hasData) {
                    final distance = Geolocator.distanceBetween(
                        myLocation!.latitude,
                        myLocation.longitude,
                        companyLatLng.latitude,
                        companyLatLng.longitude);

                    if (distance < radius) {
                      isWithinCicle = true;

                      if (notify) {
                        FlutterLocalNotification.showNotification();
                        notify = false;
                      }
                    } else {
                      send = false;
                      isWithinCicle = false;
                    }
                  }
                  return Column(children: [
                    _CustomGoogleMap(
                      initialPosition: initialPosition,
                      circle: send
                          ? checkDone
                          : isWithinCicle
                              ? withinCircle
                              : notWithinCircle,
                      marker: marker,
                      onMapCreated: onMapCreated,
                    ),
                    _ClockInShift(
                      checked: send,
                      isWithInRange: isWithinCicle,
                      onPressed: onClockInPressed,
                    ),
                  ]);
                });
          }

          return Center(
            child: Text(snapshot.data),
          );
        },
      ),
    );
  }

  onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  onClockInPressed() async {
    final pushNotification = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('<push notifications>'),
          content:
              const Text('Do you want to let them know\nyou are around here?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('no'),
            ),
            TextButton(
              onPressed: () {
                FlutterLocalNotification.showNotification();
                Navigator.of(context).pop(true);
              },
              child: const Text('yes'),
            ),
          ],
        );
      },
    );
    setState(() {
      send = pushNotification;
    });
  }

  Future<String> checkPermission() async {
    final isLacationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLacationEnabled) {
      return 'turn on your Location service';
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();

    if (checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission();

      if (checkedPermission == LocationPermission.denied) {
        return 'Allow to access this device\'s location';
      }
    }

    if (checkedPermission == LocationPermission.deniedForever) {
      return 'Allow your authority of your Location Information on the "setting"';
    }

    return 'You allowd your authority of Location Information';
  }

  AppBar renderAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Center(
        child: Text(
          '약속 장소',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            if (mapController == null) {
              return;
            }
            final location = await Geolocator.getCurrentPosition();

            mapController!.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(
                  location.latitude,
                  location.longitude,
                ),
              ),
            );
          },
          icon: const Icon(
            Icons.my_location_outlined,
            color: Colors.blue,
          ),
        )
      ],
    );
  }
}

class _ClockInShift extends StatelessWidget {
  final bool isWithInRange;
  final bool checked;
  final VoidCallback onPressed;
  const _ClockInShift({
    required this.onPressed,
    required this.isWithInRange,
    required this.checked,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          Icons.timelapse_outlined,
          size: 60.0,
          color: checked
              ? Colors.green
              : isWithInRange
                  ? Colors.blue
                  : Colors.red,
        ),
        if (isWithInRange && !checked)
          ElevatedButton(
            onPressed: onPressed,
            child: const Text(
              'push',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
      ],
    ));
  }
}

class _CustomGoogleMap extends StatelessWidget {
  final MapCreatedCallback onMapCreated;
  final CameraPosition initialPosition;
  final Circle circle;
  final Marker marker;

  const _CustomGoogleMap({
    required this.initialPosition,
    required this.circle,
    required this.marker,
    required this.onMapCreated,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        circles: {circle},
        markers: {marker},
        onMapCreated: onMapCreated,
      ),
    );
  }
}
