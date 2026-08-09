import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:routina/core/helpers/extension.dart';
import 'package:routina/core/helpers/spacing.dart';
import 'package:routina/core/theaming/app_colors.dart';
import 'package:routina/core/theaming/app_text_styles.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_cubit.dart';
import 'package:routina/features/profile_screen/logic/cubit/profile_state.dart';
import 'package:routina/features/profile_screen/ui/widgets/image_source_sheet.dart';
import 'package:routina/features/profile_screen/ui/widgets/otp_verification_sheet.dart';
import 'package:routina/features/profile_screen/ui/widgets/phone_verification_badge.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_form_field.dart';
import 'package:routina/features/profile_screen/ui/widgets/profile_header_image.dart';

class AccountInformationScreen extends StatefulWidget {
  const AccountInformationScreen({super.key});

  @override
  State<AccountInformationScreen> createState() =>
      _AccountInformationScreenState();
}

class _AccountInformationScreenState extends State<AccountInformationScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'EG');
  bool _isLoading = false;
  String? _lastVerifiedPhone;
  final ValueNotifier<int> _phoneEditTick = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileCubit>().state;
    _nameController = TextEditingController(text: state.name ?? '');
    _phoneController = TextEditingController(text: state.phone ?? '');
    _dobController = TextEditingController(text: state.dob ?? '');

    if (state.phone != null && state.phone!.isNotEmpty) {
      _phoneNumber = PhoneNumber(isoCode: 'EG', phoneNumber: state.phone);
      if (state.phoneVerified) _lastVerifiedPhone = state.phone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _phoneEditTick.dispose();
    super.dispose();
  }

  bool _phoneIsVerified(ProfileState state) {
    final current = _phoneNumber.phoneNumber ?? _phoneController.text.trim();
    if (current.isEmpty) return false;
    return (state.phoneVerified && current == state.phone) ||
        current == _lastVerifiedPhone;
  }

  bool _phoneHasUnsavedChange(ProfileState state) {
    final current = _phoneNumber.phoneNumber ?? _phoneController.text.trim();
    return current.isNotEmpty && current != (state.phone ?? '');
  }

  bool _canSave(ProfileState state) {
    final phoneChanged = _phoneHasUnsavedChange(state);
    final verifiedNow = _phoneIsVerified(state);
    final phoneOk = !phoneChanged || verifiedNow;
    final nameChanged = _nameController.text.trim() != (state.name ?? '');
    final dobChanged = _dobController.text.trim() != (state.dob ?? '');
    return (nameChanged || dobChanged || phoneChanged) && phoneOk;
  }

  void _revertPhoneChange(ProfileState state) {
    final savedPhone = state.phone ?? '';
    setState(() {
      _phoneController.text = savedPhone;
      _phoneNumber = savedPhone.isNotEmpty
          ? PhoneNumber(isoCode: 'EG', phoneNumber: savedPhone)
          : PhoneNumber(isoCode: 'EG');
      _lastVerifiedPhone = state.phoneVerified ? savedPhone : null;
    });
    _phoneEditTick.value++;
  }

  Future<void> _saveChanges() async {
    final newPhone = _phoneNumber.phoneNumber ?? _phoneController.text.trim();
    final state = context.read<ProfileCubit>().state;

    if (!_canSave(state)) return;

    setState(() => _isLoading = true);
    try {
      await context.read<ProfileCubit>().updateProfileData(
        name: _nameController.text.trim(),
        phone: newPhone,
        dob: _dobController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.profileUpdatedSuccessfully)),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.errorWithMessage(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyPhoneNumber(BuildContext context) async {
    final phone = _phoneNumber.phoneNumber ?? _phoneController.text.trim();
    if (phone.isEmpty) return;

    setState(() => _isLoading = true);
    final cubit = context.read<ProfileCubit>();

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await FirebaseAuth.instance.currentUser?.linkWithCredential(
              credential,
            );
          } on FirebaseAuthException catch (e) {
            if (e.code != 'credential-already-in-use' &&
                e.code != 'provider-already-linked') {
              if (!mounted) return;
              setState(() => _isLoading = false);
              return;
            }
          }
          await cubit.confirmPhoneVerified(phone);
          if (!mounted) return;
          setState(() {
            _lastVerifiedPhone = phone;
            _isLoading = false;
          });
          _phoneEditTick.value++;
        },
        verificationFailed: (FirebaseAuthException e) {
          if (!mounted) return;
          setState(() => _isLoading = false);
        },
        codeSent: (String verificationId, int? resendToken) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          showOtpVerificationSheet(
            context,
            verificationId: verificationId,
            phone: phone,
            cubit: cubit,
            onSuccess: () {
              if (!mounted) return;
              setState(() => _lastVerifiedPhone = phone);
              _phoneEditTick.value++;
            },
          );
        },
        codeAutoRetrievalTimeout: (_) {},
      );
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        title: Text(
          context.l10n.accountInformation,
          style: AppTextStyles.headlineSmall.copyWith(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (_nameController.text != (state.name ?? '')) {
            _nameController.text = state.name ?? '';
          }
          if (_phoneController.text != (state.phone ?? '')) {
            _phoneController.text = state.phone ?? '';
          }
          if (_dobController.text != (state.dob ?? '')) {
            _dobController.text = state.dob ?? '';
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              children: [
                ProfileHeaderImage(
                  imageUrl: state.imageUrl,
                  onTap: () => showImageSourceSheet(
                    context,
                    onCamera: () => context
                        .read<ProfileCubit>()
                        .updateProfileImage(source: ImageSource.camera),
                    onGallery: () => context
                        .read<ProfileCubit>()
                        .updateProfileImage(source: ImageSource.gallery),
                    onRemove: () =>
                        context.read<ProfileCubit>().deleteProfileImage(),
                  ),
                ),
                verticalSpace(32),
                ProfileEditableField(
                  icon: Icons.person_outline_rounded,
                  title: context.l10n.name,
                  child: TextFormField(
                    controller: _nameController,
                    onChanged: (_) => _phoneEditTick.value++,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                      fontSize: 14.sp,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                verticalSpace(14),
                ProfileReadonlyField(
                  icon: Icons.email_outlined,
                  title: context.l10n.email,
                  value: state.email ?? context.l10n.noEmail,
                ),
                verticalSpace(14),
                ProfileEditableField(
                  icon: Icons.cake_outlined,
                  title: context.l10n.dateOfBirth,
                  child: TextFormField(
                    controller: _dobController,
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _dobController.text =
                              "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                        });
                      }
                    },
                    style: TextStyle(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                      fontSize: 14.sp,
                    ),
                    decoration: InputDecoration(
                      hintText: context.l10n.dobHint,
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                verticalSpace(14),
                ProfileEditableField(
                  icon: Icons.phone_outlined,
                  title: context.l10n.phoneNumber,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface.withValues(alpha: 0.5)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: InternationalPhoneNumberInput(
                        onInputChanged: (number) {
                          _phoneNumber = number;
                          _phoneEditTick.value++;
                        },
                        textFieldController: _phoneController,
                        initialValue: _phoneNumber,
                        spaceBetweenSelectorAndTextField: 0,
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          useBottomSheetSafeArea: true,
                          leadingPadding: 0,
                          trailingSpace: false,
                        ),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: TextStyle(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                          fontSize: 14.sp,
                        ),
                        textStyle: TextStyle(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                          fontSize: 14.sp,
                        ),
                        inputDecoration: const InputDecoration(
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                        ),
                        formatInput: false, // Changed from true to false
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: true,
                          decimal: true,
                        ),
                      ),
                    ),
                  ),
                ),
                verticalSpace(8),
                ValueListenableBuilder<int>(
                  valueListenable: _phoneEditTick,
                  builder: (context, _, __) => PhoneVerificationBadge(
                    isVerified: _phoneIsVerified(state),
                    isLoading: _isLoading,
                    hasUnsavedChange: _phoneHasUnsavedChange(state),
                    onVerify: () => _verifyPhoneNumber(context),
                    onRevert: () => _revertPhoneChange(state),
                  ),
                ),
                verticalSpace(32),
                ValueListenableBuilder<int>(
                  valueListenable: _phoneEditTick,
                  builder: (context, _, __) {
                    final canSave = _canSave(state) && !_isLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 54.h,
                      child: ElevatedButton(
                        onPressed: canSave ? _saveChanges : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 22.sp,
                                height: 22.sp,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                context.l10n.saveChanges,
                                style: AppTextStyles.font16WhiteMedium,
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
