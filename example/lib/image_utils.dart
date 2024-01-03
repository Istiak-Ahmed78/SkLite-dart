/*
 * Copyright 2023 The TensorFlow Authors. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *             http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:io';
import 'package:image/image.dart' as image_lib;

// ImageUtils
class ImageUtils {
  static List<List<List<List<double>>>> preprocessInput(File imageFile, int inputSize) {
    // For convulation Neural Network
    // Load the image
    image_lib.Image image = image_lib.decodeImage(imageFile.readAsBytesSync())!;

    // Resize the image to the input size expected by the model
    image_lib.Image resizedImage = image_lib.copyResize(image, width: inputSize, height: inputSize);

    // Normalize pixel values to the range [0, 1]
    List<List<List<double>>> inputTensor = [];
    for (int y = 0; y < inputSize; y++) {
      List<List<double>> row = [];
      for (int x = 0; x < inputSize; x++) {
        int pixel = resizedImage.getPixel(x, y);
        double red = (image_lib.getRed(pixel) / 255.0);
        double green = (image_lib.getGreen(pixel) / 255.0);
        double blue = (image_lib.getBlue(pixel) / 255.0);

        // Adjust the channel order if needed based on the model requirements
        row.add([red, green, blue]);
      }
      inputTensor.add(row);
    }

    // Adjust the output shape to (1, 256, 256, 3)
    List<List<List<List<double>>>> output = [];
    output.add(inputTensor);

    return output;
  }

  static Future<List<double>?> convertImageToData(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    image_lib.Image? image = image_lib.decodeImage(bytes);
    if (image == null) return null;

    // Convert Image to list of RGB values
    List<double> rgbValues = image.getBytes(format: image_lib.Format.rgb).toList().cast<double>();

    // Convert to (1, 67500) list
    List<List<double>> reshapedData = [rgbValues];

    return rgbValues;
  }
}
