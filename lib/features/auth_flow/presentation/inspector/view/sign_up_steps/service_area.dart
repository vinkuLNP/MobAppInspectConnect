import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/stepper_header.dart';
import 'package:provider/provider.dart';
import '../../widgets/app_selector_field.dart';
import '../../widgets/country_state_cities_dialog.dart';

class ServiceAreaStep extends StatefulWidget {
  final InspectorViewModelProvider vm;
  final GlobalKey<FormState> formKey;

  const ServiceAreaStep(this.vm, this.formKey, {super.key});

  @override
  State<ServiceAreaStep> createState() => _ServiceAreaStepState();
}

class _ServiceAreaStepState extends State<ServiceAreaStep> {
  List<csc.Country>? cachedCountries;
  Map<String, List<csc.State>> cachedStates = {};
  Map<String, List<csc.City>> cachedCities = {};
  String? selectedCountryCode;
  String? selectedStateCode;
  List<String> selectedCityNames = [];
  bool loadingCountries = false;
  bool loadingStates = false;
  bool loadingCities = false;

  @override
  void initState() {
    super.initState();
    loadCountries();

    Future.microtask(() async {
      final vm = context.read<InspectorViewModelProvider>();

      await vm.setUserCurrentLocation();
    });
  }

  Future<void> loadCountries() async {
    if (cachedCountries != null) return;
    setState(() => loadingCountries = true);
    cachedCountries = await csc.getAllCountries();
    setState(() => loadingCountries = false);
  }

  Future<void> loadStates(String countryCode) async {
    if (cachedStates.containsKey(countryCode)) return;
    setState(() => loadingStates = true);
    cachedStates[countryCode] = await csc.getStatesOfCountry(countryCode);
    setState(() => loadingStates = false);
  }

  Future<void> loadCities(String countryCode) async {
    if (cachedCities.containsKey(countryCode)) return;
    setState(() => loadingCities = true);
    cachedCities[countryCode] = await csc.getCountryCities(countryCode);
    setState(() => loadingCities = false);
  }

  void openCitySelectionDialog() async {
    if (selectedCountryCode == null || selectedStateCode == null) return;

    final cities = (cachedCities[selectedCountryCode] ?? [])
        .where((c) => c.stateCode == selectedStateCode)
        .toList();

    final selected = await showMultiSelectSearchDialog<csc.City>(
      context: context,
      items: cities,
      itemAsString: (c) => c.name,
      title: "Select Cities",
      initiallySelected: cities
          .where((c) => selectedCityNames.contains(c.name))
          .toList(),
    );

    setState(() {
      selectedCityNames = selected.map((c) => c.name).toList();

      widget.vm.selectedCities
        ..clear()
        ..addAll(selectedCityNames);

      if (selectedCityNames.isNotEmpty) {
        widget.vm.clearCityErrors();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InspectorViewModelProvider>(
      builder: (_, vm, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle("Address Details"),
            const SizedBox(height: 10),

            textWidget(
              text: "Select your Service Area",
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSelectorField(
                  label: "Country",
                  value: selectedCountryCode == null
                      ? "Select Country"
                      : cachedCountries!
                            .firstWhere(
                              (c) => c.isoCode == selectedCountryCode!,
                            )
                            .name,
                  onTap: () async {
                    if (cachedCountries == null) return;

                    final selected =
                        await showSearchableListDialog<csc.Country>(
                          context: context,
                          items: cachedCountries!,
                          itemAsString: (c) => c.name,
                          title: "Country",
                        );

                    if (selected != null) {
                      setState(() {
                        selectedCountryCode = selected.isoCode;
                        selectedStateCode = null;
                        selectedCityNames.clear();
                      });
log(selected.toString());
                      widget.vm.setCountry(selected.isoCode);

                      await loadStates(selected.isoCode);
                      await loadCities(selected.isoCode);
                    }
                  },
                ),
                if (vm.countryError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4),
                    child: textWidget(
                      text: vm.countryError!,
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSelectorField(
                  label: "State",
                  value: selectedStateCode == null
                      ? "Select State"
                      : cachedStates[selectedCountryCode]!
                            .firstWhere((s) => s.isoCode == selectedStateCode!)
                            .name,
                  onTap: () async {
                    if (selectedCountryCode == null) return;

                    final states = cachedStates[selectedCountryCode] ?? [];
                    if (states.isEmpty) return;

                    final selected = await showSearchableListDialog<csc.State>(
                      context: context,
                      items: states,
                      itemAsString: (s) => s.name,
                      title: "State",
                    );

                    if (selected != null) {
                      setState(() {
                        selectedStateCode = selected.isoCode;
                        selectedCityNames.clear();
                      });
                      widget.vm.setState(selected.isoCode);
                    }
                  },
                ),
                if (vm.stateError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4),
                    child: textWidget(
                      text: vm.stateError!,
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),

            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textWidget(
                      text: "Select Cities",
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                    GestureDetector(
                      onTap: openCitySelectionDialog,
                      child: textWidget(
                        text: "Add / Edit",
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: AppColors.authThemeColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: selectedCityNames.isEmpty
                      ? textWidget(
                          text: "No cities selected",
                          color: Colors.grey,
                        )
                      : Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: selectedCityNames.map((city) {
                            return Chip(
                              backgroundColor: AppColors.selectionColor,
                              label: textWidget(text: city),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () {
                                setState(() {
                                  selectedCityNames.remove(city);
                                  widget.vm.selectedCities.remove(city);
                                  if (selectedCityNames.isNotEmpty) {
                                    widget.vm.clearCityErrors();
                                  } else {
                                    widget.vm.validateServiceArea();
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                ),

                if (vm.cityError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4),
                    child: textWidget(
                      text: vm.cityError!,
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 18),

            AppInputField(
              label: "Zip Code",
              hint: "123232",
              controller: vm.zipController,
              keyboardType: TextInputType.number,
              validator: (_) => vm.zipError,
              onChanged: (_) => vm.validateServiceArea(),
            ),
            const SizedBox(height: 12),

            AppInputField(
              label: "Enter your Mailing Address",
              hint: "Mailing address",
              controller: vm.mailingAddressController,
              validator: (_) => vm.mailingAddressError,
              onChanged: (_) => vm.validateServiceArea(),
            ),
          ],
        );
      },
    );
  }
}
