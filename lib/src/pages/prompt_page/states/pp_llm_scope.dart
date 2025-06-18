part of '../prompt_page.dart';

class _PPLLMScope extends StatelessWidget {
  const _PPLLMScope({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ValueProvider<ValueNotifier<LLMProvider>>(
        create: (_) => ValueNotifier(OpenAI()),
      ),
    ],
    child: child,
  );
}
