import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePhotoCropperScreen extends StatefulWidget {
  final File imageFile;

  const ProfilePhotoCropperScreen({
    super.key,
    required this.imageFile,
  });

  @override
  State<ProfilePhotoCropperScreen> createState() =>
      _ProfilePhotoCropperScreenState();
}

class _ProfilePhotoCropperScreenState extends State<ProfilePhotoCropperScreen> {
  final TransformationController _transformCtrl =
      TransformationController();
  final GlobalKey _boundaryKey = GlobalKey();

  bool _isSaving = false;
  int _rotationQuarterTurns = 0;

  @override
  void dispose() {
    _transformCtrl.dispose();
    super.dispose();
  }

  void _resetTransform() {
    HapticFeedback.selectionClick();
    setState(() {
      _rotationQuarterTurns = 0;
      _transformCtrl.value = Matrix4.identity();
    });
  }

  void _rotateImage() {
    HapticFeedback.selectionClick();
    setState(() {
      _rotationQuarterTurns = (_rotationQuarterTurns + 1) % 4;
    });
  }

  Future<void> _applyCrop() async {
    if (_isSaving) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _isSaving = true;
    });

    try {
      final boundary = _boundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) {
        if (mounted) Navigator.pop(context, widget.imageFile);
        return;
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 2.5);
      final byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        if (mounted) Navigator.pop(context, widget.imageFile);
        return;
      }

      final pngBytes = byteData.buffer.asUint8List();
      final tempDir = await getTemporaryDirectory();
      final targetFile = File(
        '${tempDir.path}/cropped_avatar_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await targetFile.writeAsBytes(pngBytes);

      if (mounted) {
        Navigator.pop(context, targetFile);
      }
    } catch (e) {
      debugPrint('Crop failed: $e');
      if (mounted) {
        Navigator.pop(context, widget.imageFile);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double cropSize = MediaQuery.of(context).size.width - 48.w;

    return Scaffold(
      backgroundColor: const Color(0xFF0C0D17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C0D17),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.close_rounded,
            color: Colors.white.withValues(alpha: 0.9),
            size: 22.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Move and Scale',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: TextButton(
              onPressed: _isSaving ? null : _applyCrop,
              child: _isSaving
                  ? SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Done',
                      style: TextStyle(
                        color: const Color(0xFF3B82F6),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SizedBox(
                  width: cropSize,
                  height: cropSize,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // The image viewer to capture
                      RepaintBoundary(
                        key: _boundaryKey,
                        child: Container(
                          color: Colors.black,
                          child: InteractiveViewer(
                            transformationController: _transformCtrl,
                            minScale: 1.0,
                            maxScale: 4.0,
                            boundaryMargin: const EdgeInsets.all(double.infinity),
                            child: Center(
                              child: RotatedBox(
                                quarterTurns: _rotationQuarterTurns,
                                child: Image.file(
                                  widget.imageFile,
                                  fit: BoxFit.cover,
                                  width: cropSize,
                                  height: cropSize,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Circular mask overlay with hairline guide
                      IgnorePointer(
                        child: CustomPaint(
                          painter: _CircleHolePainter(
                            radius: cropSize / 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Controls & Instruction Bar
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 20.h),
              child: Column(
                children: [
                  Text(
                    'Drag to reposition • Pinch to zoom',
                    style: TextStyle(
                      fontSize: 12.5.sp,
                      color: Colors.white.withValues(alpha: 0.4),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildBottomButton(
                        icon: Icons.refresh_rounded,
                        label: 'Reset',
                        onTap: _resetTransform,
                      ),
                      SizedBox(width: 24.w),
                      _buildBottomButton(
                        icon: Icons.rotate_right_rounded,
                        label: 'Rotate',
                        onTap: _rotateImage,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: Colors.white.withValues(alpha: 0.75),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleHolePainter extends CustomPainter {
  final double radius;

  _CircleHolePainter({required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Dim the corners outside the circle
    final dimPaint = Paint()..color = Colors.black.withValues(alpha: 0.55);
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCircle(center: center, radius: radius))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, dimPaint);

    // Clean hairline border around avatar circle
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
