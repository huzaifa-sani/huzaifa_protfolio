import 'package:flutter/material.dart';

const kBg    = Color(0xFF0D0B1A);
const kBg2   = Color(0xFF051525);
const kCyan  = Color(0xFF22D3EE);
const kCyan2 = Color(0xFF06B6D4);
const kCyan3 = Color(0xFF0E7490);
const kTeal  = Color(0xFF14B8A6);
const kIce   = Color(0xFFBAE6FD);
const kNavy  = Color(0xFF0C1F35);
const kMuted = Color(0xFF475569);
const kWhite = Color(0xFFF0F9FF);


class ContactSection extends StatefulWidget {
  const ContactSection({super.key});
  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with SingleTickerProviderStateMixin {
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _msgCtrl     = TextEditingController();
  final _phoneCtrl   = TextEditingController();
  bool  _sending     = false;
  bool  _sent        = false;

  late AnimationController _btnCtrl;
  late Animation<double>   _btnShine;

  @override
  void initState() {
    super.initState();
    _btnCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))..repeat();
    _btnShine = Tween<double>(begin: -1.5, end: 2.5)
        .animate(CurvedAnimation(parent: _btnCtrl, curve: Curves.linear));
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose();
    _msgCtrl.dispose();  _phoneCtrl.dispose();
    _btnCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_nameCtrl.text.isEmpty || _emailCtrl.text.isEmpty || _msgCtrl.text.isEmpty) return;
    setState(() => _sending = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() { _sending = false; _sent = true; });
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) setState(() => _sent = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── headline ──
        const Text(
          "Let's Start a",
          style: TextStyle(
            color: kWhite, fontSize: 28,
            fontWeight: FontWeight.w900, letterSpacing: -.5,
          ),
        ),
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [kCyan, kTeal],
          ).createShader(b),
          child: const Text(
            'Conversation.',
            style: TextStyle(
              color: Colors.white, fontSize: 28,
              fontWeight: FontWeight.w900, letterSpacing: -.5,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "I'm currently open to freelance projects & full-time\n"
              "opportunities. Have an idea? Let's build it together.",
          style: TextStyle(
            color: kMuted.withOpacity(.85), fontSize: 13.5, height: 1.7,
          ),
        ),
        const SizedBox(height: 24),

        // ── form card ──
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [kCyan.withOpacity(.07), kNavy.withOpacity(.6), kBg2.withOpacity(.95)],
            ),
            border: Border.all(color: kCyan.withOpacity(.2), width: 1.2),
            boxShadow: [
              BoxShadow(color: kCyan.withOpacity(.08), blurRadius: 30, offset: const Offset(0, 8)),
            ],
          ),
          child: Column(children: [
            _Field(_nameCtrl,  'Your Name',  Icons.person_outline_rounded),
            const SizedBox(height: 14),
            _Field(_phoneCtrl, 'Phone No.',  Icons.phone_outlined),
            const SizedBox(height: 14),
            _Field(_emailCtrl, 'Email Address', Icons.email_outlined),
            const SizedBox(height: 14),
            _MsgField(_msgCtrl),
            const SizedBox(height: 20),

            // send button
            AnimatedBuilder(
              animation: _btnShine,
              builder: (_, __) => GestureDetector(
                onTap: _sent ? null : _send,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: _sent
                        ? const LinearGradient(colors: [Color(0xFF059669), Color(0xFF10B981)])
                        : const LinearGradient(colors: [kCyan, kCyan2, kCyan3]),
                    boxShadow: [
                      BoxShadow(
                        color: (_sent ? const Color(0xFF10B981) : kCyan).withOpacity(.4),
                        blurRadius: 22, spreadRadius: 1, offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(alignment: Alignment.center, children: [
                      // shine sweep
                      if (!_sent)
                        Positioned.fill(
                          child: Transform.translate(
                            offset: Offset(_btnShine.value * 120, 0),
                            child: Container(
                              width: 30,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.white.withOpacity(0),
                                  Colors.white.withOpacity(.15),
                                  Colors.white.withOpacity(0),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      // label
                      _sending
                          ? const SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5))
                          : Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(
                          _sent ? Icons.check_circle_rounded : Icons.send_rounded,
                          color: kBg, size: 18,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          _sent ? 'Message Sent!' : 'Send Message',
                          style: const TextStyle(
                            color: kBg, fontWeight: FontWeight.w800,
                            fontSize: 15, letterSpacing: .3,
                          ),
                        ),
                      ]),
                    ]),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

// ── Info tile ──────────────────────────────────
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String   label, value;
  const _InfoTile(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      gradient: LinearGradient(
        colors: [kCyan.withOpacity(.08), Colors.transparent],
      ),
      border: Border.all(color: kCyan.withOpacity(.16), width: 1),
    ),
    child: Row(children: [
      Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: kCyan.withOpacity(.10),
          border: Border.all(color: kCyan.withOpacity(.22)),
          boxShadow: [BoxShadow(color: kCyan.withOpacity(.15), blurRadius: 10)],
        ),
        child: Icon(icon, color: kCyan, size: 16),
      ),
      const SizedBox(width: 14),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(
            color: kCyan, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1.0)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
      ]),
    ]),
  );
}

// ── Text field ─────────────────────────────────
class _Field extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final IconData icon;
  const _Field(this.ctrl, this.hint, this.icon);

  @override
  Widget build(BuildContext context) => TextField(
    controller: ctrl,
    style: const TextStyle(color: kWhite, fontSize: 14),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: kMuted.withOpacity(.6), fontSize: 13),
      prefixIcon: Icon(icon, color: kCyan.withOpacity(.5), size: 18),
      filled: true,
      fillColor: kNavy.withOpacity(.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: kCyan.withOpacity(.18)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: kCyan.withOpacity(.18)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: kCyan.withOpacity(.5), width: 1.5),
      ),
    ),
  );
}

// ── Message field ──────────────────────────────
class _MsgField extends StatelessWidget {
  final TextEditingController ctrl;
  const _MsgField(this.ctrl);

  @override
  Widget build(BuildContext context) => TextField(
    controller: ctrl,
    maxLines: 4,
    style: const TextStyle(color: kWhite, fontSize: 14),
    decoration: InputDecoration(
      hintText: 'Tell me about your project...',
      hintStyle: TextStyle(color: kMuted.withOpacity(.6), fontSize: 13),
      filled: true,
      fillColor: kNavy.withOpacity(.5),
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: kCyan.withOpacity(.18)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: kCyan.withOpacity(.18)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: kCyan.withOpacity(.5), width: 1.5),
      ),
    ),
  );
}