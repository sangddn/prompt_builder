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
    final webView = Container(
      decoration: ShapeDecoration(
        color: context.colorScheme.popover,
        shape: Superellipse.border24,
        shadows: mediumShadows(),
      ),
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ShadButton.ghost(
                icon: const ShadImage.square(
                  LucideIcons.refreshCcw,
                  size: 16,
                ),
                onPressed: () => _controller.reload(),
              ),
              ShadButton.ghost(
                icon: const ShadImage.square(
                  LucideIcons.arrowLeft,
                  size: 16,
                ),
                onPressed: () async {
                  if (await _controller.canGoBack()) {
                    await _controller.goBack();
                  }
                },
              ),
              ShadButton.ghost(
                icon: const ShadImage.square(
                  LucideIcons.arrowRight,
                  size: 16,
                ),
                onPressed: () async {
                  if (await _controller.canGoForward()) {
                    await _controller.goForward();
                  }
                },
              ),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                width: constraints.maxWidth,
                height: MediaQuery.sizeOf(context).height - 230,
                child: WebViewWidget(controller: _controller),
              );
            },
          ),
        ],
      ),
    );
    return ShadSheet(
      title: widget.title?.let((title) => Text(title)),
      gap: 16.0,
      constraints: const BoxConstraints(minWidth: 500, maxWidth: 750),
      enterDuration: Effects.veryShortDuration,
      exitDuration: Effects.veryShortDuration,
      child: ShadTabs<String>(
        value: 'web',
        tabs: [
          ShadTab(
            value: 'web',
            content: webView,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Uri.parse(_currentUrl).host,
                  overflow: TextOverflow.ellipsis,
                ),
                TranslationSwitcher.top(
                  layoutBuilder: alignedLayoutBuilder(Alignment.centerRight),
                  child: _isLoading
                      ? const Padding(
                          padding: k8HPadding,
                          child: CircularProgressIndicator.adaptive(),
                        )
                      : null,
                ),
              ],
            ),
          ),
          if (widget.textContent != null)
            ShadTab(
              value: 'content',
              content: ShadCard(
                title: const Text('Content'),
                description: const Text('Extracted content from the web page.'),
                child: SelectableText(widget.textContent!),
              ),
              child: const Text('Content'),
            ),
          if (widget.transcript != null)
            ShadTab(
              value: 'transcript',
              content: ShadCard(
                title: const Text('Transcript'),
                child: SelectableText(widget.transcript!),
              ),
              child: const Text('Transcript'),
            ),
          if (widget.summary != null)
            ShadTab(
              value: 'summary',
              content: ShadCard(
                title: const Text('Summary'),
                child: SelectableText(widget.summary!),
              ),
              child: const Text('Summary'),
            ),
        ],
      ),
    );
  }
}
