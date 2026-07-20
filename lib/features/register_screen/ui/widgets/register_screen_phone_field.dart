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
        canvasColor: isDark ? AppColors.darkBackgroundLight : Colors.white,
      ),
      child: InternationalPhoneNumberInput(
        locale: Localizations.localeOf(context).languageCode,
        onInputChanged: onInputChanged,
        textFieldController: phoneController,
        initialValue: phoneNumber,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        selectorConfig: const SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          setSelectorButtonAsPrefixIcon: true,
          leadingPadding: 0,
          trailingSpace: false,
        ),
        selectorTextStyle: TextStyle(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          fontSize: 13.sp,
        ),
        textStyle: TextStyle(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          fontSize: 14.sp,
        ),
        searchBoxDecoration: InputDecoration(
          hintText: 'Search country',
          hintStyle: TextStyle(
            color: isDark ? Colors.white38 : Colors.grey[500],
            fontSize: 13.sp,
          ),
          prefixIcon: Icon(Icons.search, size: 20.w),
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
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            fontSize: 14.sp,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          fillColor: defaultFillColor,
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColors.primary, width: 1.5.w),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
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
    );
  }
}