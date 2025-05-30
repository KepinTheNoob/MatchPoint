import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomImageViewer {
  CustomImageViewer._();

  static Widget show({
    required BuildContext context,
    required String url,
    BoxFit? fit,
    double? radius,
  }) {
    final isNetworkImage = url.startsWith('http');

    if (isNetworkImage) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: fit ?? BoxFit.cover,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).dialogBackgroundColor,
            borderRadius: BorderRadius.circular(radius ?? 8),
            image: DecorationImage(
              image: imageProvider,
              fit: fit ?? BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Container(),
        errorWidget: (context, url, error) => const Icon(Icons.error_outline),
      );
    } else {
      // Asset image
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 8),
        child: Image.asset(
          url,
          fit: fit ?? BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
  }
}
