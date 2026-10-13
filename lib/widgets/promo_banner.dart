import 'dart:async';
import 'package:flutter/material.dart';
import '../services/kantin_service.dart';

class PromoBanner extends StatefulWidget {
  final KantinService service;

  const PromoBanner({super.key, required this.service});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, dynamic>> _promos = [
    {
      'title': 'Diskon Mahasiswa Baru!',
      'desc': 'Gunakan kupon MAHASISWAHEMAT untuk potongan Rp 5.000',
      'code': 'MAHASISWAHEMAT',
      'colors': [const Color(0xFFC2185B), const Color(0xFFE91E63)],
      'icon': Icons.local_offer,
    },
    {
      'title': 'Paket Kenyang Labkom',
      'desc': 'Hemat Rp 7.500 khusus praktikan lab dengan kode LABKOMKENYANG',
      'code': 'LABKOMKENYANG',
      'colors': [const Color(0xFFE65100), const Color(0xFFFF8F00)],
      'icon': Icons.lunch_dining,
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (t) {
      if (_controller.hasClients) {
        final next = (_currentPage + 1) % _promos.length;
        _controller.animateToPage(
          next,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _promos.length,
            itemBuilder: (ctx, idx) {
              final p = _promos[idx];
              final colors = p['colors'] as List<Color>;
              final code = p['code'] as String;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colors.first.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            p['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            p['desc'] as String,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () {
                              widget.service.applyPromo(code);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Voucher "$code" berhasil diterapkan!'),
                                  backgroundColor: Colors.green.shade700,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Klaim: $code',
                                style: TextStyle(
                                  color: colors.first,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      p['icon'] as IconData,
                      size: 50,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_promos.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == i ? 18 : 6,
              height: 5,
              decoration: BoxDecoration(
                color: _currentPage == i ? Colors.deepOrange : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}
