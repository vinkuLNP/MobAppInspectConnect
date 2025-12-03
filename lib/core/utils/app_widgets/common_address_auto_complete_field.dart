import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_text_style.dart';

class AddressAutocompleteField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String googleApiKey;
  final String? hint;

  final ValueChanged<AutocompletePrediction>? onAddressSelected;
  final ValueChanged<Map<String, dynamic>>? onFullAddressFetched;

  const AddressAutocompleteField({
    super.key,
    required this.label,
    required this.controller,
    required this.googleApiKey,
    this.hint,
    this.onAddressSelected,
    this.onFullAddressFetched,
  });

  @override
  State<AddressAutocompleteField> createState() =>
      _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<AddressAutocompleteField> {
  late FlutterGooglePlacesSdk _places;
  List<AutocompletePrediction> _predictions = [];

  @override
  void initState() {
    super.initState();
    _places = FlutterGooglePlacesSdk(widget.googleApiKey);
  }

  Future<void> _fetchPlaceDetails(String placeId) async {
    final details = await _places.fetchPlace(
      placeId,
      fields: [
        PlaceField.Address,
        PlaceField.AddressComponents,
        PlaceField.Location,
        PlaceField.Name,
        PlaceField.Types,
      ],
    );

    final place = details.place;
    if (place == null) return;

    String? city;
    String? state;
    String? pincode;
    String? country;

    for (var comp in place.addressComponents ?? []) {
      if (comp.types.contains("locality")) city = comp.name;
      if (comp.types.contains("administrative_area_level_1")) state = comp.name;
      if (comp.types.contains("postal_code")) pincode = comp.name;
      if (comp.types.contains("country")) country = comp.name;
    }

    widget.onFullAddressFetched?.call({
      "place_name": place.name,
      "city": city,
      "state": state,
      "pincode": pincode,
      "country": country,
      "lat": place.latLng?.lat,
      "lng": place.latLng?.lng,
      "place_type": place.types?.isNotEmpty == true
          ? place.types!.first.name
          : null,
    });
  }

  Future<void> _search(String input) async {
    if (input.isEmpty) {
      setState(() => _predictions = []);
      return;
    }

    final result = await _places.findAutocompletePredictions(input);
    setState(() {
      _predictions = result.predictions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(
          text: widget.label,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        const SizedBox(height: 8),

        TextFormField(
          controller: widget.controller,
          style: appTextStyle(fontSize: 12),
          onChanged: _search,
          minLines: 1,
          maxLines: 5,
          decoration: InputDecoration(
            counterText: "",
            hintText: widget.hint ?? "Search address",
            hintStyle: appTextStyle(fontSize: 12, color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.authThemeColor,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 12,
            ),
          ),
        ),

        const SizedBox(height: 5),

        ..._predictions.map(
          (p) => Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: ListTile(
              dense: true,
              leading: const Icon(Icons.location_on, size: 20),
              title: Text(p.fullText, style: appTextStyle(fontSize: 12)),
              onTap: () async {
                widget.controller.text = p.fullText;
                widget.onAddressSelected?.call(p);

                setState(() => _predictions = []);

                await _fetchPlaceDetails(p.placeId);
              },
            ),
          ),
        ),
      ],
    );
  }
}
