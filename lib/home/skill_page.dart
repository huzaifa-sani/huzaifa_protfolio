import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _kCyan  = Color(0xFF22D3EE);
const _kCyan2 = Color(0xFF06B6D4);
const _kTeal  = Color(0xFF14B8A6);
const _kIce   = Color(0xFFBAE6FD);
const _kWhite = Color(0xFFF0F9FF);

// ══════════════════════════════════════════════════════════
//  HeroGreeting — শুধু "Assalamu Alaikum 👋" typewriter
//  নামের দরকার নেই, শুধু সালাম দেখাবে
// ══════════════════════════════════════════════════════════
class HeroGreeting extends StatefulWidget {
  final Animation<double> shimAnim;
  const HeroGreeting({super.key, required this.shimAnim});

  @override
  State<HeroGreeting> createState() => _HeroGreetingState();
}

class _HeroGreetingState extends State<HeroGreeting>
    with TickerProviderStateMixin {

  static const _greeting = 'Assalamu Alaikum 👋';
  String _typed = '';
  bool   _done  = false;
  Timer? _typeTimer;

  late AnimationController _glowCtrl;
  late Animation<double>   _glowAnim;

  late AnimationController _entryCtrl;
  late Animation<double>   _entryFade;
  late Animation<double>   _entryScale;

  @override
  void initState() {
    super.initState();

    _glowCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: .55, end: 1.0)
        .animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _entryFade  = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _entryScale = Tween<double>(begin: .80, end: 1.0)
        .animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutBack));
    _entryCtrl.forward();

    _startTyping();
  }

  void _startTyping() {
    int idx = 0;
    _typeTimer = Timer.periodic(const Duration(milliseconds: 65), (t) {
      if (!mounted) { t.cancel(); return; }
      if (idx < _greeting.length) {
        setState(() => _typed = _greeting.substring(0, ++idx));
      } else {
        t.cancel();
        if (mounted) setState(() => _done = true);
      }
    });
  }

  @override
  void dispose() {
    _typeTimer?.cancel();
    _glowCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_glowCtrl, _entryCtrl, widget.shimAnim]),
      builder: (_, __) {
        return FadeTransition(
          opacity: _entryFade,
          child: ScaleTransition(
            scale: _entryScale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // ── shimmer greeting text ─────────────────
                ShaderMask(
                  shaderCallback: (b) {
                    final v = widget.shimAnim.value;
                    return LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [
                        (v - .5).clamp(0.0, 1.0),
                        v.clamp(0.0, 1.0),
                        (v + .5).clamp(0.0, 1.0),
                      ],
                      colors: const [_kCyan2, _kWhite, _kTeal],
                    ).createShader(b);
                  },
                  child: Text(
                    _typed,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -.3,
                      shadows: [
                        Shadow(
                          color: _kCyan.withOpacity(_glowAnim.value * .55),
                          blurRadius: 22,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ── blinking cursor while typing ──────────
                if (!_done)
                  Opacity(
                    opacity: _glowAnim.value > .75 ? 1 : 0,
                    child: Container(
                      width: 2.5, height: 26,
                      decoration: BoxDecoration(
                        color: _kCyan,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: _kCyan.withOpacity(.7),
                            blurRadius: 10, spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),

                // ── animated underline after done ─────────
                if (_done)
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // outer glow line
                      Container(
                        height: 3,
                        width: 200 * _glowAnim.value,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          gradient: LinearGradient(colors: [
                            Colors.transparent,
                            _kCyan.withOpacity(_glowAnim.value * .4),
                            _kTeal.withOpacity(_glowAnim.value * .3),
                            Colors.transparent,
                          ]),
                          boxShadow: [
                            BoxShadow(
                              color: _kCyan.withOpacity(_glowAnim.value * .45),
                              blurRadius: 14, spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      // sharp inner line
                      Container(
                        height: 1.5,
                        width: 170 * _glowAnim.value,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: LinearGradient(colors: [
                            Colors.transparent,
                            _kCyan.withOpacity(_glowAnim.value * .9),
                            _kIce.withOpacity(_glowAnim.value * .7),
                            _kTeal.withOpacity(_glowAnim.value * .8),
                            Colors.transparent,
                          ]),
                        ),
                      ),
                      // moving shine dot
                      Positioned(
                        left: (170 * _glowAnim.value * widget.shimAnim.value)
                            .clamp(0, 170),
                        child: Container(
                          width: 6, height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _kWhite,
                            boxShadow: [
                              BoxShadow(
                                color: _kCyan.withOpacity(.9),
                                blurRadius: 8, spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}