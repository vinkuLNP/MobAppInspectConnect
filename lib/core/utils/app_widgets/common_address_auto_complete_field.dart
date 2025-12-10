import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_text_style.dart';

enum AddressFieldStyle { appInput, bookingInput }

class AddressAutocompleteField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String googleApiKey;
  final String? hint;
  final String? Function(String?)? validator;
  final ValueChanged<AutocompletePrediction>? onAddressSelected;
  final ValueChanged<Map<String, dynamic>>? onFullAddressFetched;
  final Function(String?)? onChanged;
  final AddressFieldStyle style;

  const AddressAutocompleteField({
    super.key,
    required this.label,
    required this.controller,
    required this.googleApiKey,
    this.hint = 'Enter Address',
    this.validator,
    this.onAddressSelected,
    this.onFullAddressFetched,
    this.onChanged,
    this.style = AddressFieldStyle.appInput,
  });

  @override
  State<AddressAutocompleteField> createState() =>
      _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<AddressAutocompleteField> {
  FlutterGooglePlacesSdk? _places;
  bool _placesAvailable = true;
  List<AutocompletePrediction> _predictions = [];

  @override
  void initState() {
    super.initState();
    _initializePlaces();
  }

  void _initializePlaces() {
    try {
      if (widget.googleApiKey.isNotEmpty) {
        _places = FlutterGooglePlacesSdk(widget.googleApiKey);
      } else {
        throw Exception('API key is empty → fallback mode');
      }
    } catch (e) {
      debugPrint("❌ Google Places init failed → fallback mode\n$e");
      _switchToFallback();
    }
  }

  Future<void> _search(String input) async {
    if (!_placesAvailable || _places == null || input.isEmpty) {
      setState(() => _predictions = []);
      return;
    }

    try {
      final result = await _places!.findAutocompletePredictions(input);
      if (!mounted) return;

      setState(() => _predictions = result.predictions);
    } catch (e) {
      debugPrint("❌ Prediction search failed → fallback mode\n$e");
      _switchToFallback();
    }
  }

  Future<void> _fetchPlaceDetails(String placeId) async {
    if (!_placesAvailable || _places == null) return;

    try {
      final details = await _places!.fetchPlace(
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

      Map<String, String?> components = {
        "city": null,
        "state": null,
        "pincode": null,
        "country": null,
      };

      for (var comp in place.addressComponents ?? []) {
        if (comp.types.contains("locality")) components["city"] = comp.name;
        if (comp.types.contains("administrative_area_level_1")) components["state"] = comp.name;
        if (comp.types.contains("postal_code")) components["pincode"] = comp.name;
        if (comp.types.contains("country")) components["country"] = comp.name;
      }

      widget.onFullAddressFetched?.call({
        "place_name": place.name,
        ...components,
        "lat": place.latLng?.lat,
        "lng": place.latLng?.lng,
        "place_type": place.types?.isNotEmpty == true ? place.types!.first.name : null,
      });

    } catch (e) {
      debugPrint("❌ Place details fetch failed → fallback mode\n$e");
      _switchToFallback();
    }
  }

  void _switchToFallback() {
    if (mounted) {
      setState(() {
        _placesAvailable = false;
        _places = null;
        _predictions = [];
      });
    }
  }

  InputDecoration _appInputDecoration() => InputDecoration(
        counterText: "",
        hintText: widget.hint,
        filled: false,
        errorStyle: appTextStyle(fontSize: 12, color: Colors.red),
        hintStyle: appTextStyle(fontSize: 12, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColors.authThemeColor, width: 2),
        ),
      );

  InputDecoration _bookingStyleDecoration() => InputDecoration(
        counterText: "",
        hintText: widget.hint,
        filled: true,
        fillColor: Colors.grey.shade50,
        errorStyle: appTextStyle(fontSize: 12, color: Colors.red),
        hintStyle: appTextStyle(fontSize: 12, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.authThemeColor),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final bool isBooking = widget.style == AddressFieldStyle.bookingInput;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(
          text: widget.label,
          fontWeight: isBooking ? FontWeight.w600 : FontWeight.w400,
          fontSize: isBooking ? 12 : 14,
        ),
        SizedBox(height: isBooking ? 3 : 8),
        TextFormField(
          controller: widget.controller,
          minLines: 1,
          maxLines: 5,
          style: appTextStyle(fontSize: 12),
          validator: widget.validator,
          decoration: isBooking ? _bookingStyleDecoration() : _appInputDecoration(),
          onChanged: (value) {
            _search(value);
            widget.onChanged?.call(value);
              if (!isBooking) {
              if (Form.of(context).widget.autovalidateMode ==
                  AutovalidateMode.always) {
                Form.of(context).validate();
              }
            }
          },
        ),
        const SizedBox(height: 5),
        if (_placesAvailable)
          ..._predictions.map(
            (p) => Container(
              margin: EdgeInsets.only(
                top: 4,
                left: isBooking ? 16 : 0,
                right: isBooking ? 16 : 0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isBooking ? 12 : 10),
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
