import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
// import 'package:social_network_app_mobile/widgets/tab_social.dart';

class GalleryDevice extends StatefulWidget {
  final Function? handleAction;
  final Function? handleClose;
  const GalleryDevice({super.key, this.handleAction, this.handleClose});

  @override
  State<GalleryDevice> createState() => _GalleryDeviceState();
}

class _GalleryDeviceState extends State<GalleryDevice>
    with SingleTickerProviderStateMixin {
  String tabSelected = "Tất cả";
  List<AssetEntity>? assets;
  // List<AssetEntity>? assetImages;
  // List<AssetEntity>? assetVideos;
  List<AssetPathEntity> albums = [];
  AssetPathEntity? albumSelected;

  int? selected = 1;
  bool isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final GlobalKey<ScaffoldState> _drawerScaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation =
        Tween<double>(begin: 0, end: 180).animate(_animationController);
    loadAlbums();
    loadAssets();
    // loadAssetsImage();
    // loadAssetsVideo();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleRotation() {
    if (_drawerScaffoldKey.currentState!.isEndDrawerOpen) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  void loadAlbums() async {
    List<AssetPathEntity> albumsData = await PhotoManager.getAssetPathList();
    setState(() {
      albums = albumsData;
    });
  }

  // void loadAssetsImage({AssetPathEntity? albumParam}) async {
  //   List<AssetPathEntity> albums =
  //       await PhotoManager.getAssetPathList(type: RequestType.image);
  //   AssetPathEntity? albumFilter;
  //   if (albumParam != null) {
  //     albumFilter = albums.firstWhere((element) => element.id == albumParam.id);
  //   }
  //   List<AssetEntity> allAssets =
  //       await (albumFilter ?? albums[0]).getAssetListRange(
  //     start: 0,
  //     end: 10000,
  //   );

  //   setState(() {
  //     assetImages = allAssets;
  //   });
  // }

  // void loadAssetsVideo({albumParam}) async {
  //   List<AssetPathEntity> albums =
  //       await PhotoManager.getAssetPathList(type: RequestType.video);
  //   AssetPathEntity? albumFilter;
  //   if (albumParam != null) {
  //     albumFilter = albums.firstWhere((element) => element.id == albumParam.id);
  //   }
  //   List<AssetEntity> allAssets =
  //       await (albumFilter ?? albums[0]).getAssetListRange(
  //     start: 0,
  //     end: 10000,
  //   );

  //   setState(() {
  //     assetVideos = allAssets;
  //   });
  // }

  void loadAssets({albumParam}) async {
    List<AssetEntity> allAssets;
    if (albumParam != null) {
      allAssets = await albumParam.getAssetListRange(start: 0, end: 10000);
    } else {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(type: RequestType.video);
      allAssets = await albums[0].getAssetListRange(start: 0, end: 10000);
    }
    setState(() {
      assets = allAssets;
    });
  }

  Widget buildAssetWidget(AssetEntity asset) {
    if (asset.type == AssetType.image) {
      return FutureBuilder<Uint8List?>(
        future: asset.thumbnailDataWithSize(const ThumbnailSize(400, 400)),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return GestureDetector(
              onTap: () {
                // widget.handleAction!(snapshot.data!);
              },
              child: Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
              ),
            );
          } else {
            isLoading = false;
            return Container();
          }
        },
      );
    } else if (asset.type == AssetType.video) {
      return FutureBuilder<Uint8List?>(
        future: asset.thumbnailDataWithSize(const ThumbnailSize(400, 400)),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return GestureDetector(
                onTap: () async {
                  String? filePath = await asset.getMediaUrl();
                  File? file = await asset.loadFile();

                  widget.handleAction!({'file': file, 'filePath': filePath});
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: Image.memory(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Icon(
                      Icons.play_circle,
                      size: 45,
                      color: white,
                    ),
                  ],
                ));
          } else {
            return Center(child: Container());
          }
        },
      );
    } else {
      return Container();
    }
  }

  Widget noData(BuildContext context) => Center(
        child: Text('Không có file phương tiện nào',
            style: TextStyle(
                color: Theme.of(context).textTheme.displayLarge!.color,
                fontSize: 15)),
      );

  Widget renderTabBarView(size, List<AssetEntity>? listAssets) {
    if (listAssets == null) {
      return noData(context);
    } else {
      return AssetLoader(assets: listAssets, renderWidget: buildAssetWidget);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackIconAppbar(),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                    onTap: () {
                      _toggleRotation();
                      if (_drawerScaffoldKey.currentState!.isEndDrawerOpen) {
                        _drawerScaffoldKey.currentState!.closeEndDrawer();
                      } else {
                        _drawerScaffoldKey.currentState!.openEndDrawer();
                      }
                    },
                    child: Row(
                      children: [
                        AppBarTitle(
                            title: albumSelected != null
                                ? albumSelected!.name
                                : 'Gần đây'),
                        const SizedBox(
                          width: 5,
                        ),
                        AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Transform.rotate(
                                  angle:
                                      _animation.value * (3.1415926535 / 180),
                                  child: Icon(FontAwesomeIcons.chevronDown,
                                      size: 15,
                                      color: Theme.of(context)
                                          .textTheme
                                          .displayLarge!
                                          .color));
                            }),
                      ],
                    )),
              ),
              Container()
            ],
          ),
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: Colors.grey.withOpacity(0.1),
                height: 1.0,
              )),
        ),
        body: Scaffold(
            endDrawerEnableOpenDragGesture: false,
            key: _drawerScaffoldKey,
            endDrawer: Container(
              width: double.infinity,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ListView.builder(
                  itemCount: albums.length,
                  itemBuilder: (context, index) {
                    AssetPathEntity album = albums[index];
                    return FutureBuilder(
                        future: album.getAssetListPaged(page: 0, size: 1),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<AssetEntity>? assets = snapshot.data;
                            return assets!.isNotEmpty
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        assets = null;
                                        albumSelected = album;
                                      });
                                      loadAssets(albumParam: album);
                                      // loadAssetsImage(albumParam: album);
                                      // loadAssetsVideo(albumParam: album);

                                      _toggleRotation();
                                      _drawerScaffoldKey.currentState!
                                          .closeEndDrawer();
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(8.0),
                                        margin: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            IgnorePointer(
                                              child: SizedBox(
                                                width: 60,
                                                height: 60,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: assets.isNotEmpty
                                                      ? buildAssetWidget(
                                                          assets[0])
                                                      : null,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              album.name,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge!
                                                      .color),
                                            )
                                          ],
                                        )),
                                  )
                                : const SizedBox();
                          }
                          return noData(context);
                        });
                  }),
            ),
            body: SizedBox(
              width: size.width,
              child:
                  // TabSocial(
                  //     tabHeader: const [
                  //       'Tất cả',
                  //       'Hình ảnh',
                  //       'Video',
                  //     ].toList(),
                  //     childTab: [
                  renderTabBarView(size, assets),
              //   renderTabBarView(size, assetImages),
              //   renderTabBarView(size, assetVideos),
              // ]),
            )));
  }
}

class AssetLoader extends StatelessWidget {
  final List<AssetEntity?> assets;
  final Function renderWidget;
  const AssetLoader(
      {Key? key, required this.assets, required this.renderWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return assets.isNotEmpty
        ? GridView.builder(
            padding: const EdgeInsets.only(top: 2),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 0.73),
            itemCount: assets.length,
            itemBuilder: (BuildContext context, int index) {
              final asset = assets[index];
              return renderWidget(asset);
            },
          )
        : Center(
            child: Text('Không có file phương tiện nào',
                style: TextStyle(
                    color: Theme.of(context).textTheme.displayLarge!.color,
                    fontSize: 15)),
          );
  }
}
