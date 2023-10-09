import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rakwa/app_colors/app_colors.dart';
import 'package:rakwa/widget/SVG_Widget/svg_widget.dart';

enum FieldType {
  WithBorder,
  WithOutBorder,
}

enum SecureType {
  Never,
  Toggle,
  Always,
}

class TextFieldDefault extends StatefulWidget {
  final String hint;
  final String? label;
  final String upperTitle;
  final FieldType fieldType;
  final IconData? prefixIconData;
  final IconData? suffixIconData;
  final IconData? icon;
  final String? prefixIconSvg;
  final String? prefixIconPng;
  final String? suffixIconUrl;
  final bool? isPrefixIcon;
  final bool? isSuffixIcon;
  final String? Function(String?)? validation;
  final Function(String)? onChanged;
  final VoidCallback? onComplete;
  final FormFieldSetter<String>? onSaved;
  final Color hintColor;
  final FontWeight hintWeight;
  final double hintSize;
  final Color? labelColor;
  final Color errorColor;
  final Color fieldColor;
  final Color filledColor;
  final Color enableBorder;
  final Color disableBorder;
  final Color? focusBorder;
  final Color errorBorder;
  final Color cursorColor;
  final Color prefixColor;
  final Color suffixColor;
  final Color iconColor;

  final String? errorText;
  final String? errorLargeText;
  final String? errorMinimumText;
  final int largeCondition;
  final int minimumCondition;
  final int maxLines;

  final TextEditingController? controller;

  final double horizentalPadding;
  final double verticalPadding;
  final VoidCallback? onSuffixTap;
  final FocusNode? node;

  final double borderRadius;
  final double borderWidth;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final SecureType secureType;

  final List<TextInputFormatter>? format;
  final double outerHorizentalPadding;
  final bool autofocus;

  final bool enable;

  final double upperFontSize;

  final Color upperTitleColor;
  final bool ltr;

  TextFieldDefault(
      {@required this.hint = '',
      this.controller,
      this.upperTitle = '',
      this.upperTitleColor = AppColors.kCTFUpperTitle,
      this.upperFontSize = 16,
      this.label,
        this.ltr = false,
        this.format,
      this.autofocus=false,
      this.fieldType = FieldType.WithBorder,
      this.prefixIconData,
      this.suffixIconData,
      this.prefixIconSvg,
      this.prefixIconPng,
      this.suffixIconUrl,
      this.isPrefixIcon = true,
      this.isSuffixIcon = false,
      this.validation,
      this.onChanged,
      this.onComplete,
      this.onSaved,
      this.maxLines = 1,
      this.enable = true,
      this.hintWeight = FontWeight.w200,
      this.hintSize = 10,
      this.hintColor = AppColors.kCTFHintTitle,
      this.labelColor = AppColors.kCTFHintTitle,
      this.errorColor = AppColors.kCTFErrorText,
      this.fieldColor = AppColors.kCTFBackGround,
      this.filledColor = AppColors.kCTFBackGround,
      this.enableBorder = AppColors.kCTFEnableBorder,
      this.disableBorder = AppColors.kCTFDisableBorder,
      this.focusBorder,
      this.errorBorder = AppColors.kCTFErrorBorder,
      this.cursorColor = AppColors.kCTFCursor,
      this.errorText,
      this.errorLargeText,
      this.largeCondition = 0,
      this.minimumCondition = 0,
      this.errorMinimumText,
      this.horizentalPadding = 19.0,
      this.verticalPadding = 14.0,
      this.icon,
      this.onSuffixTap,
      this.prefixColor = AppColors.kCTFPreFixIcon,
      this.suffixColor = AppColors.kCTFSuffixFixIcon,
      this.iconColor = AppColors.kCTFPreFixIcon,
      this.borderRadius = 12.0,
      this.borderWidth = 1.0,
      this.keyboardType,
        this.node,
      this.textInputAction,
      this.secureType = SecureType.Never,
      this.outerHorizentalPadding = 0.0});

  @override
  _TextFieldDefaultState createState() => _TextFieldDefaultState();
}

