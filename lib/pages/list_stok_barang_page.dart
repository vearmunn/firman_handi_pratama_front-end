import 'package:firman_handi_pratama_front_end/pages/detail_barang_page.dart';
import 'package:firman_handi_pratama_front_end/pages/tambah_barang_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/barang_controller.dart';

class ListStokBarangPage extends StatefulWidget {
  const ListStokBarangPage({super.key});

  @override
  State<ListStokBarangPage> createState() => _ListStokBarangPageState();
}

class _ListStokBarangPageState extends State<ListStokBarangPage> {
  bool editMode = false;
  void toggleEditMode() {
    setState(() {
      editMode = !editMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final BarangController c = Get.put(BarangController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Stok Barang'),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
              child: TextField(
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(color: Colors.white38)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(color: Colors.white)),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white38,
                    ),
                    hintStyle: const TextStyle(color: Colors.white70),
                    hintText: 'Cari data...'),
                onChanged: (v) {
                  c.getAllBarang(query: v);
                },
              ),
            )),
      ),
      body: ListView(
        children: [
          Obx(
            () => c.semuabarang.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () => c.isLoading.value
                              ? const CircularProgressIndicator()
                              : Text(
                                  '${c.semuabarang.length} data ditampilkan',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                        ),
                        TextButton(
                            onPressed: () {
                              toggleEditMode();
                            },
                            child: const Text(
                              'Edit Data',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ),
          ),
          Obx(
            () => c.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : c.semuabarang.isEmpty
                    ? Image.asset(
                        'assets/images/no_data.png',
                        height: 350,
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: c.semuabarang.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = c.semuabarang[index];
                          return ListTile(
                            onTap: () => Get.to(() => DetailBarangPage(
                                  barang: item,
                                )),
                            leading: editMode
                                ? Obx(
                                    () => Checkbox(
                                        value: c.selectedIdBarang
                                            .contains(item.id),
                                        visualDensity: VisualDensity.compact,
                                        onChanged: (v) {
                                          if (c.selectedIdBarang
                                              .contains(item.id)) {
                                            c.selectedIdBarang.remove(item.id);
                                          } else {
                                            c.selectedIdBarang.add(item.id!);
                                          }
                                        }),
                                  )
                                : null,
                            title: Row(
                              children: [
                                Text(
                                  item.namaBarang,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text('Stok: ${item.stok}'),
                            trailing: Text(NumberFormat.currency(
                                    locale: 'id',
                                    decimalDigits: 0,
                                    symbol: 'Rp ')
                                .format(item.harga)),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                      ),
          ),
          Center(
            child: Obx(
              () => Padding(
                padding: EdgeInsets.only(top: c.semuabarang.isEmpty ? 0 : 16.0),
                child: Text(
                  c.semuabarang.isEmpty ? 'Tidak ada data!' : '',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: c.semuabarang.isEmpty ? 20 : 14),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: editMode
          ? null
          : FloatingActionButton(
              onPressed: () {
                Get.to(
                  () => TambahBarangPage(),
                );
              },
              child: const Icon(Icons.add),
            ),
      bottomSheet: editMode
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Obx(
                        () => Checkbox(
                            value: c.pilihSemua.value,
                            onChanged: (v) {
                              c.togglePilihSemua();
                            }),
                      ),
                      const Text('Pilih Semua')
                    ],
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text(
                      'Hapus Barang',
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Warning'),
                                content: const Text('Apakah Anda yakin?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      c.deleteMultipleBarang();
                                      setState(() {
                                        editMode = false;
                                      });
                                    },
                                    child: const Text('Ya'),
                                  ),
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Tidak'),
                                  )
                                ],
                              ));
                    },
                  )
                ],
              ),
            )
          : null,
    );
  }
}
