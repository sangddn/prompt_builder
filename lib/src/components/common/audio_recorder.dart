import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:shadcn_ui/shadcn_ui.dart' hide TextDirection;

import '../../core/core.dart';
import '../../services/services.dart';
import '../components.dart';

/// Wrapper class for the [ShadPopoverController].
class VoiceInputController extends ShadPopoverController {}

/// A button that allows the user to record audio and transcribe it.
class VoiceInputButton extends StatelessWidget {
  const VoiceInputButton({
    required this.popoverController,
    required this.onEnd,
    this.onCanceled,
    super.key,
  });

  final VoiceInputController popoverController;
  final Future<void> Function(String text)? onEnd;
  final VoidCallback? onCanceled;

  @override
  Widget build(BuildContext context) {
    final isOpen = popoverController.isOpen;
    return ChangeNotifierProvider<VoiceInputController>.value(
      value: popoverController,
      child: ShadPopover(
        controller: popoverController,
        popover: (context) => Provider<AudioRecorder>(
          create: (_) => AudioRecorder(),
          dispose: (_, recorder) => recorder.dispose(),
          builder: (context, _) {
            if (onEnd == null) return const SizedBox.shrink();
            return SizedBox(
              width: 300.0,
              child: _AudioRecord(onEnd: onEnd!),
            );
          },
        ),
        child: CButton(
          tooltip: 'Voice Input',
          onTap: onEnd == null ? null : popoverController.toggle,
          padding: k8H4VPadding,
          color: isOpen
              ? context.colorScheme.primary
              : PColors.opaqueLightGray.resolveFrom(context),
          child: Icon(
            HugeIcons.strokeRoundedMic01,
            size: 16.0,
            color: isOpen
                ? context.colorScheme.primaryForeground
                : PColors.textGray.resolveFrom(context),
          ),
        ),
      ),
    );
  }
}

class _AudioRecord extends StatefulWidget {
  const _AudioRecord({required this.onEnd});

  final Future<void> Function(String text) onEnd;

  @override
  State<_AudioRecord> createState() => _AudioRecordState();
}

class _AudioRecordState extends State<_AudioRecord> {
  final _controller = AudioRecorder();
  final List<double> _amplitudes = [];
  Stream<List<double>>? _amplitudeStream;
  late DateTime _startTime;
  bool? _isAvailable;
  bool _isTranscribing = false;

  Future<void> _start() async {
    _startTime = DateTime.now();
    _isAvailable = await _controller.hasPermission();
    if (!(_isAvailable ?? false)) return;
    if (mounted) setState(() {});
    await _controller.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        bitRate: 32000,
        sampleRate: 16000,
        numChannels: 1,
      ),
      path: '/tmp/${_startTime.millisecondsSinceEpoch}.wav',
    );
    _amplitudeStream = _controller
        .onAmplitudeChanged(const Duration(milliseconds: 100))
        .map((event) => _amplitudes..insert(0, event.current));
    if (mounted) setState(() {});
  }

  Future<String?> _stop() async {
    return _controller.stop();
  }

  Future<void> _cancel() async {
    await _controller.cancel();
    if (!mounted) return;
    context.read<VoiceInputController>().hide();
  }

  Future<void> _transcribe() async {
    const handler = TranscribeAudioUseCase();
    final toaster = context.toaster;
    final file = await _stop();
    debugPrint('file: $file');
    if (file == null || !context.mounted) return;
    setState(() => _isTranscribing = true);
    try {
      final text = await handler.transcribeAudio(file);
      if (text.isEmpty || !context.mounted) {
        return;
      }
      await widget.onEnd(text);
      if (mounted) {
        context.read<VoiceInputController>().hide();
      }
    } catch (e) {
      debugPrint('Error updating block: $e');
      toaster.show(
        ShadToast.destructive(
          title: const Text('Error transcribing audio.'),
          description: Text('$e'),
        ),
      );
    } finally {
      // Delete the file
      await File(file).delete();
    }
  }

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!(_isAvailable ?? false)) {
      return Padding(
        padding: k16H12VPadding,
        child: Text(
          _isAvailable == null
              ? 'Waiting for permission…'
              : 'Access to microphone denied.',
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder(
          stream: _amplitudeStream,
          builder: (context, snapshot) {
            final duration = DateTime.now().difference(_startTime);
            final minutes = duration.inMinutes;
            final seconds =
                (duration.inSeconds % 60).toString().padLeft(2, '0');
            return Row(
              children: [
                Expanded(child: _Amplitudes(snapshot.data ?? [])),
                const Gap(6.0),
                Text('$minutes:$seconds'),
              ],
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(
              builder: (context) {
                return ShadButton.outline(
                  onPressed: _cancel,
                  child: const Text('Cancel'),
                );
              },
            ),
            ShadButton(
              onPressed: _transcribe,
              child: TranslationSwitcher.top(
                child: _isTranscribing
                    ? const GrayShimmer(child: Text('Transcribing…'))
                    : const Text('Done'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Amplitudes extends StatelessWidget {
  const _Amplitudes(this.amplitudes);

  final List<double> amplitudes;

  @override
  Widget build(BuildContext context) {
    const width = 3.0;
    return SizedBox(
      height: 100.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        reverse: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: k16HPadding,
        itemCount: 50,
        itemBuilder: (context, index) {
          final amplitude = amplitudes.elementAtOrNull(index);
          return Center(
            child: Container(
              decoration: ShapeDecoration(
                shape: const SquircleStadiumBorder(),
                color:
                    (amplitude == null ? PColors.opagueGray : PColors.textGray)
                        .resolveFrom(context),
              ),
              width: width,
              height: amplitude == null
                  ? 12.0
                  : 100.0 - (amplitude.abs().clamp(0.0, 46.0) * 2),
            ),
          );
        },
        separatorBuilder: (context, index) => const Gap(width),
      ),
    );
  }
}
