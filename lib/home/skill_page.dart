import 'dart:math';
import 'package:flutter/material.dart';

const kBg    = Color(0xFF020B18);
const kBg2   = Color(0xFF051525);
const kCyan  = Color(0xFF22D3EE);
const kCyan2 = Color(0xFF06B6D4);
const kTeal  = Color(0xFF14B8A6);
const kIce   = Color(0xFFBAE6FD);
const kNavy  = Color(0xFF0C1F35);
const kText  = Color(0xFFCBD5E1);
const kMuted = Color(0xFF475569);
const kWhite = Color(0xFFF0F9FF);

const _skills = [
  {'label': 'Flutter',    'pct': 0.88, 'icon': '📱', 'desc': 'Cross-platform magic'},
  {'label': 'Dart',       'pct': 0.85, 'icon': '🎯', 'desc': 'Fast & expressive'},
  {'label': 'Firebase',   'pct': 0.75, 'icon': '🔥', 'desc': 'Realtime backend'},
  {'label': 'REST API',   'pct': 0.80, 'icon': '🌐', 'desc': 'Seamless integration'},
  {'label': 'Git/GitHub', 'pct': 0.78, 'icon': '🐙', 'desc': 'Version control'},
  {'label': 'UI/UX',      'pct': 0.72, 'icon': '🎨', 'desc': 'Pixel-perfect design'},
];

// Commit data — last 30 days
const _commits = [
  2, 1, 3, 0, 5, 4, 2, 1, 0, 3,
  6, 2, 1, 4, 8, 3, 2, 0, 1, 5,
  12, 3, 2, 4, 1, 0, 3, 7, 2, 4,
];

const _dayLabels = [
  'D1','','','','D5','','','','','D10',
  '','','','','D15','','','','','D20',
  '','','','','D25','','','','','D30',
];

// ════════════════════════════════════════════════════════
class SkillPage extends StatefulWidget {
  const SkillPage({super.key});
  @override
  State<SkillPage> createState() => _SkillPageState();
}

class _SkillPageState extends State<SkillPage> with TickerProviderStateMixin {
  late AnimationController _bgCtrl;
  late AnimationController _radarCtrl;
  late AnimationController _chartCtrl;
  late AnimationController _rotCtrl;
  late AnimationController _entCtrl;

  late Animation<double> _bgAnim;
  late Animation<double> _radarAnim;
  late Animation<double> _chartAnim;
  late Animation<double> _fadeAnim;
  late Animation<Offset>  _slideAnim;

  int _selectedSkill = -1;
  int? _hoveredPoint;

