import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:liquidify/liquidify.dart';

void main() {
  setUp(() {
    LiquidGlassPlatform.reset();
  });

  tearDown(() {
    LiquidGlassPlatform.reset();
  });

  group('LiquidGlassOptions', () {
    test('default options and presets instantiate correctly', () {
      const options = LiquidGlassOptions();
      expect(options.force, isFalse);
      expect(options.enabled, isTrue);

      const frosted = LiquidGlassOptions.frosted();
      expect(frosted.blur, equals(20.0));
      expect(frosted.opacity, equals(0.65));

      const crystal = LiquidGlassOptions.crystal();
      expect(crystal.blur, equals(12.0));
      expect(crystal.opacity, equals(0.40));

      const smoke = LiquidGlassOptions.smoke();
      expect(smoke.blur, equals(24.0));
      expect(smoke.opacity, equals(0.82));
    });

    test('copyWith works as expected', () {
      const options = LiquidGlassOptions(blur: 10, opacity: 0.5);
      final updated = options.copyWith(blur: 25, force: true);

      expect(updated.blur, equals(25));
      expect(updated.opacity, equals(0.5));
      expect(updated.force, isTrue);
    });

    test('merge overrides existing values with non-null values', () {
      const a = LiquidGlassOptions(blur: 10, opacity: 0.5);
      const b = LiquidGlassOptions(blur: 20);

      final merged = a.merge(b);
      expect(merged.blur, equals(20));
      expect(merged.opacity, equals(0.5));
    });
  });

  group('LiquidGlassPlatform', () {
    test('detects Apple platforms and supports test overrides', () {
      LiquidGlassPlatform.overridePlatform = TargetPlatform.iOS;
      expect(LiquidGlassPlatform.isApplePlatform, isTrue);

      LiquidGlassPlatform.overridePlatform = TargetPlatform.macOS;
      expect(LiquidGlassPlatform.isApplePlatform, isTrue);

      LiquidGlassPlatform.overridePlatform = TargetPlatform.android;
      expect(LiquidGlassPlatform.isApplePlatform, isFalse);

      LiquidGlassPlatform.overridePlatform = TargetPlatform.windows;
      expect(LiquidGlassPlatform.isApplePlatform, isFalse);
    });

    testWidgets('isSupported respects force parameter', (tester) async {
      LiquidGlassPlatform.overridePlatform = TargetPlatform.android;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(
                LiquidGlassPlatform.isSupported(context, force: false),
                isFalse,
              );
              expect(
                LiquidGlassPlatform.isSupported(context, force: true),
                isTrue,
              );
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('LiquidGlassRegistry', () {
    test('contains built-in adapters out of the box', () {
      expect(LiquidGlassRegistry.has<BottomNavigationBar>(), isTrue);
      expect(LiquidGlassRegistry.has<ElevatedButton>(), isTrue);
      expect(LiquidGlassRegistry.has<Switch>(), isTrue);
      expect(LiquidGlassRegistry.has<Slider>(), isTrue);
      expect(LiquidGlassRegistry.has<TextField>(), isTrue);
      expect(LiquidGlassRegistry.has<SearchBar>(), isTrue);
      expect(LiquidGlassRegistry.has<Card>(), isTrue);
      expect(LiquidGlassRegistry.has<AppBar>(), isTrue);
    });

    test('allows registering custom adapters', () {
      final customAdapter = _MockCustomAdapter();
      LiquidGlassRegistry.register<_MockCustomWidget>(customAdapter);

      expect(LiquidGlassRegistry.has<_MockCustomWidget>(), isTrue);
      expect(
        LiquidGlassRegistry.get<_MockCustomWidget>(),
        equals(customAdapter),
      );
    });
  });

  group('LiquidGlassTheme', () {
    testWidgets('resolves theme defaults based on brightness', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.light,
          home: Builder(
            builder: (context) {
              final lightOpts = LiquidGlassTheme.of(context);
              expect(lightOpts.blur, equals(20.0));
              return const SizedBox();
            },
          ),
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.dark,
          home: Builder(
            builder: (context) {
              final darkOpts = LiquidGlassTheme.of(context);
              expect(darkOpts.blur, equals(20.0));
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('Widget Transformations & Property Preservation', () {
    testWidgets(
      'BottomNavigationBar preserves items, currentIndex, and onTap',
      (tester) async {
        LiquidGlassPlatform.overridePlatform = TargetPlatform.iOS;
        int selected = 1;

        await tester.pumpWidget(
          MaterialApp(
            home: StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  bottomNavigationBar: BottomNavigationBar(
                    currentIndex: selected,
                    onTap: (index) {
                      setState(() => selected = index);
                    },
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.search),
                        label: 'Search',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profile',
                      ),
                    ],
                  ).liquidGlass(),
                );
              },
            ),
          ),
        );

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Search'), findsOneWidget);
        expect(find.text('Profile'), findsOneWidget);

        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();

        expect(selected, equals(2));
      },
    );

    testWidgets('ElevatedButton preserves onPressed and child', (tester) async {
      LiquidGlassPlatform.overridePlatform = TargetPlatform.iOS;
      bool pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () => pressed = true,
              child: const Text('Continue'),
            ).liquidGlass(),
          ),
        ),
      );

      expect(find.text('Continue'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(pressed, isTrue);
    });

    testWidgets('Switch preserves value and toggles via onTap', (tester) async {
      LiquidGlassPlatform.overridePlatform = TargetPlatform.iOS;
      bool value = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Switch(
                  value: value,
                  onChanged: (newValue) {
                    setState(() => value = newValue);
                  },
                ).liquidGlass();
              },
            ),
          ),
        ),
      );

      expect(value, isFalse);
      await tester.tap(find.byType(LiquidSwitch));
      await tester.pumpAndSettle();

      expect(value, isTrue);
    });

    testWidgets('Slider renders and preserves values', (tester) async {
      LiquidGlassPlatform.overridePlatform = TargetPlatform.iOS;
      double value = 50.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Slider(
                  value: value,
                  min: 0,
                  max: 100,
                  onChanged: (val) {
                    setState(() => value = val);
                  },
                ).liquidGlass();
              },
            ),
          ),
        ),
      );

      expect(find.byType(LiquidSlider), findsOneWidget);
    });

    testWidgets('TextField preserves controller text and interaction', (
      tester,
    ) async {
      LiquidGlassPlatform.overridePlatform = TargetPlatform.iOS;
      final controller = TextEditingController(text: 'Initial Text');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TextField(controller: controller).liquidGlass()),
        ),
      );

      expect(find.text('Initial Text'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Updated Text');
      await tester.pumpAndSettle();

      expect(controller.text, equals('Updated Text'));
    });

    testWidgets('SearchBar preserves hintText and text changes', (
      tester,
    ) async {
      LiquidGlassPlatform.overridePlatform = TargetPlatform.iOS;
      String query = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBar(
              hintText: 'Search destinations',
              onChanged: (val) => query = val,
            ).liquidGlass(),
          ),
        ),
      );

      expect(find.text('Search destinations'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Cairo');
      await tester.pumpAndSettle();

      expect(query, equals('Cairo'));
    });

    testWidgets(
      'AppBar.liquidGlass() works as PreferredSizeWidget in Scaffold',
      (tester) async {
        LiquidGlassPlatform.overridePlatform = TargetPlatform.iOS;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('Liquid Title')).liquidGlass(),
              body: const Text('Body Content'),
            ),
          ),
        );

        expect(find.text('Liquid Title'), findsOneWidget);
        expect(find.text('Body Content'), findsOneWidget);
      },
    );

    testWidgets('Fallback: returns original widget when platform unsupported', (
      tester,
    ) async {
      LiquidGlassPlatform.overridePlatform = TargetPlatform.android;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: const Text('Android Button'),
            ).liquidGlass(),
          ),
        ),
      );

      // On Android with force: false, it returns the original ElevatedButton
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(LiquidButton), findsNothing);
    });

    testWidgets('Force: renders liquid glass on Android when force: true', (
      tester,
    ) async {
      LiquidGlassPlatform.overridePlatform = TargetPlatform.android;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: const Text('Forced Button'),
            ).liquidGlass(options: const LiquidGlassOptions(force: true)),
          ),
        ),
      );

      expect(find.byType(LiquidButton), findsOneWidget);
    });

    testWidgets('Enabled false returns original widget', (tester) async {
      LiquidGlassPlatform.overridePlatform = TargetPlatform.iOS;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ElevatedButton(
              onPressed: () {},
              child: const Text('Disabled Glass'),
            ).liquidGlass(options: const LiquidGlassOptions(enabled: false)),
          ),
        ),
      );

      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.byType(LiquidButton), findsNothing);
    });

    testWidgets('Checkbox preserves value and toggles on tap', (tester) async {
      LiquidGlassPlatform.overridePlatform = TargetPlatform.iOS;
      bool? isChecked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Checkbox(
                  value: isChecked,
                  onChanged: (val) => setState(() => isChecked = val),
                ).liquidGlass();
              },
            ),
          ),
        ),
      );

      expect(isChecked, isFalse);
      await tester.tap(find.byType(LiquidGlassContainer));
      await tester.pumpAndSettle();
      expect(isChecked, isTrue);
    });

    testWidgets('SegmentedButton preserves selection and triggers callback', (
      tester,
    ) async {
      LiquidGlassPlatform.overridePlatform = TargetPlatform.iOS;
      Set<int> selected = {1};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return SegmentedButton<int>(
                  segments: const [
                    ButtonSegment(value: 1, label: Text('First')),
                    ButtonSegment(value: 2, label: Text('Second')),
                  ],
                  selected: selected,
                  onSelectionChanged: (val) => setState(() => selected = val),
                ).liquidGlass();
              },
            ),
          ),
        ),
      );

      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);

      await tester.tap(find.text('Second'));
      await tester.pumpAndSettle();
      expect(selected, equals({2}));
    });

    testWidgets('Card preserves child content and applies glass styling', (
      tester,
    ) async {
      LiquidGlassPlatform.overridePlatform = TargetPlatform.iOS;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const Card(
              child: Text('Card Content Inside Glass'),
            ).liquidGlass(),
          ),
        ),
      );

      expect(find.text('Card Content Inside Glass'), findsOneWidget);
      expect(find.byType(LiquidGlassContainer), findsOneWidget);
    });

    testWidgets('ListTile preserves title and responds to onTap', (
      tester,
    ) async {
      LiquidGlassPlatform.overridePlatform = TargetPlatform.iOS;
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListTile(
              title: const Text('Settings Item'),
              subtitle: const Text('Detailed configuration'),
              onTap: () => tapped = true,
            ).liquidGlass(),
          ),
        ),
      );

      expect(find.text('Settings Item'), findsOneWidget);
      expect(find.text('Detailed configuration'), findsOneWidget);

      await tester.tap(find.text('Settings Item'));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });

    testWidgets('Chip preserves label and delete callback', (tester) async {
      LiquidGlassPlatform.overridePlatform = TargetPlatform.iOS;
      bool deleted = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Chip(
              label: const Text('Tag Item'),
              onDeleted: () => deleted = true,
            ).liquidGlass(),
          ),
        ),
      );

      expect(find.text('Tag Item'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.cancel));
      await tester.pumpAndSettle();
      expect(deleted, isTrue);
    });
  });
}

class _MockCustomWidget extends StatelessWidget {
  const _MockCustomWidget();

  @override
  Widget build(BuildContext context) => const Text('Mock');
}

class _MockCustomAdapter extends LiquidGlassAdapter<_MockCustomWidget> {
  @override
  Widget build(_MockCustomWidget widget, LiquidGlassOptions options) {
    return const Text('Liquid Mock');
  }
}
