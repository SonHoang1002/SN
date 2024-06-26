import 'dart:typed_data';

import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/PickImageVideo/drishya_picker.dart';
import 'package:social_network_app_mobile/widgets/PickImageVideo/src/gallery/src/repo/gallery_repository.dart';
import 'package:social_network_app_mobile/widgets/PickImageVideo/src/gallery/src/widgets/album_builder.dart';
import 'package:social_network_app_mobile/widgets/PickImageVideo/src/gallery/src/widgets/gallery_builder.dart';
import 'package:social_network_app_mobile/widgets/PickImageVideo/src/gallery/src/widgets/gallery_permission_view.dart';
import 'package:social_network_app_mobile/widgets/PickImageVideo/src/gallery/src/widgets/lazy_load_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
class GalleryGridView extends StatelessWidget {
  ///
  const GalleryGridView({
    Key? key,
    required this.controller,
    required this.albums,
    required this.onClosePressed,
  }) : super(key: key);

  ///
  final GalleryController controller;

  ///
  final Albums albums;

  ///
  final VoidCallback? onClosePressed;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: CurrentAlbumBuilder(
        albums: albums,
        builder: (context, album, child) {
          return ValueListenableBuilder<AlbumValue>(
            valueListenable: album,
            builder: (context, value, child) {
              // Error
              if (value.state == BaseState.unauthorised &&
                  value.entities.isEmpty) {
                return GalleryPermissionView(
                  onRefresh: () {
                    if (value.assetPathEntity == null) {
                      albums.fetchAlbums(controller.setting.requestType);
                    } else {
                      album.fetchAssets();
                    }
                  },
                );
              }

              // No data
              if (value.state == BaseState.completed &&
                  value.entities.isEmpty) {
                return const Center(
                  child: Text(
                    'Không có file phương tiện nào',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }

              if (value.state == BaseState.error) {
                return const Center(
                  child: Text(
                    'Cõ lỗi xảy ra, vui lòng thử lại sau!',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              }

              final entities = value.entities;
              final enableCamera = controller.setting.enableCamera;

              final itemCount = albums.value.state == BaseState.fetching
                  ? 20
                  : enableCamera
                      ? entities.length + 1
                      : entities.length;

              return LazyLoadScrollView(
                onEndOfPage: album.fetchAssets,
                scrollOffset: MediaQuery.sizeOf(context).height * 0.4,
                child: GridView.builder(
                  controller: controller.panelController.scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: controller.setting.crossAxisCount ?? 3,
                    crossAxisSpacing: 1.5,
                    mainAxisSpacing: 1.5,
                  ),
                  itemCount: itemCount,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    if (enableCamera && index == 0) {
                      return InkWell(
                        onTap: () {
                          controller.openCamera(context).then((value) {
                            if (value != null) {
                              album.insert(value);
                            }
                          });
                        },
                        child: Container(
                          color: Colors.black,
                          child: const Icon(
                            CupertinoIcons.camera,
                            color: greyColor,
                            size: 26,
                          ),
                        ),
                      );
                    }

                    final ind = enableCamera ? index - 1 : index;

                    final entity = albums.value.state == BaseState.fetching
                        ? null
                        : entities[ind];

                    if (entity == null) return const SizedBox();

                    return _MediaTile(controller: controller, entity: entity);
                  },
                ),
              );
            },
          );

          //
        },
      ),
    );
  }
}

///
class _MediaTile extends StatelessWidget {
  ///
  const _MediaTile({
    Key? key,
    required this.entity,
    required this.controller,
  }) : super(key: key);

  ///
  final GalleryController controller;

  ///
  final AssetEntity entity;

  @override
  Widget build(BuildContext context) {
    Uint8List? bytes;

    final drishya = entity.toDrishya;

    return ColoredBox(
      color: Colors.grey.shade800,
      child: InkWell(
        onTap: () {
          final entity = drishya.copyWith(pickedThumbData: bytes);
          controller.select(context, entity);
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            EntityThumbnail(
              entity: drishya,
              onBytesGenerated: (b) {
                bytes = b;
              },
            ),
            _SelectionCount(controller: controller, entity: entity),
          ],
        ),
      ),
    );
  }
}

class _SelectionCount extends StatelessWidget {
  const _SelectionCount({
    Key? key,
    required this.controller,
    required this.entity,
  }) : super(key: key);

  final GalleryController controller;
  final AssetEntity entity;

  @override
  Widget build(BuildContext context) {
    return GalleryBuilder(
      controller: controller,
      builder: (value, child) {
        final actionBased =
            controller.setting.selectionMode == SelectionMode.actionBased;

        final singleSelection = actionBased
            ? !value.enableMultiSelection
            : controller.singleSelection;

        final isSelected = value.selectedEntities.contains(entity);
        final index = value.selectedEntities.indexOf(entity.toDrishya);

        Widget counter = const SizedBox();

        if (isSelected) {
          counter = CircleAvatar(
            backgroundColor: primaryColor,
            radius: 14,
            child: Text(
              '${index + 1}',
              style: const TextStyle(color: white),
            ),
          );
        }

        if (actionBased && !singleSelection) {
          counter = Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: isSelected ? counter : const SizedBox(),
          );
        }

        return Container(
          color: isSelected ? Colors.white38 : transparent,
          padding: const EdgeInsets.all(6),
          child: Align(
            alignment: actionBased ? Alignment.topRight : Alignment.center,
            child: counter,
          ),
        );
      },
    );
  }
}