  @override
  void initState() {
    super.initState();

    _bgCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 8))
      ..repeat(reverse: true);
    _bgAnim = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut);

    _radarCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    _radarAnim = CurvedAnimation(parent: _radarCtrl, curve: Curves.easeOutCubic);

    _chartCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    _chartAnim = CurvedAnimation(parent: _chartCtrl, curve: Curves.easeOutCubic);

    _rotCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 30))
      ..repeat();

    _entCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fadeAnim  = CurvedAnimation(parent: _entCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, .15), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entCtrl, curve: Curves.easeOutCubic));

    _entCtrl.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _radarCtrl.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _chartCtrl.forward();
    });
  }

  @override
  void dispose() {
    _bgCtrl.dispose(); _radarCtrl.dispose(); _chartCtrl.dispose();
    _rotCtrl.dispose(); _entCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Stack(children: [
        AnimatedBuilder(
          animation: _bgAnim,
          builder: (_, __) => CustomPaint(
            painter: _BgPainter(_bgAnim.value),
            size: MediaQuery.of(context).size,
          ),
        ),
        SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _appBar(context)),
                  SliverToBoxAdapter(child: _radarHero()),
                  SliverToBoxAdapter(child: _activitySection()),
                  SliverToBoxAdapter(child: _sectionTitle()),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.3,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (ctx, i) => _SkillCard(
                          skill: _skills[i],
                          index: i,
                          isSelected: _selectedSkill == i,
                          onTap: () => setState(
                                  () => _selectedSkill = _selectedSkill == i ? -1 : i),
                        ),
                        childCount: _skills.length,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  // ── App Bar ────────────────────────────────────────────────
  Widget _appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: kCyan.withOpacity(.08),
              border: Border.all(color: kCyan.withOpacity(.25)),
              boxShadow: [BoxShadow(color: kCyan.withOpacity(.12), blurRadius: 12)],
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: kCyan, size: 16),
          ),
        ),
        const SizedBox(width: 14),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('My Skills', style: TextStyle(
              color: kWhite, fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -.3)),
          Text('${_skills.length} technologies mastered',
              style: TextStyle(color: kMuted, fontSize: 12)),
        ]),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: [kCyan.withOpacity(.18), kTeal.withOpacity(.10)]),
            border: Border.all(color: kCyan.withOpacity(.3)),
            boxShadow: [BoxShadow(color: kCyan.withOpacity(.2), blurRadius: 14)],
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 6, height: 6,
                decoration: BoxDecoration(shape: BoxShape.circle, color: kTeal,
                    boxShadow: [BoxShadow(color: kTeal.withOpacity(.8), blurRadius: 6)])),
            const SizedBox(width: 6),
            const Text('Active', style: TextStyle(
                color: kCyan, fontSize: 11, fontWeight: FontWeight.w700)),
          ]),
        ),
      ]),
    );
  }

  // ── Radar Hero ─────────────────────────────────────────────
  Widget _radarHero() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [kCyan.withOpacity(.10), kTeal.withOpacity(.05),
            kNavy.withOpacity(.6), kBg2.withOpacity(.95)],
        ),
        border: Border.all(color: kCyan.withOpacity(.2)),
        boxShadow: [
          BoxShadow(color: kCyan.withOpacity(.12), blurRadius: 40, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(children: [
        // label
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(width: 6, height: 6,
              decoration: BoxDecoration(shape: BoxShape.circle, color: kCyan,
                  boxShadow: [BoxShadow(color: kCyan.withOpacity(.8), blurRadius: 8)])),
          const SizedBox(width: 8),
          const Text('SKILL RADAR', style: TextStyle(
              color: kCyan, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2)),
          const SizedBox(width: 8),
          Container(width: 6, height: 6,
              decoration: BoxDecoration(shape: BoxShape.circle, color: kCyan,
                  boxShadow: [BoxShadow(color: kCyan.withOpacity(.8), blurRadius: 8)])),
        ]),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: Listenable.merge([_radarAnim, _rotCtrl]),
          builder: (_, __) => SizedBox(
            height: 250,
            child: CustomPaint(
              painter: _RadarPainter(
                progress: _radarAnim.value,
                slowRot: _rotCtrl.value * 2 * pi * 0.015,
                selected: _selectedSkill,
              ),
              size: const Size(double.infinity, 250),
            ),
          ),
        ),
        const SizedBox(height: 14),
        // legend
        Wrap(
          spacing: 8, runSpacing: 8,
          alignment: WrapAlignment.center,
          children: List.generate(_skills.length, (i) {
            final s = _skills[i];
            final sel = _selectedSkill == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedSkill = sel ? -1 : i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: sel ? kCyan.withOpacity(.2) : kCyan.withOpacity(.07),
                  border: Border.all(
                      color: sel ? kCyan.withOpacity(.7) : kCyan.withOpacity(.2),
                      width: sel ? 1.5 : 1),
                  boxShadow: sel
                      ? [BoxShadow(color: kCyan.withOpacity(.3), blurRadius: 14)]
                      : null,
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(s['icon'] as String, style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 5),
                  Text(s['label'] as String, style: TextStyle(
                      color: sel ? kCyan : kText,
                      fontSize: 11, fontWeight: FontWeight.w600)),
                ]),
              ),
            );
          }),
        ),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════
  //  ACTIVITY SECTION
  // ══════════════════════════════════════════════════════════
  Widget _activitySection() {
    final totalCommits = _commits.fold(0, (a, b) => a + b);
    final maxCommit = _commits.reduce(max);
    final avgCommit = (totalCommits / _commits.length).toStringAsFixed(1);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [kTeal.withOpacity(.10), kCyan.withOpacity(.05),
            kNavy.withOpacity(.5), kBg2.withOpacity(.95)],
        ),
        border: Border.all(color: kCyan.withOpacity(.18)),
        boxShadow: [
          BoxShadow(color: kTeal.withOpacity(.10), blurRadius: 36, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // header
        Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: [kCyan.withOpacity(.22), kTeal.withOpacity(.14)]),
              border: Border.all(color: kCyan.withOpacity(.3)),
              boxShadow: [BoxShadow(color: kCyan.withOpacity(.2), blurRadius: 12)],
            ),
            child: const Text('⚡', style: TextStyle(fontSize: 14)),
          ),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Coding Activity', style: TextStyle(
                color: kWhite, fontSize: 16, fontWeight: FontWeight.w800)),
            Text('Last 30 days', style: TextStyle(color: kMuted, fontSize: 11)),
          ]),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: kTeal.withOpacity(.12),
              border: Border.all(color: kTeal.withOpacity(.3)),
            ),
            child: Text('$totalCommits commits',
                style: const TextStyle(color: kTeal, fontSize: 10, fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 20),

        // stats row
        Row(children: [
          _miniStat('Peak', '$maxCommit', '🔺'),
          const SizedBox(width: 8),
          _miniStat('Avg/day', avgCommit, '📈'),
          const SizedBox(width: 8),
          _miniStat('Active days',
              '${_commits.where((c) => c > 0).length}', '🟢'),
        ]),
        const SizedBox(height: 18),

        // chart
        AnimatedBuilder(
          animation: _chartAnim,
          builder: (_, __) => GestureDetector(
            onTapDown: (d) {
              final box = context.findRenderObject() as RenderBox?;
              if (box == null) return;
              final chartW = box.size.width - 32 - 24;
              final step = chartW / (_commits.length - 1);
              final localX = d.localPosition.dx - 24;
              final idx = (localX / step).round().clamp(0, _commits.length - 1);
              setState(() => _hoveredPoint = idx);
            },
            onTapUp: (_) => Future.delayed(
                const Duration(seconds: 2), () {
              if (mounted) setState(() => _hoveredPoint = null);
            }),
            child: SizedBox(
              height: 140,
              child: CustomPaint(
                painter: _LinePainter(
                  commits: _commits,
                  progress: _chartAnim.value,
                  hoveredIndex: _hoveredPoint,
                ),
                size: const Size(double.infinity, 140),
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),
        // day labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['Day 1', 'Day 10', 'Day 15', 'Day 20', 'Day 30']
              .map((d) => Text(d, style: TextStyle(color: kMuted, fontSize: 9)))
              .toList(),
        ),

        // hovered tooltip
        if (_hoveredPoint != null)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: kCyan.withOpacity(.15),
                  border: Border.all(color: kCyan.withOpacity(.4)),
                  boxShadow: [BoxShadow(color: kCyan.withOpacity(.2), blurRadius: 14)],
                ),
                child: Text(
                  'Day ${_hoveredPoint! + 1}  •  ${_commits[_hoveredPoint!]} commits',
                  style: const TextStyle(color: kCyan, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
      ]),
    );
  }

  Widget _miniStat(String label, String val, String icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: kCyan.withOpacity(.06),
          border: Border.all(color: kCyan.withOpacity(.14)),
        ),
        child: Row(children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 7),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(val, style: const TextStyle(
                color: kCyan, fontSize: 14, fontWeight: FontWeight.w800,
                shadows: [Shadow(color: kCyan, blurRadius: 8)])),
            Text(label, style: TextStyle(color: kMuted, fontSize: 9)),
          ]),
        ]),
      ),
    );
  }

  // ── Section title ──────────────────────────────────────────
  Widget _sectionTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 14),
      child: Row(children: [
        Container(width: 4, height: 22,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              gradient: const LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [kCyan, kTeal]),
              boxShadow: [BoxShadow(color: kCyan.withOpacity(.5), blurRadius: 8)],
            )),
        const SizedBox(width: 12),
        const Text('Skill Breakdown', style: TextStyle(
            color: kWhite, fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -.2)),
        const Spacer(),
        Text('Tap to highlight', style: TextStyle(color: kMuted, fontSize: 11)),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════
