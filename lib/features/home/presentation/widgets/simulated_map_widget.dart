import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../core/theme/ride_flow_tokens.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../domain/entities/place.dart';
import '../../../ride/domain/enums/ride_status.dart';

/// Simulated map widget (PRD §FR-HOME-001)
/// Renders a styled canvas map with animated current-location pulse,
/// pickup and drop pins when set. No real GPS or map SDK required.
class SimulatedMapWidget extends StatefulWidget {
  final Place? pickup;
  final Place? destination;
  final RideStatus? status;
  final int? etaSeconds;

  const SimulatedMapWidget({
    super.key,
    this.pickup,
    this.destination,
    this.status,
    this.etaSeconds,
  });

  @override
  State<SimulatedMapWidget> createState() => _SimulatedMapWidgetState();
}

class _SimulatedMapWidgetState extends State<SimulatedMapWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  late AnimationController _routeController;
  late Animation<double> _routeAnim;
  
  late AnimationController _carController;
  late Animation<double> _carAnim;

  // Simulated current-location dot position (relative, 0–1)
  final Offset _currentLocationRel = const Offset(0.5, 0.55);
  final Offset _pickupLocation = const Offset(0.3, 0.4);
  final Offset _destLocation = const Offset(0.7, 0.65);
  final Offset _driverSpawnLocation = const Offset(0.8, 0.2); // Random spawn point

  @override
  void initState() {
    super.initState();

    // Pulse animation for current-location marker
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
    _pulseAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );

    _routeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _routeAnim = CurvedAnimation(
      parent: _routeController,
      curve: Curves.easeInOut,
    );

    _carController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Default, will be updated by ETA
    );
    _carAnim = Tween<double>(begin: 0.0, end: 1.0).animate(_carController);
  }

  @override
  void didUpdateWidget(covariant SimulatedMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Animate route when both pickup and destination are set
    if (widget.pickup != null && widget.destination != null) {
      if (!_routeController.isCompleted) {
        _routeController.forward(from: 0.0);
      }
    } else {
      _routeController.reverse();
    }

    // Handle car animations based on status
    if (widget.status != oldWidget.status || widget.etaSeconds != oldWidget.etaSeconds) {
      if (widget.status == RideStatus.arriving || widget.status == RideStatus.started) {
        _carController.duration = Duration(seconds: widget.etaSeconds ?? 5);
        _carController.forward(from: 0.0);
      } else if (widget.status == RideStatus.completed || widget.status == RideStatus.cancelled) {
        _carController.stop();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _routeController.dispose();
    _carController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnim, _routeAnim, _carAnim]),
      builder: (context, _) {
        return Semantics(
          label: widget.pickup != null && widget.destination != null 
              ? 'Interactive map showing route from ${widget.pickup!.name} to ${widget.destination!.name}'
              : 'Interactive map showing current location',
          child: CustomPaint(
            painter: _MapPainter(
              isDark: isDark,
              pulseValue: _pulseAnim.value,
              routeProgress: _routeAnim.value,
              carProgress: _carAnim.value,
              currentLocationRel: _currentLocationRel,
              pickupRel: _pickupLocation,
              destRel: _destLocation,
              driverSpawnRel: _driverSpawnLocation,
              hasRoute: widget.pickup != null && widget.destination != null,
              status: widget.status,
            ),
          child: Stack(
            children: [
              // ─── Compass ──────────────────────────────────────────────
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: (isDark
                            ? AppColors.surfaceDark
                            : AppColors.surfaceLight)
                        .withOpacity(0.92),
                    shape: BoxShape.circle,
                    boxShadow: Theme.of(context).extension<RideFlowTokens>()!.fabShadow,
                  ),
                  child: Icon(Icons.navigation_rounded,
                      size: 18,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight),
                ),
              ),

              // ─── Attribution label ────────────────────────────────────
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (isDark
                            ? AppColors.surfaceDark
                            : AppColors.surfaceLight)
                        .withOpacity(0.78),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'RideFlow Maps',
                    style: AppTypography.caption.copyWith(
                      fontSize: 9,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Custom Painter ────────────────────────────────────────────────────────────

class _MapPainter extends CustomPainter {
  final bool isDark;
  final double pulseValue;
  final double routeProgress;
  final double carProgress;
  final Offset currentLocationRel;
  final Offset pickupRel;
  final Offset destRel;
  final Offset driverSpawnRel;
  final bool hasRoute;
  final RideStatus? status;

  const _MapPainter({
    required this.isDark,
    required this.pulseValue,
    required this.routeProgress,
    required this.carProgress,
    required this.currentLocationRel,
    required this.pickupRel,
    required this.destRel,
    required this.driverSpawnRel,
    required this.hasRoute,
    this.status,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawGrid(canvas, size);
    _drawRoads(canvas, size);
    _drawBlocks(canvas, size);
    if (hasRoute) {
      _drawRoute(canvas, size);
      _drawPin(canvas, size, pickupRel, AppColors.accent, isPickup: true);
      _drawPin(canvas, size, destRel, AppColors.error, isPickup: false);
    } else {
      _drawCurrentLocation(canvas, size);
    }
    
    _drawAnimatedCar(canvas, size);
  }

  void _drawBackground(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark ? const Color(0xFF1A2033) : const Color(0xFFE8EDF5);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withOpacity(0.04)
      ..strokeWidth = 0.5;
    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawBlocks(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark ? const Color(0xFF242B3D) : const Color(0xFFD4DCE8);
    final rng = Random(42);
    for (int i = 0; i < 18; i++) {
      final x = rng.nextDouble() * size.width * 0.85;
      final y = rng.nextDouble() * size.height * 0.85;
      final w = 28 + rng.nextDouble() * 40;
      final h = 20 + rng.nextDouble() * 28;
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, y, w, h), const Radius.circular(3)),
        paint,
      );
    }
  }

  void _drawRoads(Canvas canvas, Size size) {
    // Major roads
    final majorPaint = Paint()
      ..color = isDark ? const Color(0xFF2C3550) : const Color(0xFFCDD5E0)
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    // Minor roads
    final minorPaint = Paint()
      ..color = isDark ? const Color(0xFF252C42) : const Color(0xFFD8E0EA)
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round;

    // Horizontal major
    canvas.drawLine(Offset(0, size.height * 0.35), Offset(size.width, size.height * 0.35), majorPaint);
    canvas.drawLine(Offset(0, size.height * 0.62), Offset(size.width, size.height * 0.62), majorPaint);

    // Vertical major
    canvas.drawLine(Offset(size.width * 0.3, 0), Offset(size.width * 0.3, size.height), majorPaint);
    canvas.drawLine(Offset(size.width * 0.72, 0), Offset(size.width * 0.72, size.height), majorPaint);

    // Minor roads
    canvas.drawLine(Offset(0, size.height * 0.5), Offset(size.width, size.height * 0.5), minorPaint);
    canvas.drawLine(Offset(size.width * 0.5, 0), Offset(size.width * 0.5, size.height), minorPaint);
    canvas.drawLine(Offset(size.width * 0.15, 0), Offset(size.width * 0.15, size.height), minorPaint);
    canvas.drawLine(Offset(size.width * 0.87, 0), Offset(size.width * 0.87, size.height), minorPaint);
  }

  void _drawRoute(Canvas canvas, Size size) {
    final start = Offset(size.width * pickupRel.dx, size.height * pickupRel.dy);
    final end = Offset(size.width * destRel.dx, size.height * destRel.dy);

    // Shadow
    final shadowPaint = Paint()
      ..color = AppColors.routePolyline.withOpacity(0.18)
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Route line
    final routePaint = Paint()
      ..color = AppColors.routePolyline
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(start.dx, start.dy);
    final mid = Offset((start.dx + end.dx) / 2, start.dy);
    path.quadraticBezierTo(mid.dx, mid.dy, end.dx, end.dy);

    // Compute partial path based on routeProgress
    final metrics = path.computeMetrics().first;
    final totalLength = metrics.length;
    final partial = metrics.extractPath(0, totalLength * routeProgress);

    canvas.drawPath(partial, shadowPaint);
    canvas.drawPath(partial, routePaint);
  }

  void _drawCurrentLocation(Canvas canvas, Size size) {
    final center = Offset(
      size.width * currentLocationRel.dx,
      size.height * currentLocationRel.dy,
    );

    // Pulse rings
    for (int i = 0; i < 2; i++) {
      final delay = i * 0.4;
      final progress = ((pulseValue + delay) % 1.0);
      final radius = 16 + progress * 24;
      final opacity = (1.0 - progress) * 0.3;
      final pulsePaint = Paint()
        ..color = AppColors.accent.withOpacity(opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, pulsePaint);
    }

    // White border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 12, borderPaint);

    // Inner dot
    final dotPaint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 8, dotPaint);
  }

  void _drawPin(Canvas canvas, Size size, Offset relPos, Color color,
      {required bool isPickup}) {
    final pos = Offset(size.width * relPos.dx, size.height * relPos.dy);
    const pinWidth = 14.0;
    const pinHeight = 20.0;

    final paint = Paint()..color = color;
    final shadowPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    // Shadow
    canvas.drawCircle(pos + const Offset(0, 2), pinWidth * 0.6, shadowPaint);

    // Pin body (teardrop)
    final path = Path();
    path.addOval(Rect.fromCenter(
        center: pos - Offset(0, pinHeight * 0.4),
        width: pinWidth,
        height: pinWidth));
    path.moveTo(pos.dx - pinWidth * 0.3, pos.dy - pinHeight * 0.4);
    path.lineTo(pos.dx, pos.dy);
    path.lineTo(pos.dx + pinWidth * 0.3, pos.dy - pinHeight * 0.4);
    canvas.drawPath(path, paint);

    // Inner dot
    final dotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(pos - Offset(0, pinHeight * 0.4), 3.5, dotPaint);
  void _drawAnimatedCar(Canvas canvas, Size size) {
    if (status == null || status == RideStatus.confirming || status == RideStatus.searching) return;

    Offset startPoint;
    Offset endPoint;
    
    if (status == RideStatus.arriving || status == RideStatus.arrived) {
      startPoint = Offset(size.width * driverSpawnRel.dx, size.height * driverSpawnRel.dy);
      endPoint = Offset(size.width * pickupRel.dx, size.height * pickupRel.dy);
    } else {
      startPoint = Offset(size.width * pickupRel.dx, size.height * pickupRel.dy);
      endPoint = Offset(size.width * destRel.dx, size.height * destRel.dy);
    }

    final path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    final mid = Offset((startPoint.dx + endPoint.dx) / 2, startPoint.dy);
    path.quadraticBezierTo(mid.dx, mid.dy, endPoint.dx, endPoint.dy);

    final metrics = path.computeMetrics().first;
    // If arrived or completed, car is at the end of the curve
    final progress = (status == RideStatus.arrived || status == RideStatus.completed) ? 1.0 : carProgress;
    
    final tangent = metrics.getTangentForOffset(metrics.length * progress);
    if (tangent == null) return;
    
    final pos = tangent.position;
    final angle = tangent.angle;

    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(angle + pi / 2); // Rotate car to face movement direction
    
    // Draw simple car
    final paint = Paint()..color = isDark ? Colors.white : Colors.black;
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(-8, -14, 16, 28), const Radius.circular(4)),
      paint,
    );
    // Windshield
    final windowPaint = Paint()..color = isDark ? Colors.black : Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(-6, -8, 12, 6), const Radius.circular(2)),
      windowPaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue ||
        oldDelegate.routeProgress != routeProgress ||
        oldDelegate.carProgress != carProgress ||
        oldDelegate.isDark != isDark ||
        oldDelegate.hasRoute != hasRoute ||
        oldDelegate.status != status;
  }
}
