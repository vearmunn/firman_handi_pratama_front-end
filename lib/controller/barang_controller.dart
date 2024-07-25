import 'dart:io';

import 'package:firman_handi_pratama_front_end/controller/kategori_model.dart';
import 'package:firman_handi_pratama_front_end/database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/barang_model.dart';

class BarangController extends GetxController {
  var selectedIdBarang = RxList<int>();
  var pilihSemua = false.obs;

  var allKategori = RxList<Kategori>();
  var semuabarang = RxList<Barang>();

  var selectedImage = File('').obs;

  var isLoading = false.obs;

  var selectedIdKategori = 0.obs;
  var selectedKelompokBarang = ''.obs;
  late TextEditingController namaBarangController;
  late TextEditingController stokBarangController;
  late TextEditingController hargaBarangController;
  @override
  void onInit() {
    namaBarangController = TextEditingController();
    stokBarangController = TextEditingController();
    hargaBarangController = TextEditingController();
    getAllBarang();
    getAllKategori();
    super.onInit();
  }

  void clear() {
    namaBarangController.clear();
    stokBarangController.clear();
    hargaBarangController.clear();
    selectedIdKategori.value = 0;
    selectedKelompokBarang.value = '';
    selectedImage.value = File('');
  }

  @override
  void dispose() {
    namaBarangController.dispose();
    stokBarangController.dispose();
    hargaBarangController.dispose();
    super.dispose();
  }

  void togglePilihSemua() {
    pilihSemua.value = !pilihSemua.value;
    if (pilihSemua.value) {
      selectedIdBarang.clear();
      for (var e in semuabarang) {
        selectedIdBarang.add(e.id!);
      }
    } else {
      selectedIdBarang.clear();
    }
  }

  Future getAllBarang({String query = ''}) async {
    try {
      isLoading.value = true;
      final res = await AppDatabase().getAllBarang(query);
      semuabarang.value = res.map((json) => Barang.fromJson(json)).toList();
    } catch (e) {
      Get.snackbar('error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future getAllKategori() async {
    try {
      isLoading.value = true;
      final res = await AppDatabase().getAllKategori();
      allKategori.value = res.map((json) => Kategori.fromJson(json)).toList();
    } catch (e) {
      Get.snackbar('error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  String getKategori(int id) {
    final res = allKategori.firstWhere((e) => e.id == id);
    return res.namaKategori;
  }

  Future addBarang() async {
    try {
      isLoading.value = true;
      await AppDatabase().addBarang(
          namaBarang: namaBarangController.text,
          kelompokBarang: selectedKelompokBarang.value,
          stok: int.parse(stokBarangController.text),
          harga: int.parse(hargaBarangController.text
              .replaceAll("Rp ", "")
              .replaceAll(".", "")),
          idKategori: selectedIdKategori.value,
          imagePath: selectedImage.value.path);
      await getAllBarang();
      clear();
      Get.back();
    } catch (e) {
      Get.snackbar('error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future updateBarang(int idBarang) async {
    try {
      isLoading.value = true;
      await AppDatabase().updateBarang(
          id: idBarang,
          namaBarang: namaBarangController.text,
          kelompokBarang: selectedKelompokBarang.value,
          stok: int.parse(stokBarangController.text),
          harga: int.parse(hargaBarangController.text
              .replaceAll("Rp ", "")
              .replaceAll(".", "")),
          idKategori: selectedIdKategori.value,
          imagePath: selectedImage.value.path);
      await getAllBarang();
      clear();
      Get.back();
      Get.back();
    } catch (e) {
      Get.snackbar('error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future deleteBarang(int idBarang) async {
    try {
      isLoading.value = true;
      await AppDatabase().deleteBarang(
        id: idBarang,
      );
      await getAllBarang();
      Get.back();
    } catch (e) {
      Get.snackbar('error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future deleteMultipleBarang() async {
    try {
      isLoading.value = true;
      for (var id in selectedIdBarang) {
        await AppDatabase().deleteBarang(id: id);
      }
      await getAllBarang();
      pilihSemua.value = false;
      Get.back();
    } catch (e) {
      Get.snackbar('error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }
      selectedImage.value = File(image.path);
      update();
    } on PlatformException catch (e) {
      Get.snackbar('error', e.toString());
    }
  }
}