//  LINE CHART PAINTER
// ════════════════════════════════════════════════════════
class _LinePainter extends CustomPainter {
  final List<int> commits;
  final double progress;
  final int? hoveredIndex;

  _LinePainter({required this.commits, required this.progress, this.hoveredIndex});

  @override
  void paint(Canvas canvas, Size size) {
    if (commits.isEmpty) return;

    final w = size.width;
    final h = size.height;
    final maxVal = commits.reduce(max).toDouble();
    final padL = 8.0, padR = 8.0, padT = 16.0, padB = 10.0;
    final chartW = w - padL - padR;
    final chartH = h - padT - padB;
    final step = chartW / (commits.length - 1);

    // how many points to draw based on progress
    final drawCount = (commits.length * progress).clamp(0, commits.length).toInt();
    if (drawCount < 2) return;

    // helper: point position
    Offset pt(int i) {
      final x = padL + i * step;
      final y = padT + chartH - (commits[i] / maxVal) * chartH;
      return Offset(x, y);
    }

    // ── horizontal guide lines ──────────────────────────────
    final guidePaint = Paint()
      ..color = kCyan.withOpacity(.07)
      ..strokeWidth = 1;
    for (int lvl = 0; lvl <= 4; lvl++) {
      final y = padT + chartH - (lvl / 4) * chartH;
      canvas.drawLine(Offset(padL, y), Offset(w - padR, y), guidePaint);
    }

    // ── fill area (gradient under the line) ────────────────
    final fillPath = Path();
    fillPath.moveTo(pt(0).dx, padT + chartH);
    for (int i = 0; i < drawCount; i++) {
      fillPath.lineTo(pt(i).dx, pt(i).dy);
    }
    fillPath.lineTo(pt(drawCount - 1).dx, padT + chartH);
    fillPath.close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [
            kCyan.withOpacity(.25),
            kTeal.withOpacity(.12),
            kCyan.withOpacity(.03),
          ],
        ).createShader(Rect.fromLTWH(0, padT, w, chartH)),
    );

    // ── glow line ───────────────────────────────────────────
    final glowPath = Path();
    glowPath.moveTo(pt(0).dx, pt(0).dy);
    for (int i = 1; i < drawCount; i++) {
      // smooth curve
      final prev = pt(i - 1);
      final curr = pt(i);
      final cpx = (prev.dx + curr.dx) / 2;
      glowPath.cubicTo(cpx, prev.dy, cpx, curr.dy, curr.dx, curr.dy);
    }
    canvas.drawPath(glowPath, Paint()
      ..color = kCyan.withOpacity(.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));

    // ── main line ───────────────────────────────────────────
    canvas.drawPath(glowPath, Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft, end: Alignment.centerRight,
        colors: [kCyan, kTeal, kCyan2],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round);

    // ── dots ────────────────────────────────────────────────
    for (int i = 0; i < drawCount; i++) {
      final p = pt(i);
      final isHov = hoveredIndex == i;
      final isHigh = commits[i] >= 5;

      if (isHov) {
        // big hovered glow
        canvas.drawCircle(p, 14, Paint()
          ..color = kCyan.withOpacity(.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8));
        canvas.drawCircle(p, 7, Paint()..color = kCyan.withOpacity(.9));
        canvas.drawCircle(p, 3.5, Paint()..color = Colors.white);

        // vertical dashed line
        final dashPaint = Paint()
          ..color = kCyan.withOpacity(.4)
          ..strokeWidth = 1;
        double dy = p.dy + 10;
        while (dy < padT + chartH) {
          canvas.drawLine(Offset(p.dx, dy), Offset(p.dx, dy + 5), dashPaint);
          dy += 10;
        }
      } else if (isHigh) {
        canvas.drawCircle(p, 8, Paint()
          ..color = kCyan.withOpacity(.2)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5));
        canvas.drawCircle(p, 4.5, Paint()..color = kCyan.withOpacity(.95));
        canvas.drawCircle(p, 2, Paint()..color = Colors.white.withOpacity(.9));
      } else {
        canvas.drawCircle(p, 5, Paint()
          ..color = kCyan.withOpacity(.15)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3));
        canvas.drawCircle(p, 3, Paint()..color = kCyan2.withOpacity(.85));
        canvas.drawCircle(p, 1.2, Paint()..color = Colors.white.withOpacity(.8));
      }
    }

    // ── peak label ──────────────────────────────────────────
    if (progress > 0.9) {
      final peakIdx = commits.indexWhere((c) => c == commits.reduce(max));
      final peakPt = pt(peakIdx);
      final tp = TextPainter(
        text: TextSpan(
          text: '🔺 ${commits[peakIdx]}',
          style: const TextStyle(
              color: kWhite, fontSize: 10, fontWeight: FontWeight.w700),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      // label bubble
      final bubbleRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
            peakPt.dx - tp.width / 2 - 8, peakPt.dy - 28,
            tp.width + 16, 20),
        const Radius.circular(8),
      );
      canvas.drawRRect(bubbleRect, Paint()
        ..color = kCyan.withOpacity(.18));
      canvas.drawRRect(bubbleRect, Paint()
        ..color = kCyan.withOpacity(.5)
        ..style = PaintingStyle.stroke..strokeWidth = 1);
      tp.paint(canvas, Offset(peakPt.dx - tp.width / 2, peakPt.dy - 26));
    }
  }

  @override
  bool shouldRepaint(_LinePainter o) =>
      o.progress != progress || o.hoveredIndex != hoveredIndex;
}

