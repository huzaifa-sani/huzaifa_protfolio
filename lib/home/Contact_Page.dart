import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

const kBg      = Color(0xFF020B18);
const kBg2     = Color(0xFF051525);
const kCyan    = Color(0xFF22D3EE);
const kCyan2   = Color(0xFF06B6D4);
const kCyan3   = Color(0xFF0E7490);
const kTeal    = Color(0xFF14B8A6);
const kIce     = Color(0xFFBAE6FD);
const kNavy    = Color(0xFF0C1F35);
const kMuted   = Color(0xFF475569);
const kWhite   = Color(0xFFF0F9FF);


class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage>
    with TickerProviderStateMixin {

  late AnimationController _bgCtrl;
  late AnimationController _entryCtrl;
  late AnimationController _glowCtrl;

  late Animation<double> _bgAnim;
  late Animation<double> _fadeIn;
  late Animation<Offset>  _slideUp;
  late Animation<double> _glowAnim;

  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _subjectCtrl = TextEditingController();
  final _msgCtrl     = TextEditingController();

  bool _sending   = false;
  bool _sent      = false;

  // which field is focused
  String? _focusedField;

  static const _socials = [
    _SocialItem('✉️', 'Email',    'huzaifa0133@gmail.com',         'mailto:huzaifa0133@gmail.com',       [kCyan, kCyan2]),
    _SocialItem('⌨',  'GitHub',   'github.com/huzaifa-sani',       'https://github.com/huzaifa-sani',    [Color(0xFF818CF8), Color(0xFFA78BFA)]),
    _SocialItem('💼', 'LinkedIn', 'linkedin.com/in/huzaifa-sani',  'https://www.linkedin.com/in/huzaifa-sani-525b36304/', [Color(0xFF0EA5E9), Color(0xFF38BDF8)]),
    _SocialItem('f',  'Facebook', 'facebook.com/hoya.ipha.sani',   'https://www.facebook.com/hoya.ipha.sani', [Color(0xFF6366F1), Color(0xFF818CF8)]),
  ];

  @override
  void initState() {
    super.initState();

    _bgCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 8))
      ..repeat(reverse: true);
    _bgAnim = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut);

    _glowCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.6, end: 1.0)
        .animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

    _entryCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fadeIn  = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
        begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));
    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _bgCtrl.dispose(); _entryCtrl.dispose(); _glowCtrl.dispose();
    _nameCtrl.dispose(); _emailCtrl.dispose();
    _subjectCtrl.dispose(); _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _open(String url) async {
    final u = Uri.parse(url);
    if (await canLaunchUrl(u)) await launchUrl(u);
  }

  Future<void> _sendMessage() async {
    if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _msgCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(colors: [
                Colors.redAccent.withOpacity(.15),
                Colors.red.withOpacity(.08),
              ]),
              border: Border.all(color: Colors.redAccent.withOpacity(.4)),
            ),
            child: const Row(children: [
              Text('⚠️', style: TextStyle(fontSize: 16)),
              SizedBox(width: 10),
              Text('Please fill all required fields',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
            ]),
          ),
        ),
      );
      return;
    }

    setState(() => _sending = true);
    // simulate send
    await Future.delayed(const Duration(seconds: 2));
    // open mail with prefilled fields
    final subject = Uri.encodeComponent(_subjectCtrl.text.isNotEmpty
        ? _subjectCtrl.text
        : 'Portfolio Contact from ${_nameCtrl.text}');
    final body = Uri.encodeComponent(
        'Name: ${_nameCtrl.text}\nEmail: ${_emailCtrl.text}\n\n${_msgCtrl.text}');
    await _open('mailto:huzaifa0133@gmail.com?subject=$subject&body=$body');
    if (!mounted) return;
    setState(() { _sending = false; _sent = true; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),
      body: Stack(children: [
        // animated bg
        AnimatedBuilder(
          animation: _bgAnim,
          builder: (_, __) => CustomPaint(
            painter: _ContactBgPainter(_bgAnim.value),
            size: MediaQuery.of(context).size,
          ),
        ),

        // content
        FadeTransition(
          opacity: _fadeIn,
          child: SlideTransition(
            position: _slideUp,
            child: CustomScrollView(
              slivers: [
                // ── App bar ──
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  pinned: true,
                  leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: kCyan.withOpacity(.10),
                        border: Border.all(color: kCyan.withOpacity(.25)),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: kCyan, size: 16),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF0D0B1A),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── header ──
                        _header(),
                        const SizedBox(height: 32),

                        // ── availability badge ──
                        _availabilityBadge(),
                        const SizedBox(height: 32),

                        // ── social links ──
                        _sectionLabel('📡', 'Connect With Me'),
                        const SizedBox(height: 14),
                        _socialsGrid(),
                        const SizedBox(height: 32),

                        // ── contact form ──
                        _sectionLabel('✉️', 'Send a Message'),
                        const SizedBox(height: 14),
                        _contactForm(),
                        const SizedBox(height: 32),

                        // ── response time ──
                        _responseCard(),
                        const SizedBox(height: 20),

                        // ── footer ──
                        _footer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  // ─────────────────────────────────────────────
  Widget _header() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      AnimatedBuilder(
        animation: _glowAnim,
        builder: (_, __) => Text(
          "Let's Work\nTogether",
          style: TextStyle(
            color: kWhite,
            fontSize: 38,
            fontWeight: FontWeight.w900,
            height: 1.15,
            letterSpacing: -1,
            shadows: [
              Shadow(
                color: kCyan.withOpacity(0.3 * _glowAnim.value),
                blurRadius: 30,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 12),
      Text(
        'Have a project in mind? I\'d love to hear about it.\nLet\'s build something amazing together.',
        style: TextStyle(color: kMuted.withOpacity(.85), fontSize: 14.5, height: 1.7),
      ),
    ]);
  }

  Widget _availabilityBadge() {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (_, __) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(colors: [
            kTeal.withOpacity(.12),
            kCyan.withOpacity(.06),
            kBg2.withOpacity(.96),
          ]),
          border: Border.all(
              color: kTeal.withOpacity(.3 * _glowAnim.value), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: kTeal.withOpacity(.12 * _glowAnim.value),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(children: [
          // pulsing dot
          Container(
            width: 10, height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kTeal,
              boxShadow: [BoxShadow(
                color: kTeal.withOpacity(_glowAnim.value * .8),
                blurRadius: 10 * _glowAnim.value,
                spreadRadius: 1,
              )],
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Available for Work',
                  style: TextStyle(
                      color: kTeal, fontSize: 13, fontWeight: FontWeight.w700)),
              SizedBox(height: 2),
              Text('Open to freelance & full-time opportunities',
                  style: TextStyle(color: kMuted, fontSize: 12)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: kTeal.withOpacity(.12),
              border: Border.all(color: kTeal.withOpacity(.3)),
            ),
            child: const Text('Hire Me',
                style: TextStyle(color: kTeal, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ]),
      ),
    );
  }

  Widget _sectionLabel(String emoji, String label) {
    return Row(children: [
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
      Text(label, style: const TextStyle(
          color: kWhite, fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: -.2)),
    ]);
  }

  Widget _socialsGrid() {
    return Column(
      children: _socials.map((s) => _SocialTile(
        item: s,
        onTap: () => _open(s.url),
        glowAnim: _glowAnim,
      )).toList(),
    );
  }

  Widget _contactForm() {
    if (_sent) return _successCard();

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [
            kCyan.withOpacity(.07),
            kTeal.withOpacity(.04),
            kBg2.withOpacity(.97),
          ],
        ),
        border: Border.all(color: kCyan.withOpacity(.18), width: 1),
        boxShadow: [BoxShadow(
            color: kCyan.withOpacity(.07), blurRadius: 30, offset: const Offset(0, 8))],
      ),
      child: Column(children: [
        // name + email row
        Row(children: [
          Expanded(child: _field('Your Name *', _nameCtrl, 'name', Icons.person_outline_rounded)),
          const SizedBox(width: 12),
          Expanded(child: _field('Email *', _emailCtrl, 'email', Icons.email_outlined,
              keyboardType: TextInputType.emailAddress)),
        ]),
        const SizedBox(height: 14),
        _field('Subject', _subjectCtrl, 'subject', Icons.subject_rounded),
        const SizedBox(height: 14),
        _messageField(),
        const SizedBox(height: 20),
        _sendButton(),
      ]),
    );
  }

  Widget _field(String hint, TextEditingController ctrl, String id,
      IconData icon, {TextInputType? keyboardType}) {

    final isFocused = _focusedField == id;

    return Focus(
      onFocusChange: (f) => setState(() => _focusedField = f ? id : null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isFocused ? kCyan.withOpacity(.06) : kNavy.withOpacity(.4),
          border: Border.all(
            color: isFocused ? kCyan.withOpacity(.5) : kMuted.withOpacity(.2),
            width: isFocused ? 1.4 : 1,
          ),
          boxShadow: isFocused
              ? [BoxShadow(color: kCyan.withOpacity(.12), blurRadius: 16)]
              : [],
        ),
        child: TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          style: const TextStyle(color: kWhite, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: kMuted.withOpacity(.6), fontSize: 13),
            prefixIcon: Icon(icon,
                color: isFocused ? kCyan : kMuted.withOpacity(.5), size: 18),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _messageField() {
    const id = 'msg';
    final isFocused = _focusedField == id;

    return Focus(
      onFocusChange: (f) => setState(() => _focusedField = f ? id : null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isFocused ? kCyan.withOpacity(.06) : kNavy.withOpacity(.4),
          border: Border.all(
            color: isFocused ? kCyan.withOpacity(.5) : kMuted.withOpacity(.2),
            width: isFocused ? 1.4 : 1,
          ),
          boxShadow: isFocused
              ? [BoxShadow(color: kCyan.withOpacity(.12), blurRadius: 16)]
              : [],
        ),
        child: TextField(
          controller: _msgCtrl,
          maxLines: 5,
          style: const TextStyle(color: kWhite, fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Your message *',
            hintStyle: TextStyle(color: kMuted.withOpacity(.6), fontSize: 13),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Icon(Icons.chat_bubble_outline_rounded,
                  color: isFocused ? kCyan : kMuted.withOpacity(.5), size: 18),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
          ),
        ),
      ),
    );
  }

  Widget _sendButton() {
    return GestureDetector(
      onTap: _sending ? null : _sendMessage,
      child: AnimatedBuilder(
        animation: _glowAnim,
        builder: (_, __) => Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(colors: [kCyan, kCyan2, kCyan3]),
            boxShadow: [
              BoxShadow(
                color: kCyan.withOpacity(.35 * _glowAnim.value),
                blurRadius: 24 * _glowAnim.value,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: _sending
                ? const SizedBox(
                width: 22, height: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5))
                : const Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.send_rounded, color: kBg, size: 18),
              SizedBox(width: 10),
              Text('Send Message',
                  style: TextStyle(
                      color: kBg,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                      letterSpacing: .3)),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _successCard() {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (_, __) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(colors: [
            kTeal.withOpacity(.12),
            kCyan.withOpacity(.06),
            kBg2.withOpacity(.97),
          ]),
          border: Border.all(
              color: kTeal.withOpacity(.3 * _glowAnim.value), width: 1.2),
          boxShadow: [BoxShadow(
              color: kTeal.withOpacity(.12 * _glowAnim.value), blurRadius: 30)],
        ),
        child: Column(children: [
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [kTeal.withOpacity(.25), kCyan.withOpacity(.15)]),
              border: Border.all(color: kTeal.withOpacity(.4)),
              boxShadow: [BoxShadow(
                  color: kTeal.withOpacity(.35 * _glowAnim.value), blurRadius: 20)],
            ),
            child: const Center(child: Text('✅', style: TextStyle(fontSize: 30))),
          ),
          const SizedBox(height: 18),
          const Text("Message Sent!",
              style: TextStyle(color: kTeal, fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text("Thanks for reaching out. I'll get back\nto you within 24 hours.",
              textAlign: TextAlign.center,
              style: TextStyle(color: kMuted.withOpacity(.85), fontSize: 13.5, height: 1.65)),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => setState(() {
              _sent = false;
              _nameCtrl.clear(); _emailCtrl.clear();
              _subjectCtrl.clear(); _msgCtrl.clear();
            }),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kTeal.withOpacity(.35)),
                color: kTeal.withOpacity(.08),
              ),
              child: const Text('Send Another',
                  style: TextStyle(color: kTeal, fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _responseCard() {
    final items = [
      {'icon': '⚡', 'label': 'Response', 'val': '< 24h'},
      {'icon': '🌍', 'label': 'Timezone',  'val': 'GMT+6'},
      {'icon': '💬', 'label': 'Languages', 'val': 'EN / BN'},
    ];

    return Row(children: items.map((i) => Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(colors: [kCyan.withOpacity(.08), Colors.transparent]),
          border: Border.all(color: kCyan.withOpacity(.15)),
        ),
        child: Column(children: [
          Text(i['icon']!, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 6),
          Text(i['val']!,
              style: const TextStyle(color: kCyan, fontSize: 13, fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(i['label']!, style: TextStyle(color: kMuted, fontSize: 11)),
        ]),
      ),
    )).toList());
  }

  Widget _footer() {
    return Center(
      child: Text(
        '© 2025 Huzaifa Sani · Made with ❤️ in Flutter',
        style: TextStyle(color: kMuted.withOpacity(.45), fontSize: 12),
      ),
    );
  }
}


class _SocialItem {
  final String icon;
  final String label;
  final String value;
  final String url;
  final List<Color> colors;
  const _SocialItem(this.icon, this.label, this.value, this.url, this.colors);
}

class _SocialTile extends StatefulWidget {
  final _SocialItem item;
  final VoidCallback onTap;
  final Animation<double> glowAnim;

  const _SocialTile({
    required this.item,
    required this.onTap,
    required this.glowAnim,
  });

  @override
  State<_SocialTile> createState() => _SocialTileState();
}

class _SocialTileState extends State<_SocialTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final c1 = widget.item.colors[0];
    final c2 = widget.item.colors[1];

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp:   (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedBuilder(
        animation: widget.glowAnim,
        builder: (_, __) => AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.centerLeft, end: Alignment.centerRight,
              colors: [
                c1.withOpacity(_pressed ? .14 : .08),
                Colors.transparent,
              ],
            ),
            border: Border.all(
              color: c1.withOpacity(_pressed ? .4 : .18 * widget.glowAnim.value),
              width: 1,
            ),
            boxShadow: _pressed
                ? [BoxShadow(color: c1.withOpacity(.2), blurRadius: 20)]
                : [BoxShadow(color: c1.withOpacity(.05), blurRadius: 14)],
          ),
          child: Row(children: [
            // icon box
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                gradient: LinearGradient(colors: [c1.withOpacity(.2), c2.withOpacity(.12)]),
                border: Border.all(color: c1.withOpacity(.3)),
                boxShadow: [BoxShadow(
                    color: c1.withOpacity(.2 * widget.glowAnim.value), blurRadius: 12)],
              ),
              child: Center(child: Text(widget.item.icon,
                  style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.item.label,
                  style: TextStyle(
                      color: c1, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: .8)),
              const SizedBox(height: 3),
              Text(widget.item.value,
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
            ])),
            // copy button
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: widget.item.value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    duration: const Duration(seconds: 2),
                    content: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: c1.withOpacity(.12),
                        border: Border.all(color: c1.withOpacity(.3)),
                      ),
                      child: Text('Copied!',
                          style: TextStyle(color: c1, fontWeight: FontWeight.w600)),
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: c1.withOpacity(.08),
                  border: Border.all(color: c1.withOpacity(.2)),
                ),
                child: Icon(Icons.copy_rounded, color: c1.withOpacity(.7), size: 14),
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 13, color: c1.withOpacity(.4)),
          ]),
        ),
      ),
    );
  }
}


