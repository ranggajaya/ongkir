import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:ongkir/app/data/models/ongkir_model.dart';

class HomeController extends GetxController {
  TextEditingController beratC = TextEditingController();

  List<Ongkir> ongkir = [];

  RxBool isLoading = false.obs;

  RxString provAsalId = "0".obs;
  RxString cityAsalId = "0".obs;
  RxString provtujuanId = "0".obs;
  RxString citytujuanId = "0".obs;

  RxString codeKurir = "".obs;

  void cekOngkir() async {
    if (provAsalId.value != "0" &&
        provtujuanId.value != "0" &&
        cityAsalId.value != "0" &&
        citytujuanId.value != "0" &&
        codeKurir.value != "" &&
        beratC.text != "") {
      try {
        isLoading.value = true;
        var response = await http.post(
            Uri.parse('https://api.rajaongkir.com/starter/cost'),
            headers: {
              "key": "7c267cc3a9ee57b025b2a3f43dee4e79",
              "content-type": "application/x-www-form-urlencoded",
            },
            body: {
              "origin": cityAsalId.value,
              "destination": citytujuanId.value,
              "weight": beratC.text,
              "courier": codeKurir.value,
            });
        isLoading.value = false;
        List results = json.decode(response.body)['rajaongkir']['results'][0]
            ['costs'] as List;
        ongkir = Ongkir.fromJsonList(results);

        Get.defaultDialog(
          title: "ONGKOS KIRIM",
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ongkir
                .map((e) => ListTile(
                      title: Text("${e.service!.toUpperCase()}"),
                      subtitle: Text("Rp ${e.cost![0].value}"),
                    ))
                .toList(),
          ),
        );
      } catch (e) {
        print(e);
        Get.defaultDialog(
          title: "Terjadi Kesalahan",
          middleText: "Tidak dapat mengecek ongkos kirim",
        );
      }
    } else {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Data input belum lengkap",
      );
    }
  }
}