// ════════════════════════════════════════════════════════
//  SKILL CARD
// ════════════════════════════════════════════════════════
class _SkillCard extends StatefulWidget {
  final Map skill;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;
  const _SkillCard({required this.skill, required this.index,
    required this.isSelected, required this.onTap});

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fillAnim;
  late Animation<double> _fadeAnim;
  late Animation<Offset>  _slideAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fillAnim = Tween<double>(begin: 0, end: widget.skill['pct'] as double)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fadeAnim  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, .25), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: 400 + widget.index * 90), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final sel = widget.isSelected;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: sel
                      ? [kCyan.withOpacity(.2), kTeal.withOpacity(.12), kBg2.withOpacity(.9)]
                      : [kCyan.withOpacity(.08), kTeal.withOpacity(.03), kBg2.withOpacity(.96)],
                ),
                border: Border.all(
                    color: sel ? kCyan.withOpacity(.55) : kCyan.withOpacity(.15),
                    width: sel ? 1.5 : 1),
                boxShadow: [
                  BoxShadow(
                      color: kCyan.withOpacity(sel ? .2 : .06),
                      blurRadius: sel ? 28 : 14,
                      offset: const Offset(0, 4)),
                  if (sel) BoxShadow(color: kCyan.withOpacity(.08), blurRadius: 40),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: kCyan.withOpacity(.1),
                        border: Border.all(color: kCyan.withOpacity(.2)),
                        boxShadow: [BoxShadow(color: kCyan.withOpacity(.15), blurRadius: 10)],
                      ),
                      child: Center(child: Text(widget.skill['icon'] as String,
                          style: const TextStyle(fontSize: 18))),
                    ),
                    SizedBox(width: 36, height: 36,
                        child: CustomPaint(
                            painter: _RingPainter(_fillAnim.value, sel))),
                  ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(widget.skill['label'] as String,
                        style: TextStyle(
                            color: sel ? kWhite : kText,
                            fontSize: 14, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(widget.skill['desc'] as String,
                        style: TextStyle(color: kMuted, fontSize: 10),
                        overflow: TextOverflow.ellipsis),
                  ]),
                  Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Proficiency',
                          style: TextStyle(color: kMuted, fontSize: 9, letterSpacing: .5)),
                      Text('${(_fillAnim.value * 100).toInt()}%',
                          style: TextStyle(
                              color: sel ? kCyan : kCyan2, fontSize: 12,
                              fontWeight: FontWeight.w800,
                              shadows: sel ? [const Shadow(color: kCyan, blurRadius: 10)] : null)),
                    ]),
                    const SizedBox(height: 5),
                    Stack(children: [
                      Container(height: 5,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: kCyan.withOpacity(.08))),
                      FractionallySizedBox(
                        widthFactor: _fillAnim.value,
                        child: Container(
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            gradient: const LinearGradient(colors: [kCyan, kTeal]),
                            boxShadow: [BoxShadow(
                                color: kCyan.withOpacity(sel ? .7 : .4),
                                blurRadius: sel ? 10 : 6)],
                          ),
                        ),
                      ),
                    ]),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════
