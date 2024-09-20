import 'dart:convert';

import 'package:app/Service/random_password.dart';
import 'package:app/models/coperate.dart';
import 'package:app/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController
    with StateMixin<List<Coperate>> {
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final _emailValid = false.obs;
  final _passwordValid = false.obs;
  RxBool get valid => (_emailValid() && _passwordValid()).obs;

  final corps = <Coperate>[].obs;
  final selectedCorp = const Coperate().obs;
  final selectedSite = const Site().obs;

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.loading());

    loadCoperate();
    passwordController(TextEditingController(text: RandomPassword().password));

    emailController().addListener(() {
      if (emailController().text.characters.isEmpty) {
        _emailValid(false);
      } else {
        _emailValid(true);
      }
    });

    passwordController().addListener(() {
      if (passwordController().text.characters.isEmpty) {
        _passwordValid(false);
      } else {
        _passwordValid(true);
      }
    });
  }

  @override
  void onClose() {
    emailController().dispose();
    passwordController().dispose();
    super.onClose();
  }

  void loadCoperate() async {
    ApiService.to.getCoperates().then((response) {
      if (response.status.isOk) {
        final body = json.decode(response.bodyString!) as List<dynamic>;
        final coperate = body
            .map((e) => Coperate.fromJson(e as Map<String, dynamic>))
            .toList();
        corps(coperate);
        setCorp(coperate[0]);
        change(coperate, status: RxStatus.success());
        return;
      }
      change(null,
          status:
              RxStatus.error('Something went wrong,\nPlease try again later.'));
    }).onError((error, stackTrace) {
      change(null,
          status:
              RxStatus.error('Something went wrong,\nPlease try again later.'));
    });
  }

  void setCorp(Coperate corp) {
    selectedCorp(corp);
    selectedSite(corp.sites[0]);
  }

  void setSite(Site site) {
    selectedSite(site);
  }

  void gotoCardCapture() {}
}