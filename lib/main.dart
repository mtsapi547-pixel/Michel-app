import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const PolyLingoApp());
}

class PolyLingoApp extends StatelessWidget {
  const PolyLingoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PolyLingo AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3157D5),
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class Language {
  final String flag;
  final String name;
  final String nativeName;
  final String greeting;

  const Language(
    this.flag,
    this.name,
    this.nativeName,
    this.greeting,
  );
}

const languages = [
  Language('🇨🇳', 'Chinois', '中文', '你好 — Nǐ hǎo'),
  Language('🇹🇭', 'Thaï', 'ภาษาไทย', 'สวัสดี — Sawatdee'),
  Language('🇰🇷', 'Coréen', '한국어', '안녕하세요 — Annyeonghaseyo'),
  Language('🇪🇸', 'Espagnol', 'Español', 'Hola'),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int xp = 0;
  int streak = 0;

  @override
  void initState() {
    super.initState();
    loadProgress();
  }

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      xp = prefs.getInt('xp') ?? 0;
      streak = prefs.getInt('streak') ?? 0;
    });
  }

  Future<void> addXp(int amount) async {
    final prefs = await SharedPreferences.getInstance();

    xp += amount;

    await prefs.setInt('xp', xp);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PolyLingo AI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Apprenez les langues autrement.',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Apprenez le chinois, le thaï, le coréen et '
            'l’espagnol grâce à des leçons simples et interactives.',
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: statCard(
                  '⭐ XP',
                  '$xp',
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: statCard(
                  '🔥 Série',
                  '$streak jours',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            'Choisissez votre langue',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          ...languages.map(
            (language) => Card(
              child: ListTile(
                leading: Text(
                  language.flag,
                  style: const TextStyle(
                    fontSize: 30,
                  ),
                ),

                title: Text(
                  language.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: Text(
                  language.nativeName,
                ),

                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LessonPage(
                        language: language,
                        onXp: addXp,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget statCard(
    String title,
    String value,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title),

            const SizedBox(height: 6),

            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LessonPage extends StatelessWidget {
  final Language language;
  final Future<void> Function(int) onXp;

  const LessonPage({
    super.key,
    required this.language,
    required this.onXp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${language.flag} ${language.name}',
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Text(
              'Leçon 1',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 8),

            const Text(
              'Premiers mots et expressions',
            ),

            const SizedBox(height: 28),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),

                child: Column(
                  children: [
                    Text(
                      language.greeting,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Apprenez cette expression et '
                      'entraînez-vous à la reconnaître.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            FilledButton.icon(
              icon: const Icon(
                Icons.quiz_outlined,
              ),

              label: const Text(
                'Faire le quiz',
              ),

              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizPage(
                      language: language,
                      onXp: onXp,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  final Language language;
  final Future<void> Function(int) onXp;

  const QuizPage({
    super.key,
    required this.language,
    required this.onXp,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  bool answered = false;
  int selected = -1;

  final answers = [
    'Bonjour',
    'Merci',
    'Au revoir',
    'S’il vous plaît',
  ];

  Future<void> answer(int index) async {
    if (answered) return;

    setState(() {
      answered = true;
      selected = index;
    });

    if (index == 0) {
      await widget.onXp(20);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            Text(
              '${widget.language.flag} ${widget.language.name}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Que signifie cette expression ?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              widget.language.greeting,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 30,
              ),
            ),

            const SizedBox(height: 24),

            ...List.generate(
              answers.length,
              (index) {
                final correct = index == 0;

                Color? textColor;

                if (answered) {
                  if (correct) {
                    textColor = Colors.green;
                  } else if (selected == index) {
                    textColor = Colors.red;
                  }
                }

                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ),

                  child: OutlinedButton(
                    onPressed: () => answer(index),

                    style: OutlinedButton.styleFrom(
                      foregroundColor: textColor,
                      padding: const EdgeInsets.all(16),
                    ),

                    child: Text(
                      answers[index],
                    ),
                  ),
                );
              },
            ),

            if (answered)
              Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                ),

                child: Text(
                  selected == 0
                      ? '🎉 Bonne réponse ! +20 XP'
                      : 'À revoir. La bonne réponse est « Bonjour ».',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
