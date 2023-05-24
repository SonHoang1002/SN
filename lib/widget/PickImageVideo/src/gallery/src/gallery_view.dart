import 'dart:async';
import 'dart:io';

import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:mime/mime.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/PickImageVideo/drishya_picker.dart';
import 'package:social_network_app_mobile/widget/PickImageVideo/src/animations/animations.dart';
import 'package:social_network_app_mobile/widget/PickImageVideo/src/camera/src/widgets/ui_handler.dart';
import 'package:social_network_app_mobile/widget/PickImageVideo/src/gallery/src/repo/gallery_repository.dart';
import 'package:social_network_app_mobile/widget/PickImageVideo/src/gallery/src/widgets/albums_page.dart';
import 'package:social_network_app_mobile/widget/PickImageVideo/src/gallery/src/widgets/gallery_asset_selector.dart';
import 'package:social_network_app_mobile/widget/PickImageVideo/src/gallery/src/widgets/gallery_grid_view.dart';
import 'package:social_network_app_mobile/widget/PickImageVideo/src/gallery/src/widgets/gallery_header.dart';
import 'package:social_network_app_mobile/widget/PickImageVideo/src/gallery/src/widgets/send_button.dart';
import 'package:social_network_app_mobile/widget/PickImageVideo/src/gallery/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
///
class GalleryView extends StatefulWidget {
  ///
  const GalleryView(
      {Key? key,
      this.controller,
      this.setting,
      this.isMutipleFile,
      this.handleGetFiles,
      this.filesSelected,
      this.typePage,
      this.type})
      : super(key: key);

  /// Gallery controller
  final GalleryController? controller;

  /// Gallery setting
  final GallerySetting? setting;

  final bool? isMutipleFile;
  final Function? handleGetFiles;
  final List? filesSelected;
  final String? typePage;

  final dynamic type;

  ///
  static const String name = 'GalleryView';

  ///
  /// Pick media
  static Future<List<DrishyaEntity>?> pick(
    BuildContext context, {
    /// Gallery controller
    GalleryController? controller,

    /// Gallery setting
    GallerySetting? setting,

    /// Route setting
    CustomRouteSetting? routeSetting,
  }) {
    return Navigator.of(context).push<List<DrishyaEntity>>(
      SlideTransitionPageRoute(
        builder: GalleryView(controller: controller, setting: setting),
        setting: routeSetting ??
            const CustomRouteSetting(
              settings: RouteSettings(name: name),
            ),
      ),
    );
  }

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  late final GalleryController _controller;
  final videoInfo = FlutterVideoInfo();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? GalleryController();

    _controller.addListener(() {
      if (mounted) {
        final entities = _controller.value.selectedEntities;

        if (widget.isMutipleFile != null && widget.isMutipleFile == true) {
          fetchDataMutipleFile(entities);
        } else {
          widget.handleGetFiles!(entities);
          Navigator.pop(context);
        }
      }
    });
  }

  fetchDataMutipleFile(entities) async {
    if (entities.isEmpty) return;
    List<dynamic> primaryList = [];
    List<dynamic> newList = widget.filesSelected ?? [];
    primaryList.addAll(newList);
    for (var i = 0; i < entities.length; i++) {
      File fileData = await entities[i].file;
      var typeFile =
          lookupMimeType(fileData.path)!.contains('image') ? 'image' : 'video';
      if (['image', 'video'].contains(typeFile)) {
        dynamic decodedImage;
        if (typeFile == 'image') {
          decodedImage = await decodeImageFromList(fileData.readAsBytesSync());
        } else {
          decodedImage = await videoInfo.getVideoInfo(fileData.path);
        }
        primaryList.add({
          'file': fileData,
          "aspect": decodedImage.width / decodedImage.height,
          "type": typeFile,
          "subType": "local"
        });
      }
    }

    if (primaryList.isNotEmpty) {
      widget.handleGetFiles!('update_file', primaryList);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null || _controller.autoDispose) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If [SlidableGallery] is used no need to build panel setting again
    if (!_controller.fullScreenMode) {
      return _View(
        controller: _controller,
        setting: widget.setting!,
        handleGetFiles: widget.handleGetFiles,
      );
    }

    // Full screen mode
    return PanelSettingBuilder(
      setting: widget.setting?.panelSetting,
      builder: (panelSetting) => _View(
          typePage: widget.typePage,
          controller: _controller,
          isMutipleFile: widget.isMutipleFile,
          filesSelected: widget.filesSelected,
          setting: (widget.setting ?? _controller.setting)
              .copyWith(panelSetting: panelSetting),
          handleGetFiles: widget.handleGetFiles),
    );

    //
  }
}

///
class _View extends StatefulWidget {
  ///
  const _View({
    Key? key,
    required this.controller,
    required this.setting,
    this.isMutipleFile,
    this.filesSelected,
    this.typePage,
    this.handleGetFiles,
  }) : super(key: key);

  final GalleryController controller;
  final GallerySetting setting;
  final bool? isMutipleFile;
  final List? filesSelected;
  final String? typePage;
  final Function? handleGetFiles;

  @override
  State<_View> createState() => _ViewState();
}

class _ViewState extends State<_View> with SingleTickerProviderStateMixin {
  late final GalleryController _controller;
  late final PanelController _panelController;

