import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeOnboardingWebView extends StatefulWidget {
  final String url;

  const StripeOnboardingWebView({super.key, required this.url});

  @override
  State<StripeOnboardingWebView> createState() =>
      _StripeOnboardingWebViewState();
}

class _StripeOnboardingWebViewState extends State<StripeOnboardingWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);

            if (_isStripeSuccessUrl(url)) {
              Navigator.pop(context, true);
            }
          },
          onNavigationRequest: (request) {
            if (!request.url.contains("stripe.com")) {
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  bool _isStripeSuccessUrl(String url) {
    return url.contains("stripe-success") ||
        url.contains("onboarding/return") ||
        url.contains(webViewUrl) ||
        url.contains("stripe/complete");
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Stripe Onboarding"),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context, false),
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
