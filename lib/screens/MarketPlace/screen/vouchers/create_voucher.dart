import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_place/apis/market_place_apis/products_api.dart';
import 'package:market_place/apis/market_place_apis/voucher_api.dart';
import 'package:market_place/helpers.dart';
import 'package:market_place/helpers/routes.dart';
import 'package:market_place/theme/colors.dart';
import 'package:market_place/widgets/GeneralWidget/show_bottom_sheet_widget.dart';
import 'package:market_place/widgets/GeneralWidget/text_content_widget.dart';
import 'package:market_place/widgets/back_icon_appbar.dart';
import 'package:market_place/widgets/messenger_app_bar/app_bar_title.dart';

String truncateText(String text, int length) {
  if (text.length > length) {
    return '${text.substring(0, length)}...';
  } else {
    return text;
  }
}

class CreateVoucherPage extends StatefulWidget {
  final String type;
  final String pageId;
  final dynamic objectItem;
  const CreateVoucherPage(
      {super.key, required this.type, required this.pageId, this.objectItem});

  @override
  State<CreateVoucherPage> createState() => _CreateVoucherPageState();
}

class _CreateVoucherPageState extends State<CreateVoucherPage> {
  TextEditingController nameProjectController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController minAmountOrderController = TextEditingController();
  TextEditingController amountDiscountController = TextEditingController();
  TextEditingController numberVoucherController = TextEditingController();
  TextEditingController numberVoucherPerPersonController =
      TextEditingController(text: "1");

  String selectedValueVoucher = '';
  String selectedTypeDiscount = '';
  int selectedTypeDisplay = 1;
  int selectedTypeVoucher = 1;
  List<String> dropdownItems = [
    'Voucher toàn Shop',
    'Voucher sản phẩm',
  ];
  List _products = [];
  List chosenProduct = [];

  DateTime selectedStartDate = DateTime.now().add(const Duration(days: 1));
  DateTime selectedEndDate = DateTime.now().add(const Duration(days: 30));
  DateTime? selectedSaveVoucherDate;
  String errorValidate = "";
  bool? isSaveVoucherBefore;
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  void updateChoosenProduct(List updatedList) {
    setState(() {
      chosenProduct = updatedList;
    });
  }

