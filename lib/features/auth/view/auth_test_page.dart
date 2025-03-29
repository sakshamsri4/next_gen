import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:next_gen/services/firebase_service.dart';

/// A test page to verify Firebase Authentication
class AuthTestPage extends StatefulWidget {
  const AuthTestPage({super.key});

  @override
  State<AuthTestPage> createState() => _AuthTestPageState();
}

class _AuthTestPageState extends State<AuthTestPage> {
  final FirebaseService _firebaseService = FirebaseService();
  User? _user;

  @override
  void initState() {
    super.initState();
    _firebaseService.authStateChanges.listen((user) {
      setState(() {
        _user = user;
      });
    });
  }

  Future<void> _signInAnonymously() async {
    try {
      await _firebaseService.signInAnonymously();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Auth Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_user == null)
              ElevatedButton(
                onPressed: _signInAnonymously,
                child: const Text('Sign In Anonymously'),
              )
            else
              Column(
                children: [
                  const Text('Signed In Successfully!'),
                  const SizedBox(height: 8),
                  Text('User ID: ${_user!.uid}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => FirebaseAuth.instance.signOut(),
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
