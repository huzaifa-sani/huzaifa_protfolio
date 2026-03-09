import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── colour tokens ──────────────────────────────
const kBg    = Color(0xFF0D0B1A);
const kBg2   = Color(0xFF0C1020);
const kCyan  = Color(0xFF22D3EE);
const kCyan2 = Color(0xFF06B6D4);
const kTeal  = Color(0xFF14B8A6);
const kViolet= Color(0xFF7C3AED);
const kPink  = Color(0xFFEC4899);
const kWhite = Color(0xFFF0F9FF);
const kMuted = Color(0xFF334155);

// ══════════════════════════════════════════════════════
//  MAIN NAV BAR  — drop this anywhere as a widget
// ══════════════════════════════════════════════════════
class GlowNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const GlowNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<GlowNavBar> createState() => _GlowNavBarState();
}

class _GlowNavBarState extends State<GlowNavBar> with TickerProviderStateMixin {

  // one controller per item for individual glow pulses
  late List<AnimationController> _pulseCtrl;
  late List<Animation<double>>   _pulseAnim;

  // ripple on tap
  late AnimationController _rippleCtrl;
  late Animation<double>   _rippleAnim;
  late Animation<double>   _rippleFade;

  // sliding indicator pill
  late AnimationController _slideCtrl;
  late Animation<double>   _slideAnim;

  // background shimmer
  late AnimationController _shimCtrl;
  late Animation<double>   _shimAnim;

  int _prevIndex = 0;
  int _rippleTarget = 0;

  static const _items = [
    _NavItem(Icons.home_rounded,        [kCyan,   kCyan2]),
    _NavItem(Icons.bolt_rounded,        [kTeal,   Color(0xFF34D399)]),
    _NavItem(Icons.work_rounded,        [kViolet, Color(0xFFA78BFA)]),
    _NavItem(Icons.rate_review_rounded, [kPink,   Color(0xFFF9A8D4)]),
    _NavItem(Icons.mail_rounded,        [kCyan2,  kTeal]),
  ];

  @override
  void initState() {
    super.initState();

    _pulseCtrl = List.generate(_items.length, (i) =>
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true));

    _pulseAnim = _pulseCtrl.map((c) =>
        Tween<double>(begin: .55, end: 1.0)
            .animate(CurvedAnimation(parent: c, curve: Curves.easeInOut))).toList();

    // stagger the pulses so they don't all sync
    for (int i = 0; i < _pulseCtrl.length; i++) {
      _pulseCtrl[i].forward(from: i * .18);
    }

