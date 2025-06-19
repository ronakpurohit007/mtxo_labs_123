import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

class Constants {
  static const String tokenKey = 'session_token';
  static const String csrfTokenKey = 'csrf_token';
  static const String csrfHashKey = 'csrf_hash';
  static const String languageKey = 'locale';
  static const String userDetailsKey = 'user_details';

  static const String userIdKey = 'userIdKey';
  static const String AIToken =
      'snqDrcRSlooliK1x3qJ7qvh2E/guI7IThPqwptsQVw/eNvTxyJZK1vjhBrQvQ5moeE0mHXA8+6EPzZekA/Za/A==';

  static const String MapBoxToken =
      'pk.eyJ1IjoiamF5cmFqbSIsImEiOiJjbTE3dTlud2Iwbmo3Mmtwd21mbnduazZ1In0.U8sj8QM5vQ9OI202NvofLA';

  static const String unrealspeechtoken =
      "yyzuKiwxJPMoS5yLSocwbsnP6iWcW9mH8v1Lzdp9plIc1Y05vSuufb";

  static const String unRealVoiceId = "Sierra";

  static const String openAIVoiceId = "fable";
  static const String openAIVoiceIdhi = "ash";
  static const String openAIVoiceIden = "nova";
  static const String openAIVoiceIdgu = "onyx";

  static String getFileUrls(String orgId, String chatId, filename) {
    return 'uploads/$orgId/chats/$chatId/$filename';
  }

  static bool isIPad(BuildContext context) {
    // Check if the platform is iOS
    if (Platform.isIOS) {
      final size = MediaQuery.of(context).size;
      final diagonal =
          sqrt(size.width * size.width + size.height * size.height);

      // iPads typically have a diagonal screen size > 1100 logical pixels
      return diagonal > 1100;
    }
    return false;
  }
}
