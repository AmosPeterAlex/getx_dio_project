import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../model/data_model.dart';
import '../services/dio_service.dart';

class DataController extends GetxController {
  RxList<DataModel> dataS =
      RxList(); // RxList for storing data, similar to observable list
  RxBool isLoading = true.obs; // RxBool for tracking loading state
  RxBool isListDown = false.obs; // RxBool for tracking if list is scrolled down
  RxBool isNetConnected =
      true.obs; // RxBool for tracking internet connection status

  var url = 'https://jsonplaceholder.typicode.com/posts'; // API endpoint URL
  var scrollController =
      ItemScrollController(); // Scroll controller for controlling scroll position

  /// Function to check if internet is connected
  void isInternetConnected() async {
    isNetConnected.value = await InternetConnectionChecker()
        .hasConnection; // Check internet connection status and update observable
  }

  /// Function to fetch data from API
  fetchData() async {
    isInternetConnected(); // Check internet connection status
    isLoading.value = true; // Set loading state to true
    var response =
        await DioService().getData(url); // Make API call using DioService
    if (response.statusCode == 200) {
      response.data.forEach(
        (data) {
          dataS.add(
            DataModel.fromJson(
                data), // Parse API response and add data to RxList
          );
        },
      );
      isLoading.value =
          false; // Set loading state to false after data fetching is complete
    }
  }

  /// Function to scroll ListView to the bottom
  scrollToDown() {
    scrollController.scrollTo(
        index: dataS.length, // Scroll to the end of the list
        duration: const Duration(milliseconds: 1000), // Animation duration
        curve: Curves.bounceInOut); // Animation curve
    isListDown.value = true; // Update list scrolling direction
  }

  /// Function to scroll ListView to the top
  scrollToUp() {
    scrollController.scrollTo(
        index: 0, // Scroll to the beginning of the list
        duration: const Duration(milliseconds: 1000), // Animation duration
        curve: Curves.bounceInOut); // Animation curve
    isListDown.value = false; // Update list scrolling direction
  }
  //hide the floating navigation button while scrolling down, but should appear on scrolling up
  void onScrollingDown(double previousOffset, double currentOffset) {
    if (currentOffset > previousOffset) {
      // Scrolling down
      // Hide floating navigation button
      isListDown.value = true;
    }
  }

  void onScrollingUp(double previousOffset, double currentOffset) {
    if (currentOffset < previousOffset) {
      // Scrolling up
      // Show floating navigation button
      isListDown.value = false;
    }
  }
  @override
  void onInit() {
    fetchData(); // Fetch data when controller initializes
    isInternetConnected(); // Check internet connection status
    super.onInit();
  }
}

/*
import 'package:advanced_flutter/api/using%20dio/services/dio_service.dart';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../model/data_model.dart';

class DataController extends GetxController {
  RxList<DataModel> dataS = RxList(); //similar to -var dataS=[].obs
  RxBool isLoading = true.obs;
  RxBool isListDown = false.obs;
  RxBool isNetConnected = true.obs;

  var url = 'https://jsonplaceholder.typicode.com/posts';
  var scrollController =
      ItemScrollController(); //to control positions of scrollable

  ///to check the internet is connected or not
  void isInternetConnected() async {
    isNetConnected.value = await InternetConnectionChecker().hasConnection;
  }

  ///to fetch all the data from api
  fetchData() async {
    isInternetConnected();
    isLoading.value = true;
    var response = await DioService().getData(url);
    if (response.statusCode == 200) {
      response.data.forEach(
        (data) {
          // DataModel.fromJson(data);
          // -->was added later by other
          dataS.add(
            DataModel.fromJson(data),
          );
        },
      );
      isLoading.value = false;
    }
  }

  ///scroll ListView to down
  scrollToDown() {
    scrollController.scrollTo(
        index: dataS.length,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.bounceInOut);
    isListDown.value = true;
  }

  ///scroll ListView to up
  scrollToUp() {
    scrollController.scrollTo(
        index: 0,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.bounceInOut);
    isListDown.value = false;
  }

  @override
  void onInit() {
    fetchData();
    isInternetConnected();
    super.onInit();
  }
}
 */
