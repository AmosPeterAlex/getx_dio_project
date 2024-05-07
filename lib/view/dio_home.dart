// import 'package:advanced_flutter/api/using%20dio/controller/data_controller.dart';
// import 'package:advanced_flutter/api/using%20dio/utils%20or%20constants/colors.dart';
// import 'package:advanced_flutter/api/using%20dio/utils%20or%20constants/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../controller/data_controller.dart';
import '../utils or constants/colors.dart';
import '../utils or constants/app_utils.dart';

class HomeDio extends StatelessWidget {
  HomeDio({super.key});

  final DataController controller =
      Get.put(DataController()); //initialize the controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.prColor,
        title: const Text("Dio AppBar"),
      ),
      backgroundColor: MyColors.bgColor,
      floatingActionButton: Obx(
        () => controller.isNetConnected.value ? _buildFAB() : Container(),
      ),
      body: Obx(
        () => SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: controller.isNetConnected.value
              ? (controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : getData())
              : noInternet(context),
        ),
      ),
    );
  }

  FloatingActionButton _buildFAB() {
    return FloatingActionButton(
      onPressed: () {
        controller.isListDown.value
            ? controller.scrollToUp()
            : controller.scrollToDown();
      },
      backgroundColor: MyColors.scColor,
      child: FaIcon(controller.isListDown.value
          ? FontAwesomeIcons.arrowUp
          : FontAwesomeIcons.arrowDown),
    );
  }

  RefreshIndicator getData() {
    return RefreshIndicator(
      child: ScrollablePositionedList.builder(
        itemScrollController: controller.scrollController,
        itemCount: controller.dataS.length,
        itemBuilder: (context, index) => InkWell(
          // onTap: () => Get.to(),
          child: Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: MyColors.scColor,
                child: Text(
                  controller.dataS[index].id.toString(),
                ),
              ),
              title: Text("${controller.dataS[index].title}"),
              subtitle: Text('${controller.dataS[index].body}'),
              trailing: Text(
                controller.dataS[index].userId.toString(),
              ), //was added by me
            ),
          ),
        ),
      ),
      onRefresh: () {
        return controller.fetchData();
      },
    );
  }

  Center noInternet(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("No Internet"),
          MaterialButton(
            color: MyColors.scColor,
            onPressed: () async {
              if (await InternetConnectionChecker().hasConnection == true) {
                controller.fetchData();
              } else {
                showCustomSnackBar(context);
              }
            },
            child: const Text('Try Again'),
          )
        ],
      ),
    );
  }
}
