import 'package:flutter/material.dart';

class GarmentArtworkPalette {
  final Color backgroundTop;
  final Color backgroundBottom;
  final Color garment;
  final Color garmentHighlight;
  final Color seam;
  final Color accent;
  final bool longSleeves;

  const GarmentArtworkPalette({
    required this.backgroundTop,
    required this.backgroundBottom,
    required this.garment,
    required this.garmentHighlight,
    required this.seam,
    required this.accent,
    required this.longSleeves,
  });
}

GarmentArtworkPalette garmentPalette(String imageKey) {
  return switch (imageKey) {
    'white_tshirt' => const GarmentArtworkPalette(
      backgroundTop: Color(0xFFF8F7F3),
      backgroundBottom: Color(0xFFE9E5DE),
      garment: Color(0xFFFDFDFB),
      garmentHighlight: Color(0xFFFFFFFF),
      seam: Color(0xFFCBC6BE),
      accent: Color(0xFFD9D2C7),
      longSleeves: false,
    ),
    'black_tshirt' => const GarmentArtworkPalette(
      backgroundTop: Color(0xFF1F2024),
      backgroundBottom: Color(0xFF0E1014),
      garment: Color(0xFF101215),
      garmentHighlight: Color(0xFF2A2E34),
      seam: Color(0xFF5A5F68),
      accent: Color(0xFF3D434B),
      longSleeves: false,
    ),
    'grey_tshirt' => const GarmentArtworkPalette(
      backgroundTop: Color(0xFFE9EAEC),
      backgroundBottom: Color(0xFFD4D7DB),
      garment: Color(0xFFB8BEC6),
      garmentHighlight: Color(0xFFD8DCE1),
      seam: Color(0xFF8A919A),
      accent: Color(0xFFC8CDD3),
      longSleeves: false,
    ),
    'black_sweater' => const GarmentArtworkPalette(
      backgroundTop: Color(0xFF24262A),
      backgroundBottom: Color(0xFF121417),
      garment: Color(0xFF15181C),
      garmentHighlight: Color(0xFF2D3238),
      seam: Color(0xFF636A73),
      accent: Color(0xFF3F454D),
      longSleeves: true,
    ),
    _ => const GarmentArtworkPalette(
      backgroundTop: Color(0xFFF4F4F4),
      backgroundBottom: Color(0xFFE7E7E7),
      garment: Color(0xFFEFEFEF),
      garmentHighlight: Color(0xFFFFFFFF),
      seam: Color(0xFFBDBDBD),
      accent: Color(0xFFD9D9D9),
      longSleeves: false,
    ),
  };
}

/// All available imageKey options
const List<String> kGarmentImageKeys = [
  'white_tshirt',
  'black_tshirt',
  'grey_tshirt',
  'black_sweater',
];

const Map<String, String> kGarmentLabels = {
  'white_tshirt': 'БЕЛАЯ ФУТБОЛКА',
  'black_tshirt': 'ЧЁРНАЯ ФУТБОЛКА',
  'grey_tshirt': 'СЕРАЯ ФУТБОЛКА',
  'black_sweater': 'ЧЁРНЫЙ СВИТЕР',
};

class GarmentPainter extends CustomPainter {
  final GarmentArtworkPalette palette;

  const GarmentPainter({required this.palette});

  @override
  void paint(Canvas canvas, Size size) {
    final garmentPath = _buildGarmentPath(size, palette.longSleeves);
    canvas.drawShadow(
      garmentPath,
      Colors.black.withValues(alpha: 0.28),
      18,
      false,
    );

    final garmentPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [palette.garmentHighlight, palette.garment],
      ).createShader(Offset.zero & size);

    canvas.drawPath(garmentPath, garmentPaint);

    final foldPaint = Paint()
      ..color = palette.seam.withValues(alpha: 0.34)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width * 0.015;

    final leftFold = Path()
      ..moveTo(size.width * 0.39, size.height * 0.34)
      ..quadraticBezierTo(
        size.width * 0.34,
        size.height * 0.56,
        size.width * 0.42,
        size.height * 0.84,
      );
    final rightFold = Path()
      ..moveTo(size.width * 0.61, size.height * 0.34)
      ..quadraticBezierTo(
        size.width * 0.66,
        size.height * 0.56,
        size.width * 0.58,
        size.height * 0.84,
      );

    canvas.drawPath(leftFold, foldPaint);
    canvas.drawPath(rightFold, foldPaint);

    final collarPaint = Paint()..color = palette.seam.withValues(alpha: 0.42);
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.19),
        width: size.width * 0.18,
        height: size.height * 0.08,
      ),
      0,
      3.14,
      false,
      collarPaint
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.018,
    );
  }

  Path _buildGarmentPath(Size size, bool longSleeves) {
    final centerX = size.width / 2;
    final topY = size.height * 0.12;
    final shoulderY = size.height * 0.21;
    final sleeveStartY = size.height * 0.29;
    final sleeveEndY = longSleeves ? size.height * 0.7 : size.height * 0.44;
    final hemY = size.height * 0.9;
    final bodyHalfWidth = size.width * 0.22;
    final sleeveOuter = size.width * (longSleeves ? 0.42 : 0.36);

    return Path()
      ..moveTo(centerX - size.width * 0.08, topY)
      ..quadraticBezierTo(
        centerX,
        size.height * 0.17,
        centerX + size.width * 0.08,
        topY,
      )
      ..lineTo(centerX + bodyHalfWidth * 0.86, shoulderY)
      ..lineTo(centerX + sleeveOuter, sleeveStartY)
      ..lineTo(centerX + sleeveOuter * 0.88, sleeveEndY)
      ..lineTo(centerX + bodyHalfWidth * 0.95, sleeveEndY + size.height * 0.02)
      ..lineTo(centerX + bodyHalfWidth * 0.82, hemY)
      ..lineTo(centerX - bodyHalfWidth * 0.82, hemY)
      ..lineTo(centerX - bodyHalfWidth * 0.95, sleeveEndY + size.height * 0.02)
      ..lineTo(centerX - sleeveOuter * 0.88, sleeveEndY)
      ..lineTo(centerX - sleeveOuter, sleeveStartY)
      ..lineTo(centerX - bodyHalfWidth * 0.86, shoulderY)
      ..close();
  }

  @override
  bool shouldRepaint(covariant GarmentPainter oldDelegate) =>
      oldDelegate.palette != palette;
}

/// Ready-to-use widget: garment artwork card with gradient background
class GarmentArtworkCard extends StatelessWidget {
  final String imageKey;
  final double aspectRatio;

  const GarmentArtworkCard({
    super.key,
    required this.imageKey,
    this.aspectRatio = 0.78,
  });

  @override
  Widget build(BuildContext context) {
    final palette = garmentPalette(imageKey);
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [palette.backgroundTop, palette.backgroundBottom],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: CustomPaint(painter: GarmentPainter(palette: palette)),
        ),
      ),
    );
  }
}
