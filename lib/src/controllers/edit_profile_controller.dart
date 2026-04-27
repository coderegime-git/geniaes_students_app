import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api_services/urls.dart';
import '../models/country.dart'; // Country = wrapper, Data = individual item

class EditUserProfileController extends GetxController {
  TextEditingController userProfileFirstNameController =
      TextEditingController();
  TextEditingController userProfileLastNameController = TextEditingController();
  TextEditingController userProfilePhoneController = TextEditingController();
  TextEditingController userProfileUserNameController = TextEditingController();
  TextEditingController userProfileDescriptionController =
      TextEditingController();
  TextEditingController userProfileAddressLine1Controller =
      TextEditingController();
  TextEditingController userProfileZipCodeController = TextEditingController();

  String? userProfileSelectedGender;
  DateTime? userProfileSelectedDate;

  // Keep these for backward compat (used in editUserProfileImageRepo calls)
  String? userProfileSelectedCountry;
  String? userProfileSelectedState;
  String? userProfileSelectedCity;

  File? profileImage;
  String? uploadedProfileImage;
  List profileImagesList = [];

  // ─── Country / State / City lists ───
  List<Data> countryList = []; // ← Data, not Country
  List<Data> stateList = [];
  List<Data> cityList = [];

  // ─── Loading flags ───
  bool isLoadingCountries = false;
  bool isLoadingStates = false;
  bool isLoadingCities = false;

  // ─── Selected IDs (int) ───
  int? selectedCountryId;
  int? selectedStateId;
  int? selectedCityId;

  @override
  void onInit() {
    super.onInit();
    fetchCountries();
    // fetchStates();
  }

  // ─── Fetch Countries ───
  Future<void> fetchCountries() async {
    try {
      isLoadingCountries = true;
      update();

      final response = await GetConnect().get(
        countryURL,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200 && response.body != null) {
        final List dataList = response.body['data'];
        countryList = dataList.map((e) => Data.fromJson(e)).toList();
      }
    } catch (e) {
      print('Country fetch error: $e');
    } finally {
      isLoadingCountries = false;
      update();
    }
  }

  Future<void> fetchStates(int countryId) async {
    print('Fetching states for countryId: $countryId'); // ← check id is correct
    print('URL: $stateURL$countryId');     try {
      stateList = [];
      cityList = [];
      selectedStateId = null;
      selectedCityId = null;
      userProfileSelectedState = null;
      userProfileSelectedCity = null;
      isLoadingStates = true;
      update();

      final response = await GetConnect().get(
        '$stateURL$countryId',
        headers: {'Accept': 'application/json'},
      );

      print('State response status: ${response.statusCode}');
      // print('State response body: ${response.body}');

      if (response.statusCode == 200 && response.body != null) {
        final List? dataList = response.body['data'];
        if (dataList != null) {
          stateList = dataList.map((e) => Data.fromJson(e)).toList();
        }
      }
    } catch (e, stackTrace) {
      print('State fetch error: $e');
      print('Stack trace: $stackTrace');
    } finally {
      isLoadingStates = false;
      update();
    }
  }

  Future<void> fetchCities(int countryId, int stateId) async {
    try {
      cityList = [];
      selectedCityId = null;
      userProfileSelectedCity = null;
      isLoadingCities = true;
      update();

      final response = await GetConnect().get(
        '$cityURL$countryId&state_id=$stateId', // → .../cities?country_id=5&state_id=12
        headers: {'Accept': 'application/json'},
      );

      print('City response status: ${response.statusCode}');

      if (response.statusCode == 200 && response.body != null) {
        final List? dataList = response.body['data'];
        if (dataList != null) {
          cityList = dataList.map((e) => Data.fromJson(e)).toList();
        }
      }
    } catch (e, stackTrace) {
      print('City fetch error: $e');
      print('Stack trace: $stackTrace');
    } finally {
      isLoadingCities = false;
      update();
    }
  }

  // ─── Initialize Dropdowns from IDs ───
  Future<void> initializeDropdowns({int? cId, int? sId, int? cityId}) async {
    if (cId != null) {
      selectedCountryId = cId;
      if (countryList.isEmpty) await fetchCountries();
      
      Data? country;
      try {
        country = countryList.firstWhere((element) => element.id == cId);
      } catch (_) {}

      if (country != null) {
        userProfileSelectedCountry = country.name;
        await fetchStates(cId);
        if (sId != null) {
          selectedStateId = sId;
          Data? state;
          try {
            state = stateList.firstWhere((element) => element.id == sId);
          } catch (_) {}

          if (state != null) {
            userProfileSelectedState = state.name;
            await fetchCities(cId, sId);
            if (cityId != null) {
              selectedCityId = cityId;
              Data? city;
              try {
                city = cityList.firstWhere((element) => element.id == cityId);
              } catch (_) {}
              
              if (city != null) {
                userProfileSelectedCity = city.name;
              }
            }
          }
        }
      }
      update();
    }
  }

  bool getUserProfileDataCheck = false;

  changeGetUserProfileDataCheck(bool value) {
    getUserProfileDataCheck = value;
    update();
  }
}
