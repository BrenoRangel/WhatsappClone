import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var textTheme = GoogleFonts.montserratTextTheme();

var theme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF25D366)),
  fontFamily: textTheme.bodyLarge?.fontFamily,
  textTheme: textTheme,
);

const padding = EdgeInsets.all(8);
