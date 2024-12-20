import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample_chat_app/widgets/custom_bottom_sheet_button.dart';

class UploadFilesBottomSheet extends StatelessWidget {
  final Function()? onPdfClick;
  final Function()? onGalleryClick;
  final Function()? onCameraClick;

  const UploadFilesBottomSheet({
    Key? key,
    required this.onPdfClick,
    required this.onGalleryClick,
    required this.onCameraClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double height = Get.height;
    final double width = Get.width;

    return Container(
      height: height * 0.3,
      padding: EdgeInsets.only(
        left: width * 0.05,
        right: width * 0.05,
        top: height * 0.02,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.shade200,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(width * 0.07),
          topRight: Radius.circular(width * 0.07),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: height * 0.006,
            width: width * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(width * 0.03),
              ),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomBottomSheetButton(
                subtitle: 'File',
                icon: const Icon(Icons.file_copy),
                onTap: onPdfClick,
                size: width * 0.1,
                padding: width * 0.06,
                fontSize: width * 0.04,
              ),
              CustomBottomSheetButton(
                onTap: onGalleryClick,
                icon: const Icon(Icons.image),
                subtitle: 'Image',
                size: width * 0.1,
                padding: width * 0.06,
                fontSize: width * 0.04,
              ),
              CustomBottomSheetButton(
                onTap: onCameraClick,
                icon: const Icon(Icons.slow_motion_video_outlined),
                subtitle: 'Video',
                size: width * 0.1,
                padding: width * 0.06,
                fontSize: width * 0.04,
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