  late final AnimationController _animationController;
  late final Animation<double> _animation;
  late final Albums _albums;

  double albumHeight = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller..init(setting: widget.setting);
    _albums = Albums()..fetchAlbums(_controller.setting.requestType);

    _panelController = _controller.panelController;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      reverseDuration: const Duration(milliseconds: 300),
      value: 0,
    );

    // ignore: prefer_int_literals
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.fastLinearToSlowEaseIn,
        reverseCurve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _albums.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _toogleAlbumList(bool isVisible) {
    if (_animationController.isAnimating) return;
    _controller.setAlbumVisibility(visible: !isVisible);
    _panelController.isGestureEnabled = _animationController.value == 1.0;
    if (_animationController.value == 1.0) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  //
  void _showAlert() {
    final cancel = TextButton(
      onPressed: Navigator.of(context).pop,
      child: const Text(
        'Giữ lại',
        style: TextStyle(color: secondaryColor),
      ),
    );
    final unselectItems = TextButton(
      onPressed: _onSelectionClear,
      child: const Text(
        'Bỏ chọn',
        style: TextStyle(color: primaryColor),
      ),
    );

    final alertDialog = AlertDialog(
      title: const Text(
        'Bỏ chọn file phương tiện?',
        style: TextStyle(fontSize: 15),
      ),
      content: const Text(
        'Bạn muốn hủy bỏ các file đã chọn?',
        style: TextStyle(fontSize: 13),
      ),
      actions: [cancel, unselectItems],
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 2,
      ),
    );

    showDialog<void>(
      context: context,
      builder: (context) => alertDialog,
    );
  }

  Future<bool> _onClosePressed() async {
    if (_animationController.isAnimating) return false;

    if (_controller.albumVisibility.value) {
      _toogleAlbumList(true);
      return false;
    }

    if (_controller.value.selectedEntities.isNotEmpty) {
      _showAlert();
      return false;
    }

    if (_controller.fullScreenMode) {
      UIHandler.of(context).pop();
      return true;
    }

    if (_panelController.isVisible) {
      if (_panelController.value.state == PanelState.max) {
        _panelController.minimizePanel();
      } else {
        _panelController.closePanel();
      }
      return false;
    }

    return true;
  }

  void _onSelectionClear() {
    _controller.clearSelection();
    widget.handleGetFiles!('update_file', []);
    Navigator.of(context).pop();
  }

  void _onAlbumChange(Album album) {
    if (_animationController.isAnimating) return;
    _albums.changeAlbum(album);
    _toogleAlbumList(true);
  }

  @override
  Widget build(BuildContext context) {
    final panelSetting = widget.setting.panelSetting!;
    final actionMode =
        _controller.setting.selectionMode == SelectionMode.actionBased;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: panelSetting.overlayStyle,
      child: WillPopScope(
        onWillPop: _onClosePressed,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            fit: StackFit.expand,
            children: [
              // Header
              Align(
                alignment: Alignment.topCenter,
                child: GalleryHeader(
                  controller: _controller,
                  albums: _albums,
                  onClose: _onClosePressed,
                  onAlbumToggle: _toogleAlbumList,
                ),
              ),
              // Body
              Column(
                children: [
                  // Header space
                  Builder(
                    builder: (context) {
                      // Header space for full screen mode
                      if (_controller.fullScreenMode) {
                        return SizedBox(height: panelSetting.headerMaxHeight);
                      }
                      // Toogling size for header hiding animation
                      return ValueListenableBuilder<PanelValue>(
                        valueListenable: _panelController,
                        builder: (context, value, child) {
                          final height = (panelSetting.headerMaxHeight *
                                  value.factor *
                                  1.2)
                              .clamp(
                            panelSetting.thumbHandlerHeight,
                            panelSetting.headerMaxHeight,
                          );
                          return SizedBox(height: height);
                        },
                      );
                    },
                  ),
                  // Divider
                  Divider(
                    color: Colors.lightBlue.shade300,
                    thickness: 0.5,
                    height: 0.5,
                    indent: 0,
                    endIndent: 0,
                  ),

                  // Gallery grid
                  Flexible(
                    flex: 1,
                    child: GalleryGridView(
                      controller: _controller,
                      albums: _albums,
                      onClosePressed: _onClosePressed,
                    ),
                  ),
                ],
              ),

              // Send and edit button
              if (!actionMode &&
                  widget.isMutipleFile != null &&
                  widget.isMutipleFile == true)
                GalleryAssetSelector(
                  typePage: widget.typePage,
                  controller: _controller,
                  albums: _albums,
                ),

              // Send button
              if (actionMode) SendButton(controller: _controller),

              // Album list
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final offsetY = panelSetting.headerMaxHeight +
                      (panelSetting.maxHeight! - panelSetting.headerMaxHeight) *
                          (1 - _animation.value);
                  return Visibility(
                    visible: _animation.value > 0.0,
                    child: Transform.translate(
                      offset: Offset(0, offsetY),
                      child: child,
                    ),
                  );
                },
                child: AlbumsPage(
                  albums: _albums,
                  controller: _controller,
                  onAlbumChange: _onAlbumChange,
                ),
              ),

              //
            ],
          ),
        ),
      ),
    );

    //
  }
}
