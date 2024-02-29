import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_wallet/util/app_constant.dart';
import 'package:flutter/material.dart';

class CustomFadeInImage extends StatefulWidget {
  String url;
  String? placeHolder;
  BoxFit? fit;
  Color? color;
  double? width;
  double? height;
  Widget? placeHolderWidget;
  Function? imageLoaded;

  CustomFadeInImage(
      {required this.url,
      this.placeHolder,
      this.fit,
      this.color,
      this.width,
      this.height,
      this.placeHolderWidget,
      this.imageLoaded});

  @override
  State<CustomFadeInImage> createState() => _CustomFadeInImageState();
}

class _CustomFadeInImageState extends State<CustomFadeInImage> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      imageUrl: widget.url,
      color: widget.color,
      fadeInDuration:Duration(milliseconds: 0) ,
      imageBuilder: (context, ImageProvider<Object> imageProvider) {
        if (widget.imageLoaded != null) {
          widget.imageLoaded!();
        }
        return Image(
          image: imageProvider,
          width: widget.width,
          height: widget.height,
          color: widget.color,
          fit: widget.fit,

        );
      },
      placeholder: (_, __) {
        if (widget.placeHolderWidget != null) {
          return widget.placeHolderWidget!;
        }
        return Image.asset(
          widget.placeHolder ?? AppImage.imgLogo,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
        );
      },
      errorWidget: (_, __, ___) {
        return Image.file(
          File(
            widget.url,
          ),
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          errorBuilder: (_, __, ___) {
            if (widget.placeHolderWidget != null) {
              return widget.placeHolderWidget!;
            }
            return Image.asset(
              widget.placeHolder ?? AppImage.imgLogo,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
            );
          },
        );
      },
    );
  }
}