class _TextFieldDefaultState extends State<TextFieldDefault> {
  bool secureState = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.outerHorizentalPadding.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          drawUpperTitle(
              upperTitleText: widget.upperTitle,
              fontSize: widget.upperFontSize,
              usedUpperTitleColor: widget.upperTitleColor),
          TextFormField(
            focusNode: widget.node,
            textDirection: TextDirection.ltr,
            autofocus: widget.autofocus,
            obscureText: widget.secureType == SecureType.Never
                ? false
                : widget.secureType == SecureType.Always
                    ? true
                    : secureState,
            keyboardType: widget.keyboardType,

            textInputAction: widget.textInputAction,
            onEditingComplete: widget.onComplete,
            onChanged: widget.onChanged,
            onSaved: widget.onSaved,
            controller: widget.controller,
            cursorColor: widget.cursorColor,
            // ignore: missing_return
            enabled: widget.enable,
            maxLines: widget.maxLines,

            inputFormatters: widget.format,
            validator: widget.validation ??
                (value) {
                  if (value!.isEmpty)
                    return widget.errorText;
                  else if (value.length < widget.minimumCondition)
                    return widget.errorMinimumText;
                  if (widget.largeCondition != 0) {
                    if (value.length > widget.largeCondition)
                      return widget.errorLargeText;
                  } else
                    return null;
                },
            style:  TextStyle(
                fontSize: 12.sp,
                color: AppColors.kCTFMainTitle,
                fontFamily: "semibold"),
            decoration: InputDecoration(
              enabled: true,
              filled: true,
              fillColor: widget.filledColor,
              // HINT TEXT WITH STYLE
              hintText: widget.hint,

              hintStyle: GoogleFonts.notoKufiArabic(
                textStyle:  TextStyle(
                  fontSize: widget.hintSize.sp,
                  fontWeight: widget.hintWeight,
                  color: widget.hintColor,
                ),
              ),
              // TextStyle(
              //     fontSize: 15,
              //     color: widget.hintColor,
              //     fontFamily: "light"
              // ),
              // LABEL TEXT WITH STYLE
              labelText: widget.label,
              labelStyle: TextStyle(
                  fontSize: 11.sp, color: widget.labelColor, fontFamily: "light"),
              // ERROR TEXT STYLE

              errorStyle: Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontSize: 12.sp, color: widget.errorColor, fontFamily: "light"),
              // PADDING
              contentPadding: EdgeInsets.symmetric(
                vertical: widget.verticalPadding,
                horizontal: widget.horizentalPadding,
              ),
              icon: widget.icon != null
                  ? Icon(
                      widget.icon,
                      color: widget.iconColor,
                      size: 15.sp,
                    )
                  : null,
              prefixIcon: (widget.prefixIconSvg != null ||
                      widget.prefixIconData != null ||
                      widget.prefixIconPng != null)
                  ? widget.prefixIconSvg != null
                      ? Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: IconSvg(
                          widget.prefixIconSvg!,
                          size: 20.w,
                          color: widget.prefixColor,
                        ),
                      )
                      : widget.prefixIconPng != null
                          ? IconPng(
                              widget.prefixIconPng!,
                              size: 15.w,
                            )
                          : Icon(
                              widget.prefixIconData,
                              color: widget.prefixColor,
                              size: 15.w,
                            )
                  : null,


              prefixIconConstraints: widget.prefixIconSvg == null
                  ? null
                  :  BoxConstraints(
                      maxHeight: 25.h,
                      maxWidth: 25.w,
                    ),
              suffixIcon: widget.secureType == SecureType.Toggle
                  ? IconButton(
                      icon: IconSvg(
                        secureState ? "Eye" : "EyeOn",
                        size: 15.w,
                        color: widget.suffixColor,
                      ),
                      // Icon(secureState
                      //     ? Icons.visibility_outlined
                      //     : Icons.visibility_off_outlined),
                      color: widget.suffixColor,
                      iconSize: 15.sp,
                      onPressed: () {
                        setState(() {
                          secureState = !secureState;
                        });
                      })
                  : (widget.suffixIconData != null ||
                          widget.suffixIconUrl != null)
                      ? IconButton(
                          icon: Icon(
                            widget.suffixIconData,
                            color: widget.suffixColor,
                            size: 16.w,
                          ),
                          onPressed: widget.onSuffixTap,
                        )
                      : null,
              border: widget.fieldType == FieldType.WithBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(
                        color: widget.enableBorder,
                        width: widget.borderWidth,
                        //style: BorderStyle.solid,
                      ),
                    )
                  : UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: widget.errorBorder,
                        width: widget.borderWidth.w,
                      ),
                    ),
              disabledBorder: widget.fieldType == FieldType.WithBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius,
                      ),
                      borderSide: BorderSide(
                        color: widget.disableBorder,
                        width: widget.borderWidth.w,
                      ),
                    )
                  : UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: widget.disableBorder,
                        width: widget.borderWidth.w,
                      ),
                    ),
              enabledBorder: widget.fieldType == FieldType.WithBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius.r,
                      ),
                      borderSide: BorderSide(
                        color: widget.enableBorder,
                        width: widget.borderWidth.w,
                      ),
                    )
                  : UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: widget.enableBorder,
                        width: widget.borderWidth,
                      ),
                    ),
              focusedBorder: widget.fieldType == FieldType.WithBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius,
                      ),
                      borderSide: BorderSide(
                        color: widget.focusBorder == null ? AppColors.kCTFFocusBorder: widget.focusBorder!,
                        width: widget.borderWidth,
                      ),
                    )
                  : UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: widget.focusBorder == null ? AppColors.kCTFFocusBorder: widget.focusBorder!,
                        width: widget.borderWidth,
                      ),
                    ),
              errorBorder: widget.fieldType == FieldType.WithBorder
                  ? OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        widget.borderRadius,
                      ),
                      borderSide: BorderSide(
                        color: widget.errorBorder,
                        width: widget.borderWidth.w,
                      ),
                    )
                  : UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: widget.errorBorder,
                        width: widget.borderWidth.w,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget drawUpperTitle(
      {String upperTitleText = '', Color? usedUpperTitleColor, double? fontSize}) {
    return widget.upperTitle.isNotEmpty
        ? Padding(
            padding:  EdgeInsets.only(
              bottom: 7.h,
            ),
            child: Text(
              widget.upperTitle,
              textDirection: TextDirection.rtl,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoKufiArabic(
                textStyle:  TextStyle(
                  fontSize: fontSize!.sp,
                  fontWeight: FontWeight.w300,
                  color: usedUpperTitleColor
                ),
              ),
              // style: Theme.of(context).textTheme.caption!.copyWith(
              //     color: usedUpperTitleColor,
              //     fontSize: 16,
              //     fontFamily: 'light',
              // ),
            ),
          )
        : const SizedBox(
            height: 0,
          );
  }
}
