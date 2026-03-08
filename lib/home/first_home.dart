import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huzaifa_portfolio/home/skill_page.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ChatScreen.dart';

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

class FirstHome extends StatefulWidget {
  const FirstHome({super.key});
  @override
  State<FirstHome> createState() => _FirstHomeState();
}

class _FirstHomeState extends State<FirstHome>
    with TickerProviderStateMixin {

  late AnimationController _bgCtrl;
  late AnimationController _floatCtrl;
  late AnimationController _ringCtrl;
  late AnimationController _shimCtrl;
  late AnimationController _entCtrl;
  late AnimationController _onlineCtrl;

  late Animation<double> _bgAnim;
  late Animation<double> _floatAnim;
  late Animation<double> _shimAnim;
  late Animation<double> _fadeIn;
  late Animation<Offset>  _slideUp;
  late Animation<double> _onlineAnim;


  static const _projects = [
    {
      'title': 'Privae Chef App',
      'desc':  'Hire personal chefs & enjoy gourmet meals at home.',
      'tech':  ['Apps Store', 'Google Store',],
      'emoji': '',
    },
    {
      'title': 'JobsinApp',
      'desc':  'Find jobs near you with map & AI tools.',
      'tech':  ['Apps Store', 'Google Store',],
      'emoji': '',
    },

  ];

  @override
  void initState() {
    super.initState();

    _bgCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 8))
      ..repeat(reverse: true);
    _bgAnim = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut);

    _floatCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 4))
      ..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -12, end: 12)
        .animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    _ringCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 6))
      ..repeat();

    _shimCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..repeat();
    _shimAnim = Tween<double>(begin: -1.0, end: 2.0)
        .animate(CurvedAnimation(parent: _shimCtrl, curve: Curves.linear));

    _onlineCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _onlineAnim = Tween<double>(begin: 0.5, end: 1.0)
        .animate(CurvedAnimation(parent: _onlineCtrl, curve: Curves.easeInOut));

    _entCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeIn  = CurvedAnimation(parent: _entCtrl, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
        begin: const Offset(0, 0.22), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entCtrl, curve: Curves.easeOutCubic));
    _entCtrl.forward();
  }

  @override
  void dispose() {
    _bgCtrl.dispose(); _floatCtrl.dispose(); _ringCtrl.dispose();
    _shimCtrl.dispose(); _entCtrl.dispose(); _onlineCtrl.dispose();
    super.dispose();
  }

  Future<void> _open(String url) async {
    final u = Uri.parse(url);
    if (await canLaunchUrl(u)) await launchUrl(u);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),
      body: Stack(children: [
        // ── animated background ──
        AnimatedBuilder(
          animation: _bgAnim,
          builder: (_, __) => CustomPaint(
            painter: _OceanBgPainter(_bgAnim.value),
            size: MediaQuery.of(context).size,
          ),
        ),
        // ── content ──
        FadeTransition(
          opacity: _fadeIn,
          child: SlideTransition(
            position: _slideUp,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
              child: Column(children: [
                _hero(),
                const SizedBox(height: 4),
                _statsRow(),
                _section('About Me',    '👤', _aboutCard()),
                _section('Skills', '⚡', _skillsButton()),
                _section('Projects',    '🚀', _projectsWidget()),
                _section('Get In Touch', '📬', const ContactSection()),
                _footer(),
              ]),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _skillsButton() {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SkillPage()),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [kCyan.withOpacity(.12), kTeal.withOpacity(.06), kBg2.withOpacity(.97)],
          ),
          border: Border.all(color: kCyan.withOpacity(.3), width: 1),
          boxShadow: [BoxShadow(color: kCyan.withOpacity(.12), blurRadius: 24)],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            const Text('🕸️', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('View Skill Radar', style: TextStyle(
                  color: kWhite, fontSize: 15, fontWeight: FontWeight.w800)),
              Text('6 skills • Interactive chart', style: TextStyle(
                  color: kMuted, fontSize: 12)),
            ]),
          ]),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kCyan.withOpacity(.15),
              border: Border.all(color: kCyan.withOpacity(.3)),
            ),
            child: const Icon(Icons.arrow_forward_ios_rounded, color: kCyan, size: 14),
          ),
        ]),
      ),
    );
  }

  // ═══════════════════════════════════════════════
  //  HERO
  // ═══════════════════════════════════════════════
  Widget _hero() {
    return Padding(
      padding: const EdgeInsets.only(top: 72, bottom: 40),
      child: Column(children: [
        // floating avatar
        AnimatedBuilder(
          animation: Listenable.merge([_floatCtrl, _ringCtrl]),
          builder: (_, __) => Transform.translate(
            offset: Offset(0, _floatAnim.value),
            child: _avatar(),
          ),
        ),
        const SizedBox(height: 28),
        // shimmer name
        _ShimmerName(_shimAnim),
        const SizedBox(height: 12),
        // rotating badge
        _RotatingBadge(),
        const SizedBox(height: 16),
        Text(
          'Building beautiful, high-performance\nmobile apps with Flutter & Dart.',
          textAlign: TextAlign.center,
          style: TextStyle(color: kMuted.withOpacity(.9), fontSize: 15, height: 1.75),
        ),
        const SizedBox(height: 30),

        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _PrimaryBtn('🚀  My Projects', () {}),
          const SizedBox(width: 12),
          _SecondaryBtn('✉️  Hire Me', () => _open('mailto:huzaifa0133@gmail.com')),
        ]),
        const SizedBox(height: 12),

        GestureDetector(
          onTap: () => _open('your_cv_link'),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kCyan.withOpacity(.25), width: 1),
              color: kCyan.withOpacity(.04),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.download_rounded, color: kCyan.withOpacity(.7), size: 16),
              const SizedBox(width: 8),
              Text('Download CV', style: TextStyle(
                color: kCyan.withOpacity(.8), fontSize: 13, fontWeight: FontWeight.w600,
                letterSpacing: .5,
              )),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _avatar() {
    return SizedBox(
      width: 200, height: 200,
      child: Stack(alignment: Alignment.center, children: [
        // outer glow
        Container(
          width: 200, height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [
              kCyan.withOpacity(.22),
              kTeal.withOpacity(.10),
              Colors.transparent,
            ]),
          ),
        ),
        // spinning conic ring
        Transform.rotate(
          angle: _ringCtrl.value * 2 * pi,
          child: Container(
            width: 155, height: 155,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const SweepGradient(colors: [
                Colors.transparent, kCyan, kTeal,
                kCyan2, Colors.transparent,
              ]),
            ),
          ),
        ),
        // avatar face
        Container(
          width: 148, height: 148,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kBg,
            boxShadow: [
              BoxShadow(color: kCyan.withOpacity(.45), blurRadius: 36, spreadRadius: 2),
              BoxShadow(color: kTeal.withOpacity(.20), blurRadius: 60),
            ],
          ),
          padding: const EdgeInsets.all(3),
          child: CircleAvatar(
            backgroundColor: kNavy,
            backgroundImage: AssetImage('assets/images/my_1st_iamge.png')
            //child: const Icon(Icons.person_rounded, size: 68, color: kCyan),
          ),
        ),
        // online dot
        Positioned(
          bottom: 28, right: 28,
          child: AnimatedBuilder(
            animation: _onlineAnim,
            builder: (_, __) => Container(
              width: 18, height: 18,
              decoration: BoxDecoration(
                color: kTeal,
                shape: BoxShape.circle,
                border: Border.all(color: kBg, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: kTeal.withOpacity(_onlineAnim.value),
                    blurRadius: 14 * _onlineAnim.value,
                    spreadRadius: 2 * _onlineAnim.value,
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _statsRow() {
    final items = [
      {'v': '3+',   'l': 'Projects'},
      {'v': '2+',   'l': 'Years Exp'},
      {'v': '100%', 'l': 'Passion'},
    ];

    return Row(
      children: items.map((s) => Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [kCyan.withOpacity(.10), kTeal.withOpacity(.04), Colors.transparent],
            ),
            border: Border.all(color: kCyan.withOpacity(.18), width: 1),
            boxShadow: [BoxShadow(color: kCyan.withOpacity(.07), blurRadius: 18)],
          ),
          child: Column(children: [
            Text(s['v']!, style: const TextStyle(
                color: kCyan, fontSize: 24, fontWeight: FontWeight.w900,
                shadows: [Shadow(color: kCyan, blurRadius: 16)])),
            const SizedBox(height: 4),
            Text(s['l']!, style: TextStyle(color: kMuted, fontSize: 12, letterSpacing: .5)),
          ]),
        ),
      )).toList(),
    );
  }


  Widget _aboutCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [kCyan.withOpacity(.07), kTeal.withOpacity(.04), kBg2.withOpacity(.97)],
        ),
        border: Border.all(color: kCyan.withOpacity(.15), width: 1),
        boxShadow: [
          BoxShadow(color: kCyan.withOpacity(.06), blurRadius: 30, offset: const Offset(0, 8)),
        ],
      ),
      child: const Text(
        'Hi, I\'m Huzaifa Sani — a Flutter developer from Dhaka, Bangladesh. '
            'Though I\'m early in my journey with 5+ months of hands-on experience, '
            'I\'ve already shipped real apps to both the App Store & Google Play — '
            'including a personal chef booking app and a job-finding platform '
            'with map & AI features.\n\n'
            'I specialize in clean UI design, smooth animations, Firebase integration, '
            'and REST API connections. I love turning ideas into polished, '
            'pixel-perfect mobile experiences that users actually enjoy.\n\n'
            '💡 Currently open to freelance projects & full-time opportunities.',
        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14.5, height: 1.85),
      ),
    );
  }


  Widget _projectsWidget() {
    return Column(
      children: _projects.map((p) => _ProjCard(p)).toList(),
    );
  }


  Widget _contactWidget() {
    return Column(children: [
      _CTile('✉️', 'EMAIL',    'huzaifa0133@gmail.com',      () => _open('mailto:huzaifa0133@gmail.com')),
      _CTile('⌨',  'GITHUB',   'github.com/huzaifa-sani',    () => _open('https://github.com/huzaifa-sani')),
      _CTile('💼', 'LINKEDIN', 'linkedin.com/in/huzaifa-sani',() => _open('https://www.linkedin.com/in/huzaifa-sani-525b36304/')),
      _CTile('f',  'FACEBOOK', 'facebook.com/hoya.ipha.sani', () => _open('https://www.facebook.com/hoya.ipha.sani')),
    ]);
  }

  Widget _CTile(String icon, String label, String val, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.centerLeft, end: Alignment.centerRight,
            colors: [kCyan.withOpacity(.08), Colors.transparent],
          ),
          border: Border.all(color: kCyan.withOpacity(.18), width: 1),
          boxShadow: [BoxShadow(color: kCyan.withOpacity(.05), blurRadius: 14)],
        ),
        child: Row(children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color: kCyan.withOpacity(.10),
              border: Border.all(color: kCyan.withOpacity(.22)),
              boxShadow: [BoxShadow(color: kCyan.withOpacity(.15), blurRadius: 10)],
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 16))),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(
                color: kCyan, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: .8)),
            const SizedBox(height: 2),
            Text(val, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
          ])),
          Icon(Icons.arrow_forward_ios_rounded, size: 13,
              color: kCyan.withOpacity(.4)),
        ]),
      ),
    );
  }

  Widget _footer() {
    return Padding(
      padding: const EdgeInsets.only(top: 36, bottom: 10),
      child: Column(children: [
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [Colors.transparent, kCyan, kTeal, Colors.transparent],
          ).createShader(b),
          child: Container(height: 1, color: Colors.white),
        ),
        const SizedBox(height: 18),
        _ShimmerName(_shimAnim, text: 'Made with ❤️ using Flutter', size: 13),
        const SizedBox(height: 6),
        Text('© 2025 Huzaifa Sani',
            style: TextStyle(color: kMuted.withOpacity(.5), fontSize: 12)),
      ]),
    );
  }

  Widget _section(String title, String emoji, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 34, height: 34,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: [kCyan.withOpacity(.25), kTeal.withOpacity(.15)]),
              border: Border.all(color: kCyan.withOpacity(.3)),
              boxShadow: [BoxShadow(color: kCyan.withOpacity(.2), blurRadius: 12)],
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 15))),
          ),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(
              color: kWhite, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -.2)),
        ]),
        const SizedBox(height: 16),
        child,
      ]),
    );
  }
}
class _OceanBgPainter extends CustomPainter {
  final double t;
  _OceanBgPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── base: very deep navy-black ──
    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()..color = const Color(0xFF0D0B1A),
    );

    _blob(canvas, Offset(w * (.0 + t * .04), h * .0),   w * .55, kCyan,                    .13); // ছিল .07
    _blob(canvas, Offset(w * (1.0 - t * .04), h * .12), w * .50, const Color(0xFF7C3AED),  .14); // ছিল .08
    _blob(canvas, Offset(w * (.5 + t * .02), h * 1.0),  w * .50, kTeal,                    .11); // ছিল .06


    // ── very faint hex-dot grid ──
    final dot = Paint()..color = kCyan.withOpacity(.022);
    const step = 44.0;
    for (double x = 0; x < w; x += step)
      for (double y = 0; y < h; y += step)
        canvas.drawCircle(Offset(x, y), .7, dot);

    // ── minimal drifting particles ──
    final rng = Random(99);
    for (int i = 0; i < 28; i++) {
      final px = rng.nextDouble() * w;
      final py = (rng.nextDouble() * h + t * 50) % h;
      final r  = rng.nextDouble() * 1.1 + .3;
      final op = rng.nextDouble() * .14 + .04;
      final color = i % 3 == 0
          ? kCyan
          : i % 3 == 1
          ? const Color(0xFF7C3AED)
          : kTeal;
      canvas.drawCircle(Offset(px, py), r,
          Paint()..color = color.withOpacity(op));
    }
  }

  void _blob(Canvas canvas, Offset c, double r, Color color, double opacity) {
    canvas.drawCircle(c, r, Paint()
      ..shader = RadialGradient(colors: [
        color.withOpacity(opacity),
        color.withOpacity(opacity * .35),
        Colors.transparent,
      ]).createShader(Rect.fromCircle(center: c, radius: r)));
  }

  @override
  bool shouldRepaint(_OceanBgPainter o) => o.t != t;
}

