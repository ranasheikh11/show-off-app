import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

import '../controllers/showoff_controller.dart';
import '../controllers/feed_audio_controller.dart';
import '../widgets/create_media_grid.dart';
import '../widgets/create_upload_progress.dart';
import '../services/music_service.dart';
import '../widgets/music_search_bottom_sheet.dart';

class CreateShowOffScreen extends StatefulWidget {
  const CreateShowOffScreen({super.key});

  @override
  State<CreateShowOffScreen> createState() => _CreateShowOffScreenState();
}

class _CreateShowOffScreenState extends State<CreateShowOffScreen> {
  final _ctrl = Get.find<ShowOffController>();
  final _picker = ImagePicker();
  final List<File> _images = [];
  bool _isPicking = false;
  MusicModel? _selectedMusic;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<FeedAudioController>()) {
      Get.find<FeedAudioController>().pauseMusic();
    }
  }

  Future<void> _pickImages() async {
    if (_isPicking) return;
    HapticFeedback.lightImpact();
    _isPicking = true;
    try {
      final picked = await _picker.pickMultiImage(
        imageQuality: 85,
      );
      if (picked.isNotEmpty) {
        final dir = await getTemporaryDirectory();

        for (var x in picked) {
          if (_images.length >= 10) break;

          final originalFile = File(x.path);
          final targetPath =
              '${dir.path}/${DateTime.now().millisecondsSinceEpoch}_comp.jpg';

          final compressedFile =
              await FlutterImageCompress.compressAndGetFile(
            x.path,
            targetPath,
            quality: 70,
          );

          if (compressedFile != null) {
            setState(() => _images.add(File(compressedFile.path)));
          } else {
            setState(() => _images.add(originalFile));
          }
        }
      }
    } catch (e) {
      debugPrint('Error picking images: $e');
    } finally {
      _isPicking = false;
    }
  }

  void _remove(int i) {
    HapticFeedback.selectionClick();
    setState(() => _images.removeAt(i));
  }

  void _reorder(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;
    HapticFeedback.lightImpact();
    setState(() {
      final item = _images.removeAt(oldIndex);
      _images.insert(newIndex, item);
    });
  }

  Future<void> _post() async {
    if (_images.isEmpty) {
      _showSnack('Please select at least one photo', isError: true);
      return;
    }
    HapticFeedback.mediumImpact();
    final ok = await _ctrl.createPost(
      _images.map((e) => e.path).toList(),
      musicUrl: _selectedMusic?.previewUrl,
      musicTitle: _selectedMusic?.title,
      musicArtist: _selectedMusic?.artist,
    );
    if (!mounted) return;
    if (ok) {
      _showSnack('Post published successfully!');
      Navigator.pop(context);
    } else {
      _showSnack('Failed to publish post. Please try again.', isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor:
            isError ? const Color(0xFFEF4444) : const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        margin: EdgeInsets.all(16.w),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0D17),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0C0D17),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
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
          'Create Post',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.5.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Center(
              child: _buildPostButton(),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (_ctrl.isUploading.value) {
            return CreateUploadProgress(progress: _ctrl.uploadProgress.value);
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Soundtrack / Music Selector
                _buildMusicSelector(),

                SizedBox(height: 24.h),

                // Photos Section Header
                _buildPhotosHeader(),

                SizedBox(height: 10.h),

                // Media Content (Empty state vs Grid)
                if (_images.isEmpty)
                  _buildEmptyState()
                else
                  CreateMediaGrid(
                    images: _images,
                    onAddTap: _pickImages,
                    onRemove: _remove,
                    onReorder: _reorder,
                  ),

                SizedBox(height: 24.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPostButton() {
    final bool hasImages = _images.isNotEmpty;
    final bool isBusy = _ctrl.isUploading.value;

    if (!hasImages) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.5.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          'Post',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.3),
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return InkWell(
      onTap: isBusy ? null : _post,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.5.h),
        decoration: BoxDecoration(
          color: const Color(0xFF3B82F6),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          'Post',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildMusicSelector() {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => MusicSearchBottomSheet(
            onMusicSelected: (music) {
              setState(() => _selectedMusic = music);
            },
          ),
        );
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: _selectedMusic != null
                ? const Color(0xFF3B82F6).withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Icon(
              _selectedMusic != null
                  ? Icons.graphic_eq_rounded
                  : Icons.music_note_rounded,
              color: const Color(0xFF60A5FA),
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedMusic != null
                        ? _selectedMusic!.title
                        : 'Add Soundtrack',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    _selectedMusic != null
                        ? _selectedMusic!.artist
                        : 'Select background music for your photos',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (_selectedMusic != null)
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 18.sp,
                ),
                splashRadius: 18.r,
                onPressed: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedMusic = null);
                },
              )
            else
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withValues(alpha: 0.3),
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PHOTOS',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.35),
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.9,
              ),
            ),
            if (_images.length > 1) ...[
              SizedBox(height: 2.h),
              Text(
                'Hold and drag to reorder. First photo is cover.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.35),
                  fontSize: 11.5.sp,
                ),
              ),
            ],
          ],
        ),
        if (_images.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              '${_images.length}/10',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return GestureDetector(
      onTap: _pickImages,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        height: 190.h,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_photo_alternate_outlined,
                size: 26.sp,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Select Photos',
              style: TextStyle(
                fontSize: 14.5.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Upload up to 10 photos for your showoff story',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
