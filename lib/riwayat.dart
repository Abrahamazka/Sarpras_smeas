import 'package:flutter/material.dart';
import 'pinjam.dart';
enum KategoriPinjam { barang, ruangan }
 
enum StatusPeminjaman { diproses, dipinjam, selesai, ditolak }
 
extension StatusPeminjamanX on StatusPeminjaman {
  String get label {
    switch (this) {
      case StatusPeminjaman.diproses:
        return 'Diproses';
      case StatusPeminjaman.dipinjam:
        return 'Dipinjam';
      case StatusPeminjaman.selesai:
        return 'Selesai';
      case StatusPeminjaman.ditolak:
        return 'Ditolak';
    }
  }
 
  Color get color {
    switch (this) {
      case StatusPeminjaman.diproses:
        return const Color(0xFFF5A623); 
      case StatusPeminjaman.dipinjam:
        return AppColors.primary; 
      case StatusPeminjaman.selesai:
        return const Color(0xFF2E9E5B);
      case StatusPeminjaman.ditolak:
        return const Color(0xFFE0503A);
    }
  }
}
 
class RiwayatEntry {
  const RiwayatEntry({
    required this.namaItem,
    required this.kategori,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.status,
  });
 
  final String namaItem;
  final KategoriPinjam kategori;
  final String tanggalMulai;
  final String tanggalSelesai;
  final StatusPeminjaman status;
}

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key, this.items});
 
  final List<RiwayatEntry>? items;
 
  static const List<RiwayatEntry> _dummy = [
    RiwayatEntry(
      namaItem: 'Proyektor Epson',
      kategori: KategoriPinjam.barang,
      tanggalMulai: '2 Agu 2026',
      tanggalSelesai: '4 Agu 2026',
      status: StatusPeminjaman.dipinjam,
    ),
    RiwayatEntry(
      namaItem: 'Ruang F 203',
      kategori: KategoriPinjam.ruangan,
      tanggalMulai: '28 Jul 2026',
      tanggalSelesai: '28 Jul 2026',
      status: StatusPeminjaman.selesai,
    ),
    RiwayatEntry(
      namaItem: 'Mic Wireless',
      kategori: KategoriPinjam.barang,
      tanggalMulai: '25 Jul 2026',
      tanggalSelesai: '-',
      status: StatusPeminjaman.diproses,
    ),
    RiwayatEntry(
      namaItem: 'Studio Musik',
      kategori: KategoriPinjam.ruangan,
      tanggalMulai: '20 Jul 2026',
      tanggalSelesai: '-',
      status: StatusPeminjaman.ditolak,
    ),
  ];
 
  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}
 
class _RiwayatPageState extends State<RiwayatPage> {
  StatusPeminjaman? _filter; 
 
  static const _filterOptions = [
    null,
    StatusPeminjaman.diproses,
    StatusPeminjaman.dipinjam,
    StatusPeminjaman.selesai,
    StatusPeminjaman.ditolak,
  ];
 
  @override
  Widget build(BuildContext context) {
    final data = widget.items ?? RiwayatPage._dummy;
    final filtered =
        _filter == null ? data : data.where((e) => e.status == _filter).toList();
 
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          _buildHeader(context),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: _buildFilterChips(),
          ),
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _RiwayatCard(entry: filtered[index]),
                  ),
          ),
        ],
      ),
    );
  }
 
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64,
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: SizedBox(
                  width: 90,
                  child: CustomPaint(painter: _DiagonalStripesPainter()),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.maybePop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      Container(
                        width: 26,
                        height: 26,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.history_rounded, size: 14, color: AppColors.primary),
                      ),
                      const SizedBox(width: 10),
                      const Flexible(
                        child: Text(
                          'RIWAYAT PEMINJAMAN',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
 
  Widget _buildFilterChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filterOptions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final option = _filterOptions[index];
          final selected = _filter == option;
          final label = option == null ? 'Semua' : option.label;
          return GestureDetector(
            onTap: () => setState(() => _filter = option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.fieldFill,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.textGrey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
 
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_outlined, size: 40, color: AppColors.textGrey),
          const SizedBox(height: 10),
          Text(
            'Belum ada riwayat',
            style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
 
class _RiwayatCard extends StatelessWidget {
  const _RiwayatCard({required this.entry});
 
  final RiwayatEntry entry;
 
  @override
  Widget build(BuildContext context) {
    final isBarang = entry.kategori == KategoriPinjam.barang;
 
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldFill, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Icon(
              isBarang ? Icons.inventory_2_outlined : Icons.meeting_room_outlined,
              color: AppColors.textDark,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.namaItem,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${isBarang ? "Barang" : "Ruangan"} • ${entry.tanggalMulai}'
                  '${entry.tanggalSelesai != "-" ? " - ${entry.tanggalSelesai}" : ""}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: entry.status.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              entry.status.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: entry.status.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
 
class _DiagonalStripesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      const Color(0xFFE53935),
      const Color(0xFF43A047),
      const Color(0xFFFFC107),
    ];
    final stripeWidth = size.width / colors.length;
    for (int i = 0; i < colors.length; i++) {
      final paint = Paint()..color = colors[i];
      final path = Path()
        ..moveTo(i * stripeWidth + 24, 0)
        ..lineTo((i + 1) * stripeWidth + 24, 0)
        ..lineTo((i + 1) * stripeWidth, size.height)
        ..lineTo(i * stripeWidth, size.height)
        ..close();
      canvas.drawPath(path, paint);
    }
  }
 
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
 