//  RING PAINTER
// ════════════════════════════════════════════════════════
class _RingPainter extends CustomPainter {
  final double value;
  final bool selected;
  _RingPainter(this.value, this.selected);

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 - 3;

    canvas.drawCircle(c, r, Paint()
      ..color = kCyan.withOpacity(.1)
      ..style = PaintingStyle.stroke..strokeWidth = 3);

    final sweepPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    if (selected) {
      sweepPaint.shader = const SweepGradient(
        startAngle: 0, endAngle: pi * 2,
        colors: [kCyan, kTeal, kCyan],
      ).createShader(Rect.fromCircle(center: c, radius: r));
    } else {
      sweepPaint.color = kCyan.withOpacity(.8);
    }

    canvas.drawArc(Rect.fromCircle(center: c, radius: r),
        -pi / 2, 2 * pi * value, false, sweepPaint);

    final tp = TextPainter(
      text: TextSpan(
        text: '${(value * 100).toInt()}',
        style: TextStyle(
            color: selected ? kCyan : kCyan.withOpacity(.8),
            fontSize: 9, fontWeight: FontWeight.w800),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(c.dx - tp.width / 2, c.dy - tp.height / 2));
  }

  @override
  bool shouldRepaint(_RingPainter o) => o.value != value || o.selected != selected;
}


