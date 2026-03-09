import 'dart:async';
import 'package:flutter/material.dart';

const kBg      = Color(0xFF020B18);
const kBg2     = Color(0xFF051525);
const kCyan    = Color(0xFF22D3EE);
const kCyan2   = Color(0xFF06B6D4);
const kTeal    = Color(0xFF14B8A6);
const kIce     = Color(0xFFBAE6FD);
const kNavy    = Color(0xFF0C1F35);
const kText    = Color(0xFFCBD5E1);
const kMuted   = Color(0xFF475569);
const kWhite   = Color(0xFFF0F9FF);

class _Testimonial {
  final String name;
  final String role;
  final String company;
  final String feedback;
  final int rating;
  final String avatar;
  final List<Color> colors;

  const _Testimonial({
    required this.name,
    required this.role,
    required this.company,
    required this.feedback,
    required this.rating,
    required this.avatar,
    required this.colors,
  });
}


class TestimonialSlider extends StatefulWidget {
  const TestimonialSlider({super.key});

  @override
  State<TestimonialSlider> createState() => _TestimonialSliderState();
}

class _TestimonialSliderState extends State<TestimonialSlider>
    with TickerProviderStateMixin {

  static const _items = [

    _Testimonial(
      name: 'Sarah Johnson',
      role: 'Product Manager',
      company: 'TechCorp USA',
      feedback:
      'Huzaifa delivered an exceptional Flutter app. The animations are smooth, '
          'the code is clean, and he was always responsive. Highly recommended!',
      rating: 5,
      avatar: '👩‍💼',
      colors: [Color(0xFF22D3EE), Color(0xFF06B6D4)],
    ),
    // _Testimonial(
    //   name: 'Ahmed Al-Rashid',
    //   role: 'CEO',
    //   company: 'StartupHub Dubai',
    //   feedback:
    //   'Outstanding work on our chef booking app! He understood the requirements '
    //       'perfectly and delivered ahead of schedule. Will hire again!',
    //   rating: 5,
    //   avatar: '👨‍💻',
    //   colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
    // ),
    _Testimonial(
      name: 'Emily Chen',
      role: 'CTO',
      company: 'JobsInApp Inc.',
      feedback:
      'Incredible attention to UI details. The job-finding app looks and feels '
          'premium. Firebase integration was flawless. 10/10 experience.',
      rating: 5,
      avatar: '👩‍🔬',
      colors: [Color(0xFF818CF8), Color(0xFFA78BFA)],
    ),
    _Testimonial(
      name: 'Marcus Weber',
      role: 'Founder',
      company: 'AppStudio Berlin',
      feedback:
      'Huzaifa has a rare talent for combining beautiful design with solid '
          'engineering. The app performance is top-notch on both iOS and Android.',
      rating: 5,
      avatar: '🧑‍🎨',
      colors: [Color(0xFF4ADE80), Color(0xFF22C55E)],
    ),
  ];

  late PageController _pageCtrl;
  late AnimationController _autoCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _cardEntryCtrl;

  late Animation<double> _glowAnim;
  late Animation<double> _cardFade;
  late Animation<Offset>  _cardSlide;

  int _current = 0;
  Timer? _autoTimer;

  @override
  void initState() {
    super.initState();

    _pageCtrl = PageController(viewportFraction: 0.92);

    _glowCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.6, end: 1.0)
        .animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

    _cardEntryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _cardFade  = CurvedAnimation(parent: _cardEntryCtrl, curve: Curves.easeOut);
    _cardSlide = Tween<Offset>(
        begin: const Offset(0.08, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _cardEntryCtrl, curve: Curves.easeOutCubic));
    _cardEntryCtrl.forward();

    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_current + 1) % _items.length;
      _pageCtrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    _glowCtrl.dispose();
    _cardEntryCtrl.dispose();
    _autoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // ── page view ──
      SizedBox(
        height: 230,
        child: PageView.builder(
          controller: _pageCtrl,
          itemCount: _items.length,
          onPageChanged: (i) {
            setState(() => _current = i);
            _cardEntryCtrl.reset();
            _cardEntryCtrl.forward();
            _startAutoSlide();
          },
          itemBuilder: (_, i) {
            final item = _items[i];
            final isActive = i == _current;
            return AnimatedScale(
              scale: isActive ? 1.0 : 0.93,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
              child: AnimatedOpacity(
                opacity: isActive ? 1.0 : 0.55,
                duration: const Duration(milliseconds: 400),
                child: _TestimonialCard(
                  item: item,
                  glowAnim: _glowAnim,
                  isActive: isActive,
                  cardFade: isActive ? _cardFade : const AlwaysStoppedAnimation(1.0),
                  cardSlide: isActive ? _cardSlide : const AlwaysStoppedAnimation(Offset.zero),
                ),
              ),
            );
          },
        ),
      ),

      const SizedBox(height: 20),

      // ── dot indicators ──
      AnimatedBuilder(
        animation: _glowAnim,
        builder: (_, __) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_items.length, (i) {
            final isActive = i == _current;
            final color = _items[i].colors[0];
            return GestureDetector(
              onTap: () {
                _pageCtrl.animateToPage(i,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOutCubic);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isActive
                      ? color
                      : kMuted.withOpacity(0.35),
                  boxShadow: isActive
                      ? [BoxShadow(
                    color: color.withOpacity(0.6 * _glowAnim.value),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )]
                      : [],
                ),
              ),
            );
          }),
        ),
      ),
    ]);
  }
}


