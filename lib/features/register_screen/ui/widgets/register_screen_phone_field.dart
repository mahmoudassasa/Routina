import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/theaming/app_colors.dart';

class RegisterScreenPhoneField extends StatelessWidget {
  final TextEditingController phoneController;
  final PhoneNumber phoneNumber;
  final ValueChanged<PhoneNumber> onInputChanged;

  const RegisterScreenPhoneField({
    super.key,
    required this.phoneController,
    required this.phoneNumber,
    required this.onInputChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.border;
    final defaultFillColor = isDark ? AppColors.darkBackgroundLight : AppColors.backgroundLight;

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: isDark ? AppColors.darkSurface : Colors.white,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: InternationalPhoneNumberInput(
          locale: Localizations.localeOf(context).languageCode,
          onInputChanged: onInputChanged,
          textFieldController: phoneController,
          initialValue: phoneNumber,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          selectorConfig: SelectorConfig(
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
            setSelectorButtonAsPrefixIcon: true,
            leadingPadding: 12.w,
            trailingSpace: false,
          ),
          selectorTextStyle: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          textStyle: TextStyle(
            color: isDark ? Colors.white : AppColors.textPrimary,
            fontSize: 14.sp,
          ),
          searchBoxDecoration: InputDecoration(
            hintText: 'Search country...',
            hintStyle: TextStyle(
              color: isDark ? Colors.white30 : Colors.grey[400],
              fontSize: 13.sp,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              size: 20.w,
              color: isDark ? AppColors.primaryLight : AppColors.primary,
            ),
            filled: true,
            fillColor: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.grey.withValues(alpha: 0.08),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5.w),
            ),
          ),
          cursorColor: AppColors.primary,
          formatInput: false,
          keyboardType: const TextInputType.numberWithOptions(
            signed: true,
            decimal: true,
          ),
          inputDecoration: InputDecoration(
            labelText: '${context.l10n.phonePlaceholder} (${context.l10n.optional})',
            labelStyle: TextStyle(
              color: isDark ? Colors.white60 : AppColors.textSecondary,
              fontSize: 14.sp,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            fillColor: defaultFillColor,
            filled: true,
            suffixIcon: Icon(
              Icons.phone_outlined,
              size: 20.sp,
              color: isDark ? AppColors.primaryLight : AppColors.primary,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5.w),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: AppColors.error, width: 1.5.w),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return null;
            }
            final digits = value.trim().replaceAll(RegExp(r'[^\d]'), '');
            if (digits.length < 8 || digits.length > 12) {
              return context.l10n.phoneInvalid;
            }
            return null;
          },
        ),
      ),
    );
  }
}