// lib/screens/levels/level_ada_sheet.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/gemini_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/theme_provider.dart';

/// Bottom-Sheet zum Chatten mit Ada im Lernarena-Style
///
/// [contextText] = die Lehr-Karten-Erklärung (Kontext für Ada)
/// [topic] = "SQL — SELECT" o.ä. (Themenbereich)
/// [initialPrompt] = optional, wird als erste User-Message gesendet
///                    (z.B. "Erkläre mir das nochmal anders")
class LevelAdaSheet extends StatefulWidget {
  final String contextText;
  final String topic;
  final String? initialPrompt;

  const LevelAdaSheet({
    super.key,
    required this.contextText,
    required this.topic,
    this.initialPrompt,
  });

  /// Komfort-Funktion zum Öffnen
  static Future<void> show(
    BuildContext context, {
    required String contextText,
    required String topic,
    String? initialPrompt,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LevelAdaSheet(
        contextText: contextText,
        topic: topic,
        initialPrompt: initialPrompt,
      ),
    );
  }

  @override
  State<LevelAdaSheet> createState() => _LevelAdaSheetState();
}

class _LevelAdaSheetState extends State<LevelAdaSheet> {
  final _aiService = GeminiService();
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMsg> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Welcome-Message
    _messages.add(
      _ChatMsg(
        text:
            'Hi! Ich bin Ada 👋  Ich erkläre dir das Konzept gern '
            'nochmal — frag einfach.',
        isUser: false,
      ),
    );

    // Falls initialPrompt: direkt absenden
    if (widget.initialPrompt != null && widget.initialPrompt!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _sendMessage(widget.initialPrompt!);
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage([String? overrideText]) async {
    final text = (overrideText ?? _messageController.text).trim();
    if (text.isEmpty || _isLoading) return;

    setState(() {
      _messages.add(_ChatMsg(text: text, isUser: true));
      _isLoading = true;
    });
    _messageController.clear();
    _scrollToBottom();

    final history = _messages
        .skip(1) // Welcome ignorieren
        .where((m) => m.text != text || !m.isUser)
        .map(
          (m) => {'role': m.isUser ? 'user' : 'assistant', 'content': m.text},
        )
        .toList();

    try {
      final response = await _aiService.chatWithTutor(
        userMessage: text,
        conversationHistory: history,
        currentQuestion: widget.contextText,
        topic: widget.topic,
      );
      if (!mounted) return;
      setState(() {
        _messages.add(_ChatMsg(text: response, isUser: false));
        _isLoading = false;
      });
      _scrollToBottom();
    } on LimitReachedException catch (_) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          _ChatMsg(
            text:
                'Du hast dein tägliches Ada-Limit erreicht. '
                'Komm morgen wieder oder hol dir Premium für unbegrenzte Fragen.',
            isUser: false,
          ),
        );
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          _ChatMsg(
            text: 'Hm, da ist was schiefgelaufen. Versuch es nochmal. ($e)',
            isUser: false,
          ),
        );
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 80), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final text = isDark ? AppColors.darkText : AppColors.lightText;
    final textMid = isDark ? AppColors.darkTextMid : AppColors.lightTextMid;
    final textDim = isDark ? AppColors.darkTextDim : AppColors.lightTextDim;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(top: BorderSide(color: border)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                color: textDim,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 12, 8),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.accent.withOpacity(0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.psychology_rounded,
                      color: AppColors.accent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ada',
                          style: AppTextStyles.instrumentSerif(
                            size: 22,
                            color: text,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.success,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.topic.toUpperCase(),
                              style: AppTextStyles.monoSmall(textDim),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: textMid, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            Divider(color: border, height: 16),

            // Chat-Liste
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                itemCount: _messages.length + (_isLoading ? 1 : 0),
                itemBuilder: (_, i) {
                  if (i >= _messages.length) {
                    return _buildTypingBubble(textDim);
                  }
                  return _buildBubble(
                    _messages[i],
                    surface,
                    border,
                    text,
                    textMid,
                  );
                },
              ),
            ),

            // Input-Bar
            Container(
              padding: EdgeInsets.fromLTRB(
                16,
                10,
                16,
                MediaQuery.of(context).padding.bottom + 12,
              ),
              decoration: BoxDecoration(
                color: surface,
                border: Border(top: BorderSide(color: border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      enabled: !_isLoading,
                      style: AppTextStyles.bodyMedium(text),
                      decoration: InputDecoration(
                        hintText: 'Frag Ada...',
                        hintStyle: AppTextStyles.bodyMedium(textDim),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _isLoading
                          ? textDim.withOpacity(0.3)
                          : AppColors.accent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_upward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: _isLoading ? null : () => _sendMessage(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBubble(
    _ChatMsg msg,
    Color surface,
    Color border,
    Color text,
    Color textMid,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: msg.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!msg.isUser) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.psychology_rounded,
                size: 16,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: msg.isUser ? AppColors.accent : surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(14),
                  topRight: const Radius.circular(14),
                  bottomLeft: Radius.circular(msg.isUser ? 14 : 4),
                  bottomRight: Radius.circular(msg.isUser ? 4 : 14),
                ),
                border: msg.isUser ? null : Border.all(color: border),
              ),
              child: Text(
                msg.text,
                style: AppTextStyles.bodyMedium(
                  msg.isUser ? Colors.white : text,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingBubble(Color textDim) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.psychology_rounded,
              size: 16,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 30,
            height: 16,
            child: Center(
              child: SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textDim,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMsg {
  final String text;
  final bool isUser;
  _ChatMsg({required this.text, required this.isUser});
}
