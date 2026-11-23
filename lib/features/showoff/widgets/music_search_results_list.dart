import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/music_service.dart';
import 'music_list_item.dart';

class MusicSearchResultsList extends StatelessWidget {
  final List<MusicModel> results;
  final bool isLoading;
  final bool isLoadingMore;
  final ScrollController scrollController;
  final String? currentUrl;
  final bool isPlaying;
  final bool isBuffering;
  final Function(String) onPlayToggle;
  final Function(MusicModel) onSelect;

  const MusicSearchResultsList({
    super.key,
    required this.results,
    required this.isLoading,
    this.isLoadingMore = false,
    required this.scrollController,
    required this.currentUrl,
    required this.isPlaying,
    required this.isBuffering,
    required this.onPlayToggle,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          width: 24.w,
          height: 24.w,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
          ),
        ),
      );
    }

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.music_off_outlined,
              size: 38.sp,
              color: Colors.white.withValues(alpha: 0.25),
            ),
            SizedBox(height: 10.h),
            Text(
              'No soundtracks found',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Try searching with a different song or artist name',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.35),
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 4.h),
      itemCount: results.length + (isLoadingMore ? 1 : 0),
      separatorBuilder: (context, index) => Divider(
        color: Colors.white.withValues(alpha: 0.04),
        height: 1,
        indent: 74.w,
        endIndent: 18.w,
      ),
      itemBuilder: (context, i) {
        if (i == results.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                ),
              ),
            ),
          );
        }
        final m = results[i];
        final isCurrent = currentUrl == m.previewUrl;
        return MusicListItem(
          music: m,
          isPlaying: isCurrent && isPlaying,
          isLoading: isCurrent && isBuffering,
          onPlayToggle: () => onPlayToggle(m.previewUrl),
          onSelect: () => onSelect(m),
        );
      },
    );
  }
}
