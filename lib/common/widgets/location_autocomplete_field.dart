import 'dart:async';

import 'package:dirve_society/common/app_color/app_colors.dart';
import 'package:dirve_society/common/app_text_style/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nominatim/flutter_nominatim.dart';

class LocationSearchResult {
  const LocationSearchResult({
    required this.address,
    this.latitude,
    this.longitude,
  });

  final String address;
  final double? latitude;
  final double? longitude;

  factory LocationSearchResult.fromJson(Map<String, dynamic> json) {
    return LocationSearchResult(
      address: json['display_name']?.toString() ?? '',
      latitude: double.tryParse(json['lat']?.toString() ?? ''),
      longitude: double.tryParse(json['lon']?.toString() ?? ''),
    );
  }
}

class LocationAutocompleteField extends StatefulWidget {
  const LocationAutocompleteField({
    super.key,
    required this.controller,
    required this.onSelected,
    this.hintText = 'Search location',
    this.label,
    this.validator,
    this.textColor,
    this.hintTextStyle,
    this.borderColor,
    this.suffixIconColor,
    this.suggestionsBackgroundColor,
  });

  final TextEditingController controller;
  final ValueChanged<LocationSearchResult> onSelected;
  final String hintText;
  final String? label;
  final String? Function(String?)? validator;
  final Color? textColor;
  final TextStyle? hintTextStyle;
  final Color? borderColor;
  final Color? suffixIconColor;
  final Color? suggestionsBackgroundColor;

  @override
  State<LocationAutocompleteField> createState() =>
      _LocationAutocompleteFieldState();
}

class _LocationAutocompleteFieldState extends State<LocationAutocompleteField> {
  final Nominatim _nominatim = Nominatim.instance;
  final List<LocationSearchResult> _suggestions = [];
  Timer? _debounce;
  bool _isLoading = false;
  String _lastSelectedAddress = '';
  bool _skipNextSearch = false;
  String _activeQuery = '';

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChange);
  }

  void _handleTextChange() {
    if (_skipNextSearch) {
      _skipNextSearch = false;
      return;
    }

    final query = widget.controller.text.trim();

    if (query != _lastSelectedAddress && _suggestions.isEmpty == false) {
      setState(() {
        _lastSelectedAddress = '';
      });
    }

    _debounce?.cancel();

    if (query.length < 3) {
      setState(() {
        _isLoading = false;
        _suggestions.clear();
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () {
      _searchLocations(query);
    });
  }

  Future<void> _searchLocations(String query) async {
    _activeQuery = query;
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await _nominatim.search(query);

      if (!mounted) return;
      if (_activeQuery != query) return;
      if (widget.controller.text.trim() != query) return;
      if (_lastSelectedAddress == widget.controller.text.trim()) {
        setState(() {
          _suggestions.clear();
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _suggestions
          ..clear()
          ..addAll(
            results
                .map(
                  (place) => LocationSearchResult(
                    address: place.displayName.toString(),
                    latitude: double.tryParse(place.latitude.toString()),
                    longitude: double.tryParse(place.longitude.toString()),
                  ),
                )
                .where((item) => item.address.isNotEmpty)
                .take(5),
          );
      });
    } catch (_) {
      if (!mounted) return;
      if (_activeQuery != query) return;
      setState(() {
        _suggestions.clear();
      });
    } finally {
      if (!mounted) return;
      if (_activeQuery != query) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _selectLocation(LocationSearchResult result) {
    _lastSelectedAddress = result.address;
    _skipNextSearch = true;
    widget.controller.text = result.address;
    widget.controller.selection = TextSelection.fromPosition(
      TextPosition(offset: widget.controller.text.length),
    );
    widget.onSelected(result);
    FocusScope.of(context).unfocus();

    setState(() {
      _suggestions.clear();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: h5),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: widget.borderColor ?? AppColors.borderColor),
          ),
          child: TextFormField(
            controller: widget.controller,
            validator: widget.validator,
            style: TextStyle(color: widget.textColor ?? AppColors.black),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle:
                  widget.hintTextStyle ?? h5.copyWith(color: AppColors.black),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
              suffixIcon: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                  : Icon(
                      Icons.search,
                      color: widget.suffixIconColor,
                    ),
            ),
          ),
        ),
        if (_suggestions.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: widget.suggestionsBackgroundColor ?? Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: widget.borderColor ?? AppColors.borderColor),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _suggestions.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, thickness: 0.6),
              itemBuilder: (context, index) {
                final item = _suggestions[index];
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(
                    item.address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: h6,
                  ),
                  onTap: () => _selectLocation(item),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(_handleTextChange);
    _nominatim.dispose();
    super.dispose();
  }
}
