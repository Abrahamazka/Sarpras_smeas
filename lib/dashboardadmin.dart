import 'package:flutter/material.dart';
import 'main.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key, this.namaAdmin = 'Nama Admin'});

  final String namaAdmin;

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin>
    with SingleTickerProviderStateMixin {
  late final AnimationController _drawer = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  );

  static const double _drawerWidth = 250;
  static const double _dragExtent = 220;

  @override
  void dispose() {
    _drawer.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final delta = (details.primaryDelta ?? 0) / _dragExtent;
    _drawer.value = (_drawer.value + delta).clamp(0.0, 1.0);
  }

  void _onDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() > 700) {
      _drawer.animateTo(velocity > 0 ? 1 : 0, curve: Curves.easeOutCubic);
    } else {
      _drawer.animateTo(
        _drawer.value > 0.5 ? 1 : 0,
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _toggleDrawer() {
    _drawer.animateTo(_drawer.value > 0.5 ? 0 : 1, curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Halo, ${widget.namaAdmin}!',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Pantau aktivitas peminjaman sarpras hari ini.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textGrey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              title: 'Menunggu ACC',
                              count: '3',
                              icon: Icons.pending_actions_rounded,
                              color: const Color(0xFFF5A623),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _StatCard(
                              title: 'Sedang Dipinjam',
                              count: '12',
                              icon: Icons.outbox_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'Antrean Terbaru',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.only(bottom: 24),
                          itemCount: 5,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            return _RequestCard(
                              nama: 'Siswa Nomor ${index + 1}',
                              kelas: 'XII RPL 1',
                              barang: 'Proyektor Epson',
                              waktu: '${(index + 1) * 5} Menit yang lalu',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          AnimatedBuilder(
            animation: _drawer,
            builder: (context, child) {
              if (_drawer.value == 0) return const SizedBox.shrink();
              return Positioned.fill(
                child: GestureDetector(
                  onTap: () => _drawer.animateTo(0, curve: Curves.easeOutCubic),
                  child: Container(
                    color: Colors.black.withOpacity(0.35 * _drawer.value),
                  ),
                ),
              );
            },
          ),

          AnimatedBuilder(
            animation: _drawer,
            builder: (context, child) {
              final dx = -_drawerWidth * (1 - _drawer.value);
              return Transform.translate(offset: Offset(dx, 0), child: child);
            },
            child: _AdminDrawer(
              width: _drawerWidth,
              namaAdmin: widget.namaAdmin,
              onDragUpdate: _onDragUpdate,
              onDragEnd: _onDragEnd,
              onItemTap: () => _drawer.animateTo(0, curve: Curves.easeOutCubic),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            IconButton(
              onPressed: _toggleDrawer,
              icon: const Icon(Icons.menu_rounded, color: AppColors.textDark),
            ),
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 10),
            const Spacer(),
            Image.asset('assets/logo.png', height: 38, fit: BoxFit.contain),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _AdminDrawer extends StatelessWidget {
  const _AdminDrawer({
    required this.width,
    required this.namaAdmin,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onItemTap,
  });

  final double width;
  final String namaAdmin;
  final GestureDragUpdateCallback onDragUpdate;
  final GestureDragEndCallback onDragEnd;
  final VoidCallback onItemTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        elevation: 8,
        color: const Color(0xFF232733),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        child: SizedBox(
          width: width,
          height: double.infinity,
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                const CircleAvatar(
                  radius: 34,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/sarpras.png'),
                ),

                const SizedBox(height: 10),
                Text(
                  namaAdmin,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  color: Colors.white24,
                ),
                const SizedBox(height: 10),
                _DrawerTile(
                  icon: Icons.person_outline,
                  label: 'Data user',
                  onTap: () {
                    onItemTap(); // 1. Tutup laci dulu
                    // 2. Berangkat ke Ruang Data User
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlaceholderAdminPage(
                          title: 'Kelola Data User',
                        ),
                      ),
                    );
                  },
                ),
                _DrawerTile(
                  icon: Icons.inventory_2_outlined,
                  label: 'Daftar barang',
                  onTap: () {
                    onItemTap();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlaceholderAdminPage(
                          title: 'Katalog Barang Admin',
                        ),
                      ),
                    );
                  },
                ),
                _DrawerTile(
                  icon: Icons.history_rounded,
                  label: 'Aktivitas peminjaman',
                  onTap: () {
                    onItemTap();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlaceholderAdminPage(
                          title: 'Arsip Peminjaman Global',
                        ),
                      ),
                    );
                  },
                ),
                _DrawerTile(
                  icon: Icons.notifications_none_rounded,
                  label: 'Notifikasi peminjaman',
                  onTap: () {
                    onItemTap();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const PlaceholderAdminPage(title: 'notif admin'),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),
                Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  color: Colors.white24,
                ),
                const SizedBox(height: 10),
                _DrawerTile(
                  icon: Icons.logout_rounded,
                  label: 'Keluar',
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Konfirmasi'),
                        content: const Text('Apakah Bapak yakin ingin keluar?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Batal',
                              style: TextStyle(color: AppColors.textGrey),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false,
                              );
                            },
                            child: const Text(
                              'Ya, Keluar',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.white70),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  final String title;
  final String count;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            count,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.nama,
    required this.kelas,
    required this.barang,
    required this.waktu,
  });

  final String nama;
  final String kelas;
  final String barang;
  final String waktu;

  @override
  Widget build(BuildContext context) {
    // Fungsi pembantu khusus untuk merapikan teks di dalam Pop-up
    Widget buildDetailRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 60,
              child: Text(
                label,
                style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
              ),
            ),
            const Text(
              ':',
              style: TextStyle(fontSize: 12, color: AppColors.textGrey),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                nama,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                waktu,
                style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$kelas • Meminjam $barang',
            style: const TextStyle(fontSize: 13, color: AppColors.textDark),
          ),
          const SizedBox(height: 16),

          // TOMBOL BUKA POP-UP
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // --- MUNCULKAN MAP DETAIL DARI BAWAH ---
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // Biar tinggi pop-up ngikutin isi
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Garis handle atas
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: AppColors.fieldFill,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        const Text(
                          'Detail Pengajuan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // KOTAK DATA LENGKAP
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.1),
                            ),
                          ),
                          child: Column(
                            children: [
                              buildDetailRow('Nama', nama),
                              buildDetailRow('Kelas', kelas),
                              buildDetailRow('Barang', barang),
                              buildDetailRow(
                                'Tanggal',
                                'Hari ini - Besok',
                              ), // Contoh data dummy
                              buildDetailRow(
                                'Alasan',
                                'Untuk kebutuhan praktikum kejuruan di lab sekolah.',
                              ), // Contoh data dummy
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // TOMBOL EKSEKUSI (TOLAK / ACC)
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  // 1. Munculkan Kertas Tempel (Dialog) untuk mengisi alasan
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text(
                                        'Alasan Penolakan',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: TextField(
                                        maxLines: 2,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Misal: Barang sedang rusak...',
                                          hintStyle: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textGrey,
                                          ),
                                          filled: true,
                                          fillColor: AppColors.fieldFill,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text(
                                            'Batal',
                                            style: TextStyle(
                                              color: AppColors.textGrey,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(
                                              context,
                                            ); // Tutup Kertas Tempel (Dialog)
                                            Navigator.pop(
                                              context,
                                            ); // Tutup Map Dokumen (Bottom Sheet)
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Ditolak: Alasan telah dikirim ke Siswa',
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            'Kirim Penolakan',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(color: Colors.red),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Tolak',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                  ); // Tutup Map Dokumen (Bottom Sheet)
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Disetujui! Stempel Digital telah dikirim ke Siswa.',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Setujui',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Lihat Detail',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Ruangan Kosong Sementara untuk Menu Laci Admin
class PlaceholderAdminPage extends StatelessWidget {
  const PlaceholderAdminPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction_rounded,
              size: 80,
              color: AppColors.textGrey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Ruangan "$title" Sedang Dibangun',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
