import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_logo.dart';
import '../widgets/theme_switcher_button.dart';
import 'animated_signin_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;
  final bool isVerified;
  final int score;

  const HomeScreen({
    super.key,
    this.username = "User",
    this.isVerified = true,
    this.score = 100,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _bottomNavIndex = 0;
  int _selectedFilterIndex = 0;
  int _activeStudioTab = 1; // 0: Rounds, 1: Flow, 2: Studio

  final List<String> _filterChips = [
    "All Active Pipelines",
    "Remote",
    "Flutter & Mobile",
    "Workflow Automation",
    "AI & Full Stack",
    "Immediate Start",
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final verifiedId = "11J-VERIFIED-${(widget.username.hashCode.abs() % 9000 + 1000)}";

    final bgColor = isDark ? const Color(0xFF060919) : const Color(0xFFF6F8FC);
    final cardBg = isDark ? const Color(0xFF0D1527) : Colors.white;
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final txtPrimary = isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
    final txtSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgColor,

      // Right-Side Hamburger Drawer (Exact match to 11Jobs website layout)
      endDrawer: _buildHamburgerDrawer(verifiedId, isDark, cardBg, borderColor, txtPrimary, txtSecondary),

      // Top Navigation Bar matching 11Jobs website screenshot
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF070C1E) : Colors.white,
        elevation: 0.5,
        shadowColor: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
        titleSpacing: 18,
        automaticallyImplyLeading: false,

        // Left Side: 11Jobs Brand Logo
        title: const BrandLogo(height: 24),
        centerTitle: false,

        // Right Side: Notification Bell & Right Hamburger Menu Button
        actions: [
          // Notification Bell with Active Indicator
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_none_rounded,
                  color: txtPrimary,
                  size: 23,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFF005BFF),
                      content: const Text("3 enterprise recruiters reviewed your verified assessment scorecard!"),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),

          // Hamburger Menu Button on RIGHT SIDE (Opens Drawer with Dark Mode toggle)
          IconButton(
            key: const Key('hamburgerMenuButton'),
            tooltip: 'Open Menu',
            icon: Icon(
              Icons.menu_rounded,
              color: txtPrimary,
              size: 26,
            ),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // Bottom Navigation Bar (11Jobs 5-tab style)
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF070C1E) : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.dashboard_rounded, "Dashboard", isDark),
                _buildNavItem(1, Icons.alt_route_rounded, "Pipelines", isDark),
                _buildNavItem(2, Icons.work_outline_rounded, "Opportunities", isDark),
                _buildNavItem(3, Icons.hub_outlined, "MCP & Tools", isDark),
                _buildNavItem(4, Icons.person_outline_rounded, "Profile", isDark),
              ],
            ),
          ),
        ),
      ),

      // Body Content (100% Authentic 11Jobs Platform Design)
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Hero Banner (Exact 11Jobs Hero Section from screenshot)
            _build11JobsHeroSection(verifiedId, isDark, cardBg, borderColor, txtPrimary, txtSecondary),

            const SizedBox(height: 20),

            // 2. 11Jobs Active Hiring Workflow Pipeline Tracker
            _buildHiringPipelineTracker(isDark, cardBg, borderColor, txtPrimary, txtSecondary),

            const SizedBox(height: 22),

            // 3. 11Jobs Platform Capabilities Grid (From 11jobs.in)
            _buildPlatformCapabilitiesSection(isDark, cardBg, borderColor, txtPrimary, txtSecondary),

            const SizedBox(height: 22),

            // 4. AI-Matched High Priority Opportunities
            _buildOpportunitiesSection(isDark, cardBg, borderColor, txtPrimary, txtSecondary),

            const SizedBox(height: 22),

            // 5. Model Context Protocol (MCP) & ATS Integration Card
            _buildMcpIntegrationSection(isDark, cardBg, borderColor, txtPrimary, txtSecondary),

            const SizedBox(height: 22),

            // 6. Live Pipeline Performance Metrics
            _buildPipelineMetricsSection(isDark, cardBg, borderColor, txtPrimary, txtSecondary),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 1. EXACT 11JOBS HERO SECTION (From Screenshot)
  // ==========================================
  Widget _build11JobsHeroSection(
    String verifiedId,
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color txtPrimary,
    Color txtSecondary,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  const Color(0xFF0A1026),
                  const Color(0xFF060B1E),
                  const Color(0xFF040714),
                ]
              : [
                  const Color(0xFF005BFF),
                  const Color(0xFF003CB8),
                ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Capsule Pill: "✨ Hiring workflows, on autopilot"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF131D38) : Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? const Color(0xFF2563EB).withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome_rounded, color: Color(0xFF38BDF8), size: 15),
                const SizedBox(width: 6),
                Text(
                  "Hiring workflows, on autopilot",
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: isDark ? const Color(0xFFE2E8F0) : Colors.white,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Main Headline (From 11jobs.in)
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.2,
                height: 1.18,
              ),
              children: [
                const TextSpan(text: "Create your own\n"),
                const TextSpan(text: "Hiring Workflow\n"),
                TextSpan(
                  text: "Built once reuse ",
                  style: TextStyle(
                    color: isDark ? const Color(0xFF64748B) : Colors.white.withValues(alpha: 0.75),
                  ),
                ),
                const TextSpan(
                  text: "forever.",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Subtitle (From 11jobs.in)
          Text(
            "11Jobs helps you design candidate workflows, run intelligent quizzes, and move great people through every round — all in one calm, powerful place.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? const Color(0xFF94A3B8) : Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 18),

          // Verified Candidate Status Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0D172E) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                    ),
                  ),
                  child: const Icon(Icons.verified_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              "Welcome, ${widget.username}!",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : AppTheme.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "VERIFIED CANDIDATE",
                              style: TextStyle(
                                fontSize: 9.0,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF059669),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Assessment Score: ${widget.score}% • #$verifiedId",
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF38BDF8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Primary & Secondary Action Buttons (From 11jobs.in)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Candidate workflow auto-dispatched to matching tech roles!"),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005BFF),
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: const Color(0xFF005BFF).withValues(alpha: 0.4),
                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Start free",
                      style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_rounded, size: 16),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Loading 11Jobs Workflow Interactive Tour..."),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isDark ? const Color(0xFF334155) : Colors.white.withValues(alpha: 0.6),
                  ),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text(
                  "Watch demo",
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Text(
            "Free while we're in early access • No credit card required",
            style: TextStyle(
              fontSize: 11,
              color: isDark ? const Color(0xFF64748B) : Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 22),

          // Interactive 11Jobs Studio Flow Card Preview (From 11jobs.in screenshot)
          _buildInteractiveFlowCardPreview(isDark),
        ],
      ),
    );
  }

  // ==========================================
  // INTERACTIVE WORKFLOW FLOW CARD (From Screenshot)
  // ==========================================
  Widget _buildInteractiveFlowCardPreview(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF080D1E) : const Color(0xFF0F1A30),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFF1E3A8A),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with 3 colored terminal dots and tabs
          Row(
            children: [
              // 3 Colored Dots
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle)),
              const SizedBox(width: 5),
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFFF59E0B), shape: BoxShape.circle)),
              const SizedBox(width: 5),
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF3B82F6), shape: BoxShape.circle)),

              const SizedBox(width: 10),

              // Title
              const Expanded(
                child: Text(
                  "11Jobs — Operations Manager • Culture fit",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),

              // Tabs: Rounds, Flow, Studio
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: const Color(0xFF111C35),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStudioTab(0, "Rounds"),
                    _buildStudioTab(1, "Flow"),
                    _buildStudioTab(2, "Studio"),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFF1E293B)),
          const SizedBox(height: 12),

          // Animated Switcher for Tab Content
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _activeStudioTab == 0
                ? _buildRoundsTabContent()
                : _activeStudioTab == 1
                    ? _buildFlowTabContent()
                    : _buildStudioTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildStudioTab(int index, String label) {
    final isActive = _activeStudioTab == index;
    return InkWell(
      onTap: () {
        setState(() {
          _activeStudioTab = index;
        });
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1E293B) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
            color: isActive ? Colors.white : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildFlowTabContent() {
    return Row(
      key: const ValueKey('flowTabContent'),
      children: [
        _buildFlowStepBadge("1. Screening Quiz", const Color(0xFF38BDF8)),
        const Icon(Icons.arrow_forward_rounded, color: Color(0xFF64748B), size: 14),
        _buildFlowStepBadge("2. AI Interview", const Color(0xFF10B981)),
        const Icon(Icons.arrow_forward_rounded, color: Color(0xFF64748B), size: 14),
        _buildFlowStepBadge("3. Offer", const Color(0xFFFACC15)),
      ],
    );
  }

  Widget _buildRoundsTabContent() {
    return Row(
      key: const ValueKey('roundsTabContent'),
      children: [
        _buildFlowStepBadge("Round 1: MCQ", const Color(0xFF38BDF8)),
        const Icon(Icons.arrow_forward_rounded, color: Color(0xFF64748B), size: 14),
        _buildFlowStepBadge("Round 2: Tech Task", const Color(0xFFA855F7)),
        const Icon(Icons.arrow_forward_rounded, color: Color(0xFF64748B), size: 14),
        _buildFlowStepBadge("Round 3: Culture Fit", const Color(0xFF10B981)),
      ],
    );
  }

  Widget _buildStudioTabContent() {
    return Row(
      key: const ValueKey('studioTabContent'),
      children: [
        _buildFlowStepBadge("⚡ Trigger: Apply", const Color(0xFFF59E0B)),
        const Icon(Icons.arrow_forward_rounded, color: Color(0xFF64748B), size: 14),
        _buildFlowStepBadge("🤖 AI Scoring Engine", const Color(0xFF005BFF)),
        const Icon(Icons.arrow_forward_rounded, color: Color(0xFF64748B), size: 14),
        _buildFlowStepBadge("📨 ATS Sync", const Color(0xFF10B981)),
      ],
    );
  }

  Widget _buildFlowStepBadge(String label, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 2. HIRING WORKFLOW PIPELINE TRACKER
  // ==========================================
  Widget _buildHiringPipelineTracker(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color txtPrimary,
    Color txtSecondary,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.alt_route_rounded, color: AppTheme.primaryBlue, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    "Hiring Workflow Pipeline",
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w800,
                      color: txtPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "LIVE STATUS",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Automated progress synchronization across active hiring pipelines",
            style: TextStyle(fontSize: 12, color: txtSecondary),
          ),
          const SizedBox(height: 16),
          _buildPipelineStep("1. Profile & Registration", "Completed", true, txtPrimary, isDark),
          _buildPipelineStep("2. 11Jobs Skill Assessment", "Passed (${widget.score}%)", true, txtPrimary, isDark),
          _buildPipelineStep("3. Recruiter Pipeline Matching", "Active & Fast-Tracked", true, txtPrimary, isDark),
          _buildPipelineStep("4. Direct Interview Stage", "Scheduled Soon", false, txtPrimary, isDark),
        ],
      ),
    );
  }

  Widget _buildPipelineStep(String title, String status, bool isDone, Color txtPrimary, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone ? const Color(0xFF10B981) : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
            ),
            child: Icon(
              isDone ? Icons.check : Icons.circle,
              color: isDone ? Colors.white : const Color(0xFF94A3B8),
              size: 14,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isDone ? FontWeight.w700 : FontWeight.w500,
                color: txtPrimary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isDone ? const Color(0xFFECFDF5) : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isDone ? const Color(0xFF059669) : const Color(0xFF94A3B8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 3. 11JOBS PLATFORM CAPABILITIES
  // ==========================================
  Widget _buildPlatformCapabilitiesSection(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color txtPrimary,
    Color txtSecondary,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Why 11Jobs Automates Faster",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: txtPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "End-to-end recruitment architecture powered by AI scoring & custom stages",
            style: TextStyle(fontSize: 12.5, color: txtSecondary),
          ),
          const SizedBox(height: 14),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.15,
            children: [
              _buildFeatureCard(
                icon: Icons.bolt_rounded,
                title: "Instant Scoring",
                desc: "Objective skill benchmark with zero recruiter lag.",
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                iconColor: AppTheme.primaryBlue,
                cardBg: cardBg,
                borderColor: borderColor,
                txtPrimary: txtPrimary,
                txtSecondary: txtSecondary,
              ),
              _buildFeatureCard(
                icon: Icons.hub_rounded,
                title: "Native MCP Ready",
                desc: "Connect AI agents, webhooks & ATS pipelines.",
                color: isDark ? const Color(0xFF132E27) : const Color(0xFFECFDF5),
                iconColor: const Color(0xFF10B981),
                cardBg: cardBg,
                borderColor: borderColor,
                txtPrimary: txtPrimary,
                txtSecondary: txtSecondary,
              ),
              _buildFeatureCard(
                icon: Icons.schema_outlined,
                title: "Custom Rounds",
                desc: "Design MCQ, coding & behavioral flow stages.",
                color: isDark ? const Color(0xFF2C1B4D) : const Color(0xFFFAF5FF),
                iconColor: const Color(0xFFA855F7),
                cardBg: cardBg,
                borderColor: borderColor,
                txtPrimary: txtPrimary,
                txtSecondary: txtSecondary,
              ),
              _buildFeatureCard(
                icon: Icons.speed_rounded,
                title: "10x Shortlisting",
                desc: "Filter 1000s of candidates automatically.",
                color: isDark ? const Color(0xFF33200B) : const Color(0xFFFFFBEB),
                iconColor: const Color(0xFFF59E0B),
                cardBg: cardBg,
                borderColor: borderColor,
                txtPrimary: txtPrimary,
                txtSecondary: txtSecondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String desc,
    required Color color,
    required Color iconColor,
    required Color cardBg,
    required Color borderColor,
    required Color txtPrimary,
    required Color txtSecondary,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: txtPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            desc,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: txtSecondary,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 4. AI-MATCHED OPPORTUNITIES
  // ==========================================
  Widget _buildOpportunitiesSection(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color txtPrimary,
    Color txtSecondary,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Fast-Track Opportunities",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: txtPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "HIGH MATCH",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Direct recruitment pipelines based on your verified assessment score",
            style: TextStyle(fontSize: 12.5, color: txtSecondary),
          ),
          const SizedBox(height: 12),

          // Filter Chips Scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: List.generate(_filterChips.length, (index) {
                final isSelected = _selectedFilterIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(_filterChips[index]),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryBlue,
                    backgroundColor: isDark ? const Color(0xFF0D172E) : Colors.white,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? Colors.white : txtSecondary,
                    ),
                    side: BorderSide(
                      color: isSelected ? AppTheme.primaryBlue : borderColor,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilterIndex = index;
                      });
                    },
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 14),

          _buildJobCard(
            title: "Senior Flutter & Mobile Architect",
            company: "TechFlow Systems",
            location: "Remote (Global)",
            stipend: "\$90,000 - \$120,000 / yr",
            matchRate: 98,
            tags: ["Flutter", "Dart", "Clean Architecture", "CI/CD"],
            isDark: isDark,
            cardBg: cardBg,
            borderColor: borderColor,
            txtPrimary: txtPrimary,
            txtSecondary: txtSecondary,
          ),
          const SizedBox(height: 12),
          _buildJobCard(
            title: "Full Stack AI Workflow Engineer",
            company: "AutoHire AI",
            location: "Bengaluru • Hybrid",
            stipend: "₹18 - 25 LPA",
            matchRate: 94,
            tags: ["Python", "MCP", "FastAPI", "React"],
            isDark: isDark,
            cardBg: cardBg,
            borderColor: borderColor,
            txtPrimary: txtPrimary,
            txtSecondary: txtSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard({
    required String title,
    required String company,
    required String location,
    required String stipend,
    required int matchRate,
    required List<String> tags,
    required bool isDark,
    required Color cardBg,
    required Color borderColor,
    required Color txtPrimary,
    required Color txtSecondary,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFDBEAFE),
                  ),
                ),
                child: Center(
                  child: Text(
                    company.substring(0, 1),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: txtPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "$company • $location",
                      style: TextStyle(fontSize: 12, color: txtSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "$matchRate% MATCH",
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.payments_outlined, size: 16, color: Color(0xFF10B981)),
              const SizedBox(width: 6),
              Text(
                stipend,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tags.map((t) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  t,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: txtSecondary,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: const Color(0xFF059669),
                    behavior: SnackBarBehavior.floating,
                    content: Row(
                      children: [
                        const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text("Applied to $title via Fast-Track Pipeline!"),
                      ],
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(vertical: 11),
              ),
              child: const Text(
                "Apply via 1-Click Pipeline",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 5. MCP INTEGRATION SECTION
  // ==========================================
  Widget _buildMcpIntegrationSection(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color txtPrimary,
    Color txtSecondary,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.hub_outlined, color: AppTheme.primaryBlue, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Model Context Protocol (MCP)",
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: txtPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Connect AI Agents & Recruiters in real time",
                      style: TextStyle(fontSize: 11.5, color: txtSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            "11Jobs features native MCP and webhook architecture to push candidate test evaluation data straight into Greenhouse, Lever, Workday, and internal HR pipelines.",
            style: TextStyle(fontSize: 12.5, color: txtSecondary, height: 1.45),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 6. PIPELINE PERFORMANCE METRICS
  // ==========================================
  Widget _buildPipelineMetricsSection(
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color txtPrimary,
    Color txtSecondary,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _MetricItem("100%", "ASSESSMENT", txtPrimary, txtSecondary),
          Container(width: 1, height: 38, color: borderColor),
          _MetricItem("12", "PIPELINES", txtPrimary, txtSecondary),
          Container(width: 1, height: 38, color: borderColor),
          _MetricItem("1-Day", "AVG RESPONSE", txtPrimary, txtSecondary),
        ],
      ),
    );
  }

  // ==========================================
  // 7. RIGHT HAMBURGER DRAWER (11Jobs Platform Style)
  // ==========================================
  Widget _buildHamburgerDrawer(
    String verifiedId,
    bool isDark,
    Color cardBg,
    Color borderColor,
    Color txtPrimary,
    Color txtSecondary,
  ) {
    return Drawer(
      backgroundColor: isDark ? const Color(0xFF070C1E) : Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer Header with Verified Profile Info & Close Button
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BrandLogo(height: 24),
                      IconButton(
                        icon: Icon(Icons.close_rounded, color: txtPrimary, size: 22),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppTheme.primaryBlue, Color(0xFF38BDF8)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            widget.username.isNotEmpty ? widget.username[0].toUpperCase() : "U",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.username,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: txtPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "#$verifiedId",
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: txtSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFA7F3D0)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_rounded, color: Color(0xFF059669), size: 16),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            "Assessment Score: ${widget.score}% Verified",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF059669),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Navigation Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  // Theme Mode Switcher Card in Drawer
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F1A30) : const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFBFDBFE),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF182744) : Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: ElevenJobsFlowerIcon(
                            size: 20,
                            color: isDark ? const Color(0xFFFACC15) : AppTheme.primaryBlue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Dark Mode",
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w800,
                                  color: txtPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isDark ? "11Jobs Midnight Navy" : "Clean White Light",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: txtSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          key: const Key('drawerThemeSwitch'),
                          value: isDark,
                          activeThumbColor: const Color(0xFFFACC15),
                          activeTrackColor: const Color(0xFF1E293B),
                          onChanged: (value) {
                            AppTheme.toggleTheme();
                          },
                        ),
                      ],
                    ),
                  ),

                  Divider(height: 16, color: borderColor),

                  _buildDrawerSectionHeader("WORKFLOW PIPELINES"),
                  _buildDrawerItem(Icons.dashboard_outlined, "Overview Dashboard", true, txtPrimary),
                  _buildDrawerItem(Icons.alt_route_rounded, "Active Hiring Pipelines", false, txtPrimary),
                  _buildDrawerItem(Icons.verified_outlined, "Assessment Scorecard & Badges", false, txtPrimary),
                  _buildDrawerItem(Icons.smart_toy_outlined, "AI Technical Screenings", false, txtPrimary),

                  Divider(height: 24, color: borderColor),

                  _buildDrawerSectionHeader("OPPORTUNITIES & ROLES"),
                  _buildDrawerItem(Icons.work_outline_rounded, "Matched Tech Roles", false, txtPrimary),
                  _buildDrawerItem(Icons.bolt_rounded, "Fast-Track Pipeline Openings", false, txtPrimary),
                  _buildDrawerItem(Icons.language_rounded, "Remote Global Roles", false, txtPrimary),

                  Divider(height: 24, color: borderColor),

                  _buildDrawerSectionHeader("TOOLS & INTEGRATIONS"),
                  _buildDrawerItem(Icons.hub_outlined, "MCP & ATS Connectors", false, txtPrimary),
                  _buildDrawerItem(Icons.calendar_month_outlined, "Interview Dispatcher", false, txtPrimary),
                  _buildDrawerItem(Icons.bar_chart_rounded, "Skill Benchmark Analytics", false, txtPrimary),

                  Divider(height: 24, color: borderColor),

                  _buildDrawerSectionHeader("HELP & COMPLIANCE"),
                  _buildDrawerItem(Icons.help_outline_rounded, "11Jobs Knowledge Base", false, txtPrimary),
                  _buildDrawerItem(Icons.chat_bubble_outline_rounded, "Recruitment Support", false, txtPrimary),
                  _buildDrawerItem(Icons.security_outlined, "Security & Privacy", false, txtPrimary),
                ],
              ),
            ),

            // Logout Action Button at Bottom
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _handleLogout(),
                  icon: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 18),
                  label: const Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFFECACA)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w800,
          color: Color(0xFF64748B),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, bool isSelected, Color txtPrimary) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppTheme.primaryBlue : txtPrimary,
        size: 21,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13.5,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          color: isSelected ? AppTheme.primaryBlue : txtPrimary,
        ),
      ),
      dense: true,
      selected: isSelected,
      selectedTileColor: const Color(0xFF005BFF).withValues(alpha: 0.12),
      onTap: () {
        Navigator.pop(context); // Close drawer
      },
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isDark) {
    final isSelected = _bottomNavIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _bottomNavIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? AppTheme.primaryBlue : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? AppTheme.primaryBlue : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AnimatedSignInScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String value;
  final String label;
  final Color txtPrimary;
  final Color txtSecondary;

  const _MetricItem(this.value, this.label, this.txtPrimary, this.txtSecondary);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: txtPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: txtSecondary,
          ),
        ),
      ],
    );
  }
}
