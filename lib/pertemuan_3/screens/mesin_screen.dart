import 'package:flutter/material.dart';
import '../services/rfid_service.dart';
import '../models/mesin_model.dart';

class MesinScreen extends StatefulWidget {
  const MesinScreen({super.key});

  @override
  State<MesinScreen> createState() => _MesinScreenState();
}

class _MesinScreenState extends State<MesinScreen> {
  late Future<List<Mesin>> futureMesin;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    setState(() => isLoading = true);
    try {
      futureMesin = RfidService.cekAllMesin();
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Mesin RFID'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: FutureBuilder<List<Mesin>>(
        future: futureMesin,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 50),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshData,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada mesin terdaftar'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final mesin = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: mesin.status ? Colors.green : Colors.red,
                    ),
                  ),
                  title: Text(
                    mesin.deviceId,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    mesin.status ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: mesin.status ? Colors.green : Colors.red,
                    ),
                  ),
                  trailing: Icon(
                    mesin.status ? Icons.check_circle : Icons.warning,
                    color: mesin.status ? Colors.green : Colors.red,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
