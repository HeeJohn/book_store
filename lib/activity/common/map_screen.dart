import 'dart:async';
import 'dart:convert';
import 'package:db/activity/common/custom_text.dart';
import 'package:db/activity/common/round_small_btn.dart';
import 'package:db/common/api/address.dart';
import 'package:db/common/api/models/meet_up.dart';
import 'package:db/common/api/models/meeting_model.dart';
import 'package:db/common/api/request.dart';
import 'package:db/common/local_storage/const.dart';
import 'package:db/home/splash.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final MeetingModel appointment;

  const MapScreen({
    super.key,
    required this.appointment,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double previousLcoation = 0;
  bool send = false;
  GoogleMapController? mapController;
  TextEditingController placeController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  String place = '';
  String time = '';
  List<Marker> markers = [];
  late Marker meetingPoint = const Marker(
    markerId: MarkerId('marker'),
    position: hanseoLatLng,
  );
  late Meet editableAppoint;
  //latitude - 위도 , longitude - 경도
  static const LatLng hanseoLatLng = LatLng(
    36.6909,
    126.5845,
  );
  static const CameraPosition initialPosition = CameraPosition(
    target: hanseoLatLng,
    zoom: 16,
  );
  int myID = 0;
  double editableLatitude = 0;
  double editableLongitude = 0;

  @override
  void initState() {
    markers.clear();

    getMeetingInfo();
    super.initState();
  }

  Future<void> getMeetingInfo() async {
    print('herere=========================================================>');
    final meeting = ApiService();
    final sessionID = await storage.read(key: sessionIDLS);
    if (sessionID != null) {
      final response = await meeting.getRequest(sessionID, readMeetingURL, {
        'bookID': widget.appointment.bookID,
      });
      if ('success' == await meeting.reponseMessageCheck(response)) {
        setState(() {
          final decodedData = jsonDecode(response!.data)['data'][0];
          editableAppoint = Meet.fromJson(decodedData);
          place = editableAppoint.place ?? '이학관 203호 or 이학관 앞';
          time = editableAppoint.time ?? '12월 5일 오후 3시 30분';
          if (editableAppoint.latitude != null &&
              editableAppoint.longitude != null) {
            markers = [
              Marker(
                markerId: const MarkerId('meet here'),
                position: LatLng(
                  editableAppoint.latitude!.toDouble(),
                  editableAppoint.longitude!.toDouble(),
                ),
              ),
            ];
          }
        });
      }
    }
    print('herere=========================================================>');
  }

  Future<void> sendMeetingInfo() async {
    final meeting = ApiService();
    final sessionID = await storage.read(key: sessionIDLS);
    if (sessionID != null) {
      final response = await meeting.postRequest(
        sessionID,
        updateNotBoxURL,
        {
          'bookID': widget.appointment.bookID,
          'time': timeController.value.text,
          'place': placeController.value.text,
          'latitude': editableLatitude,
          'longitude': editableLongitude,
        },
      );
      if ('success' == await meeting.reponseMessageCheck(response)) {
        getMeetingInfo();
        pop();
      }
    }
  }

  void getMarkersPostion(LatLng latLng) {
    editableLatitude = latLng.latitude;
    editableLongitude = latLng.longitude;
  }

  void pop() {
    Navigator.of(context).pop();
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
                if (!snapshot.hasData) {
                  return const BottomCircleProgressBar();
                }
                return Column(children: [
                  Flexible(
                    flex: 2,
                    child: _CustomGoogleMap(
                      getMarkersPostion: getMarkersPostion,
                      markers: markers,
                      initialPosition: initialPosition,
                      circle: const Circle(
                        circleId: CircleId('me'),
                      ),
                      onMapCreated: onMapCreated,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () => showModalBottomSheet(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        context: context,
                        builder: (BuildContext context) {
                          bool isOnKeyBoard =
                              MediaQuery.of(context).viewInsets.bottom == 0;
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.4 +
                                (isOnKeyBoard
                                    ? 0
                                    : MediaQuery.of(context).viewInsets.bottom),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '장소와 시간을 입력하세요 =)',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    RoundedSmallBtn(
                                      title: "Done",
                                      onPressed: () {
                                        sendMeetingInfo();
                                      },
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                CustomTextField(
                                  label: "장소",
                                  hintText: "이학관 206호 or 이학관 앞",
                                  controller: placeController,
                                  textinputType: TextInputType.name,
                                ),
                                const SizedBox(height: 10),
                                CustomTextField(
                                  label: "시간",
                                  hintText: "12월 11일 2시 30분",
                                  controller: timeController,
                                  textinputType: TextInputType.name,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomTextField(
                              enabled: false,
                              label: "장소",
                              hintText: place,
                              controller: placeController,
                              textinputType: TextInputType.name,
                            ),
                            CustomTextField(
                              enabled: false,
                              label: "시간",
                              hintText: time,
                              controller: timeController,
                              textinputType: TextInputType.name,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]);
              },
            );
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

class _CustomGoogleMap extends StatelessWidget {
  final MapCreatedCallback onMapCreated;
  final CameraPosition initialPosition;
  final Circle circle;
  final List<Marker> markers;
  final ValueChanged<LatLng> getMarkersPostion;

  const _CustomGoogleMap({
    required this.getMarkersPostion,
    required this.initialPosition,
    required this.circle,
    required this.markers,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: initialPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      circles: {circle},
      markers: Set.from(markers),
      onMapCreated: onMapCreated,
      onTap: (LatLng latLng) {
        markers[0] = Marker(
          markerId: const MarkerId('meet here'),
          position: latLng,
        );
        getMarkersPostion(latLng);
        (context as Element).markNeedsBuild();
      },
    );
  }
}
