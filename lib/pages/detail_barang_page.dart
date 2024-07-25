// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:firman_handi_pratama_front_end/pages/tambah_barang_page.dart';
import 'package:firman_handi_pratama_front_end/utils/spacer.dart';

import '../controller/barang_controller.dart';
import '../models/barang_model.dart';

class DetailBarangPage extends StatelessWidget {
  final Barang barang;

  const DetailBarangPage({
    super.key,
    required this.barang,
  });

  @override
  Widget build(BuildContext context) {
    final BarangController c = Get.find<BarangController>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.file(File(barang.imagePath)),
                SafeArea(
                  child: CustomBackButton(
                    onTap: () => Get.back(),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    barang.namaBarang,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  verticalSpace(8),
                  Text(
                    NumberFormat.currency(
                            locale: 'id', decimalDigits: 0, symbol: 'Rp ')
                        .format(barang.harga),
                    style: const TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  verticalSpace(20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.deepPurple[50],
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        ItemDescription(
                          label: 'Kategori',
                          content: c.getKategori(barang.idKategori),
                        ),
                        const Divider(),
                        verticalSpace(10),
                        ItemDescription(
                          label: 'Stok',
                          content: barang.stok.toString(),
                        ),
                        const Divider(),
                        verticalSpace(10),
                        ItemDescription(
                            label: 'Kelompok', content: barang.kelompokBarang)
                      ],
                    ),
                  ),
                  verticalSpace(100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                // width: double.infinity,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.all(16),
                        elevation: 0,
                        side: const BorderSide(width: 1, color: Colors.red),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Warning'),
                                content: const Text('Apakah Anda yakin?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => c.deleteBarang(barang.id!),
                                    child: const Text('Ya'),
                                  ),
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Tidak'),
                                  )
                                ],
                              ));
                    },
                    child: const Text('Hapus')),
              ),
            ),
            horizontalSpace(16),
            Expanded(
              child: SizedBox(
                // width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                    onPressed: () {
                      c.namaBarangController.text = barang.namaBarang;
                      c.selectedIdKategori.value = barang.idKategori;
                      c.stokBarangController.text = barang.stok.toString();
                      c.selectedKelompokBarang.value = barang.kelompokBarang;
                      c.hargaBarangController.text = barang.harga.toString();
                      c.selectedImage.value = File(barang.imagePath);
                      Get.to(() => TambahBarangPage(
                            idBarang: barang.id!,
                            isEditing: true,
                          ));
                    },
                    child: const Text('Edit')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemDescription extends StatelessWidget {
  const ItemDescription({
    super.key,
    required this.label,
    required this.content,
  });

  final String label;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            content,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  final VoidCallback onTap;
  const CustomBackButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.black26, borderRadius: BorderRadius.circular(50)),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          )),
    );
  }
}
