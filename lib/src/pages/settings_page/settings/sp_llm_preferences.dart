part of '../settings_page.dart';

class LLMPreferencesSettings extends StatelessWidget {
  const LLMPreferencesSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: k32HPadding,
      decoration: ShapeDecoration(
        color: PColors.lightGray.resolveFrom(context).withOpacityFactor(.5),
        shape: Superellipse.border12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Gap(32.0),
          Padding(
            padding: k4HPadding,
            child: Text('Model Preferences', style: context.textTheme.h4),
          ),
          const Gap(16.0),
          for (final useCase in kAllLLMUseCases) ...[
            _LLMUseCase(useCase: useCase),
            const Gap(24.0),
          ],
          const Gap(8.0),
        ].toList(),
      ),
    );
  }
}

class _LLMUseCase extends StatelessWidget {
  const _LLMUseCase({required this.useCase});

  final LLMUseCase useCase;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Text(useCase.name, style: textTheme.large),
        ),
        const Gap(8.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Text(useCase.description, style: textTheme.muted),
        ),
        const Gap(20.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Text('Model', style: textTheme.muted),
        ),
        const Gap(6.0),
        _LLMUseCaseModelPicker(useCase),
        const Gap(16.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Prompt', style: textTheme.muted),
              Text(
                useCase.promptInstructions,
                style: context.textTheme.muted.apply(fontSizeDelta: -2),
              ),
            ],
          ),
        ),
        const Gap(6.0),
        _LLMUseCasePromptField(useCase),
      ],
    );
  }
}

class _LLMUseCaseModelPicker extends StatelessWidget {
  const _LLMUseCaseModelPicker(this.useCase);

  final LLMUseCase useCase;

  void onChange(LLMProvider? provider, String? model) {
    if (provider != null && model != null) {
      useCase.setProviderAndModel(provider, model);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (provider, model) = useCase.getProviderAndModel() ?? (null, null);
    if (useCase is TranscribeAudioUseCase) {
      return AudioTranscriberPicker(
        initialProvider: provider,
        initialModel: model,
        onChange: onChange,
      );
    }
    return LLMPicker(
      initialProvider: provider,
      initialModel: model,
      onChange: onChange,
    );
  }
}

class _LLMUseCasePromptField extends StatelessWidget {
  const _LLMUseCasePromptField(this.useCase);

  final LLMUseCase useCase;

  @override
  Widget build(BuildContext context) {
    final initialPrompt = useCase.getPrompt();
    if (initialPrompt == null) {
      return const SizedBox.shrink();
    }
    return ShadInput(
      initialValue: initialPrompt,
      minLines: 2,
      maxLines: 5,
      placeholder: const Text('Prompt'),
      onChanged: (value) {
        try {
          useCase.setPrompt(value);
        } catch (e) {
          context.toaster
              .show(ShadToast.destructive(title: Text(e.toString())));
        }
      },
    );
  }
}
