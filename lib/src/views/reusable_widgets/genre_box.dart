import 'package:flutter/material.dart';
import 'package:nuphonic_front_end/src/views/utils/consts.dart';

class GenreBox extends StatelessWidget {
  final String genreName;
  final Color color;
  final String imageSrc;

  GenreBox({this.genreName, this.color, this.imageSrc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  genreName,
                  style: normalFontStyle.copyWith(
                      fontSize: 14,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: ClipPath(
                    clipper: CustomContainer(),
                    child: Image.network(
                      imageSrc,
                      fit: BoxFit.cover,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomContainer extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.20, 0);
    path.lineTo(0, size.height * 0.40);
    path.lineTo(size.width * 0.40, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.20, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldDelegate) {
    return true;
  }
}