class _ShimmerName extends StatefulWidget {
  final Animation<double> anim;
  final String text;
  final double size;

  const _ShimmerName(this.anim,
      {this.text = 'Huzaifa Sani', this.size = 20});

  @override
  State<_ShimmerName> createState() => _ShimmerNameState();
}

class _ShimmerNameState extends State<_ShimmerName>
    with TickerProviderStateMixin {

  late AnimationController _glowCtrl;
  late AnimationController _floatCtrl;
  late AnimationController _lineCtrl;
  late AnimationController _entryCtrl;

  late Animation<double> _glowAnim;
  late Animation<double> _floatAnim;
  late Animation<double> _lineAnim;
  late Animation<double> _entryFade;
  late Animation<double> _entryScale;

  @override
  void initState() {
    super.initState();

    // pulsing glow
    _glowCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: .5, end: 1.0)
        .animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

    // subtle float up-down
    _floatCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 4))
      ..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -3.0, end: 3.0)
        .animate(CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    // underline expand
    _lineCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 4))
      ..repeat(reverse: true);
    _lineAnim = Tween<double>(begin: .6, end: 1.0)
        .animate(CurvedAnimation(parent: _lineCtrl, curve: Curves.easeInOut));

    // entry animation
    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _entryFade  = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _entryScale = Tween<double>(begin: .75, end: 1.0)
        .animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutBack));
    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _glowCtrl.dispose(); _floatCtrl.dispose();
    _lineCtrl.dispose(); _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parts = widget.text.split(' ');
    final first = parts.isNotEmpty ? parts[0] : widget.text;
    final rest  = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return AnimatedBuilder(
      animation: Listenable.merge([
        widget.anim, _glowAnim, _floatAnim, _lineAnim, _entryCtrl,
      ]),
      builder: (_, __) {

        return FadeTransition(
          opacity: _entryFade,
          child: ScaleTransition(
            scale: _entryScale,
            child: Transform.translate(
              offset: Offset(0, _floatAnim.value),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ── name stack ──────────────────────────
                  Stack(
                    alignment: Alignment.center,
                    children: [

                      // outer halo blur
                      Opacity(
                        opacity: _glowAnim.value * .25,
                        child: Text(
                          first,
                          style: GoogleFonts.poppins(
                            fontSize: widget.size,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -.5,
                            foreground: Paint()
                              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28)
                              ..color = kCyan,
                          ),
                        ),
                      ),

                      // inner tighter blur
                      Opacity(
                        opacity: _glowAnim.value * .18,
                        child: Text(
                          rest,
                          style: GoogleFonts.poppins(
                            fontSize: widget.size,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -.5,
                            foreground: Paint()
                              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28)
                              ..color = kCyan,
                          ),
                        ),
                      ),

                      // actual shimmer text
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [

                          // ── first word: Huzaifa ──
                          ShaderMask(
                            shaderCallback: (b) => LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              stops: [
                                (widget.anim.value - .55).clamp(0.0, 1.0),
                                widget.anim.value.clamp(0.0, 1.0),
                                (widget.anim.value + .55).clamp(0.0, 1.0),
                              ],
                              colors: const [kCyan2, kWhite, kCyan],
                            ).createShader(b),
                            child: Text(
                              first,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: widget.size,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -.5,
                                shadows: [
                                  Shadow(
                                    color: kCyan.withOpacity(_glowAnim.value * .6),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          if (rest.isNotEmpty) ...[
                            const SizedBox(width: 12),

                            // ── second word: Sani ──
                            ShaderMask(
                              shaderCallback: (b) => LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: [
                                  (widget.anim.value - .45).clamp(0.0, 1.0),
                                  widget.anim.value.clamp(0.0, 1.0),
                                  (widget.anim.value + .45).clamp(0.0, 1.0),
                                ],
                                colors: const [kTeal, kIce, kCyan],
                              ).createShader(b),
                              child: Text(
                                rest,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: widget.size,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -.5,
                                  shadows: [
                                    Shadow(
                                      color: kTeal.withOpacity(_glowAnim.value * .5),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // ── animated underline ──────────────────
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // outer glow line
                      Container(
                        height: 3,
                        width: widget.size * widget.text.length * .52 * _lineAnim.value,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          gradient: LinearGradient(colors: [
                            Colors.transparent,
                            kCyan.withOpacity(_glowAnim.value * .35),
                            kTeal.withOpacity(_glowAnim.value * .25),
                            Colors.transparent,
                          ]),
                          boxShadow: [
                            BoxShadow(
                              color: kCyan.withOpacity(_glowAnim.value * .4),
                              blurRadius: 12, spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      // sharp inner line
                      Container(
                        height: 1.5,
                        width: widget.size * widget.text.length * .42 * _lineAnim.value,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: LinearGradient(colors: [
                            Colors.transparent,
                            kCyan.withOpacity(_glowAnim.value * .9),
                            kIce.withOpacity(_glowAnim.value * .7),
                            kTeal.withOpacity(_glowAnim.value * .8),
                            Colors.transparent,
                          ]),
                        ),
                      ),

                      // moving shine dot on line
                      Positioned(
                        left: (widget.size * widget.text.length * .42 *
                            _lineAnim.value * widget.anim.value)
                            .clamp(0, widget.size * widget.text.length * .42),
                        child: Container(
                          width: 6, height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kWhite,
                            boxShadow: [
                              BoxShadow(
                                color: kCyan.withOpacity(.9),
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
          ),
        );
      },
    );
  }
}
class _RotatingBadge extends StatefulWidget {
  const _RotatingBadge();
  @override
  State<_RotatingBadge> createState() => _RotatingBadgeState();
}

class _RotatingBadgeState extends State<_RotatingBadge>
    with TickerProviderStateMixin {


  static const _items = [
    _BadgeItem('📱', 'Flutter Developer', [Color(0xFF22D3EE), Color(0xFF06B6D4)]),
    _BadgeItem('💡', 'Problem Solver', [Color(0xADA4FF35), Color(0x4DA4FF35)]),
    _BadgeItem('🔥', 'Firebase Integration', [Color(0xFF0076BF), Color(
        0xFF32E825)]),
    _BadgeItem('🧩', 'API Integration', [Color(0xFF4ADE80), Color(0xFF22C55E)]),
    _BadgeItem('🛠️', 'App Debugging', [Color(0xFFA78BFA), Color(0xFF8B5CF6)]),
    _BadgeItem('🎨', 'UI/UX Enthusiast', [Color(0xFF818CF8), Color(0xFFA78BFA)]),

  ];


  late AnimationController _slideCtrl;
  late AnimationController _typeCtrl;
  late AnimationController _glowCtrl;
  late AnimationController _shineCtrl;

  late Animation<Offset>  _slideIn;
  late Animation<Offset>  _slideOut;
  late Animation<double>  _fadeIn;
  late Animation<double>  _fadeOut;
  late Animation<double>  _glowAnim;
  late Animation<double>  _shineAnim;

  int    _cur  = 0;
  int    _prev = 0;
  bool   _transitioning = false;
  String _typedText = '';
  Timer? _typeTimer;
  Timer? _holdTimer;

  @override
  void initState() {
    super.initState();

    // slide transition
    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _slideIn  = Tween<Offset>(begin: const Offset(0, 1.4), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeOutBack));
    _slideOut = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1.4))
        .animate(CurvedAnimation(parent: _slideCtrl, curve: Curves.easeInBack));
    _fadeIn   = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _slideCtrl,
        curve: const Interval(0, .5, curve: Curves.easeOut)));
    _fadeOut  = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _slideCtrl,
        curve: const Interval(.5, 1, curve: Curves.easeIn)));

    // typewriter
    _typeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 50));

    // glow pulse
    _glowCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: .6, end: 1.0)
        .animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

    // shine sweep
    _shineCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))..repeat();
    _shineAnim = Tween<double>(begin: -1.5, end: 2.5)
        .animate(CurvedAnimation(parent: _shineCtrl, curve: Curves.linear));

    // start
    _startTyping();
  }

  @override
  void dispose() {
    _slideCtrl.dispose(); _typeCtrl.dispose();
    _glowCtrl.dispose();  _shineCtrl.dispose();
    _typeTimer?.cancel();  _holdTimer?.cancel();
    super.dispose();
  }

  // ── typewriter logic ───────────────────────────────────
  void _startTyping() {
    final full = _items[_cur].text;
    _typedText = '';
    int idx = 0;

    _typeTimer?.cancel();
    _typeTimer = Timer.periodic(const Duration(milliseconds: 55), (t) {
      if (!mounted) { t.cancel(); return; }
      if (idx < full.length) {
        setState(() => _typedText = full.substring(0, ++idx));
      } else {
        t.cancel();
        // hold then transition
        _holdTimer = Timer(const Duration(milliseconds: 2200), _transition);
      }
    });
  }

  Future<void> _transition() async {
    if (!mounted) return;
    setState(() { _transitioning = true; _prev = _cur; });

    // slide old out
    await _slideCtrl.animateTo(1.0,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeInBack);
    if (!mounted) return;

    setState(() {
      _cur = (_cur + 1) % _items.length;
      _transitioning = false;
      _typedText = '';
    });

    _slideCtrl.reset();
    // slide new in
    _slideCtrl.forward(from: 0);
    _startTyping();
  }

  // ── build ──────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final item = _items[_cur];
    final colors = item.colors;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _slideCtrl, _glowCtrl, _shineCtrl,
      ]),
      builder: (_, __) {
        return SizedBox(
          height: 46,
          child: Stack(alignment: Alignment.center, children: [

            // ── previous badge sliding out ──────────────
            if (_transitioning)
              SlideTransition(
                position: _slideOut,
                child: FadeTransition(
                  opacity: _fadeOut,
                  child: _buildBadge(
                    _items[_prev], _items[_prev].text, false,
                  ),
                ),
              ),

            // ── current badge sliding in ────────────────
            if (!_transitioning)
              SlideTransition(
                position: _slideIn,
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: _buildBadge(item, _typedText, true),
                ),
              )
            else
              _buildBadge(item, _typedText, false),

          ]),
        );
      },
    );
  }

  Widget _buildBadge(_BadgeItem item, String text, bool withShine) {
    final c1 = item.colors[0];
    final c2 = item.colors[1];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [c1.withOpacity(.18), c2.withOpacity(.12)],
        ),
        border: Border.all(
          color: c1.withOpacity(.45 * _glowAnim.value), width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: c1.withOpacity(.28 * _glowAnim.value),
            blurRadius: 20 * _glowAnim.value,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: c2.withOpacity(.12 * _glowAnim.value),
            blurRadius: 36 * _glowAnim.value,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(children: [
          // shine sweep
          if (withShine)
            Positioned.fill(
              child: Transform.translate(
                offset: Offset(_shineAnim.value * 120, 0),
                child: Transform.flip(
                  child: Container(
                    width: 30,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0),
                          Colors.white.withOpacity(.12),
                          Colors.white.withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // content
          Row(mainAxisSize: MainAxisSize.min, children: [
            // icon with glow
            Container(
              width: 28, height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: c1.withOpacity(.15),
                border: Border.all(color: c1.withOpacity(.3)),
                boxShadow: [
                  BoxShadow(
                      color: c1.withOpacity(.4 * _glowAnim.value),
                      blurRadius: 10),
                ],
              ),
              child: Center(
                child: Text(item.icon,
                    style: const TextStyle(fontSize: 13)),
              ),
            ),
            const SizedBox(width: 10),

            // typewriter text
            Row(mainAxisSize: MainAxisSize.min, children: [
              ShaderMask(
                shaderCallback: (b) => LinearGradient(
                  colors: [c1, c2],
                ).createShader(b),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .3,
                  ),
                ),
              ),
              // blinking cursor
              AnimatedBuilder(
                animation: _glowCtrl,
                builder: (_, __) => Opacity(
                  opacity: _glowAnim.value > .8 ? 1 : 0,
                  child: Text('|',
                      style: TextStyle(
                          color: c1, fontSize: 14,
                          fontWeight: FontWeight.w300)),
                ),
              ),
            ]),
          ]),
        ]),
      ),
    );
  }
}

