import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/widgets.dart';

class FirebaseApi {
  static Future<String> recogniseText(File imageFile) async {
    if (imageFile == null) {
      return "No selected image";
    } else {
      final visionImage = FirebaseVisionImage.fromFile(imageFile);
      final textRecognizer = FirebaseVision.instance.textRecognizer();

      try {
        final visionText = await textRecognizer.processImage(visionImage);
        await textRecognizer.close();

        final text = extractText(visionText);

        return text.isEmpty ? 'No text found in the image' : text;
      } catch (e) {
        return e.toString();
      }
    }
  }

  static extractText(VisionText visionText) {
    String text = '';

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          text = text + word.text.toString() + ' ';
        }
        text = text + '\n';
      }
    }
    return text;
  }
}
