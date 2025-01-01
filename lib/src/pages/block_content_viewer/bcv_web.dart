part of 'block_content_viewer.dart';

class BCVWebView extends StatefulWidget {
  const BCVWebView({
    this.title,
    this.textContent,
    this.transcript,
    this.summary,
    required this.url,
    super.key,
  });

  final String? title, textContent, transcript, summary;
  final String url;

  @override
  State<BCVWebView> createState() => _BCVWebViewState();
}

class _BCVWebViewState extends State<BCVWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String _currentUrl = '';

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _currentUrl = url;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return ShadSheet(
      title: widget.title?.let((title) => Text(title)),
      actions: [
        ShadButton.ghost(
          icon: const ShadImage.square(LucideIcons.refreshCcw, size: 16),
          onPressed: () => _controller.reload(),
        ),
        ShadButton.ghost(
          icon: const ShadImage.square(LucideIcons.arrowLeft, size: 16),
          onPressed: () async {
            if (await _controller.canGoBack()) {
              await _controller.goBack();
            }
          },
        ),
        ShadButton.ghost(
          icon: const ShadImage.square(LucideIcons.arrowRight, size: 16),
          onPressed: () async {
            if (await _controller.canGoForward()) {
              await _controller.goForward();
            }
          },
        ),
      ],
      gap: 16.0,
      constraints: const BoxConstraints(minWidth: 500, maxWidth: 750),
      enterDuration: Effects.veryShortDuration,
      exitDuration: Effects.veryShortDuration,
      child: Column(
        children: [
          if (_isLoading)
            const Padding(
              padding: k32VPadding,
              child: CircularProgressIndicator.adaptive(),
            ),
          ShadTabs<String>(
            value: 'web',
            tabBarConstraints: const BoxConstraints(maxWidth: 400),
            contentConstraints: const BoxConstraints(maxWidth: 400),
            tabs: [
              ShadTab(
                value: 'web',
                content: WebViewWidget(controller: _controller),
                child: Text(_currentUrl),
              ),
              if (widget.textContent != null)
                ShadTab(
                  value: 'content',
                  content: ShadCard(
                    title: const Text('Content'),
                    description:
                        const Text('Extracted content from the web page.'),
                    child: Text(widget.textContent!),
                  ),
                  child: const Text('Content'),
                ),
              if (widget.transcript != null)
                ShadTab(
                  value: 'transcript',
                  content: ShadCard(
                    title: const Text('Transcript'),
                    child: Text(widget.transcript!),
                  ),
                  child: const Text('Transcript'),
                ),
              if (widget.summary != null)
                ShadTab(
                  value: 'summary',
                  content: ShadCard(
                    title: const Text('Summary'),
                    child: Text(widget.summary!),
                  ),
                  child: const Text('Summary'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
