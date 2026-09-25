class AssessmentQuestion {
  final String id;
  final String category;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final String iconEmoji;

  const AssessmentQuestion({
    required this.id,
    required this.category,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.iconEmoji,
  });
}

class AssessmentBank {
  static List<AssessmentQuestion> getQuestions() {
    return const [
      AssessmentQuestion(
        id: "q1",
        category: "Concurrency & Stock Handling",
        iconEmoji: "⚡",
        question:
            "Imagine an e-commerce app has only 4 items left in stock.\n\nAt almost the same time:\n👤 User A adds 4 items to the cart.\n👤 User B also adds 4 items to the cart.\nBoth users click Checkout at almost the same time.\n\nAs an App Developer, where should the final stock validation and concurrency handling happen?",
        options: [
          "Only on the frontend, because the app already knows the available stock.",
          "On the backend/database using proper transaction or atomic stock handling; the frontend should only perform basic UX-level validation.",
          "No validation is required because both users saw 4 items available.",
          "Disable the Checkout button for everyone when stock is low.",
        ],
        correctIndex: 1,
        explanation:
            "Concurrency control and inventory updates must be validated server-side through atomic transactions to prevent race conditions and over-selling.",
      ),
      AssessmentQuestion(
        id: "q2",
        category: "The Offline User",
        iconEmoji: "🌐",
        question:
            "A user opens the Products screen, but their internet connection is unavailable.\n\nWhat would provide the best user experience?",
        options: [
          "Show a clear “No Internet Connection” message with a retry option",
          "Crash the application",
          "Keep showing a loading spinner forever",
          "Automatically logout the user",
        ],
        correctIndex: 0,
        explanation:
            "Clear error handling and giving a retry button keeps the user informed and in control.",
      ),
      AssessmentQuestion(
        id: "q3",
        category: "The Shopping Cart",
        iconEmoji: "🛒",
        question:
            "A user adds a ₹500 product to the cart. They increase the quantity from 1 → 2.\n\nWhat should happen?",
        options: [
          "The total price should automatically update to ₹1,000",
          "The user should restart the app",
          "The user should open the cart again manually",
          "Nothing should happen until checkout",
        ],
        correctIndex: 0,
        explanation:
            "Reactive state management ensures cart totals update instantly when item quantities change.",
      ),
      AssessmentQuestion(
        id: "q4",
        category: "1000+ Products Challenge",
        iconEmoji: "📦",
        question:
            "Imagine your shopping app has 1,000+ products coming from an API. You need to display these products in a list.\n\nWhat would be the better approach?",
        options: [
          "Load all 1,000+ products at once",
          "Use pagination/lazy loading and load products in smaller batches",
          "Hard-code all products in the app",
          "Show only 10 products permanently",
        ],
        correctIndex: 1,
        explanation:
            "Pagination and lazy loading optimize memory usage and keep the app fast and responsive.",
      ),
      AssessmentQuestion(
        id: "q5",
        category: "The Mystery Button",
        iconEmoji: "🐞",
        question:
            "A user reports:\n\n“The Submit button is visible, but nothing happens when I tap it.”\n\nAs the developer, what would you check first?",
        options: [
          "Reinstall the operating system",
          "Check whether the button's tap/click event is correctly connected to its function",
          "Delete the database",
          "Change the app logo",
        ],
        correctIndex: 1,
        explanation:
            "Checking if the button's onPressed/onClick callback is properly wired is the first diagnostic step.",
      ),
    ];
  }
}
