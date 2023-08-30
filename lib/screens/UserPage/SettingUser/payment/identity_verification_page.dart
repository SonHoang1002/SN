import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:social_network_app_mobile/apis/media_api.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/messenger_app_bar/app_bar_title.dart';

class IdentityVerificationPage extends ConsumerStatefulWidget {
  final dynamic data;
  const IdentityVerificationPage({super.key, required this.data});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _IdentityVerificationState();
}

class _IdentityVerificationState
    extends ConsumerState<IdentityVerificationPage> {
  late File image;
  TextEditingController taxController = TextEditingController(text: "");
  TextEditingController companyNameController = TextEditingController(text: "");
  String pathImage = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List mediasId = [];
  bool alreadySend = false;
  Map<String, dynamic> request = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: const Center(
        child: CupertinoActivityIndicator(),
      ),
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const AppBarTitle(title: 'Xác minh trang'),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                ),
                child: SingleChildScrollView(
                    child: Column(children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                              'Giấy phép đăng kí kinh doanh · Bắt buộc*'),
                          TextButton(
                              onPressed: () {
                                openEditor("front");
                              },
                              child: const Text('Thêm')),
                        ],
                      ),
                      Container(
                        height: 200,
                        color: Colors.black,
                        child: Center(
                          child: pathImage != ''
                              ? Image.file(
                                  image,
                                  height: 240.0,
                                  width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/pages/banner.png',
                                  width: 20,
                                  height: 20,
                                ),
                        ),
                      ),
                      const Divider(
                        height: 30,
                        thickness: 1,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Mã số thuế  · Bắt buộc*'),
                        ],
                      ),
                      _buildInput(taxController, "Mã số Thuế"),
                      const Divider(
                        height: 30,
                        thickness: 1,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text('Tên chủ doanh nghiệp  · Bắt buộc*'),
                          ),
                        ],
                      ),
                      _buildInput(
                          companyNameController, "Tên chủ doanh nghiệp"),
                      const Divider(
                        height: 30,
                        thickness: 1,
                      ),
                    ],
                  ),
                  ButtonPrimary(
                    isGrey: companyNameController.text != '' &&
                            taxController.text != '' &&
                            pathImage != ''
                        ? false
                        : true,
                    label: "Gửi phê duyệt",
                    handlePress: () {
                      if (companyNameController.text != '' &&
                          taxController.text != '' &&
                          pathImage != '') {
                        handleSendRequest();
                      }
                      //handleSendRequest();
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ]))),
          )),
    );
  }

  void openEditor(type) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
        pathImage = pickedFile.path;
      });
    }
  }

  handleSendRequest() async {
    context.loaderOverlay.show();
    List<Future> listUpload = [];
    listUpload.add(handleUploadMedia(0, image, 'image'));

    var results = await Future.wait(listUpload);
    if (results.isNotEmpty) {
      mediasId = results.map((e) => e['id']).toList();
    }
    var res = await UserPageApi().sendPageIdentityVerify({
      "tax_code": taxController.text,
      "company": companyNameController.text,
      "business_registration_id": mediasId[0],
      "page_id": widget.data["id"]
    });
    if (mounted) {
      context.loaderOverlay.hide();
    }
    if (res != "null" && res["success"] == true) {
      _buildSnackBar(
          "Bạn đã gửi xác minh thành công, chúng tôi sẽ xem xét và sớm gửi thông báo đến bạn!");
      if (mounted) {
        Navigator.of(context).pop();
      }
    } else {
      _buildSnackBar(res["content"]["error"] ?? "Gửi yêu cầu thất bại");
    }
  }

  handleUploadMedia(index, file, type) async {
    var fileData;
    fileData = file;
    String fileName = fileData!.path.split('/').last;
    FormData formData;
    dynamic response;
    if (type == 'image') {
      formData = FormData.fromMap({
        /* "description": file['description'] ?? '', */
        "position": index + 1,
        "file": await MultipartFile.fromFile(fileData.path, filename: fileName),
      });
      response = await MediaApi().uploadMediaEmso(formData);
    } else {
      var userToken = await SecureStorage().getKeyStorage("token");
      formData = FormData.fromMap({
        "token": userToken,
        "channelId": '2',
        "privacy": '1',
        "name": fileName,
        "mimeType": "video/mp4",
        "position": index + 1,
        "videofile":
            await MultipartFile.fromFile(fileData.path, filename: fileName),
      });
      response = await ApiMediaPetube().uploadMediaPetube(formData);
    }
    return response;
  }

  _buildSnackBar(String title) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(title),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(9)))),
    );
  }

  _buildInput(TextEditingController controller, String hintText) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      height: 50,
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Hãy nhập đầy đủ thông tin';
          }
          return null;
        },
        onChanged: (value) {
          setState(() {});
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10),
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              )),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              )),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 17),
        ),
      ),
    );
  }
}
