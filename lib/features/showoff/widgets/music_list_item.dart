import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/music_service.dart';

class MusicListItem extends StatelessWidget {
  final MusicModel music;
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onPlayToggle;
  final VoidCallback onSelect;

  const MusicListItem({
    super.key,
    required this.music,
    required this.isPlaying,
    this.isLoading = false,
    required this.onPlayToggle,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onSelect();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        child: Row(
          children: [
            // Album Art / Fallback
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: SizedBox(
                width: 44.w,
                height: 44.w,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    music.coverImage != null
                        ? Image.network(
                            music.coverImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => _fallbackCover(),
                          )
                        : _fallbackCover(),
                    if (isPlaying)
                      Container(
                        color: Colors.black.withValues(alpha: 0.45),
                        child: Icon(
                          Icons.equalizer_rounded,
                          color: const Color(0xFF60A5FA),
                          size: 20.sp,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // Title & Artist
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    music.title,
                    style: TextStyle(
                      color: isPlaying
                          ? const Color(0xFF60A5FA)
                          : Colors.white.withValues(alpha: 0.95),
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    music.artist,
                    style: TextStyle(
                      color: const Color(0xFF94A3B8),
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),

            // Play / Pause Preview Button
            IconButton(
              icon: isLoading
                  ? SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                      ),
                    )
                  : Icon(
                      isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_outline_rounded,
                      color: isPlaying
                          ? const Color(0xFF60A5FA)
                          : Colors.white.withValues(alpha: 0.65),
                      size: 24.sp,
                    ),
              splashRadius: 20.r,
              onPressed: () {
                HapticFeedback.selectionClick();
                onPlayToggle();
              },
            ),
            SizedBox(width: 4.w),

            // Clean, non-glowing Add Button
            InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                onSelect();
              },
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallbackCover() {
    return Container(
      color: Colors.white.withValues(alpha: 0.06),
      child: Icon(
        Icons.music_note_rounded,
        color: Colors.white.withValues(alpha: 0.4),
        size: 20.sp,
      ),
    );
  }
}
