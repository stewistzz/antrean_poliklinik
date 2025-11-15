import 'package:firebase_database/firebase_database.dart';

class AntreanService {
  final db = FirebaseDatabase.instance.ref();

  // Mapping prefix poli → nomor
  String getPrefix(String layananId) {
    switch (layananId) {
      case "POLI_UMUM":
        return "A";
      case "POLI_GIGI":
        return "B";
      default:
        return "X"; // fallback
    }
  }

  // fungsi generate nomor antrean
  Future<String> generateNomorAntrean(
    String layananId,
    String pasienUid,
  ) async {
    final prefix = getPrefix(layananId);

    final counterRef = db.child("counter_antrean/$layananId");

    // menambahkan transaction agar antrean terlindungi dari simultaneous request untuk menghindari nomor dobel, locat atauapun ketika pasien bersama2 mengambil nomor antrean
    // Gunakan transaction agar aman dari simultaneous request
    final transactionResult = await counterRef.runTransaction((currentValue) {
      int newValue = (currentValue as int? ?? 0) + 1;
      return Transaction.success(newValue);
    });

    if (!transactionResult.committed) {
      throw Exception("Gagal update counter antrean");
    }

    final nomorUrut = (transactionResult.snapshot.value ?? 0) as int;
    final nomorAntrean = "$prefix${nomorUrut.toString().padLeft(3, '0')}";

    // Simpan data antrean
    final antreanRef = db.child("antrean/$layananId/$nomorAntrean");

    await antreanRef.set({
      "nomor": nomorAntrean,
      "pasien_uid": pasienUid,
      "layanan_id": layananId,
      "loket_id": null,
      "status": "menunggu",
      "waktu_ambil": DateTime.now().toIso8601String(),
      "waktu_panggil": null,
      "waktu_selesai": null,
    });

    return nomorAntrean;
  }
}