class _RadarPainter extends CustomPainter {
  final double progress;
  final double slowRot;
  final int selected;

  _RadarPainter({required this.progress, required this.slowRot, required this.selected});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final maxR = min(cx, cy) - 32.0;
    final n = _skills.length;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.rotate(slowRot);

    for (int lvl = 1; lvl <= 5; lvl++) {
      final r = maxR * lvl / 5;
      final path = Path();
      for (int i = 0; i < n; i++) {
        final a = 2 * pi * i / n - pi / 2;
        final pt = Offset(r * cos(a), r * sin(a));
        i == 0 ? path.moveTo(pt.dx, pt.dy) : path.lineTo(pt.dx, pt.dy);
      }
      path.close();
      canvas.drawPath(path, Paint()
        ..color = kCyan.withOpacity(.05 + .015 * lvl)
        ..style = PaintingStyle.stroke..strokeWidth = 1);
    }

    for (int i = 0; i < n; i++) {
      final a = 2 * pi * i / n - pi / 2;
      canvas.drawLine(Offset.zero,
          Offset(maxR * cos(a), maxR * sin(a)),
          Paint()..color = kCyan.withOpacity(.1)..strokeWidth = 1);
    }

    final vals = _skills.map((s) => s['pct'] as double).toList();
    final dataPath = Path();
    for (int i = 0; i < n; i++) {
      final a = 2 * pi * i / n - pi / 2;
      final r = maxR * vals[i] * progress;
      final pt = Offset(r * cos(a), r * sin(a));
      i == 0 ? dataPath.moveTo(pt.dx, pt.dy) : dataPath.lineTo(pt.dx, pt.dy);
    }
    dataPath.close();