// ── Data model ────────────────────────────────────────────
class _BadgeItem {
  final String icon;
  final String text;
  final List<Color> colors;
  const _BadgeItem(this.icon, this.text, this.colors);
}



// ═══════════════════════════════════════════════
//  PROJECT CARD
// ═══════════════════════════════════════════════
class _ProjCard extends StatefulWidget {
  final Map project;
  const _ProjCard(this.project);
  @override State<_ProjCard> createState() => _ProjCardState();
}

class _ProjCardState extends State<_ProjCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp:   (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => Transform.scale(
          scale: 1.0 - _ctrl.value * .025,
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft, end: Alignment.bottomRight,
                colors: [kCyan.withOpacity(.09), kTeal.withOpacity(.04), kBg2.withOpacity(.97)],
              ),
              border: Border.all(color: kCyan.withOpacity(.2), width: 1.2),
              boxShadow: [
                BoxShadow(color: kCyan.withOpacity(.08), blurRadius: 24, offset: const Offset(0, 6)),
              ],
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // icon box
              Container(
                width: 50, height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(colors: [kCyan.withOpacity(.22), kTeal.withOpacity(.12)]),
                  border: Border.all(color: kCyan.withOpacity(.28)),
                  boxShadow: [BoxShadow(color: kCyan.withOpacity(.22), blurRadius: 16)],
                ),
                child: Center(child: Text(widget.project['emoji'] as String,
                    style: const TextStyle(fontSize: 22))),
              ),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.project['title'] as String,
                    style: const TextStyle(color: kWhite, fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 5),
                Text(widget.project['desc'] as String,
                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 13, height: 1.55)),
                const SizedBox(height: 12),
                Wrap(spacing: 6, runSpacing: 6,
                  children: (widget.project['tech'] as List<String>).map((t) =>
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: kCyan.withOpacity(.08),
                          border: Border.all(color: kCyan.withOpacity(.22)),
                        ),
                        child: Text(t, style: const TextStyle(
                            color: kCyan, fontSize: 11, fontWeight: FontWeight.w600)),
                      )
                  ).toList(),
                ),
              ])),
            ]),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════
