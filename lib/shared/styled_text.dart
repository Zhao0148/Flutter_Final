import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyledText extends StatelessWidget {
  const StyledText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.kanit(
      textStyle: Theme.of(context).textTheme.bodyMedium,
    ));
  }
}

class StyledHeading extends StatelessWidget {
  const StyledHeading(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: GoogleFonts.kanit(
      textStyle: Theme.of(context).textTheme.headlineMedium,
    ));
  }
}

class StyledTitle extends StatelessWidget {
  const StyledTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(), style: GoogleFonts.kanit(
      textStyle: Theme.of(context).textTheme.titleMedium,
    ));
  }
}

class StyledFormPlaceholder {
  static TextStyle get style {
    return GoogleFonts.kanit(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: Colors.grey[600],
    );
  }
}
class StyledFormInput {
  static TextStyle get style {
    return GoogleFonts.kanit(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: const Color.fromARGB(255, 0, 0, 0),
    );
  }
}