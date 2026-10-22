import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'game_data.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SohbetKutusuApp());
}

const bg = Color(0xFF0A0E20);
const surface = Color(0xFF171D34);
const cardShade = Color(0xFF1C2440);
const softText = Color(0xFFAFB9D2);
const lavender = Color(0xFFAB8CFF);
const aqua = Color(0xFF64E4D2);

class PlayerProgress extends ChangeNotifier {
  SharedPreferences? _prefs;
  bool ready = false;
  int streak = 1;
  int todayRounds = 0;
  final Map<GameMode, int> counts = {
    for (final mode in GameMode.values) mode: 0,
  };

  int get totalRounds => counts.values.fold(0, (a, b) => a + b);
  int get level => totalRounds ~/ 15 + 1;
  int get dailyGoal => min(todayRounds, 10);

  String _dayStamp(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<void> load() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      for (final mode in GameMode.values) {
        counts[mode] = _prefs?.getInt('cards_${mode.name}') ?? 0;
      }
      final now = DateTime.now();
      final today = _dayStamp(now);
      final yesterday = _dayStamp(now.subtract(const Duration(days: 1)));
      final lastDay = _prefs?.getString('last_visit');
      streak = _prefs?.getInt('streak') ?? 0;
      if (lastDay == today) {
        todayRounds = _prefs?.getInt('today_rounds') ?? 0;
        streak = max(streak, 1);
      } else {
        todayRounds = 0;
        streak = lastDay == yesterday ? streak + 1 : 1;
        await _prefs?.setString('last_visit', today);
        await _prefs?.setInt('today_rounds', 0);
        await _prefs?.setInt('streak', streak);
      }
    } catch (_) {
      // The game remains playable without persistent storage.
      streak = 1;
      todayRounds = 0;
    }
    ready = true;
    notifyListeners();
  }

  void record(GameMode mode) {
    counts[mode] = (counts[mode] ?? 0) + 1;
    todayRounds++;
    _prefs?.setInt('cards_${mode.name}', counts[mode]!);
    _prefs?.setInt('today_rounds', todayRounds);
    notifyListeners();
  }
}

class SohbetKutusuApp extends StatefulWidget {
  const SohbetKutusuApp({super.key});

  @override
  State<SohbetKutusuApp> createState() => _SohbetKutusuAppState();
}

class _SohbetKutusuAppState extends State<SohbetKutusuApp> {
  final PlayerProgress progress = PlayerProgress();

  @override
  void initState() {
    super.initState();
    progress.load();
  }