  void showSnackBar(Color? color, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          title,
          style: TextStyle(color: color ?? Colors.red),
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'X',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void validateForm() {
    if (_products.isEmpty) {
      errorValidate =
          "Cửa hàng của bạn chưa có sản phẩm nào. Vui lòng cập nhật trước khi tạo mã giảm giá.";
    } else {
      if (codeController.text.isEmpty) {
        errorValidate = "Mã Voucher không được để trống";
      } else if (selectedStartDate.isBefore(DateTime.now())) {
        errorValidate =
            "Vui lòng chọn ngày bắt đầu muộn hơn thời gian hiện tại";
      } else if (selectedEndDate.isBefore(selectedStartDate)) {
        errorValidate =
            "Vui lòng chọn ngày kết thúc muộn hơn thời gian bắt đầu";
      } else if (selectedTypeDiscount == "") {
        errorValidate = "Loại giảm giá không được để trống";
      } else if (amountDiscountController.text.isEmpty) {
        errorValidate = "Mức giảm giá không được để trống";
      } else if (selectedTypeDiscount == "Theo số tiền" &&
          int.parse(amountDiscountController.text) <= 0) {
        errorValidate = 'Mức giảm phải lớn hơn 0';
      } else if (selectedTypeDiscount == "Theo phần trăm" &&
          (int.parse(amountDiscountController.text) <= 0 ||
              int.parse(amountDiscountController.text) > 69)) {
        errorValidate =
            'Mức giảm phải lớn hơn 1 và nhỏ hơn 69% giá trị đơn hàng tối thiểu';
      } else if (minAmountOrderController.text.isEmpty) {
        errorValidate = 'Đơn tối thiểu không được để trống';
      } else if (int.parse(minAmountOrderController.text) <= 0) {
        errorValidate = 'Đơn tối thiểu phải lớn hơn 0';
      } else if (selectedTypeDiscount == "Theo số tiền" &&
          int.parse(amountDiscountController.text) >
              int.parse(minAmountOrderController.text) * 0.69) {
        errorValidate = 'Mức giảm phải nhỏ hơn 69% giá trị đơn hàng tối thiểu';
      } else if (numberVoucherController.text.isEmpty) {
        errorValidate = 'Số lượng Voucher không được để trống';
      } else if (int.parse(numberVoucherController.text) <= 0) {
        errorValidate = 'Số lượng Voucher phải lớn hơn 0';
      } else if (numberVoucherPerPersonController.text.isEmpty) {
        errorValidate = 'Lượt sử dụng tối đa không được để trống';
      } else if (int.parse(numberVoucherPerPersonController.text) <= 0) {
        errorValidate = 'Số lượt sử dụng phải lớn hơn 0';
      } else if (int.parse(numberVoucherPerPersonController.text) >
          int.parse(numberVoucherController.text)) {
        errorValidate = 'Số lượt sử dụng không thể lớn hơn số lượng voucher';
      } else if (isSaveVoucherBefore == true &&
          selectedSaveVoucherDate == null) {
        errorValidate = 'Vui lòng chọn ngày lưu mã trước thời gian sử dụng';
      } else if (selectedSaveVoucherDate != null &&
          selectedSaveVoucherDate!.isAfter(selectedStartDate)) {
        errorValidate =
            'Vui lòng chọn ngày lưu mã trước thời gian sử dụng sớm hơn ngày bắt đầu';
      } else {
        errorValidate = "";
      }
    }
  }

  void initDataUpdateVoucher() {
    if (widget.objectItem != null) {
      nameProjectController =
          TextEditingController(text: widget.objectItem["title"]);
      codeController = TextEditingController(text: widget.objectItem["code"]);
      minAmountOrderController = TextEditingController(
          text: widget.objectItem["minimum_basket_price"].toString());
      amountDiscountController =
          TextEditingController(text: widget.objectItem["amount"].toString());
      numberVoucherController = TextEditingController(
          text: widget.objectItem["usage_quantity"].toString());
      numberVoucherPerPersonController = TextEditingController(
          text: widget.objectItem["max_distribution_per_buyer"].toString());
      selectedTypeDiscount =
          widget.objectItem["discount_type"] == "by_percentage"
              ? "Theo phần trăm"
              : "Theo số tiền";
      selectedTypeDisplay =
          widget.objectItem["display_setting"] == "display_on_all_pages"
              ? 1
              : 2;
      selectedTypeVoucher =
          widget.objectItem["reward_type"] == "discount" ? 1 : 2;
      selectedStartDate = DateTime.parse(widget.objectItem["start_time"]);
      selectedEndDate = DateTime.parse(widget.objectItem["end_time"]);
      isSaveVoucherBefore = widget.objectItem["display_voucher_early"];
      selectedSaveVoucherDate = widget.objectItem["start_save_time"] != null
          ? DateTime.parse(widget.objectItem["start_save_time"])
          : null;
    }
  }

  getProducts() async {
    _products =
        await ProductsApi().getShopProducts(widget.pageId, {"limit": 1});
  }

  DataTable _buildOneDataTable(List _products) {
    List<DataColumn> dataColumns = [];
    List<DataRow> dataRows = [];
    dataColumns.add(
      const DataColumn(
          label: Text('Thao tác',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );
    dataColumns.add(
      const DataColumn(
          label: Text('Sản phẩm',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );
    dataColumns.add(
      const DataColumn(
          label: Text('Giá',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );
    dataColumns.add(
      const DataColumn(
          label: Text('Tồn kho',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );
    for (int i = 0; i < _products.length; i++) {
      dataRows.add(DataRow(cells: [
        DataCell(IconButton(
            onPressed: () {
              setState(() {
                chosenProduct.removeAt(i);
              });
            },
            icon: const Icon(FontAwesomeIcons.trash))),
        DataCell(Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(_products[i]
                                  ["product_image_attachments"][0]["attachment"]
                              ?["url"] ??
                          _products[i]["product_variants"][0]?["image"]
                              ?["url"] ??
                          "https://thumbs.dreamstime.com/b/product-icon-collection-trendy-modern-flat-linear-vector-white-background-thin-line-outline-illustration-130947207.jpg"))),
            ),
            const SizedBox(
              width: 10,
            ),
            buildTextContent(
                truncateText(_products[i]["product_variants"][0]["title"], 15),
                false,
                isCenterLeft: false,
                fontSize: 17),
          ],
        )),
        DataCell(
          buildTextContent(
              "${_products[i]["product_variants"][0]["price"].toStringAsFixed(0)} đ",
              false,
              isCenterLeft: false,
              fontSize: 17),
        ),
        DataCell(
          buildTextContent(
              _products[i]["product_variants"][0]["inventory_quantity"]
                  .toString(),
              false,
              isCenterLeft: false,
              fontSize: 17),
        ),
      ]));
    }

    return DataTable(
      columns: dataColumns,
      rows: dataRows,
      showBottomBorder: true,
      // dataRowHeight: 60,
      dividerThickness: .4,
    );
  }

  @override
  void initState() {
    selectedValueVoucher =
        widget.type == 'shop' ? 'Voucher toàn Shop' : 'Voucher sản phẩm';
    initDataUpdateVoucher();
    getProducts();
    super.initState();
  }

  @override
  void dispose() {
    nameProjectController.dispose();
    codeController.dispose();
    minAmountOrderController.dispose();
    numberVoucherController.dispose();
    numberVoucherPerPersonController.dispose();
    amountDiscountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    Color colorTheme = ThemeMode.dark == true
        ? Theme.of(context).cardColor
        : const Color(0xfff1f2f5);
    Color colorWord = ThemeMode.dark == true
        ? white
        : true == ThemeMode.light
            ? blackColor
            : greyColor;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            const AppBarTitle(title: "Chi tiết voucher"),
            GestureDetector(
              onTap: () {},
              child: const Icon(
                FontAwesomeIcons.bell,
                size: 18,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildTextContent("Loại mã", true),
                  DropdownButton<String>(
                    value: selectedValueVoucher,
                    onChanged: (newValue) {
                      setState(() {
                        selectedValueVoucher = newValue!;
                      });
                    },
                    items: dropdownItems.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                  )
                ],
              ),
              const Divider(
                height: 30,
                thickness: 8,
              ),
              Column(
                children: [
                  buildTextContent("Tên chương trình", true),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameProjectController,
                    maxLength: 40,
                    decoration: const InputDecoration(
                      hintText: 'Người mua sẽ không nhìn thấy tên chương trình',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTextContent("Mã giảm giá", true),
                      SizedBox(
                        width: 200,
                        child: TextField(
                          readOnly: widget.objectItem != null ? true : false,
                          controller: codeController,
                          onChanged: (text) {
                            setState(() {
                              codeController.text = text.toUpperCase();
                              codeController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: codeController.text.length),
                              );
                            });
                          },
                          maxLength: 5,
                          decoration: const InputDecoration(
                            hintText: 'Tối đa 5 kí tự',
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTextContent("Ngày bắt đầu", true),
                      GestureDetector(
                        onTap: () {
                          _showDialog(
                            CupertinoDatePicker(
                              initialDateTime: selectedStartDate,
                              mode: CupertinoDatePickerMode.date,
                              minimumYear: 2000,
                              maximumYear: 2101,
                              onDateTimeChanged: (DateTime newDate) {
                                setState(() => selectedStartDate = newDate);
                              },
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            buildTextContent(
                                '${selectedStartDate.day}/${selectedStartDate.month}/${selectedStartDate.year}',
                                false),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.arrow_forward_ios,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTextContent("Ngày kết thúc", true),
                      GestureDetector(
                        onTap: () {
                          _showDialog(
                            CupertinoDatePicker(
                              initialDateTime: selectedEndDate,
                              mode: CupertinoDatePickerMode.date,
                              minimumYear: 2000,
                              maximumYear: 2101,
                              onDateTimeChanged: (DateTime newDate) {
                                setState(() => selectedEndDate = newDate);
                              },
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            buildTextContent(
                                '${selectedEndDate.day}/${selectedEndDate.month}/${selectedEndDate.year}',
                                false),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.arrow_forward_ios,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      buildTextContent(
                          "Cho phép lưu mã trước Thời gian sử dụng", false,
                          fontSize: 16),
                      Checkbox(
                        value: isSaveVoucherBefore ?? false,
                        onChanged: (value) => setState(() {
                          isSaveVoucherBefore = value;
                        }),
                      )
                    ],
                  ),
                  if (isSaveVoucherBefore == true)
                    GestureDetector(
                      onTap: () {
                        _showDialog(
                          CupertinoDatePicker(
                            mode: CupertinoDatePickerMode.date,
                            minimumYear: 2000,
                            maximumYear: 2101,
                            onDateTimeChanged: (DateTime newDate) {
                              setState(() => selectedSaveVoucherDate = newDate);
                            },
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(FontAwesomeIcons.calendar),
                          const SizedBox(
                            width: 20,
                          ),
                          buildTextContent(
                            selectedSaveVoucherDate == null
                                ? 'dd/MM/yyyy'
                                : '${selectedSaveVoucherDate!.day}/${selectedSaveVoucherDate!.month}/${selectedSaveVoucherDate!.year}',
                            false,
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.arrow_forward_ios,
                          ),
                        ],
                      ),
                    ),
                  const Divider(
                    height: 30,
                    thickness: 8,
                  ),
                ],
              ),
              Column(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      buildTextContent("Loại Voucher", true),
                      RadioListTile<int>(
                        title: const Text('Khuyến mãi'),
                        value: 1,
                        groupValue: selectedTypeVoucher,
                        onChanged: (value) {
                          setState(() {
                            selectedTypeVoucher = value!;
                          });
                        },
                      ),
                      RadioListTile<int>(
                        title: const Text('Hoàn xu'),
                        value: 2,
                        groupValue: selectedTypeVoucher,
                        onChanged: (value) {
                          setState(() {
                            selectedTypeVoucher = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTextContent("Loại giảm giá", true),
                      DropdownButton<String>(
                        value: selectedTypeDiscount == ""
                            ? null
                            : selectedTypeDiscount,
                        hint: const Text(
                            'Chọn loại giảm giá'), // Custom hint text
                        onChanged: (newValue) {
                          setState(() {
                            selectedTypeDiscount = newValue!;
                          });
                        },
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem<String>(
                            value: 'Theo số tiền',
                            child: Text('Theo số tiền'),
                          ),
                          DropdownMenuItem<String>(
                            value: 'Theo phần trăm',
                            child: Text('Theo phần trăm'),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTextContent("Mức giảm", true),
                      SizedBox(
                        width: size.width * 0.6,
                        child: TextField(
                          controller: amountDiscountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: selectedTypeDiscount == "Theo phần trăm"
                                ? "Nhập giá trị lớn hơn 1%"
                                : selectedTypeDiscount == "Theo số tiền"
                                    ? 'đ\u0332 Nhập vào'
                                    : '',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTextContent("Đơn tối thiểu", true),
                      SizedBox(
                        width: size.width * 0.6,
                        child: TextField(
                          controller: minAmountOrderController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText:
                                'đ\u0332 Chọn giá trị tối thiểu của đơn hàng',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildTextContent("Số mã có thể sử dụng", true),
                      SizedBox(
                        width: size.width * 0.45,
                        child: TextField(
                          controller: numberVoucherController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Tổng số Voucher có thể dùng',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      buildTextContent("Lượt sử dụng tối đa/Người mua", true),
                      TextField(
                        controller: numberVoucherPerPersonController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText:
                              'Số lượt sử dụng mã tối đa của một người mua',
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const Divider(
                height: 30,
                thickness: 8,
              ),
              buildTextContent("Thiết lập hiển thị mã giảm giá", true),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<int>(
                    title: const Text('Hiển thị nhiều nơi'),
                    value: 1,
                    groupValue: selectedTypeDisplay,
                    onChanged: (value) {
                      setState(() {
                        selectedTypeDisplay = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    title: const Text('Chia sẻ thông qua mã Voucher'),
                    value: 2,
                    groupValue: selectedTypeDisplay,
                    onChanged: (value) {
                      setState(() {
                        selectedTypeDisplay = value!;
                      });
                    },
                  ),
                ],
              ),
              if (widget.type == "products")
                Column(
                  children: [
                    buildTextContent("Sản phẩm được áp dụng", true),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildTextContent("Sản phẩm đã được chọn", false,
                            fontSize: 12),
                        TextButton(
                            onPressed: () {
                              showCustomBottomSheet(context, size.height - 50,
                                  title: "Chọn sản phẩm",
                                  paddingHorizontal: 0,
                                  enableDrag: false,
                                  isDismissible: false, prefixFunction: () {
                                popToPreviousScreen(context);
                              },
                                  widget: ChoseProduct(
                                    pageId: widget.pageId,
                                    updateChosenProduct: updateChoosenProduct,
                                  ));
                            },
                            child: Container(
                              width: size.width * 0.4,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blueAccent,
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Thêm sản phẩm",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )
                                ],
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              if (chosenProduct.isNotEmpty)
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: _buildOneDataTable(chosenProduct))),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Chi tiết Voucher'),
                              content: const Text('Bạn có chắc muốn hủy'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    // Perform quit action here
                                    Navigator.of(context)
                                      ..pop()
                                      ..pop(); // Close the dialog
                                  },
                                  child: const Text('Hủy'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context); // Close the dialog
                                  },
                                  child: const Text('Không'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        width: size.width * 0.4,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey,
                        ),
                        child: const Text(
                          "Hủy",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      )),
                  TextButton(
                      onPressed: () async {
                        validateForm();
                        if (errorValidate != "") {
                          showSnackBar(null, errorValidate);
                        } else {
                          if (widget.objectItem == null) {
                            //create voucher
                            final response = await VoucerApis().createVoucher(
                                title: nameProjectController.text,
                                code: codeController.text,
                                start_time:
                                    '${selectedStartDate.day}-${selectedStartDate.month}-${selectedStartDate.year}',
                                end_time:
                                    '${selectedEndDate.day}-${selectedEndDate.month}-${selectedEndDate.year}',
                                display_voucher_early:
                                    isSaveVoucherBefore ?? false,
                                start_save_time: isSaveVoucherBefore == true
                                    ? selectedSaveVoucherDate!.toIso8601String()
                                    : null,
                                voucher_type:
                                    selectedValueVoucher == "Voucher toàn Shop"
                                        ? "shop_voucher"
                                        : "product_voucher",
                                reward_type: selectedTypeVoucher == 1
                                    ? "discount"
                                    : "cashback",
                                discount_type: selectedTypeDiscount == "Theo số tiền"
                                    ? "fix_amount"
                                    : "by_percentage",
                                amount:
                                    int.parse(amountDiscountController.text),
                                maximum_discount_price: null,
                                minimum_basket_price:
                                    int.parse(minAmountOrderController.text),
                                usage_quantity:
                                    int.parse(numberVoucherController.text),
                                max_distribution_per_buyer: int.parse(
                                    numberVoucherPerPersonController.text),
                                display_setting: selectedTypeDisplay == 1
                                    ? "display_on_all_pages"
                                    : "to_be_shared_through_voucher_code",
                                applicable_products: widget.type == "shop"
                                    ? "all_products"
                                    : "specific_products",
                                product_ids: widget.type == "shop"
                                    ? null
                                    : chosenProduct
                                        .map((e) => int.parse(e["id"]))
                                        .toList(),
                                page_id: widget.pageId);
                            if (response != null) {
                              showSnackBar(
                                  Colors.green, "Tạo voucher thành công");
                            } else {
                              showSnackBar(null, "Tạo voucher thất bại");
                            }
                          } else {
                            // update voucher
                            final response = await VoucerApis().updateVoucher(
                              voucherId: widget.objectItem["id"],
                              title: nameProjectController.text,
                              code: codeController.text,
                              start_time:
                                  '${selectedStartDate.day}-${selectedStartDate.month}-${selectedStartDate.year}',
                              end_time:
                                  '${selectedEndDate.day}-${selectedEndDate.month}-${selectedEndDate.year}',
                              display_voucher_early:
                                  isSaveVoucherBefore ?? false,
                              start_save_time: isSaveVoucherBefore == true
                                  ? selectedSaveVoucherDate!.toIso8601String()
                                  : null,
                              discount_type:
                                  selectedTypeDiscount == "Theo số tiền"
                                      ? "fix_amount"
                                      : "by_percentage",
                              amount: int.parse(amountDiscountController.text),
                              maximum_discount_price: null,
                              minimum_basket_price:
                                  int.parse(minAmountOrderController.text),
                              usage_quantity:
                                  int.parse(numberVoucherController.text),
                              product_ids: widget.type == "shop"
                                  ? null
                                  : chosenProduct
                                      .map((e) => int.parse(e["id"]))
                                      .toList(),
                            );
                            if (response != null) {
                              showSnackBar(
                                  Colors.green, "Cập nhật voucher thành công");
                            } else {
                              showSnackBar(null, "Cập nhật voucher thất bại");
                            }
                          }
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width * 0.4,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: primaryColor,
                        ),
                        child: const Text("Xác nhận",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.black, fontSize: 16)),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChoseProduct extends StatefulWidget {
  final String pageId;
  final Function updateChosenProduct;
  const ChoseProduct(
      {super.key, required this.pageId, required this.updateChosenProduct});

  @override
  State<ChoseProduct> createState() => _ChoseProductState();
}

class _ChoseProductState extends State<ChoseProduct> {
  String selectedSearchType = "Tên sản phẩm";
  List _products = [];
  List choosenList = [];
  bool isSelectAll = false;
  List chosenProduct = [];
  getProducts() async {
    _products = await ProductsApi()
        .getShopProducts(widget.pageId, {"limit": 20, "is_active": true});
    choosenList = List<bool>.generate(_products.length, (index) => false);
    setState(() {});
  }

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  DataTable _buildOneDataTable(List _products) {
    List<DataColumn> dataColumns = [];
    List<DataRow> dataRows = [];

    dataColumns.add(
      DataColumn(
          label: Checkbox(
        value: isSelectAll,
        onChanged: (value) {
          isSelectAll = value!;
          for (int i = 0; i < choosenList.length; i++) {
            if (isSelectAll == true) {
              choosenList[i] = true;
            } else {
              choosenList[i] = false;
            }
          }
          if (isSelectAll == true) {
            widget.updateChosenProduct(_products);
          } else {
            widget.updateChosenProduct([]);
          }
          chosenProduct = [];
          setState(() {});
        },
      )),
    );
    dataColumns.add(
      const DataColumn(
          label: Text('Sản phẩm',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );
    dataColumns.add(
      const DataColumn(
          label: Text('Giá',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );
    dataColumns.add(
      const DataColumn(
          label: Text('Tồn kho',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );
    for (int i = 0; i < _products.length; i++) {
      dataRows.add(DataRow(cells: [
        DataCell(Checkbox(
          onChanged: (value) {
            setState(() {
              choosenList[i] = value!;
            });
            if (choosenList[i] == true) {
              chosenProduct.add(_products[i]);
            } else {
              chosenProduct.remove(_products[i]);
            }
            widget.updateChosenProduct(chosenProduct);
          },
          value: choosenList.isEmpty ? null : choosenList[i],
        )),
        DataCell(Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(_products[i]
                                  ["product_image_attachments"][0]["attachment"]
                              ?["url"] ??
                          _products[i]["product_variants"][0]?["image"]
                              ?["url"] ??
                          "https://thumbs.dreamstime.com/b/product-icon-collection-trendy-modern-flat-linear-vector-white-background-thin-line-outline-illustration-130947207.jpg"))),
            ),
            const SizedBox(
              width: 10,
            ),
            buildTextContent(
                truncateText(_products[i]["product_variants"][0]["title"], 15),
                false,
                isCenterLeft: false,
                fontSize: 17),
          ],
        )),
        DataCell(
          buildTextContent(
              "${_products[i]["product_variants"][0]["price"].toStringAsFixed(0)} đ",
              false,
              isCenterLeft: false,
              fontSize: 17),
        ),
        DataCell(
          buildTextContent(
              _products[i]["product_variants"][0]["inventory_quantity"]
                  .toString(),
              false,
              isCenterLeft: false,
              fontSize: 17),
        ),
      ]));
    }

    return DataTable(
      columns: dataColumns,
      rows: dataRows,
      showBottomBorder: true,
      // dataRowHeight: 60,
      dividerThickness: .4,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButton<String>(
                value: selectedSearchType,
                onChanged: (newValue) {
                  setState(() {
                    selectedSearchType = newValue!;
                  });
                },
                items: const [
                  DropdownMenuItem<String>(
                    value: 'Tên sản phẩm',
                    child: Text('Tên sản phẩm'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Mã sản phẩm',
                    child: Text('Mã sản phẩm'),
                  ),
                ],
              ),
              const SizedBox(width: 10.0),
              Expanded(
                child: TextFormField(
                  onFieldSubmitted: (value) async {
                    _products = await ProductsApi().getShopProducts(
                        widget.pageId, {
                      "limit": 20,
                      "is_active": true,
                      "q": value.isEmpty ? null : value
                    });
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    labelText: 'Nhập vào',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              height: size.height * 0.65,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: _buildOneDataTable(_products)),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: size.width * 0.4,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: primaryColor,
                    ),
                    child: const Text("Xác nhận",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
