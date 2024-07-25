// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:firman_handi_pratama_front_end/controller/barang_controller.dart';
import 'package:firman_handi_pratama_front_end/utils/spacer.dart';
import 'package:firman_handi_pratama_front_end/widgets/custom_textfield.dart';

class TambahBarangPage extends StatelessWidget {
  final bool isEditing;
  final int idBarang;
  TambahBarangPage({super.key, this.isEditing = false, this.idBarang = 0});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final BarangController c = Get.find<BarangController>();
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Update Barang' : 'Tambah Barang'),
        leading: IconButton(
            onPressed: () {
              Get.back();
              c.clear();
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomTextfield(
                    label: 'Nama Barang',
                    hint: 'Masukkan Nama Barang',
                    controller: c.namaBarangController),
                verticalSpace(16),
                DropdownButtonFormField(
                    validator: (value) {
                      if (c.selectedIdKategori.value == 0) {
                        return 'Pilih kategori barang';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(16),
                        labelText: 'Kategori barang',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Colors.deepPurple)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey[400]!)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.red))),
                    hint: Text(c.selectedIdKategori.value == 0
                        ? 'Pilih Kategori Barang'
                        : c.getKategori(c.selectedIdKategori())),
                    items: c.allKategori
                        .map((e) => DropdownMenuItem(
                            value: e.id, child: Text(e.namaKategori)))
                        .toList(),
                    onChanged: (v) {
                      c.selectedIdKategori.value = v!;
                    }),
                verticalSpace(16),
                CustomTextfield(
                  hint: 'Masukkan Stok',
                  label: 'Stok',
                  controller: c.stokBarangController,
                  inputType: TextInputType.number,
                ),
                verticalSpace(16),
                DropdownButtonFormField(
                    validator: (value) {
                      if (c.selectedKelompokBarang.value == '') {
                        return 'Pilih kelompok barang';
                      }
                      return null;
                    },
                    hint: Text(c.selectedKelompokBarang.value == ''
                        ? 'Pilih Kelompok Barang'
                        : c.selectedKelompokBarang.value),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(16),
                        labelText: 'Kelompok Barang',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Colors.deepPurple)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.grey[400]!)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Colors.transparent)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.red))),
                    items: const [
                      DropdownMenuItem(
                          value: "Smartphone", child: Text("Smartphone")),
                      DropdownMenuItem(value: "Laptop", child: Text("Laptop")),
                    ],
                    onChanged: (v) {
                      c.selectedKelompokBarang.value = v!;
                    }),
                verticalSpace(16),
                CustomTextfield(
                  inputFormatter: [
                    CurrencyTextInputFormatter.currency(
                        locale: 'id', decimalDigits: 0, symbol: 'Rp ')
                  ],
                  hint: 'Masukkan Harga',
                  label: 'Harga',
                  controller: c.hargaBarangController,
                  inputType: TextInputType.number,
                ),
                verticalSpace(16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          elevation: 0,
                          side: BorderSide(width: 1, color: Colors.grey[400]!),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        c.pickImage();
                      },
                      icon: const Icon(Icons.image),
                      label: const Text('Pilih Gambar')),
                ),
                verticalSpace(12),
                Obx(() => c.selectedImage.value.path != ''
                    ? Image.file(c.selectedImage.value)
                    : const SizedBox.shrink()),
                verticalSpace(80),
                // const Spacer(),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
            onPressed: () {
              if (formKey.currentState!.validate() &&
                  c.selectedImage.value.path != '') {
                if (isEditing) {
                  c.updateBarang(idBarang);
                } else {
                  c.addBarang();
                }
              } else {
                Get.snackbar(
                    'Warning', 'Silakan lengkapi data terlebih dahulu!');
              }
            },
            child: Text(isEditing ? 'Update' : 'Tambah Barang')),
      ),
    );
  }
}