  @override
  void dispose() {
    progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sohbet Kutusu',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: lavender,
          brightness: Brightness.dark,
          surface: surface,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Color(0xFF353A58),
          behavior: SnackBarBehavior.floating,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
      ),
      home: HomeScreen(progress: progress),
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF17163B), bg, Color(0xFF081A28)],
          stops: [0, 0.5, 1],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -140,
            right: -120,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: lavender.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -110,
            left: -130,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: aqua.withValues(alpha: 0.05),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final PlayerProgress progress;
  const HomeScreen({required this.progress, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        return Scaffold(
          body: GradientBackground(
            child: SafeArea(
              child: !progress.ready
                  ? const Center(child: CircularProgressIndicator())
                  : CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 22, 20, 32),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              _topBar(context),
                              const SizedBox(height: 32),
                              _hero(),
                              const SizedBox(height: 24),
                              _stats(),
                              const SizedBox(height: 26),
                              const Text(
                                'Bugün ne oynuyoruz?',
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 7),
                              const Text(
                                'Telefonu sırayla dolaştır. Eğlence başlasın!',
                                style: TextStyle(color: softText, fontSize: 13),
                              ),
                              const SizedBox(height: 16),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: constraints.maxWidth < 310
                                          ? 1
                                          : 2,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 12,
                                      childAspectRatio:
                                          constraints.maxWidth < 310 ? 2.0 : 0.82,
                                    ),
                                    itemCount: GameMode.values.length,
                                    itemBuilder: (context, index) => ModeTile(
                                      mode: GameMode.values[index],
                                      onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) => GameScreen(
                                            mode: GameMode.values[index],
                                            progress: progress,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 22),
                              _dailyProgress(),
                              const SizedBox(height: 22),
                              const Center(
                                child: Text(
                                  'Reklamsız deneme sürümü • V1.0',
                                  style: TextStyle(
                                    color: softText,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _topBar(BuildContext context) => Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFFC58DFF), Color(0xFF756FFF)],
              ),
              boxShadow: [
                BoxShadow(
                  color: lavender.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.forum_rounded, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 11),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SOHBET KUTUSU',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0)),
                Text('Her buluşma yeni bir hikâye',
                    style: TextStyle(fontSize: 11, color: softText)),
              ],
            ),
          ),
          IconButton.filledTonal(
            tooltip: 'Nasıl oynanır?',
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: surface,
              showDragHandle: true,
              builder: (_) => const InfoSheet(),
            ),
            icon: const Icon(Icons.help_outline_rounded),
          ),
        ],
      );

  Widget _hero() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF423879), Color(0xFF232956)],
          ),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: const Color(0xFF7872BF), width: 0.7),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.auto_awesome_rounded, color: Color(0xFFFFDA8C), size: 17),
                SizedBox(width: 7),
                Text('EĞLENCE KARTLARI',
                    style: TextStyle(
                      color: Color(0xFFFFE3A9),
                      fontSize: 11,
                      letterSpacing: 1.6,
                      fontWeight: FontWeight.w800,
                    )),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Bir soru,\nbin kahkaha!',
                style: TextStyle(
                  height: 1.05,
                  fontSize: 35,
                  letterSpacing: -1,
                  fontWeight: FontWeight.w900,
                )),
            const SizedBox(height: 13),
            const Text('Arkadaşlarla oynanır. İnternet gerekmez.',
                style: TextStyle(fontSize: 13, color: Color(0xFFE5DFFF))),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(99),
              ),
              child: const Text('4 oyun modu  •  128 eğlence kartı',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      );

  Widget _stats() => Row(
        children: [
          Expanded(
            child: StatCard(
                icon: Icons.local_fire_department_rounded,
                color: const Color(0xFFFFBB7F),
                value: '${progress.streak} gün',
                label: 'Giriş serisi'),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: StatCard(
                icon: Icons.layers_rounded,
                color: aqua,
                value: '${progress.totalRounds}',
                label: 'Oynanan kart'),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: StatCard(
                icon: Icons.bolt_rounded,
                color: lavender,
                value: '${progress.level}',
                label: 'Seviye'),
          ),
        ],
      );

  Widget _dailyProgress() => Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: surface,
          border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.track_changes_rounded, color: aqua),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text('Günlük hedef',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                ),
                Text('${progress.dailyGoal}/10 kart',
                    style: const TextStyle(
                        color: aqua, fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 13),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: LinearProgressIndicator(
                value: progress.dailyGoal / 10,
                minHeight: 8,
                backgroundColor: const Color(0xFF39415C),
                valueColor: const AlwaysStoppedAnimation<Color>(aqua),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              progress.dailyGoal >= 10
                  ? 'Harika! Bugünkü hedefini tamamladın. 🎉'
                  : 'Bugün 10 kart oynayıp hedefini tamamla.',
              style: const TextStyle(color: softText, fontSize: 12),
            ),
          ],
        ),
      );
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  const StatCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 21),
            const SizedBox(height: 7),
            Text(value,
                maxLines: 1,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 3),
            Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: softText, fontSize: 10)),
          ],
        ),
      );
}

