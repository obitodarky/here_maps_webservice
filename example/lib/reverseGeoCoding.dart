import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:here_maps_webservice/here_maps_webservice.dart';
import 'package:location/location.dart' as l;
import 'package:flutter/services.dart';

class ReverseGeoCoding extends StatefulWidget {
  @override
  _ReverseGeoCodingState createState() => _ReverseGeoCodingState();
}

class _ReverseGeoCodingState extends State<ReverseGeoCoding> {
  var currentLocation;
  String address;
  @override
  void initState() {
    doReverseGeoCoding();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reverse GeoCoding"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          DropdownButton<Container>(
            items: <Container>[
              getContainer(ReverseGeoCodeModes.retrieveAddresses, "Get Addresses"),
      ].map<DropdownMenuItem<Container>>((Container value){
                return DropdownMenuItem<Container>(
                  child: value
                );
            }).toList()
          ),
          Container(
            alignment: Alignment.center,
            child: Text(currentLocation!=null?
                "${currentLocation.latitude},${currentLocation.longitude}":"Loading"),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.all(24),
            alignment: Alignment.center,
            child: Text(address??"Loading"),
          ),
        ],
      ),
    );
  }

  void doReverseGeoCoding({ReverseGeoCodeModes geoCodeMode = ReverseGeoCodeModes.retrieveAreas}) async {
    var location = new l.Location();

    try {
      await location.getLocation().then((location) {
        print(location);
        setState(() {
          currentLocation = location;
        });
      });
      HereMaps(apiKey: "your apiKey")
          .reverseGeoCode(mode: geoCodeMode,
              lat: currentLocation.latitude, lon: currentLocation.longitude)
          .then((response) {
        print(response);
        setState(() {
          address = response['Response']['View'][0]['Result'][0]['Location']
          ['Address']['Label'];
        });
      });
    } on PlatformException catch (error) {
      if (error.code == 'PERMISSION_DENIED') {
        print("Permission Dennied");
      }
    }
  }
  getContainer(ReverseGeoCodeModes geoCodeMode, String text){
    return  Container(
      padding: EdgeInsets.only(bottom: 20),
      child: FlatButton(
        onPressed: (){
          address = "Loading";
          doReverseGeoCoding(geoCodeMode: geoCodeMode);
        },
        child: Text(text, style: TextStyle(color: Colors.white),),
        color: Colors.blueAccent,
      ),
    );
  }
}
