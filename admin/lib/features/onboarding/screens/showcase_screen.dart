import 'package:flutter/material.dart';
import '../../../core/app_constants.dart';
import '../../../core/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'role_selection_screen.dart';
import 'dart:math' as math;

class ShowcaseScreen extends StatelessWidget {
  const ShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: const AssetImage('assets/images/logo.png'),
            opacity: 0.02,
            repeat: ImageRepeat.repeat,
            scale: 5,
          ),
        ),
        child: Row(
          children: [
            // LEFT PANEL: ANIMATED BRAND HUB
            if (isDesktop)
              Expanded(
                flex: 6,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primaryRed, AppColors.primaryPink],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Animated Background Particles
                      ...List.generate(15, (index) {
                        final random = math.Random(index);
                        return Positioned(
                              left: random.nextDouble() * 800,
                              top: random.nextDouble() * 1000,
                              child: Icon(
                                [
                                  Icons.auto_awesome,
                                  Icons.bubble_chart_rounded,
                                  Icons.blur_on_rounded,
                                  Icons.all_inclusive_rounded,
                                ][random.nextInt(4)],
                                color: Colors.white.withValues(alpha: 0.1),
                                size: 40 + random.nextDouble() * 100,
                              ),
                            )
                            .animate(
                              onPlay: (controller) => controller.repeat(),
                            )
                            .moveY(
                              begin: 0,
                              end: -100,
                              duration: (5 + random.nextInt(10)).seconds,
                              curve: Curves.easeInOut,
                            )
                            .fadeIn(duration: 2.seconds)
                            .then()
                            .fadeOut(duration: 2.seconds);
                      }),

                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                  padding: const EdgeInsets.all(40),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.school_rounded,
                                    size: 120,
                                    color: Colors.white,
                                  ),
                                )
                                .animate()
                                .scale(
                                  duration: 1200.ms,
                                  curve: Curves.elasticOut,
                                )
                                .shimmer(delay: 2.seconds, duration: 2.seconds),
                            const SizedBox(height: 32),
                            Text(
                                  "MAYA INSTITUTE",
                                  style: AppTheme.titleStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 56,
                                    letterSpacing: 8,
                                    fontWeight: FontWeight.w900,
                                  ),
                                )
                                .animate()
                                .fadeIn(delay: 400.ms)
                                .slideY(begin: 0.3, curve: Curves.easeOutBack),
                            const SizedBox(height: 8),
                            Container(
                              height: 4,
                              width: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ).animate().scaleX(delay: 800.ms),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // RIGHT PANEL: AUTH & INFO
            Expanded(
              flex: isDesktop ? 4 : 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 60 : 24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: isDesktop
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // LOGO BOX
                      Container(
                        padding: EdgeInsets.all(isDesktop ? 24 : 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryRed.withValues(
                                alpha: 0.1,
                              ),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                            ),
                          ],
                          border: Border.all(
                            color: AppColors.backgroundBlush,
                            width: 2,
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: isDesktop ? 80 : 50,
                          fit: BoxFit.contain,
                        ),
                      ).animate().fadeIn().scale(curve: Curves.easeOutBack),

                      const SizedBox(height: 40),

                      Text(
                        "Welcome to\nthe Future of Academia",
                        style: AppTheme.titleStyle.copyWith(
                          fontSize: isDesktop ? 38 : 28,
                          height: 1.1,
                          letterSpacing: -1,
                        ),
                        textAlign: isDesktop
                            ? TextAlign.start
                            : TextAlign.center,
                      ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),

                      const SizedBox(height: 16),

                      Text(
                        "Experience the most advanced, secure, and unified ERP platform designed for Maya Institutes.",
                        style: AppTheme.bodyStyle.copyWith(
                          fontSize: isDesktop ? 18 : 14,
                        ),
                        textAlign: isDesktop
                            ? TextAlign.start
                            : TextAlign.center,
                      ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1),

                      const SizedBox(height: 32),

                      // Feature Cards
                      _buildFeatureHighlights(isDesktop),

                      const SizedBox(height: 40),

                      // PRIMARY CTA
                      SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryPink.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 25,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) => const RoleSelectionScreen(),
                                      transitionsBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                            child,
                                          ) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Get Started",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isDesktop ? 20 : 16,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 800.ms)
                          .scale(delay: 800.ms)
                          .shimmer(
                            delay: 3.seconds,
                            duration: 2.seconds,
                            color: Colors.white24,
                          ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureHighlights(bool isDesktop) {
    if (!isDesktop) {
      return Column(
        children: [
          _miniFeature(Icons.security_rounded, "Secure SSO"),
          const SizedBox(height: 12),
          _miniFeature(Icons.auto_graph_rounded, "Live Insights"),
          const SizedBox(height: 12),
          _miniFeature(Icons.bolt_rounded, "Fast Execution"),
          const SizedBox(height: 12),
          _miniFeature(Icons.workspace_premium_rounded, "Best UX"),
        ],
      ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2);
    }
    return Column(
      children: [
        Row(
          children: [
            _miniFeature(Icons.security_rounded, "Secure SSO"),
            const SizedBox(width: 20),
            _miniFeature(Icons.auto_graph_rounded, "Live Insights"),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _miniFeature(Icons.bolt_rounded, "Fast Execution"),
            const SizedBox(width: 20),
            _miniFeature(Icons.workspace_premium_rounded, "Best UX"),
          ],
        ),
      ],
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2);
  }

  Widget _miniFeature(IconData icon, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.backgroundBlush.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryRed, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: AppColors.textMain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
