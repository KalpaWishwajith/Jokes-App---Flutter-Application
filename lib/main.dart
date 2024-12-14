// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'joke_service.dart';

void main() async {
  runApp(const JokesApp());
}

class JokesApp extends StatelessWidget {
  const JokesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Laugh Factory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5),
          brightness: Brightness.light,
          primary: const Color(0xFF1E88E5),
          secondary: const Color(0xFFFF5252),
          background: const Color(0xFFF5F5F5),
          tertiary: const Color(0xFF2196F3),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      home: const JokesHomePage(),
    );
  }
}

class JokesHomePage extends StatefulWidget {
  const JokesHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _JokesHomePageState createState() => _JokesHomePageState();
}

class _JokesHomePageState extends State<JokesHomePage>
    with SingleTickerProviderStateMixin {
  final JokeService _jokeService = JokeService();
  List<dynamic> _jokes = [];
  bool _isLoading = false;
  String _errorMessage = '';
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchJokes() async {
    setState(() {
      _errorMessage = '';
      _isLoading = true;
      _jokes.clear();
    });

    try {
      final jokes = await _jokeService.fetchJokes();

      if (jokes.isEmpty) {
        setState(() {
          _errorMessage = 'No jokes found. Try again!';
        });
        return;
      }

      setState(() {
        _jokes = jokes.take(5).toList();
        _animationController.forward(from: 0);
      });
    } catch (error) {
      String errorText = 'An unexpected error occurred';

      if (error.toString().contains('SocketException')) {
        errorText = 'No internet connection. Please check your network.';
      } else if (error.toString().contains('TimeoutException')) {
        errorText = 'Request timed out. Please try again.';
      } else if (error.toString().contains('FormatException')) {
        errorText = 'Unable to parse jokes. Please try again later.';
      }

      setState(() {
        _errorMessage = errorText;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorText),
          backgroundColor: const Color(0xFFFF5252),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: fetchJokes,
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Laugh Factory',
          style: GoogleFonts.pacifico(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1E88E5).withOpacity(0.9),
              const Color(0xFFFF5252).withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(
                  'Get Ready to Laugh!',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.4),
                        offset: const Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _errorMessage,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : _jokes.isEmpty
                        ? Center(
                            child: Text(
                              _errorMessage.isNotEmpty
                                  ? _errorMessage
                                  : 'Click "Fetch Jokes" to start laughing!',
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : FadeTransition(
                            opacity: _animation,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _jokes.length,
                              itemBuilder: (context, index) {
                                final joke = _jokes[index];
                                return ScaleTransition(
                                  scale: _animation,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white,
                                              const Color(0xFF2196F3)
                                                  .withOpacity(0.3),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(20),
                                        child: Text(
                                          joke['setup'] != null
                                              ? '${joke['setup']} - ${joke['delivery']}'
                                              : joke['joke'] ?? 'No joke',
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : fetchJokes,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFFFF5252),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                    shadowColor: const Color(0xFF1E88E5),
                  ),
                  child: Text(
                    'Fetch Jokes',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