class _ContactBgPainter extends CustomPainter {
  final double t;
  _ContactBgPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h),
        Paint()..color = const Color(0xFF0D0B1A));

    _blob(canvas, Offset(w * (.9 - t * .04), h * .05), w * .5, kCyan, .10);
    _blob(canvas, Offset(w * (.0 + t * .03), h * .35), w * .45, const Color(0xFF7C3AED), .12);
    _blob(canvas, Offset(w * .5, h * .85), w * .5, kTeal, .09);

    final dot = Paint()..color = kCyan.withOpacity(.018);
    const step = 44.0;
    for (double x = 0; x < w; x += step)
      for (double y = 0; y < h; y += step)
        canvas.drawCircle(Offset(x, y), .7, dot);
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
  bool shouldRepaint(_ContactBgPainter o) => o.t != t;
}


class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowCtrl;
  late Animation<double> _glowAnim;

  static const _socials = [
    _SocialItem('✉️', 'EMAIL',    'huzaifa0133@gmail.com',         'mailto:huzaifa0133@gmail.com',       [kCyan, kCyan2]),
    _SocialItem('⌨',  'GITHUB',   'github.com/huzaifa-sani',       'https://github.com/huzaifa-sani',    [Color(0xFF818CF8), Color(0xFFA78BFA)]),
    _SocialItem('💼', 'LINKEDIN', 'linkedin.com/in/huzaifa-sani',  'https://www.linkedin.com/in/huzaifa-sani-525b36304/', [Color(0xFF0EA5E9), Color(0xFF38BDF8)]),
    _SocialItem('f',  'FACEBOOK', 'facebook.com/hoya.ipha.sani',   'https://www.facebook.com/hoya.ipha.sani', [Color(0xFF6366F1), Color(0xFF818CF8)]),
  ];

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: .6, end: 1.0)
        .animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _glowCtrl.dispose(); super.dispose(); }

  Future<void> _open(String url) async {
    final u = Uri.parse(url);
    if (await canLaunchUrl(u)) await launchUrl(u);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ..._socials.map((s) => _SocialTile(
        item: s,
        onTap: () => _open(s.url),
        glowAnim: _glowAnim,
      )),
      const SizedBox(height: 14),
      // "Open full contact page" button
      GestureDetector(
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const ContactPage())),
        child: AnimatedBuilder(
          animation: _glowAnim,
          builder: (_, __) => Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(colors: [kCyan, kCyan2, kCyan3]),
              boxShadow: [BoxShadow(
                color: kCyan.withOpacity(.35 * _glowAnim.value),
                blurRadius: 22, spreadRadius: 1, offset: const Offset(0, 4),
              )],
            ),
            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.send_rounded, color: kBg, size: 18),
              SizedBox(width: 10),
              Text('Open Full Contact Page',
                  style: TextStyle(
                      color: kBg, fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: .3)),
            ]),
          ),
        ),
      ),
    ]);
  }
}