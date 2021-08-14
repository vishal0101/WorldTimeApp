import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {

  String location; // location name for the UI
  String time; // the time in that location
  String flag; // url to an asset flag icon
  String url; // location url for api endpoint
  bool isDaytime = true; // true or false if daytime or not

  WorldTime({ this.location, this.flag, this.url});

  Future<void> getTime() async {

    try{
      // make a request
      Response response = await get('http://worldtimeapi.org/api/timezone/$url');
      Map data = jsonDecode(response.body);
      //print(data);

      // get properties from data
      String dateTime = data['datetime'];
      String offset = data['utc_offset'].substring(1,3);
      String min_offset = data['utc_offset'].substring(4,6);
      // print(dateTime);
      // print(offset);

      // create DateTime object
      DateTime now = DateTime.parse(dateTime);
      now = now.add(Duration(hours: int.parse(offset)));
      now = now.add(Duration(minutes: int.parse(min_offset)));

      // set the time property
      isDaytime = (now.hour > 6 && now.hour < 20) ? true : false;
      time = DateFormat.jm().format(now);
    }

    catch (e) {
      print('caught error: $e');
      time = 'Could not get time data';
    }

  }

}