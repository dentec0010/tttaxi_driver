
import 'package:flutter/material.dart';

import '../models/model_coord.dart';
import '../services/location_service.dart';

enum LocationProviderStatus {
  Initial,
  Loading,
  Success,
  Error,
}

class LocationProvider with ChangeNotifier {
  UserLocation _userLocation = UserLocation(0.0, 0.0);
  LocationServices _locationServices = LocationServices();

  LocationProviderStatus _status = LocationProviderStatus.Success;

  UserLocation get userLocation => _userLocation;

  LocationProviderStatus get status => _status;

  Future<void> getLocation() async {
    try {
      _updateStatus(LocationProviderStatus.Loading);
      _userLocation = await _locationServices.getCurrentLocation();
      _updateStatus(LocationProviderStatus.Success);
    } catch (e) {
      _updateStatus(LocationProviderStatus.Error);
    }
  }

  void _updateStatus(LocationProviderStatus status) {
    if (_status != status) {
      //developer.log('LocationProvider: Status updated from: $_status to: $status');
      _status = status;
      notifyListeners();
    }
  }
}