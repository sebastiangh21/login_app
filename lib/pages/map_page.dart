import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:marker_icon/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../services/services_ingreso.dart';
import '../user_preferences/user_preferences.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' as vmath;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  LatLng _center = const LatLng(6.267668, -75.568648);
  final List<String> icons = [
    "warningIcon.png",
    "theftIcon.png",
    "murderIcon.png",
    "kidnappingIcon.png",
    "fightIcon.png",
    "faintIcon.png",
    "carCrashIcon.png"
  ];
  final Map<int, bool> filterIcon = {
    0: true,
    1: true,
    2: true,
    3: true,
    4: true,
    5: true,
    6: true
  };
  final Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  double zoomC = 12.0;
  List eventos = [];
  bool isCreatedMarkers = false;
  final ingresoServices = IngresoServices();
  final prefs = PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de eventos'),
        backgroundColor: const Color.fromARGB(255, 13, 51, 48),
      ),
      body: isCreatedMarkers ? _crearMap2() : _crearMap(),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: const Color.fromARGB(255, 23, 88, 83),
        direction: SpeedDialDirection.down,
        children: [
          SpeedDialChild(
            child: ImageIcon(
              const AssetImage("assets/warningIcon.png"),
              size: 35,
              color: filterIcon[0]! ? Colors.green : Colors.grey,
            ),
            label: "Peligro",
            onTap: () {
              setState(() {
                filterIcon[0] = !filterIcon[0]!;
                markers.clear();
              });
            },
          ),
          SpeedDialChild(
            child: ImageIcon(
              const AssetImage("assets/theftIcon.png"),
              size: 50,
              color: filterIcon[1]! ? Colors.green : Colors.grey,
            ),
            label: "Robo",
            onTap: () {
              setState(() {
                filterIcon[1] = !filterIcon[1]!;
                markers.clear();
              });
            },
          ),
          SpeedDialChild(
            child: ImageIcon(
              const AssetImage("assets/murderIcon.png"),
              size: 35,
              color: filterIcon[2]! ? Colors.green : Colors.grey,
            ),
            label: "Asesinato",
            onTap: () {
              setState(() {
                filterIcon[2] = !filterIcon[2]!;
                markers.clear();
              });
            },
          ),
          SpeedDialChild(
            child: ImageIcon(
              const AssetImage("assets/kidnappingIcon.png"),
              size: 35,
              color: filterIcon[3]! ? Colors.green : Colors.grey,
            ),
            label: "Secuestro",
            onTap: () {
              setState(() {
                filterIcon[3] = !filterIcon[3]!;
                markers.clear();
              });
            },
          ),
          SpeedDialChild(
            child: ImageIcon(
              const AssetImage("assets/fightIcon.png"),
              size: 35,
              color: filterIcon[4]! ? Colors.green : Colors.grey,
            ),
            label: "Pelea callejera",
            onTap: () {
              setState(() {
                filterIcon[4] = !filterIcon[4]!;
                markers.clear();
              });
            },
          ),
          SpeedDialChild(
            child: ImageIcon(
              const AssetImage("assets/faintIcon.png"),
              size: 35,
              color: filterIcon[5]! ? Colors.green : Colors.grey,
            ),
            label: "Desmayo",
            onTap: () {
              setState(() {
                filterIcon[5] = !filterIcon[5]!;
                markers.clear();
              });
            },
          ),
          SpeedDialChild(
            child: ImageIcon(
              const AssetImage("assets/carCrashIcon.png"),
              size: 50,
              color: filterIcon[6]! ? Colors.green : Colors.grey,
            ),
            label: "Accidente",
            onTap: () {
              setState(() {
                filterIcon[6] = !filterIcon[6]!;
                markers.clear();
              });
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    location.onLocationChanged.listen((LocationData currentLocation) {
      print("Entro");
      _locationData = currentLocation;
      _center = LatLng(_locationData.latitude ?? 6.267668,
          _locationData.longitude ?? -75.568648);
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: _center,
        zoom: zoomC,
      )));
    });
  }

  Future checkSerrviceEnable() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  Future permissionLocation() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<bool> getLocation() async {
    checkSerrviceEnable();
    permissionLocation();
    _locationData = await location.getLocation();
    _center = LatLng(_locationData.latitude ?? 6.267668,
        _locationData.longitude ?? -75.568648);
    return true;
  }

  Future<Set<Marker>> getMarkers() async {
    final List zonas = await ingresoServices.zonas(prefs.token);
    eventos.clear();
    for (var mark in zonas) {
      final LatLng posicionM = LatLng(mark["location"][0], mark["location"][1]);
      if (distancia(_center, posicionM) < 10) {
        int code = mark["zoneCode"];
        final List eventos2 =
            await ingresoServices.eventForZone(prefs.token, code.toString());
        for (var event in eventos2) {
          String description = event["eventDescription"] + event["comment"];
          int indice = selectIcon(description);
          if (filterIcon[indice]!) {
            markers.add(Marker(
              markerId: MarkerId("${event["id"]}"),
              position: LatLng(event["location"][0], event["location"][1]),
              infoWindow: InfoWindow(
                title: "${event["eventDescription"]}",
                snippet:
                    "El evento ocurrio el ${event["date"]} a las ${event["time"]}, se reporto que: ${event["comment"]}.",
              ),
              icon: await MarkerIcon.pictureAsset(
                  assetPath: "assets/${icons[indice]}",
                  width: 150,
                  height: 150),
            ));
          }
        }
        eventos.addAll(eventos2);
      }
    }

    await getLocation();
    markers.add(Marker(
      markerId: const MarkerId("Yo"),
      position: _center,
      infoWindow: const InfoWindow(
        title: 'Yo',
        snippet: 'Mi ubicaion actual.',
      ),
      icon: await MarkerIcon.pictureAsset(
          assetPath: "assets/meIcon.png", width: 150, height: 150),
    ));
    isCreatedMarkers = true;
    return markers;
  }

  _crearMap() {
    return FutureBuilder(
      future: getMarkers(),
      builder: (BuildContext context, AsyncSnapshot<Set<Marker>> snapshot) {
        if (snapshot.hasData) {
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: zoomC,
            ),
            markers: markers,
            onCameraMove: (position) => zoomC = position.zoom,
            onMapCreated: _onMapCreated,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  _crearMap2() {
    return FutureBuilder(
      future: filterMarkers(),
      builder: (BuildContext context, AsyncSnapshot<Set<Marker>> snapshot) {
        if (snapshot.hasData) {
          final Set<Marker> litsMarker = snapshot.data!;
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: zoomC,
            ),
            markers: litsMarker,
            onCameraMove: (position) => zoomC = position.zoom,
            onMapCreated: _onMapCreated,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<Set<Marker>> filterMarkers() async {
    final Set<Marker> markers2 = {};
    for (var event in eventos) {
      String description = "${event["eventDescription"]} ${event["comment"]}";
      int indice = selectIcon(description);
      if (filterIcon[indice]!) {
        markers2.add(Marker(
          markerId: MarkerId("${event["id"]}"),
          position: LatLng(event["location"][0], event["location"][1]),
          infoWindow: InfoWindow(
            title: "${event["eventDescription"]}",
            snippet:
                "El evento ocurrio el ${event["date"]} a las ${event["time"]}, se reporto que: ${event["comment"]}.",
          ),
          icon: await MarkerIcon.pictureAsset(
              assetPath: "assets/${icons[indice]}", width: 150, height: 150),
        ));
      }
    }
    markers2.add(Marker(
      markerId: const MarkerId("Yo"),
      position: _center,
      infoWindow: const InfoWindow(
        title: 'Yo',
        snippet: 'Mi ubicaion actual.',
      ),
      icon: await MarkerIcon.pictureAsset(
          assetPath: "assets/meIcon.png", width: 150, height: 150),
    ));
    return markers2;
  }

  double distancia(LatLng startP, LatLng endP) {
    int radius = 6378; // radio de la tierra en  kilómetros
    double lat1 = startP.latitude;
    double lat2 = endP.latitude;
    double lon1 = startP.longitude;
    double lon2 = endP.longitude;
    double dLat = vmath.radians(lat2 - lat1);
    double dLon = vmath.radians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(vmath.radians(lat1)) *
            cos(vmath.radians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * asin(sqrt(a));
    double valueResult = radius * c;
    double km = valueResult / 1;
    return km;
  }

  int selectIcon(String description) {
    final String text = description.toLowerCase();
    List<String> keyWords = [
      "ayuda",
      "robo",
      "asesinato",
      "secuestro",
      "pelea",
      "desmayo",
      "accidente"
    ];
    for (int i = 0; i < keyWords.length; i++) {
      if (text.contains(keyWords[i])) {
        return i;
      }
    }
    return 0;
  }
}
