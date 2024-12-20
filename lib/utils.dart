import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample_chat_app/widgets/custom_bottom_sheet_button.dart';

class Utils {
  static void uploadFilesBottomSheet({
    required Function()? onPdfClick,
    required Function()? onGalleryClick,
    required Function()? onCameraClick,
  }) {
    final double height = Get.height;
    final double width = Get.width;

    Get.bottomSheet(Container(
      height: height * 0.3,
      padding: EdgeInsets.only(
        left: width * 0.05,
        right: width * 0.05,
        top: height * 0.02,
      ),
      decoration: BoxDecoration(
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
              Obx(() {
                return CustomBottomSheetButton(
                  subtitle: 'File',
                  icon: const Icon(Icons.file_copy),
                  onTap: onPdfClick,
                  size: width * 0.1,
                  padding: width * 0.06,
                  fontSize: width * 0.04,
                );
              }),
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
    ));
  }

  static String generateChatId({required String uid1, required String uid2}) {
    List uids = [uid1, uid2];
    uids.sort();
    String chatID = uids.fold("", (id, uid) => '$id$uid');
    return chatID;
  }
}
