class QuizQuestions {
  final String questionText;
  final List<String> answers;

  QuizQuestions(this.questionText, this.answers);

  List<String> getShuffledAnswers() {
    final shuffledAnswers = List<String>.from(answers);
    shuffledAnswers.shuffle();
    return shuffledAnswers;
  }
}
