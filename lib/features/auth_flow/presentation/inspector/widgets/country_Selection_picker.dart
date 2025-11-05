import 'package:flutter/material.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';

class LocationPickerExample extends StatefulWidget {
  @override
  _LocationPickerExampleState createState() => _LocationPickerExampleState();
}

class _LocationPickerExampleState extends State<LocationPickerExample> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Location")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
          
          ],
        ),
      ),
    );
  }
}
