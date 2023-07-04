import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/tab_social.dart';

class GalleryDevice extends StatefulWidget {
  const GalleryDevice({super.key});

  @override
  State<GalleryDevice> createState() => _GalleryDeviceState();
}

class _GalleryDeviceState extends State<GalleryDevice>
    with SingleTickerProviderStateMixin {
  String tabSelected = "Tất cả";
  List<AssetEntity>? assets;
  List<AssetEntity>? assetImages;
  List<AssetEntity>? assetVideos;
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
    loadAssets();
    loadAlbums();
    loadAssetsImage();
    loadAssetsVideo();
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

  void loadAssetsImage({albumsSelected}) async {
    List<AssetPathEntity> albums =
        await PhotoManager.getAssetPathList(type: RequestType.image);
    List<AssetEntity> allAssets =
        await (albumsSelected ?? albums[0]).getAssetListRange(
      start: 0,
      end: 10000,
    );
    setState(() {
      assetImages = allAssets;
    });
  }

  void loadAssetsVideo({albumsSelected}) async {
    List<AssetPathEntity> albums =
        await PhotoManager.getAssetPathList(type: RequestType.video);
    List<AssetEntity> allAssets =
        await (albumsSelected ?? albums[0]).getAssetListRange(
      start: 0,
      end: 10000,
    );
    setState(() {
      assetVideos = allAssets;
    });
  }

  void loadAssets({albumsSelected}) async {
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();
    List<AssetEntity> allAssets = await (albumsSelected ?? albums[0])
        .getAssetListRange(start: 0, end: 10000);
    setState(() {
      assets = allAssets;
    });
  }

  Widget buildAssetWidget(AssetEntity asset) {
    if (asset.type == AssetType.image) {
      return GestureDetector(
        onTap: () {},
        child: FutureBuilder<Uint8List?>(
          future: asset.thumbnailDataWithSize(const ThumbnailSize(400, 400)),
          builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
              );
            } else {
              isLoading = false;
              return Container();
            }
          },
        ),
      );
    } else if (asset.type == AssetType.video) {
      return GestureDetector(
        onTap: () {},
        child: FutureBuilder<Uint8List?>(
          future: asset.thumbnailDataWithSize(const ThumbnailSize(400, 400)),
          builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.data != null) {
              return Stack(
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
                    size: 30,
                    color: white,
                  ),
                ],
              );
            } else {
              return Center(child: Container());
            }
          },
        ),
      );
    } else {
      return Container();
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
                            return InkWell(
                              onTap: () {
                                if (albumSelected!.id == album.id) {
                                } else {
                                  setState(() {
                                    albumSelected = album;
                                  });
                                  loadAssets(albumsSelected: album);
                                  loadAssetsImage(albumsSelected: album);
                                  loadAssetsVideo(albumsSelected: album);
                                }
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
                                              child: assets!.isNotEmpty
                                                  ? buildAssetWidget(assets[0])
                                                  : Container(
                                                      width: 60,
                                                      height: 60,
                                                      color: Colors.amber,
                                                    ),
                                            )),
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
                            );
                          }
                          return const SizedBox();
                        });
                  }),
            ),
            body: SizedBox(
              width: size.width,
              child: TabSocial(
                  tabHeader: const [
                    'Tất cả',
                    'Hình ảnh',
                    'Video',
                  ].toList(),
                  childTab: [
                    if (assets == null)
                      ShimmerLoader(size: size)
                    else
                      AssetLoader(
                          assets: assets ?? [], renderWidget: buildAssetWidget),
                    if (assetImages == null)
                      ShimmerLoader(size: size)
                    else
                      AssetLoader(
                          assets: assetImages ?? [],
                          renderWidget: buildAssetWidget),
                    if (assetVideos == null)
                      ShimmerLoader(size: size)
                    else
                      AssetLoader(
                          assets: assetVideos ?? [],
                          renderWidget: buildAssetWidget),
                  ]),
            )));
  }
}

class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color.fromARGB(255, 215, 215, 215),
      highlightColor: const Color.fromARGB(255, 225, 223, 223),
      child: SizedBox(
        height: size.height - 100,
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          shrinkWrap: true,
          children: List.generate(51, (index) {
            return Container(
              width: 100,
              height: 100,
              color: Colors.white,
            );
          }),
        ),
      ),
    );
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
    return GridView.builder(
      padding: const EdgeInsets.only(top: 2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: assets.length,
      itemBuilder: (BuildContext context, int index) {
        final asset = assets[index];
        return renderWidget(asset);
      },
    );
  }
}
