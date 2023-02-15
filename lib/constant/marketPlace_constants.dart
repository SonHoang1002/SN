import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MarketPlaceConstants {
  static String PATH_IMG = "assets/images/";
  static String PATH_ICON = "assets/icons/";
  static const String NEXT = "Tiếp";
  static const String DONE = "Xong";
  static const String CREATE_GROUP = "Tạo nhóm";
  static const String SKIP = "Bỏ qua";
  static const String CONTINUE_AFTER = "Tiếp tục sau";
  static const IconData MENU_ICON_DATA = FontAwesomeIcons.ellipsis;
  static const IconData DOWN_ICON_DATA = FontAwesomeIcons.caretDown;
}

class MainMarketBodyConstants {
  static String MAIN_MARKETPLACE_BODY_CATEGORY_TITLE = "";
  static Map<String, dynamic>
      MAIN_MARKETPLACE_BODY_SELL_AND_CATEGORY_BUTTON_CONTENTS = {
    "key": "sell_and_category_button_contents",
    "data": [
      {
        "title": "Bán",
        "icon": Icons.usb_rounded,
      },
      {
        "title": "Hạng mục",
        "icon": Icons.usb_rounded,
      },
    ]
  };
  static Map<String, dynamic> MAIN_MARKETPLACE_BODY_CATEGORY_CONTENTS = {
    "key": "main_marketplace_category_contents",
    "data": [
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Thời Trang và Phụ Kiện"
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Du Lịch & Hành Lý"
      },
      {"icon": MarketPlaceConstants.PATH_IMG + "cat_1.png", "title": "Sắc Đẹp"},
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Thời Trang và Phụ Kiện"
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Thiết Bị Điện Gia Dụng"
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Giày Dép"
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Điện Thoại & Phụ kiện"
      },
      {"icon": MarketPlaceConstants.PATH_IMG + "cat_1.png", "title": "Túi Ví"},
      {"icon": MarketPlaceConstants.PATH_IMG + "cat_1.png", "title": "Đồng Hồ"},
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Thiết Bị Âm Thanh"
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Thực Phẩm Và Đồ Uống"
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Chăm Sóc Thú Cưng"
      },
      {"icon": MarketPlaceConstants.PATH_IMG + "cat_1.png", "title": "Mẹ & Bé"},
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Thời Trang Trẻ Em & Trẻ Sơ Sinh"
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Cameras & FlyCam"
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Nhà Cửa & Đời Sống"
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Thể Thao & Dã Ngoại"
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Văn Phòng Phẩm"
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Sở Thích & Thực Phẩm"
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Sách & Tạp Chí"
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Máy Tính & Laptop"
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Moto & Xe Máy "
      },
      {"icon": MarketPlaceConstants.PATH_IMG + "cat_1.png", "title": "Oto"},
    ]
  };
  static String MAIN_MARKETPLACE_BODY_SUGGEST_FOR_YOU_TITLE = "Gợi ý cho bạn";
  static Map<String, dynamic> MAIN_MARKETPLACE_BODY_SUGGEST_FOR_YOU_CONTENTS = {
    "key": " suggest_for_you_contents",
    "data": [
      {
        "id": 1,
        "img":
            "https://lzd-img-global.slatic.net/g/p/246824975c6773676b820f19a2d6be40.jpg_720x720q80.jpg",
        "title":
            "Áo Bomber nam nữ unisex UNFLUID - Áo khoác hoodie chất liệu nỉ bông phong cách Ulzzang Hàn Quốc",
        "min_price": Random().nextInt(200000),
        "max_price": Random().nextInt(200000),
        "selled": Random().nextInt(200),
        "rate": Random().nextInt(5),
        "available_products": Random().nextInt(2000),
        "description": [
          "yên tâm mặc mùa đông rất ấm áp 💹 Thông số chọn size sản phẩm Áo Bomber nam nữ unisex UNFLUID - Áo khoác hoodie chất liệu nỉ bông phong cách Ulzzang Hàn Quốc – Monlyshop 785. - M: dài 71cm, rộng 70cm, tay 51 cm / dành cho người cao dưới 1m60 hoặc dưới 58kg - L: dài 75cm, rộng 71.5cm, tay 52.5 cm / dành cho người cao 1m61-1m73 hoặc 52-70kg - XL: dài 78cm, rộng 73cm, tay 55 cm / dành cho người cao trên 1m73 hoặc trên 70 kg - Chọn size (nếu chênh lệch chiều cao cân nặng với mô tả dưới đây, nặng hơn thì bạn chọn theo cân nặng, cao hơn bạn chọn theo chiều cao nhé!) 💹 HƯỚNG DẪN CÁCH ĐẶT HÀNG: - Cách đặt hàng: Nếu bạn muốn mua 2 sản phẩm khác nhau hoặc 2 size khác nhau, để được freeship - Bạn chọn từng sản phẩm rồi thêm vào giỏ hàng - Khi giỏ hàng đã có đầy đủ các sản phẩm cần mua, bạn mới tiến hành ấn nút “ Thanh toán” - Shop luôn sẵn sàng trả lời inbox để tư vấn. 💹 Quyền Lợi của Khách Hàng khi mua hàng shop tại shop: ✔ Nếu sản phẩm khách nhận được không đúng với sản phẩm khách đặt, hoặc không đúng với mô tả sản phẩm. Khách hàng đừng vội đánh giá 1⭐. Hãy inbox lại cho shop. Chúng tôi xin lắng nghe và giải quyết. Shop không hi vọng trường hợp này xảy ra, và sẽ cố gắng hết sức để bạn không có một trải nghiệm mua hàng không tốt tại shop. Nhưng nếu có shop sẽ giải quyết mọi chuyện sao cho thỏa đáng nhất. ✔ 10 khách hàng đánh giá 5s kèm kình ảnh ấn tượng nhất tháng sẽ được gửi kèm QUÀ TẶNG TO TO và MÃ GIẢM GIÁ trong lần mua hàng ở tháng kế tiếp. 💹 Chính sách bán hàng tại shop: - Cam kết giá tốt nhất thị trường, chất lượng tuyệt vời - Sản phẩm cam kết như hình thật 100% - Đổi trả trong vòng 3 ngày nếu hàng lỗi, sai mẫu cho quý khách - Hỗ trợ bạn mọi lúc, mọi nơi #ao #bomber #unisex #UNFLUID #ao #khoac #hoodie #dang #varsity #chat #lieu #ni #bong #phong #cach #Ulzzang #Han #Quoc #MayLinh #Shop #Aokhoacbongchay #aobomber #aokhoacbongchayunisex #bomberunisex #bombernam #bombernu #aokhoacbongchaynam #aokhoacbongchaynu #aokhoac #aokhoacnam #aokhoacnu #aokhoackaki #aokaki #bomber #aobomber #aokhoacbomber #bombernu #bombernibong"
        ],
      },
      {
        "id": 2,
        "img":
            "https://www.sporter.vn/wp-content/uploads/2017/06/Ao-bong-da-anh-san-nha-hang-viet-nam-1.jpg",
        "title":
            "Áo Hoodie Teelab Special Colection có khóa và không khóa chất liệu nỉ bông ấm áp, form rộng dáng unisex",
        "min_price": Random().nextInt(200000),
        "selled": Random().nextInt(200),
        "rate": Random().nextInt(5),
        "available_products": Random().nextInt(2000),
        "description": [
          "99 - Green Generation nơi bạn có thể thỏa sức thử nghiệm phong cách của mình. Được thành lập vào 2020 với rất nhiều những sự biến động của xã hội, Lemon Store099 bắt đầu chặng đường viết lên câu chuyện của riêng mình. Khi văn hóa đường phố dần trở nên phổ biến hơn cũng là lúc nhu cầu được thỏa mãn đam mê về thời trang của những GenZ mãnh liệt hơn bao giờ hết. Lemon Store99 , phòng thí nghiệm về thời trang và những thiết kế mang đậm tinh thần Lemon Store99 của chúng tôi “Your body is your greatest canvas” hứa hẹn sẽ mang đến cho các bạn trẻ Việt Nam nhiều trải nghiệm thú vị và mới mẻ về thời trang đường phố. Đội ngũ Fashion Scientist của Lemon Store99 luôn cố gắng hoàn thiện và phát triển sản phầm, để có thể mang tới cho khách hàng những sản phẩm có chất lượng tốt nhất, được nghiên cứu kỹ càng và đáp ứng những tiêu chuẩn điên rồ nhất từ phòng thí nghiệm của chúng tôi. #genz #teelab #aokhoac #streetwear #aonam #aonu #aokhoacdep #bomber #bomber #bomer"
        ],
      },
      {
        "id": 3,
        "img":
            "https://cdn.tgdd.vn/Files/2019/11/17/1219762/tim-hieu-ve-tai-nghe-in-ear-tai-nghe-earbuds-chung.jpg",
        "title":
            "Tai Nghe Bluetooth M10 Pro Tai Nghe Không M10 Pro Phiên Bản Nâng Cấp Pin Trâu, Nút Cảm Ứng Tự Động Kết Nối - BINTECH",
        "min_price": Random().nextInt(200000),
        "max_price": Random().nextInt(200000),
        "selled": Random().nextInt(200),
        "rate": Random().nextInt(5),
        "available_products": Random().nextInt(2000),
        "description": [
          "Tai Nghe Bluetooth M10 Pro Tai Nghe Không M10 Pro Phiên Bản  Nâng Cấp Pin Trâu,  Nút Cảm Ứng Tự Động Kết Nối",
          "Bintech đảm bảo:",
          "- Mang lại cho quý khách những sản phẩm tốt nhất, đẹp nhất",
          "- Cam kết hàng chính hãng - Lỗi 1 đổi 1 trong 6 tháng.",
          "- Freeship đơn hàng từ 50k."
        ]
      },
      {
        "id": 4,
        "img":
            "https://soundpeatsvietnam.com/wp-content/uploads/2022/03/cach-khac-phuc-loi-nghe-mot-ben-tren-tai-nghe-bluetooth.jpg",
        "title":
            "Loa bluetooth đồng hồ G5, loa mini không dây nghe nhạc làm đèn ngủ màn hình soi gương",
        "min_price": Random().nextInt(200000),
        "max_price": Random().nextInt(200000),
        "selled": Random().nextInt(200),
        "rate": Random().nextInt(5),
        "available_products": Random().nextInt(2000),
        "description": [
          "Loa bluetooth đồng hồ G5, loa mini không dây Clock seaker D88 nghe nhạc",
          "Chú ý: loa có công suất 3w 1 bên là loa còn một bên là màng chắn âm bass, mặt kính có giấy bóng bọc bên ngoài, khi sử dụng quý khách nên bóc giấy bóng ra. Sản phẩm có 2 phiên bản - phiên bản G5 nội địa và phiên bản Clock Speaker D88 Châu âu (tiếng anh)",
          "1. Loa bluetooth mini không dây đồng hồ có Màn hình LED hiển thị lớn: LED hiển thị đồng hồ , báo thức, trạng thái chế độ, và nhiệt độ theo độ C . Bạn cũng có thể sử dụng nó như một chiếc gương soi. Và có thể điều chỉnh độ sáng 3 mức độ (BRIGHTEST, MIDDLE & LOWEST).",
          "2. Loa bluetooth mini không dây đồng hồ có công nghệ Bluetooth mới nhất: Bluetooth 5.2 cho phép smartphone kết nối tới với khoảng cách lên tới 10M. Có microphone để nghe điện thoại ở chế độ rảnh tay.",
          "3. Loa bluetooth mini không dây đồng hồ có chất lượng âm thanh cao chống ồn và tăng cường âm Bass.",
          "4.  Loa bluetooth mini không dây đồng hồ có dung lượng pin lớn 1400mAh cho phép chơi nhạc 8 giờ liên tiếp (tùy âm lượng). Chơi nhạc từ TF card, AUX, nó có thể đáp ứng nhu cầu của bạn bất cứ khi nào, nghe đài FM, tự động tìm kiếm, sạc trong 3h và sử dụng được trong 8h, nếu sử dụng đồng hồ thời gian sử dụng lên tới 72h. ",
        ]
      },
      {
        "id": 5,
        "img":
            "https://lzd-img-global.slatic.net/g/p/246824975c6773676b820f19a2d6be40.jpg_720x720q80.jpg",
        "title":
            "Áo Bomber nam nữ unisex UNFLUID - Áo khoác hoodie chất liệu nỉ bông phong cách Ulzzang Hàn Quốc",
        "min_price": Random().nextInt(200000),
        "max_price": Random().nextInt(200000),
        "selled": Random().nextInt(200),
        "rate": Random().nextInt(5),
        "available_products": Random().nextInt(2000),
        "description": [
          "yên tâm mặc mùa đông rất ấm áp 💹 Thông số chọn size sản phẩm Áo Bomber nam nữ unisex UNFLUID - Áo khoác hoodie chất liệu nỉ bông phong cách Ulzzang Hàn Quốc – Monlyshop 785. - M: dài 71cm, rộng 70cm, tay 51 cm / dành cho người cao dưới 1m60 hoặc dưới 58kg - L: dài 75cm, rộng 71.5cm, tay 52.5 cm / dành cho người cao 1m61-1m73 hoặc 52-70kg - XL: dài 78cm, rộng 73cm, tay 55 cm / dành cho người cao trên 1m73 hoặc trên 70 kg - Chọn size (nếu chênh lệch chiều cao cân nặng với mô tả dưới đây, nặng hơn thì bạn chọn theo cân nặng, cao hơn bạn chọn theo chiều cao nhé!) 💹 HƯỚNG DẪN CÁCH ĐẶT HÀNG: - Cách đặt hàng: Nếu bạn muốn mua 2 sản phẩm khác nhau hoặc 2 size khác nhau, để được freeship - Bạn chọn từng sản phẩm rồi thêm vào giỏ hàng - Khi giỏ hàng đã có đầy đủ các sản phẩm cần mua, bạn mới tiến hành ấn nút “ Thanh toán” - Shop luôn sẵn sàng trả lời inbox để tư vấn. 💹 Quyền Lợi của Khách Hàng khi mua hàng shop tại shop: ✔ Nếu sản phẩm khách nhận được không đúng với sản phẩm khách đặt, hoặc không đúng với mô tả sản phẩm. Khách hàng đừng vội đánh giá 1⭐. Hãy inbox lại cho shop. Chúng tôi xin lắng nghe và giải quyết. Shop không hi vọng trường hợp này xảy ra, và sẽ cố gắng hết sức để bạn không có một trải nghiệm mua hàng không tốt tại shop. Nhưng nếu có shop sẽ giải quyết mọi chuyện sao cho thỏa đáng nhất. ✔ 10 khách hàng đánh giá 5s kèm kình ảnh ấn tượng nhất tháng sẽ được gửi kèm QUÀ TẶNG TO TO và MÃ GIẢM GIÁ trong lần mua hàng ở tháng kế tiếp. 💹 Chính sách bán hàng tại shop: - Cam kết giá tốt nhất thị trường, chất lượng tuyệt vời - Sản phẩm cam kết như hình thật 100% - Đổi trả trong vòng 3 ngày nếu hàng lỗi, sai mẫu cho quý khách - Hỗ trợ bạn mọi lúc, mọi nơi #ao #bomber #unisex #UNFLUID #ao #khoac #hoodie #dang #varsity #chat #lieu #ni #bong #phong #cach #Ulzzang #Han #Quoc #MayLinh #Shop #Aokhoacbongchay #aobomber #aokhoacbongchayunisex #bomberunisex #bombernam #bombernu #aokhoacbongchaynam #aokhoacbongchaynu #aokhoac #aokhoacnam #aokhoacnu #aokhoackaki #aokaki #bomber #aobomber #aokhoacbomber #bombernu #bombernibong"
        ],
      },
      {
        "id": 6,
        "img":
            "https://www.sporter.vn/wp-content/uploads/2017/06/Ao-bong-da-anh-san-nha-hang-viet-nam-1.jpg",
        "title":
            "Áo Hoodie Teelab Special Colection có khóa và không khóa chất liệu nỉ bông ấm áp, form rộng dáng unisex",
        "min_price": Random().nextInt(200000),
        "max_price": Random().nextInt(200000),
        "selled": Random().nextInt(200),
        "rate": Random().nextInt(5),
        "available_products": Random().nextInt(2000),
        "description": [
          "99 - Green Generation nơi bạn có thể thỏa sức thử nghiệm phong cách của mình. Được thành lập vào 2020 với rất nhiều những sự biến động của xã hội, Lemon Store099 bắt đầu chặng đường viết lên câu chuyện của riêng mình. Khi văn hóa đường phố dần trở nên phổ biến hơn cũng là lúc nhu cầu được thỏa mãn đam mê về thời trang của những GenZ mãnh liệt hơn bao giờ hết. Lemon Store99 , phòng thí nghiệm về thời trang và những thiết kế mang đậm tinh thần Lemon Store99 của chúng tôi “Your body is your greatest canvas” hứa hẹn sẽ mang đến cho các bạn trẻ Việt Nam nhiều trải nghiệm thú vị và mới mẻ về thời trang đường phố. Đội ngũ Fashion Scientist của Lemon Store99 luôn cố gắng hoàn thiện và phát triển sản phầm, để có thể mang tới cho khách hàng những sản phẩm có chất lượng tốt nhất, được nghiên cứu kỹ càng và đáp ứng những tiêu chuẩn điên rồ nhất từ phòng thí nghiệm của chúng tôi. #genz #teelab #aokhoac #streetwear #aonam #aonu #aokhoacdep #bomber #bomber #bomer"
        ],
      },
      {
        "id": 7,
        "img":
            "https://cdn.tgdd.vn/Files/2019/11/17/1219762/tim-hieu-ve-tai-nghe-in-ear-tai-nghe-earbuds-chung.jpg",
        "title":
            "Tai Nghe Bluetooth M10 Pro Tai Nghe Không M10 Pro Phiên Bản Nâng Cấp Pin Trâu, Nút Cảm Ứng Tự Động Kết Nối - BINTECH",
        "min_price": Random().nextInt(200000),
        "max_price": Random().nextInt(200000),
        "selled": Random().nextInt(200),
        "rate": Random().nextInt(5),
        "available_products": Random().nextInt(2000),
        "description": [
          "Tai Nghe Bluetooth M10 Pro Tai Nghe Không M10 Pro Phiên Bản  Nâng Cấp Pin Trâu,  Nút Cảm Ứng Tự Động Kết Nối",
          "Bintech đảm bảo:",
          "- Mang lại cho quý khách những sản phẩm tốt nhất, đẹp nhất",
          "- Cam kết hàng chính hãng - Lỗi 1 đổi 1 trong 6 tháng.",
          "- Freeship đơn hàng từ 50k."
        ]
      },
      {
        "id": 8,
        "img":
            "https://soundpeatsvietnam.com/wp-content/uploads/2022/03/cach-khac-phuc-loi-nghe-mot-ben-tren-tai-nghe-bluetooth.jpg",
        "title":
            "Loa bluetooth đồng hồ G5, loa mini không dây nghe nhạc làm đèn ngủ màn hình soi gương",
        "min_price": Random().nextInt(200000),
        "max_price": Random().nextInt(200000),
        "selled": Random().nextInt(200),
        "rate": Random().nextInt(5),
        "available_products": Random().nextInt(2000),
        "description": [
          "Loa bluetooth đồng hồ G5, loa mini không dây Clock seaker D88 nghe nhạc",
          "Chú ý: loa có công suất 3w 1 bên là loa còn một bên là màng chắn âm bass, mặt kính có giấy bóng bọc bên ngoài, khi sử dụng quý khách nên bóc giấy bóng ra. Sản phẩm có 2 phiên bản - phiên bản G5 nội địa và phiên bản Clock Speaker D88 Châu âu (tiếng anh)",
          "1. Loa bluetooth mini không dây đồng hồ có Màn hình LED hiển thị lớn: LED hiển thị đồng hồ , báo thức, trạng thái chế độ, và nhiệt độ theo độ C . Bạn cũng có thể sử dụng nó như một chiếc gương soi. Và có thể điều chỉnh độ sáng 3 mức độ (BRIGHTEST, MIDDLE & LOWEST).",
          "2. Loa bluetooth mini không dây đồng hồ có công nghệ Bluetooth mới nhất: Bluetooth 5.2 cho phép smartphone kết nối tới với khoảng cách lên tới 10M. Có microphone để nghe điện thoại ở chế độ rảnh tay.",
          "3. Loa bluetooth mini không dây đồng hồ có chất lượng âm thanh cao chống ồn và tăng cường âm Bass.",
          "4.  Loa bluetooth mini không dây đồng hồ có dung lượng pin lớn 1400mAh cho phép chơi nhạc 8 giờ liên tiếp (tùy âm lượng). Chơi nhạc từ TF card, AUX, nó có thể đáp ứng nhu cầu của bạn bất cứ khi nào, nghe đài FM, tự động tìm kiếm, sạc trong 3h và sử dụng được trong 8h, nếu sử dụng đồng hồ thời gian sử dụng lên tới 72h. ",
        ]
      },
    ]
  };
  // static String MAIN_MARKETPLACE_BODY_SUGGEST_FOR_YOU_TITLE = "GỢi ý cho bạn";
}