class ModeTile extends StatelessWidget {
  final GameMode mode;
  final VoidCallback onTap;
  const ModeTile({required this.mode, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(21),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: mode.accent.withValues(alpha: 0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: mode.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(mode.icon, color: mode.accent, size: 26),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(mode.title,
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  Text(mode.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: softText)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.arrow_forward_rounded,
                      color: mode.accent, size: 19),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final GameMode mode;
  final PlayerProgress progress;
  const GameScreen({required this.mode, required this.progress, super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final Random _random = Random();
  late List<int> _deck;
  int _position = 0;
  int? _selected;
  Timer? _timer;
  int _seconds = 5;
  bool _started = false;
  bool _finished = false;
  bool _success = false;

  int get _deckLength => switch (widget.mode) {
        GameMode.dilemma => dilemmas.length,
        GameMode.likely => likelyQuestions.length,
        GameMode.countdown => fiveSecondQuestions.length,
        GameMode.challenge => challengeQuestions.length,
      };

  @override
  void initState() {
    super.initState();
    _deck = List.generate(_deckLength, (i) => i)..shuffle(_random);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get _cardIndex => _deck[_position];

  void _advance({bool record = true}) {
    _timer?.cancel();
    if (record) widget.progress.record(widget.mode);
    HapticFeedback.selectionClick();
    setState(() {
      final previous = _cardIndex;
      _position++;
      if (_position >= _deck.length) {
        _position = 0;
        _deck.shuffle(_random);
        if (_deck.length > 1 && _deck.first == previous) {
          final other = _deck[1];
          _deck[1] = _deck[0];
          _deck[0] = other;
        }
      }
      _selected = null;
      _seconds = 5;
      _started = false;
      _finished = false;
      _success = false;
    });
  }

  void _choose(int index) {
    if (_selected != null) return;
    widget.progress.record(widget.mode);
    HapticFeedback.mediumImpact();
    setState(() => _selected = index);
  }

  void _startTimer() {
    if (_started) return;
    setState(() {
      _started = true;
      _finished = false;
      _seconds = 5;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_seconds <= 1) {
        timer.cancel();
        _endTimer(false);
      } else {
        setState(() => _seconds--);
        HapticFeedback.selectionClick();
      }
    });
  }

  void _endTimer(bool success) {
    if (_finished) return;
    _timer?.cancel();
    widget.progress.record(widget.mode);
    HapticFeedback.mediumImpact();
    setState(() {
      _seconds = success ? _seconds : 0;
      _finished = true;
      _success = success;
    });
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.mode.accent;
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 16, 4),
                child: Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                      tooltip: 'Ana ekrana dön',
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(widget.mode.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w900)),
                    ),
                    IconButton.filledTonal(
                      tooltip: 'Kurallar',
                      onPressed: () => showDialog<void>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(widget.mode.title),
                          content: Text(widget.mode.instructions),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Anladım'),
                            ),
                          ],
                        ),
                      ),
                      icon: const Icon(Icons.question_mark_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(22, 16, 22, 22),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: 0.14),
                                border: Border.all(
                                    color: accent.withValues(alpha: 0.35)),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                'KART ${_position + 1} / ${_deck.length}',
                                style: TextStyle(
                                    color: accent,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.4,
                                    fontSize: 11),
                              ),
                            ),
                          ),
                          const SizedBox(height: 23),
                          Container(
                            constraints: const BoxConstraints(minHeight: 230),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22, vertical: 30),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.lerp(surface, accent, 0.24)!,
                                  surface,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                  color: accent.withValues(alpha: 0.35),
                                  width: 1.1),
                              boxShadow: [
                                BoxShadow(
                                    color: accent.withValues(alpha: 0.07),
                                    blurRadius: 36,
                                    offset: const Offset(0, 12)),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(widget.mode.icon, color: accent, size: 47),
                                const SizedBox(height: 20),
                                Text(
                                  _questionText(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 27,
                                    height: 1.24,
                                    letterSpacing: -0.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 22),
                          _modeControls(accent),
                          const SizedBox(height: 18),
                          Text(
                            widget.mode.instructions,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: softText, height: 1.55, fontSize: 12),
                          ),
                          const SizedBox(height: 15),
                          TextButton.icon(
                            onPressed: _copyQuestion,
                            icon: const Icon(Icons.copy_rounded, size: 17),
                            label: const Text('Soruyu kopyala ve paylaş'),
                            style: TextButton.styleFrom(foregroundColor: softText),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _questionText() => switch (widget.mode) {
        GameMode.dilemma => 'Hangisini seçerdin?',
        GameMode.likely => likelyQuestions[_cardIndex],
        GameMode.countdown => fiveSecondQuestions[_cardIndex],
        GameMode.challenge => challengeQuestions[_cardIndex],
      };

  void _copyQuestion() {
    final question = widget.mode == GameMode.dilemma
        ? 'Hangisini seçerdin? ${dilemmas[_cardIndex].left} mı, ${dilemmas[_cardIndex].right} mı?'
        : _questionText();
    Clipboard.setData(ClipboardData(text: 'Sohbet Kutusu 🎉\n$question'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Soru kopyalandı. İstediğin yerde paylaşabilirsin.')),
    );
  }

  Widget _modeControls(Color accent) {
    if (widget.mode == GameMode.dilemma) {
      final dilemma = dilemmas[_cardIndex];
      return Column(
        children: [
          _choiceButton(0, dilemma.left, accent),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('YA DA',
                style: TextStyle(
                    color: softText, fontSize: 11, fontWeight: FontWeight.w900)),
          ),
          _choiceButton(1, dilemma.right, accent),
          if (_selected != null) ...[
            const SizedBox(height: 18),
            const Text('Seçimini yaptın! Arkadaşların ne der?',
                textAlign: TextAlign.center,
                style: TextStyle(color: softText)),
            const SizedBox(height: 13),
            _nextButton(accent, () => _advance(record: false)),
          ],
        ],
      );
    }
    if (widget.mode == GameMode.countdown) {
      return Column(
        children: [
          Text('$_seconds',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: accent,
                  fontSize: 82,
                  fontWeight: FontWeight.w900,
                  height: 1.1)),
          const SizedBox(height: 8),
          if (!_started)
            _nextButton(accent, _startTimer, text: '5 saniyeyi başlat')
          else if (!_finished)
            _nextButton(accent, () => _endTimer(true), text: 'Başardım!')
          else ...[
            Text(_success ? 'Süper hız! ✨' : 'Süre doldu! ⏰',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
            const SizedBox(height: 13),
            _nextButton(accent, () => _advance(record: false)),
          ],
        ],
      );
    }
    return Column(
      children: [
        if (widget.mode == GameMode.challenge)
          const Padding(
            padding: EdgeInsets.only(bottom: 14),
            child: Text('İsteyen oyuncu görevi yapabilir ya da pas geçebilir.',
                textAlign: TextAlign.center,
                style: TextStyle(color: softText, fontSize: 12)),
          ),
        _nextButton(accent, _advance),
      ],
    );
  }

  Widget _choiceButton(int index, String label, Color accent) {
    final active = _selected == index;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _selected == null ? () => _choose(index) : null,
        style: OutlinedButton.styleFrom(
          disabledForegroundColor: active ? Colors.white : softText,
          foregroundColor: Colors.white,
          backgroundColor: active ? accent.withValues(alpha: 0.32) : surface,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          side: BorderSide(
              color: active ? accent : Colors.white.withValues(alpha: 0.12)),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(19)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 17)),
            ),
            if (active) Icon(Icons.check_circle_rounded, color: accent),
          ],
        ),
      ),
    );
  }

  Widget _nextButton(Color accent, VoidCallback onPressed,
      {String text = 'Sonraki kart'}) {
    return SizedBox(
      height: 58,
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: bg,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18)),
        ),
        icon: const Icon(Icons.arrow_forward_rounded, size: 21),
        label: Text(text,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
      ),
    );
  }
}

class InfoSheet extends StatelessWidget {
  const InfoSheet({super.key});

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 26),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Nasıl oynanır?',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                const Text('Bir telefon, bol kahkaha! İnternet gerektirmez.',
                    style: TextStyle(color: softText)),
                const SizedBox(height: 18),
                for (final mode in GameMode.values) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(mode.icon, color: mode.accent, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(mode.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 15)),
                            const SizedBox(height: 4),
                            Text(mode.instructions,
                                style: const TextStyle(
                                    color: softText, height: 1.45, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 17),
                ],
                const Text(
                  'Not: Bu uygulama eğlence amaçlıdır. Kimse istemediği bir görevi yapmak zorunda değildir. Veriler yalnızca cihazda saklanır.',
                  style: TextStyle(color: softText, fontSize: 11, height: 1.45),
                ),
              ],
            ),
          ),
        ),
      );
}