class _TestimonialCard extends StatelessWidget {
  final _Testimonial item;
  final Animation<double> glowAnim;
  final Animation<double> cardFade;
  final Animation<Offset>  cardSlide;
  final bool isActive;

  const _TestimonialCard({
    required this.item,
    required this.glowAnim,
    required this.cardFade,
    required this.cardSlide,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final c1 = item.colors[0];
    final c2 = item.colors[1];

    return AnimatedBuilder(
      animation: Listenable.merge([glowAnim, cardFade, cardSlide]),
      builder: (_, __) => FadeTransition(
        opacity: cardFade,
        child: SlideTransition(
          position: cardSlide,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  c1.withOpacity(0.10),
                  c2.withOpacity(0.05),
                  const Color(0xFF051525).withOpacity(0.97),
                ],
              ),
              border: Border.all(
                color: c1.withOpacity(isActive ? 0.35 * glowAnim.value : 0.15),
                width: 1.2,
              ),
              boxShadow: isActive
                  ? [
                BoxShadow(
                  color: c1.withOpacity(0.15 * glowAnim.value),
                  blurRadius: 30,
                  offset: const Offset(0, 8),
                ),
              ]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── quote icon + stars ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // big quote mark
                    ShaderMask(
                      shaderCallback: (b) =>
                          LinearGradient(colors: [c1, c2]).createShader(b),
                      child: const Text(
                        '"',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          height: 0.8,
                        ),
                      ),
                    ),
                    // star rating
                    Row(
                      children: List.generate(item.rating, (_) => Padding(
                        padding: const EdgeInsets.only(left: 2),
                        child: Icon(Icons.star_rounded,
                            color: c1, size: 14),
                      )),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // ── feedback text ──
                Text(
                  item.feedback,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 13,
                    height: 1.65,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const Spacer(),

                // ── divider ──
                Container(
                  height: 1,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.transparent,
                      c1.withOpacity(0.25),
                      Colors.transparent,
                    ]),
                  ),
                ),

                // ── author info ──
                Row(children: [
                  // avatar circle
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [
                        c1.withOpacity(0.25),
                        c2.withOpacity(0.15),
                      ]),
                      border: Border.all(
                          color: c1.withOpacity(0.4), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                            color: c1.withOpacity(0.25 * glowAnim.value),
                            blurRadius: 12),
                      ],
                    ),
                    child: Center(
                      child: Text(item.avatar,
                          style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              color: kWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${item.role} · ${item.company}',
                            style: TextStyle(
                              color: c1.withOpacity(0.75),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ]),
                  ),
                  // verified badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: c1.withOpacity(0.10),
                      border: Border.all(color: c1.withOpacity(0.25)),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.verified_rounded, color: c1, size: 10),
                      const SizedBox(width: 3),
                      Text('Verified',
                          style: TextStyle(
                              color: c1,
                              fontSize: 10,
                              fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}