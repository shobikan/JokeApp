class Joke {
  final String setup;
  final String punchline;

  Joke({required this.setup, required this.punchline});

  String get fullJoke => "$setup $punchline";

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      setup: json['setup'] ?? '',
      punchline: json['punchline'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'setup': setup,
      'punchline': punchline,
    };
  }
}
