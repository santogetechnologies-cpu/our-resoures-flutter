import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ButtonStyleType {
  category,
  mainMenu,
  subMenu,
  brownAction,
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonStyleType styleType;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight fontWeight;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.styleType = ButtonStyleType.mainMenu,
    this.width,
    this.height,
    this.fontSize,
    this.fontWeight = FontWeight.w600,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor = AppColors.textBlack;
    Border? border;
    double resolvedHeight;
    EdgeInsetsGeometry resolvedMargin;
    EdgeInsetsGeometry resolvedPadding;
    double resolvedFontSize;

    switch (styleType) {
      case ButtonStyleType.category:
        bgColor = AppColors.categoryBtnBg;
        border = Border.all(color: Colors.white.withOpacity(0.6), width: 1.5);
        resolvedHeight = height ?? 64;
        resolvedMargin = margin ?? const EdgeInsets.all(10);
        resolvedPadding = padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
        resolvedFontSize = fontSize ?? 24;
        break;
      case ButtonStyleType.mainMenu:
        bgColor = AppColors.mainMenuBtnBg;
        border = Border.all(color: Colors.white.withOpacity(0.8), width: 1.5);
        resolvedHeight = height ?? 70;
        resolvedMargin = margin ?? const EdgeInsets.only(left: 21, right: 21, top: 16);
        resolvedPadding = padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
        resolvedFontSize = fontSize ?? 25;
        break;
      case ButtonStyleType.subMenu:
        bgColor = AppColors.subMenuBtnBg;
        border = Border.all(color: Colors.white.withOpacity(0.5), width: 1.0);
        resolvedHeight = height ?? 50;
        resolvedMargin = margin ?? const EdgeInsets.symmetric(horizontal: 21, vertical: 5);
        resolvedPadding = padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
        resolvedFontSize = fontSize ?? 20;
        break;
      case ButtonStyleType.brownAction:
        bgColor = AppColors.primaryBrown;
        textColor = Colors.white;
        border = Border.all(color: AppColors.solidBrown, width: 1.5);
        resolvedHeight = height ?? 52;
        resolvedMargin = margin ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 8);
        resolvedPadding = padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 10);
        resolvedFontSize = fontSize ?? 18;
        break;
    }

    return Container(
      width: width,
      height: resolvedHeight,
      margin: resolvedMargin,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppColors.borderRadius),
        border: border,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppColors.borderRadius),
          onTap: onPressed,
          child: Padding(
            padding: resolvedPadding,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'NotoKufi',
                    fontSize: resolvedFontSize,
                    fontWeight: fontWeight,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
