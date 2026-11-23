import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'profile_photo_cropper_screen.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../core/widgets/custom_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AuthController _authCtrl = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _educationController;

  final List<Map<String, String>> _availablePassions = [
    {'label': '📸 Photography', 'value': 'Photography'},
    {'label': '🎵 Music', 'value': 'Music'},
    {'label': '✈️ Traveling', 'value': 'Traveling'},
    {'label': '🍳 Cooking', 'value': 'Cooking'},
    {'label': '🎮 Gaming', 'value': 'Gaming'},
    {'label': '📚 Reading', 'value': 'Reading'},
    {'label': '⚽ Sports', 'value': 'Sports'},
    {'label': '💪 Fitness', 'value': 'Fitness'},
    {'label': '🎨 Art', 'value': 'Art'},
    {'label': '🎬 Movies', 'value': 'Movies'},
    {'label': '💃 Dancing', 'value': 'Dancing'},
    {'label': '💻 Tech', 'value': 'Tech'},
  ];

  final List<Map<String, String>> _availableLookingFor = [
    {'label': '👫 Friendship', 'value': 'Friendship'},
    {'label': '❤️ Relationship', 'value': 'Relationship'},
    {'label': '🤝 Networking', 'value': 'Networking'},
    {'label': '☕ Casual', 'value': 'Casual'},
    {'label': '🏃 Activity Partner', 'value': 'Activity Partner'},
    {'label': '💬 Chatting', 'value': 'Chatting'},
  ];

  List<String> _selectedPassions = [];
  List<String> _selectedLookingFor = [];

  String? _gender;
  String? _petLover;
  File? _imageFile;

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];
  final List<String> _petLoverOptions = ['Yes', 'No', 'Sometimes'];

  @override
  void initState() {
    super.initState();
    final user = _authCtrl.currentUser.value;
    _nameController = TextEditingController(text: user?.name ?? '');
    _ageController = TextEditingController(text: user?.age?.toString() ?? '');
    _educationController = TextEditingController(text: user?.education ?? '');
    _selectedPassions = List<String>.from(user?.passion ?? []);
    _selectedLookingFor = List<String>.from(user?.preferences ?? []);

    _gender = user?.gender;
    if (_gender != null && !_genderOptions.contains(_gender)) {
      _gender = 'Prefer not to say';
    }

    _petLover = user?.petLover;
    if (_petLover != null && !_petLoverOptions.contains(_petLover)) {
      _petLover = 'No';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _educationController.dispose();
    super.dispose();
  }

  Future<void> _pickAge() async {
    final DateTime now = DateTime.now();
    final initialDate = DateTime(
      now.year - (int.tryParse(_ageController.text) ?? 20),
    );
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1920),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF3B82F6),
              onPrimary: Colors.white,
              surface: Color(0xFF161828),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final int age = now.year -
          picked.year -
          ((now.month < picked.month ||
                  (now.month == picked.month && now.day < picked.day))
              ? 1
              : 0);
      setState(() {
        _ageController.text = age.toString();
      });
    }
  }

  Future<void> _pickImage() async {
    HapticFeedback.lightImpact();
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: const Color(0xFF131525),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library_outlined,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                title: Text(
                  'Choose from Gallery',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              ),
              Divider(
                color: Colors.white.withValues(alpha: 0.05),
                height: 1,
              ),
              ListTile(
                leading: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                title: Text(
                  'Take Photo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.5.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () => Navigator.pop(ctx, ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 95,
    );

    if (pickedFile != null && mounted) {
      final croppedFile = await Navigator.push<File>(
        context,
        MaterialPageRoute(
          builder: (_) => ProfilePhotoCropperScreen(
            imageFile: File(pickedFile.path),
          ),
        ),
      );

      if (croppedFile != null && mounted) {
        setState(() {
          _imageFile = croppedFile;
        });
      }
    }
  }

  void _saveProfile() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) {
      HapticFeedback.selectionClick();
      return;
    }

    HapticFeedback.mediumImpact();
    final int? age = int.tryParse(_ageController.text.trim());
    final data = <String, dynamic>{'name': _nameController.text.trim()};
    if (age != null) data['age'] = age;
    if (_gender != null) data['gender'] = _gender;
    if (_educationController.text.isNotEmpty) {
      data['education'] = _educationController.text.trim();
    }
    if (_petLover != null) data['petLover'] = _petLover;
    data['passion'] = _selectedPassions;
    data['preferences'] = _selectedLookingFor;

    _authCtrl.updateProfile(data, context, imagePath: _imageFile?.path);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
        backgroundColor: const Color(0xFF0C0D17),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0C0D17),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white.withValues(alpha: 0.9),
              size: 19.sp,
            ),
            splashRadius: 22.r,
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Edit Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.5.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
          ),
          centerTitle: true,
          actions: [
            Obx(() => TextButton(
                  onPressed: _authCtrl.isLoading.value ? null : _saveProfile,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                  ),
                  child: _authCtrl.isLoading.value
                      ? SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF3B82F6),
                          ),
                        )
                      : Text(
                          'Save',
                          style: TextStyle(
                            color: const Color(0xFF60A5FA),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                )),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Clean Avatar Photo Picker
                  Center(child: _buildAvatarPicker()),
                  SizedBox(height: 28.h),

                  // Section 1: Basic Information
                  _sectionHeader('PERSONAL INFORMATION'),
                  SizedBox(height: 12.h),
                  _buildMinimalField(
                    label: 'Full Name',
                    hint: 'Your display name',
                    controller: _nameController,
                    icon: Icons.person_outline_rounded,
                    validator: (val) {
                      final text = val?.trim() ?? '';
                      if (text.isEmpty) return 'Name cannot be empty';
                      if (text.length < 2) return 'At least 2 characters';
                      return null;
                    },
                  ),
                  _fieldDivider(),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: _buildMinimalField(
                          label: 'Age',
                          hint: 'Select age',
                          controller: _ageController,
                          icon: Icons.cake_outlined,
                          readOnly: true,
                          onTap: _pickAge,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Expanded(
                        flex: 7,
                        child: _buildMinimalDropdown(
                          label: 'Gender',
                          value: _gender,
                          options: _genderOptions,
                          onChanged: (v) => setState(() => _gender = v),
                        ),
                      ),
                    ],
                  ),
                  _fieldDivider(),

                  _buildMinimalField(
                    label: 'Education',
                    hint: 'School, college or profession',
                    controller: _educationController,
                    icon: Icons.school_outlined,
                  ),
                  _fieldDivider(),

                  _buildMinimalDropdown(
                    label: 'Pet Lover?',
                    value: _petLover,
                    options: _petLoverOptions,
                    onChanged: (v) => setState(() => _petLover = v),
                  ),

                  SizedBox(height: 32.h),

                  // Section 2: Passions
                  _sectionHeader('PASSIONS & INTERESTS'),
                  SizedBox(height: 4.h),
                  Text(
                    'Select what you love doing most',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildTagChips(_availablePassions, _selectedPassions),

                  SizedBox(height: 32.h),

                  // Section 3: Looking For
                  _sectionHeader('LOOKING FOR'),
                  SizedBox(height: 4.h),
                  Text(
                    'What kind of connections do you prefer?',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  _buildTagChips(_availableLookingFor, _selectedLookingFor),

                  SizedBox(height: 36.h),

                  // Bottom Save Changes Button
                  Obx(() => CustomButton(
                        text: 'Save Changes',
                        onPressed: _saveProfile,
                        isLoading: _authCtrl.isLoading.value,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF3B82F6),
                            Color(0xFF1D4ED8),
                          ],
                        ),
                        borderRadius: 12.r,
                        height: 50.h,
                      )),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Minimal Clean Avatar Picker ──────────────────────────────────────────
  Widget _buildAvatarPicker() {
    final user = _authCtrl.currentUser.value;

    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 92.w,
                height: 92.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1.5,
                  ),
                ),
                child: ClipOval(
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : (user?.profileImage != null &&
                              user!.profileImage!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: user.profileImage!,
                              fit: BoxFit.cover,
                              placeholder: (ctx, url) => Container(
                                color: const Color(0xFF161828),
                                child: const Center(
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFFFF4D8D),
                                    ),
                                  ),
                                ),
                              ),
                              errorWidget: (ctx, url, err) =>
                                  _avatarPlaceholder(user.name),
                            )
                          : _avatarPlaceholder(user?.name ?? 'S')),
                ),
              ),

              // Camera Edit Badge
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2138),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF0C0D17),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: const Color(0xFF60A5FA),
                      size: 15.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: _pickImage,
          child: Text(
            'Change profile photo',
            style: TextStyle(
              color: const Color(0xFF60A5FA),
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _avatarPlaceholder(String name) {
    final initial = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : 'S';
    return Container(
      color: const Color(0xFF1A1D30),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ─── Section Header ───────────────────────────────────────────────────────
  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: const Color(0xFF64748B),
        fontSize: 11.5.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _fieldDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.white.withValues(alpha: 0.04),
      ),
    );
  }

  // ─── Minimal Text Field (Pure, Text-Driven, No Heavy Slabs) ───────────────
  Widget _buildMinimalField({
    required String label,
    required String hint,
    required TextEditingController controller,
    IconData? icon,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.white.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          validator: validator,
          cursorColor: const Color(0xFF3B82F6),
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.5.sp,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 14.sp,
            ),
            prefixIcon: icon != null
                ? Padding(
                    padding: EdgeInsets.only(left: 12.w, right: 10.w),
                    child: Icon(icon,
                        color: Colors.white.withValues(alpha: 0.5), size: 18.sp),
                  )
                : null,
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            filled: true,
            fillColor: const Color(0xFF141624),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(
                color: Color(0xFF3B82F6),
                width: 1.2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Minimal Dropdown Field ───────────────────────────────────────────────
  Widget _buildMinimalDropdown({
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.white.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 6.h),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF161828),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white.withValues(alpha: 0.4),
            size: 19.sp,
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.5.sp,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF141624),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(
                color: Color(0xFF3B82F6),
                width: 1.2,
              ),
            ),
          ),
          selectedItemBuilder: (context) {
            return options.map((opt) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  opt,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            }).toList();
          },
          items: options
              .map(
                (opt) => DropdownMenuItem(
                  value: opt,
                  child: Text(
                    opt,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13.5.sp,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  // ─── Clean Minimal Tag Chips (No Heavy Glows) ─────────────────────────────
  Widget _buildTagChips(
      List<Map<String, String>> options, List<String> selected) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: options.map((opt) {
        final val = opt['value']!;
        final isSelected = selected.contains(val);

        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() {
              if (isSelected) {
                selected.remove(val);
              } else {
                selected.add(val);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.08),
                width: 1,
              ),
            ),
            child: Text(
              opt['label']!,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF0C0D17)
                    : Colors.white.withValues(alpha: 0.75),
                fontSize: 12.5.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