//  BUTTONS
// ═══════════════════════════════════════════════
class _PrimaryBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PrimaryBtn(this.label, this.onTap);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(colors: [kCyan, kCyan2, kCyan3]),
        boxShadow: [
          BoxShadow(color: kCyan.withOpacity(.4), blurRadius: 22, spreadRadius: 1, offset: const Offset(0, 4)),
          BoxShadow(color: kCyan.withOpacity(.15), blurRadius: 40),
        ],
      ),
      child: Text(label, style: const TextStyle(
          color: kBg, fontWeight: FontWeight.w800, fontSize: 14)),
    ),
  );
}

class _SecondaryBtn extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _SecondaryBtn(this.label, this.onTap);
  @override
  State<_SecondaryBtn> createState() => _SecondaryBtnState();
}

class _SecondaryBtnState extends State<_SecondaryBtn>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _shine;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat();
    _shine = Tween<double>(begin: -1.5, end: 2.5)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.linear));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp:   (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedBuilder(
          animation: _shine,
          builder: (_, __) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  kCyan.withOpacity(_pressed ? .18 : .10),
                  kTeal.withOpacity(.05),
                  kCyan.withOpacity(.07),
                ],
              ),
              border: Border.all(color: kCyan.withOpacity(.40), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: kCyan.withOpacity(_pressed ? .30 : .15),
                  blurRadius: _pressed ? 28 : 18,
                  spreadRadius: _pressed ? 1 : 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // shine sweep
                  Positioned.fill(
                    child: Transform.translate(
                      offset: Offset(_shine.value * 80, 0),
                      child: Container(
                        width: 24,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Colors.white.withOpacity(0),
                            Colors.white.withOpacity(.10),
                            Colors.white.withOpacity(0),
                          ]),
                        ),
                      ),
                    ),
                  ),
                  // label
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [kCyan, kIce, kTeal],
                    ).createShader(b),
                    child: Text(
                      widget.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: .3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocBtn extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  const _SocBtn(this.icon, this.onTap);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: 44, height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: kCyan.withOpacity(.07),
        border: Border.all(color: kCyan.withOpacity(.22)),
        boxShadow: [BoxShadow(color: kCyan.withOpacity(.1), blurRadius: 12)],
      ),
      child: Center(child: Text(icon,
          style: const TextStyle(color: kCyan, fontSize: 16, fontWeight: FontWeight.w600))),
    ),
  );
}

// missing constant
const kCyan3 = Color(0xFF0E7490);