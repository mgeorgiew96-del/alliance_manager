import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateAccountRequestScreen extends StatefulWidget {
  const CreateAccountRequestScreen({super.key});

  @override
  State<CreateAccountRequestScreen> createState() =>
      _CreateAccountRequestScreenState();
}

class _CreateAccountRequestScreenState
    extends State<CreateAccountRequestScreen> {
  final TextEditingController _playerNameController = TextEditingController();
  final TextEditingController _realmController = TextEditingController();
  final TextEditingController _allianceController = TextEditingController();

  @override
  void dispose() {
    _playerNameController.dispose();
    _realmController.dispose();
    _allianceController.dispose();
    super.dispose();
  }

  void _submitRequest() {
    final playerName = _playerNameController.text.trim();
    final realm = _realmController.text.trim();
    final alliance = _allianceController.text.trim();

    if (playerName.isEmpty || realm.isEmpty || alliance.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill player name, realm, and alliance.')),
      );
      return;
    }

    context.go('/waiting-approval');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Create Account Request'),
        leading: IconButton(
          onPressed: () => context.go('/login'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFD4AF37), width: 1.4),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.person_add,
                    size: 64,
                    color: Color(0xFFD4AF37),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Request Access',
                    style: TextStyle(
                      color: Color(0xFFFFE8A3),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Your R4/R5 will approve your account and give you an AM ID.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 28),

                  TextField(
                    controller: _playerNameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Player name',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: _realmController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Realm',
                      hintText: '1360',
                      prefixIcon: Icon(Icons.public),
                    ),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: _allianceController,
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Alliance name',
                      hintText: 'APX',
                      prefixIcon: Icon(Icons.groups),
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _submitRequest,
                      child: const Text('Submit request'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Back to login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
