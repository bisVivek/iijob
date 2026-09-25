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
        category: "Hiring Automation",
        iconEmoji: "🚀",
        question:
            "In a modern hiring platform like 11Jobs, what is the fastest way to evaluate candidates fairly and efficiently?",
        options: [
          "Manual manual resume printing and guesswork",
          "Automated skill assessments with instant pipeline scoring",
          "Waiting for candidates to call the recruiter",
          "Deleting half the applicant list randomly",
        ],
        correctIndex: 1,
        explanation:
            "Automated screening pipelines and interactive assessments evaluate skills objectively and instantly.",
      ),
      AssessmentQuestion(
        id: "q2",
        category: "Logic & Problem Solving",
        iconEmoji: "💡",
        question:
            "A critical feature has a bug before a release. What is the most professional engineering approach?",
        options: [
          "Panic and delete the entire repository",
          "Identify root causes with logs, isolate the bug, and apply a targeted hotfix",
          "Push untested code straight to production and hope for the best",
          "Ignore the issue and blame the network",
        ],
        correctIndex: 1,
        explanation:
            "Systematic root cause analysis and isolated testing ensure quick, reliable resolution.",
      ),
      AssessmentQuestion(
        id: "q3",
        category: "UI & UX Excellence",
        iconEmoji: "📱",
        question:
            "Why should interactive forms always provide instant, inline field validation rather than failing silently?",
        options: [
          "It guides candidates clearly and prevents frustration with immediate helpful feedback",
          "It takes up more screen space",
          "It makes the application look unnecessarily complicated",
          "It slows down user typing speed intentionally",
        ],
        correctIndex: 0,
        explanation:
            "Immediate, descriptive validation improves candidate experience, trust, and completion rates.",
      ),
      AssessmentQuestion(
        id: "q4",
        category: "Performance & Code Sense",
        iconEmoji: "⚡",
        question:
            "Which data structure provides an average time complexity of O(1) for instant user lookup by email or phone?",
        options: [
          "Unsorted Linked List",
          "Hash Map / Key-Value Lookup",
          "Bubble Sorted Array",
          "Single Stack with reverse pop",
        ],
        correctIndex: 1,
        explanation:
            "Hash Maps provide near-constant O(1) time complexity for rapid key lookups.",
      ),
      AssessmentQuestion(
        id: "q5",
        category: "Candidate Mindset",
        iconEmoji: "🌟",
        question:
            "As an engineer applying through 11Jobs, what quality best demonstrates top-tier talent?",
        options: [
          "Never asking questions or seeking feedback",
          "Writing clean code, continuous learning, and prioritizing user experience",
          "Working completely isolated with zero team collaboration",
          "Shipping code without verifying or testing it",
        ],
        correctIndex: 1,
        explanation:
            "Empathy for users, clean maintainable code, and collaborative growth define top engineers.",
      ),
    ];
  }
}