    _rippleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _rippleAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _rippleCtrl, curve: Curves.easeOut));
    _rippleFade = Tween<double>(begin: .5, end: 0)
        .animate(CurvedAnimation(parent: _rippleCtrl, curve: Curves.easeIn));

    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _slideAnim = Tween<double>(begin: widget.currentIndex.toDouble(),
        end:   widget.currentIndex.toDouble())
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));

    _shimCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 4))..repeat();
    _shimAnim = Tween<double>(begin: -1.0, end: 2.0)
        .animate(CurvedAnimation(parent: _shimCtrl, curve: Curves.linear));
  }

  @override
  void didUpdateWidget(GlowNavBar old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      _prevIndex    = old.currentIndex;
      _rippleTarget = widget.currentIndex;

      // slide the pill
      _slideAnim = Tween<double>(
        begin: old.currentIndex.toDouble(),
        end:   widget.currentIndex.toDouble(),
      ).animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutCubic));
      _slideCtrl
        ..reset()
        ..forward();

      // ripple
      _rippleCtrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    for (final c in _pulseCtrl) c.dispose();
    _rippleCtrl.dispose();
    _slideCtrl.dispose();
    _shimCtrl.dispose();
    super.dispose();
  }

  void _handleTap(int i) {
    HapticFeedback.lightImpact();
    widget.onTap(i);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final itemW = (w - 40) / _items.length; // 40 = horizontal padding

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
      child: AnimatedBuilder(
        animation: Listenable.merge([_slideCtrl, _shimCtrl, _rippleCtrl]),
        builder: (_, __) {
          final pillX = _slideAnim.value * itemW;

          return Container(
            height: 68,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: kBg2,
              border: Border.all(color: kCyan.withOpacity(.12), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.45),
                  blurRadius: 32,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: kCyan.withOpacity(.07),
                  blurRadius: 24,
                  spreadRadius: -4,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(children: [

                // ── shimmer sweep across the whole bar ──
                Positioned.fill(
                  child: Transform.translate(
                    offset: Offset(_shimAnim.value * (w - 40), 0),
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Colors.white.withOpacity(0),
                          Colors.white.withOpacity(.025),
                          Colors.white.withOpacity(0),
                        ]),
                      ),
                    ),
                  ),
                ),

                // ── sliding glow pill ──
                Positioned(
                  left: pillX + 6,
                  top: 8,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    width: itemW - 12,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _items[widget.currentIndex].colors[0].withOpacity(.18),
                          _items[widget.currentIndex].colors[1].withOpacity(.08),
                        ],
                      ),
                      border: Border.all(
                        color: _items[widget.currentIndex].colors[0].withOpacity(.30),
                        width: 1,
                      ),
                    ),
                  ),
                ),

                // ── tap ripple ──
                if (_rippleCtrl.isAnimating)
                  Positioned(
                    left: _rippleTarget * itemW + itemW / 2 - 36,
                    top: 68 / 2 - 36,
                    child: Opacity(
                      opacity: _rippleFade.value,
                      child: Container(
                        width: 72 * _rippleAnim.value,
                        height: 72 * _rippleAnim.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _items[_rippleTarget].colors[0]
                                .withOpacity(.6 * _rippleFade.value),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                // ── icons row ──
                Row(
                  children: List.generate(_items.length, (i) {
                    final isActive = i == widget.currentIndex;
                    final item     = _items[i];
                    final c1       = item.colors[0];
                    final c2       = item.colors[1];

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _handleTap(i),
                        behavior: HitTestBehavior.opaque,
                        child: SizedBox(
                          height: 68,
                          child: AnimatedBuilder(
                            animation: _pulseAnim[i],
                            builder: (_, __) {
                              return Center(
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutCubic,
                                  width: isActive ? 44 : 38,
                                  height: isActive ? 44 : 38,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isActive
                                        ? c1.withOpacity(.12)
                                        : Colors.transparent,
                                    boxShadow: isActive
                                        ? [
                                      BoxShadow(
                                        color: c1.withOpacity(
                                            .35 * _pulseAnim[i].value),
                                        blurRadius:
                                        18 * _pulseAnim[i].value,
                                        spreadRadius: 1,
                                      ),
                                      BoxShadow(
                                        color: c2.withOpacity(
                                            .15 * _pulseAnim[i].value),
                                        blurRadius:
                                        32 * _pulseAnim[i].value,
                                      ),
                                    ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: isActive
                                        ? ShaderMask(
                                      shaderCallback: (b) =>
                                          LinearGradient(
                                            colors: [c1, c2],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ).createShader(b),
                                      child: Icon(
                                        item.icon,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    )
                                        : Icon(
                                      item.icon,
                                      color: kMuted.withOpacity(.7),
                                      size: 22,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                // ── active dot indicator at bottom ──
                Positioned(
                  bottom: 6,
                  left: widget.currentIndex * itemW + itemW / 2 - 3,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _items[widget.currentIndex].colors[0],
                      boxShadow: [
                        BoxShadow(
                          color: _items[widget.currentIndex]
                              .colors[0]
                              .withOpacity(.8),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),

              ]),
            ),
          );
        },
      ),
    );
  }
}

// ── data model ─────────────────────────────────
class _NavItem {
  final IconData       icon;
  final List<Color>    colors;
  const _NavItem(this.icon, this.colors);
}

// ══════════════════════════════════════════════════════
//  HOW TO USE IN YOUR SCAFFOLD
// ══════════════════════════════════════════════════════
//
//  int _tab = 0;
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: kBg,
//      body: _pages[_tab],               // your pages
//      bottomNavigationBar: GlowNavBar(
//        currentIndex: _tab,
//        onTap: (i) => setState(() => _tab = i),
//      ),
//    );
//  }
//
// ══════════════════════════════════════════════════════
//  DEMO WRAPPER  (remove when integrating)
// ══════════════════════════════════════════════════════
class NavBarDemo extends StatefulWidget {
  const NavBarDemo({super.key});
  @override
  State<NavBarDemo> createState() => _NavBarDemoState();
}

class _NavBarDemoState extends State<NavBarDemo> {
  int _tab = 0;

  static const _labels = ['Home', 'Skills', 'Projects', 'Reviews', 'Contact'];
  static const _emojis = ['🏠', '⚡', '🚀', '⭐', '📬'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Stack(children: [
        // faint bg blobs
        Positioned(top: -60, left: -60,
            child: Container(width: 280, height: 280,
                decoration: BoxDecoration(shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [
                      kCyan.withOpacity(.10), Colors.transparent])))),
        Positioned(bottom: 120, right: -80,
            child: Container(width: 260, height: 260,
                decoration: BoxDecoration(shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [
                      kViolet.withOpacity(.12), Colors.transparent])))),

        // content
        Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(_emojis[_tab], style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(_labels[_tab], style: const TextStyle(
              color: kWhite, fontSize: 28, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text('Tab $_tab active', style: TextStyle(
              color: kMuted.withOpacity(.6), fontSize: 14)),
        ])),
      ]),

      bottomNavigationBar: GlowNavBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
      ),
    );
  }
}