    canvas.drawPath(dataPath, Paint()
      ..shader = RadialGradient(colors: [
        kCyan.withOpacity(.28 * progress),
        kTeal.withOpacity(.14 * progress),
        Colors.transparent,
      ]).createShader(Rect.fromCircle(center: Offset.zero, radius: maxR))
      ..style = PaintingStyle.fill);

    canvas.drawPath(dataPath, Paint()
      ..color = kCyan.withOpacity(.6 * progress)
      ..style = PaintingStyle.stroke..strokeWidth = 2.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));

    canvas.drawPath(dataPath, Paint()
      ..color = kCyan.withOpacity(.95 * progress)
      ..style = PaintingStyle.stroke..strokeWidth = 1.8);

    for (int i = 0; i < n; i++) {
      final a = 2 * pi * i / n - pi / 2;
      final r = maxR * vals[i] * progress;
      final pt = Offset(r * cos(a), r * sin(a));
      final isSel = selected == i;
      canvas.drawCircle(pt, isSel ? 12 : 8, Paint()
        ..color = kCyan.withOpacity(isSel ? .3 : .12)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
      canvas.drawCircle(pt, isSel ? 6 : 4.5, Paint()..color = kCyan.withOpacity(.9 * progress));
      canvas.drawCircle(pt, isSel ? 3 : 2.2, Paint()..color = Colors.white.withOpacity(.95 * progress));
    }

    canvas.restore();

    for (int i = 0; i < n; i++) {
      final a = 2 * pi * i / n - pi / 2;
      final x = cx + (maxR + 26) * cos(a);
      final y = cy + (maxR + 26) * sin(a);
      final isSel = selected == i;
      final tp = TextPainter(
        text: TextSpan(
          text: '${(vals[i] * 100).toInt()}%',
          style: TextStyle(
              color: isSel ? kWhite : kCyan.withOpacity(.8 * progress),
              fontSize: isSel ? 12 : 10,
              fontWeight: isSel ? FontWeight.w900 : FontWeight.w600),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(_RadarPainter o) =>
      o.progress != progress || o.slowRot != slowRot || o.selected != selected;
}

// ════════════════════════════════════════════════════════
//  BACKGROUND PAINTER
// ════════════════════════════════════════════════════════
class _BgPainter extends CustomPainter {
  final double t;
  _BgPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h),
        Paint()..shader = const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF020B18), Color(0xFF030F20), Color(0xFF041322)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)));

    void blob(Offset c, double r, Color col, double op) => canvas.drawCircle(c, r,
        Paint()..shader = RadialGradient(colors: [col.withOpacity(op), Colors.transparent])
            .createShader(Rect.fromCircle(center: c, radius: r)));

    blob(Offset(w * (.08 + t * .05), h * (.1 + t * .04)), w * .65, kCyan, .12);
    blob(Offset(w * (.88 - t * .04), h * (.15 + t * .03)), w * .55, kTeal, .09);
    blob(Offset(w * (.5 + t * .03),  h * (.8 - t * .03)),  w * .5,  kCyan2, .10);

    final dot = Paint()..color = kCyan.withOpacity(.04);
    for (double x = 0; x < w; x += 46) {
      for (double y = 0; y < h; y += 46) {
        canvas.drawCircle(Offset(x, y), .9, dot);
      }
    }
    final rng = Random(5);
    for (int i = 0; i < 40; i++) {
      final px = rng.nextDouble() * w;
      final py = (rng.nextDouble() * h + t * 85) % h;
      canvas.drawCircle(Offset(px, py), rng.nextDouble() * 1.4 + .3,
          Paint()..color = kCyan.withOpacity(rng.nextDouble() * .28 + .04));
    }
  }

  @override
  bool shouldRepaint(_BgPainter o) => o.t != t;
}