import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickImageAsBase64() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64Str = base64Encode(bytes);
        return 'data:image/jpeg;base64,$base64Str';
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
    return null;
  }

  /// Builds a widget that handles both network URLs, data URI base64 strings, and raw base64 strings gracefully.
  static Widget buildPetImage(String? imageSource, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    if (imageSource == null || imageSource.trim().isEmpty) {
      return Container(
        width: width,
        height: height,
        color: const Color(0xFFE2E8F0),
        child: const Icon(Icons.pets, color: Color(0xFF94A3B8), size: 28),
      );
    }

    final trimmed = imageSource.trim();

    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return Image.network(
        trimmed,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: const Color(0xFFE2E8F0),
          child: const Icon(Icons.pets, color: Color(0xFF94A3B8), size: 28),
        ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: const Color(0xFFF1F5F9),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
      );
    }

    try {
      String cleanBase64 = trimmed;
      if (cleanBase64.contains(',')) {
        cleanBase64 = cleanBase64.split(',').last;
      }
      final bytes = base64Decode(cleanBase64);
      return Image.memory(
        bytes,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: const Color(0xFFE2E8F0),
          child: const Icon(Icons.pets, color: Color(0xFF94A3B8), size: 28),
        ),
      );
    } catch (_) {
      return Container(
        width: width,
        height: height,
        color: const Color(0xFFE2E8F0),
        child: const Icon(Icons.pets, color: Color(0xFF94A3B8), size: 28),
      );
    }
  }
}
