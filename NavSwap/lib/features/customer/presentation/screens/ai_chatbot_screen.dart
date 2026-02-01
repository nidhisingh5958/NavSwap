import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AiChatbotScreen extends ConsumerStatefulWidget {
  const AiChatbotScreen({super.key});

  @override
  ConsumerState<AiChatbotScreen> createState() => _AiChatbotScreenState();
}

class _AiChatbotScreenState extends ConsumerState<AiChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _addBotMessage(
      'Hello! 👋 I\'m your NavSwap assistant. How can I help you today?\n\n'
      'I can help you with:\n'
      '• Finding nearby swap stations\n'
      '• Checking queue status\n'
      '• Battery swap information\n'
      '• Pricing and plans\n'
      '• General support',
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _addUserMessage(text);
    _messageController.clear();

    setState(() => _isTyping = true);

    // Simulate AI response
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isTyping = false);

    // Generate response based on keywords
    final response = _generateResponse(text.toLowerCase());
    _addBotMessage(response);
  }

  String _generateResponse(String message) {
    if (message.contains('station') ||
        message.contains('near') ||
        message.contains('find')) {
      return 'I can help you find the nearest swap station! 📍\n\n'
          'Based on your location, here are the closest stations:\n'
          '1. NavSwap Downtown - 2.3 km away\n'
          '2. NavSwap Mall Plaza - 3.1 km away\n\n'
          'Would you like directions to any of these?';
    } else if (message.contains('queue') || message.contains('wait')) {
      return 'Let me check the queue status for you... ⏱️\n\n'
          'Current wait times:\n'
          '• NavSwap Downtown: ~5 minutes\n'
          '• NavSwap Mall Plaza: ~10 minutes\n\n'
          'You can join the queue directly from the home screen!';
    } else if (message.contains('price') ||
        message.contains('cost') ||
        message.contains('plan')) {
      return 'Here are our current plans: 💰\n\n'
          '🔋 Pay Per Swap: ₹99 per swap\n'
          '📦 Monthly Plan: ₹2,499/month (unlimited swaps)\n'
          '🎯 Premium Plan: ₹3,999/month (priority queue + extras)\n\n'
          'Would you like more details about any plan?';
    } else if (message.contains('battery') || message.contains('swap')) {
      return 'Battery swap is quick and easy! ⚡\n\n'
          'Process:\n'
          '1. Join queue at any station\n'
          '2. Show your QR code when it\'s your turn\n'
          '3. Staff swaps your battery in under 2 minutes\n'
          '4. You\'re ready to go!\n\n'
          'Each swap gives you 80-120 km range depending on your vehicle.';
    } else if (message.contains('help') || message.contains('support')) {
      return 'I\'m here to help! 🤝\n\n'
          'You can:\n'
          '• Contact our 24/7 support: 1800-NAVSWAP\n'
          '• Email: support@navswap.com\n'
          '• Visit Help Center in the app\n\n'
          'What specific issue can I assist you with?';
    } else if (message.contains('hi') ||
        message.contains('hello') ||
        message.contains('hey')) {
      return 'Hello! 👋 How can I assist you today?\n\n'
          'Feel free to ask me about stations, queues, pricing, or anything else!';
    } else if (message.contains('thank')) {
      return 'You\'re welcome! 😊\n\n'
          'Is there anything else I can help you with?';
    } else {
      return 'I understand you\'re asking about: "$message"\n\n'
          'I can help you with:\n'
          '• Finding stations nearby\n'
          '• Queue information\n'
          '• Pricing and plans\n'
          '• Battery swap process\n'
          '• General support\n\n'
          'What would you like to know more about?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[700]!, Colors.blue[500]!],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('NavSwap AI', style: TextStyle(fontSize: 18)),
                Text(
                  'Always here to help',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show options menu
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Action Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _QuickActionChip(
                    label: 'Find Station',
                    icon: Icons.location_on,
                    onTap: () {
                      _messageController.text = 'Find nearest station';
                      _handleSendMessage();
                    },
                  ),
                  const SizedBox(width: 8),
                  _QuickActionChip(
                    label: 'Queue Status',
                    icon: Icons.people,
                    onTap: () {
                      _messageController.text = 'Check queue status';
                      _handleSendMessage();
                    },
                  ),
                  const SizedBox(width: 8),
                  _QuickActionChip(
                    label: 'Pricing',
                    icon: Icons.attach_money,
                    onTap: () {
                      _messageController.text = 'Show pricing plans';
                      _handleSendMessage();
                    },
                  ),
                  const SizedBox(width: 8),
                  _QuickActionChip(
                    label: 'Help',
                    icon: Icons.help_outline,
                    onTap: () {
                      _messageController.text = 'I need help';
                      _handleSendMessage();
                    },
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return const _TypingIndicator();
                }
                final message = _messages[index];
                return _MessageBubble(message: message);
              },
            ),
          ),

          // Input Field
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _handleSendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[700]!, Colors.blue[500]!],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _handleSendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[700]!, Colors.blue[500]!],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser ? Colors.blue[700] : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.person, size: 20, color: Colors.blue[700]),
            ),
          ],
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[700]!, Colors.blue[500]!],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TypingDot(delay: 0),
                const SizedBox(width: 4),
                _TypingDot(delay: 200),
                const SizedBox(width: 4),
                _TypingDot(delay: 400),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingDot extends StatefulWidget {
  final int delay;

  const _TypingDot({required this.delay});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue[200]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.blue[700]),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
