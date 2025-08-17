import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../models/mesin_model.dart';

class RfidService {
  static const String baseUrl =
      'https://edupanda.man2kotamalang.sch.id/api/rfid';

  static Future<List<Mesin>> cekAllMesin() async {
    // try {
    final response = await http.get(
      Uri.parse('$baseUrl/cek_all_mesin'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      // Sesuaikan dengan struktur response Laravel
      if (jsonData['success'] == true) {
        final List<dynamic> mesinList = jsonData['data'];
        return mesinList.map((mesin) => Mesin.fromJson(mesin)).toList();
      } else {
        throw Exception(jsonData['message'] ?? 'Gagal memuat data mesin');
      }
      // else {
      //   throw Exception('HTTP Error: ${response.statusCode}');
      // }

      // } on TimeoutException {
      //   throw Exception('Timeout, server tidak merespon');
      // } on SocketException {
      //   throw Exception('Tidak ada koneksi internet');
      // }
    }
  }
}
