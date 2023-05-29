import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MarketPlaceConstants {
  static const String PATH_IMG = "assets/images/";
  static const String PATH_ICON = "assets/icons/";
  static const String NEXT = "Tiếp";
  static const String DONE = "Xong";
  static const String CREATE_GROUP = "Tạo nhóm";
  static const String SKIP = "Bỏ qua";
  static const String CONTINUE_AFTER = "Tiếp tục sau";
  static const IconData MENU_ICON_DATA = FontAwesomeIcons.ellipsis;
  static const IconData DOWN_ICON_DATA = FontAwesomeIcons.caretDown;
}

class MainMarketPageConstants {
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
        "title": "Moto & Xe Máy"
      },
      {"icon": MarketPlaceConstants.PATH_IMG + "cat_1.png", "title": "Oto"},
    ]
  };
  static String MAIN_MARKETPLACE_BODY_SUGGEST_FOR_YOU_TITLE = "Gợi ý cho bạn";
  static Map<String, dynamic> MAIN_MARKETPLACE_BODY_SUGGEST_FOR_YOU_CONTENTS = {
    "key": " suggest_for_you_contents",
    "data": [
      {
        "id": "1",
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
          "Yên tâm mặc mùa đông rất ấm áp 💹 Thông số chọn size sản phẩm Áo Bomber nam nữ unisex UNFLUID - Áo khoác hoodie chất liệu nỉ bông phong cách Ulzzang Hàn Quốc – Monlyshop 785. - M: dài 71cm, rộng 70cm, tay 51 cm / dành cho người cao dưới 1m60 hoặc dưới 58kg - L: dài 75cm, rộng 71.5cm, tay 52.5 cm / dành cho người cao 1m61-1m73 hoặc 52-70kg - XL: dài 78cm, rộng 73cm, tay 55 cm / dành cho người cao trên 1m73 hoặc trên 70 kg - Chọn size (nếu chênh lệch chiều cao cân nặng với mô tả dưới đây, nặng hơn thì bạn chọn theo cân nặng, cao hơn bạn chọn theo chiều cao nhé!) 💹 HƯỚNG DẪN CÁCH ĐẶT HÀNG: - Cách đặt hàng: Nếu bạn muốn mua 2 sản phẩm khác nhau hoặc 2 size khác nhau, để được freeship - Bạn chọn từng sản phẩm rồi thêm vào giỏ hàng - Khi giỏ hàng đã có đầy đủ các sản phẩm cần mua, bạn mới tiến hành ấn nút “ Thanh toán” - Shop luôn sẵn sàng trả lời inbox để tư vấn. 💹 Quyền Lợi của Khách Hàng khi mua hàng shop tại shop: ✔ Nếu sản phẩm khách nhận được không đúng với sản phẩm khách đặt, hoặc không đúng với mô tả sản phẩm. Khách hàng đừng vội đánh giá 1⭐. Hãy inbox lại cho shop. Chúng tôi xin lắng nghe và giải quyết. Shop không hi vọng trường hợp này xảy ra, và sẽ cố gắng hết sức để bạn không có một trải nghiệm mua hàng không tốt tại shop. Nhưng nếu có shop sẽ giải quyết mọi chuyện sao cho thỏa đáng nhất. ✔ 10 khách hàng đánh giá 5s kèm kình ảnh ấn tượng nhất tháng sẽ được gửi kèm QUÀ TẶNG TO TO và MÃ GIẢM GIÁ trong lần mua hàng ở tháng kế tiếp. 💹 Chính sách bán hàng tại shop: - Cam kết giá tốt nhất thị trường, chất lượng tuyệt vời - Sản phẩm cam kết như hình thật 100% - Đổi trả trong vòng 3 ngày nếu hàng lỗi, sai mẫu cho quý khách - Hỗ trợ bạn mọi lúc, mọi nơi #ao #bomber #unisex #UNFLUID #ao #khoac #hoodie #dang #varsity #chat #lieu #ni #bong #phong #cach #Ulzzang #Han #Quoc #MayLinh #Shop #Aokhoacbongchay #aobomber #aokhoacbongchayunisex #bomberunisex #bombernam #bombernu #aokhoacbongchaynam #aokhoacbongchaynu #aokhoac #aokhoacnam #aokhoacnu #aokhoackaki #aokaki #bomber #aobomber #aokhoacbomber #bombernu #bombernibong"
        ],
        "reviews": [
          {
            "id": 1,
            "username": "John Doe",
            "rating": 4,
            "comment":
                "Tôi rất hài lòng với sản phẩm này! Chất lượng tốt và giá cả phải chăng.",
            "created_at": "2022-12-01T12:00:00Z"
          },
          {
            "id": 2,
            "username": "Jane Doe",
            "rating": 5,
            "comment":
                "Tôi rất thích sản phẩm này! Chất lượng tuyệt vời và giao hàng nhanh chóng.",
            "created_at": "2022-12-02T14:30:00Z"
          },
          {
            "id": 3,
            "username": "Jim Smith",
            "rating": 3,
            "comment":
                "Sản phẩm tạm được, nhưng màu sắc không giống với mô tả.",
            "created_at": "2022-12-03T16:45:00Z"
          }
        ]
      },
      {
        "id": "2",
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
        "reviews": [
          {
            "id": 1,
            "username": "John Doe",
            "rating": 4,
            "comment":
                "Tôi rất hài lòng với sản phẩm này! Chất lượng tốt và giá cả phải chăng.",
            "created_at": "2022-12-01T12:00:00Z"
          },
          {
            "id": 2,
            "username": "Jane Doe",
            "rating": 5,
            "comment":
                "Tôi rất thích sản phẩm này! Chất lượng tuyệt vời và giao hàng nhanh chóng.",
            "created_at": "2022-12-02T14:30:00Z"
          },
          {
            "id": 3,
            "username": "Jim Smith",
            "rating": 3,
            "comment":
                "Sản phẩm tạm được, nhưng màu sắc không giống với mô tả.",
            "created_at": "2022-12-03T16:45:00Z"
          }
        ]
      },
      {
        "id": "3",
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
        ],
        "reviews": [
          {
            "id": 1,
            "username": "John Doe",
            "rating": 4,
            "comment":
                "Tôi rất hài lòng với sản phẩm này! Chất lượng tốt và giá cả phải chăng.",
            "created_at": "2022-12-01T12:00:00Z"
          },
          {
            "id": 2,
            "username": "Jane Doe",
            "rating": 5,
            "comment":
                "Tôi rất thích sản phẩm này! Chất lượng tuyệt vời và giao hàng nhanh chóng.",
            "created_at": "2022-12-02T14:30:00Z"
          },
          {
            "id": 3,
            "username": "Jim Smith",
            "rating": 3,
            "comment":
                "Sản phẩm tạm được, nhưng màu sắc không giống với mô tả.",
            "created_at": "2022-12-03T16:45:00Z"
          }
        ]
      },
      {
        "id": "4",
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
        ],
        "reviews": [
          {
            "id": 1,
            "username": "John Doe",
            "rating": 4,
            "comment":
                "Tôi rất hài lòng với sản phẩm này! Chất lượng tốt và giá cả phải chăng.",
            "created_at": "2022-12-01T12:00:00Z"
          },
          {
            "id": 2,
            "username": "Jane Doe",
            "rating": 5,
            "comment":
                "Tôi rất thích sản phẩm này! Chất lượng tuyệt vời và giao hàng nhanh chóng.",
            "created_at": "2022-12-02T14:30:00Z"
          },
          {
            "id": 3,
            "username": "Jim Smith",
            "rating": 3,
            "comment":
                "Sản phẩm tạm được, nhưng màu sắc không giống với mô tả.",
            "created_at": "2022-12-03T16:45:00Z"
          }
        ]
      },
      {
        "id": "5",
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
        "reviews": [
          {
            "id": 1,
            "username": "John Doe",
            "rating": 4,
            "comment":
                "Tôi rất hài lòng với sản phẩm này! Chất lượng tốt và giá cả phải chăng.",
            "created_at": "2022-12-01T12:00:00Z"
          },
          {
            "id": 2,
            "username": "Jane Doe",
            "rating": 5,
            "comment":
                "Tôi rất thích sản phẩm này! Chất lượng tuyệt vời và giao hàng nhanh chóng.",
            "created_at": "2022-12-02T14:30:00Z"
          },
          {
            "id": 3,
            "username": "Jim Smith",
            "rating": 3,
            "comment":
                "Sản phẩm tạm được, nhưng màu sắc không giống với mô tả.",
            "created_at": "2022-12-03T16:45:00Z"
          }
        ]
      },
      {
        "id": "6",
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
        "reviews": [
          {
            "id": 1,
            "username": "John Doe",
            "rating": 4,
            "comment":
                "Tôi rất hài lòng với sản phẩm này! Chất lượng tốt và giá cả phải chăng.",
            "created_at": "2022-12-01T12:00:00Z"
          },
          {
            "id": 2,
            "username": "Jane Doe",
            "rating": 5,
            "comment":
                "Tôi rất thích sản phẩm này! Chất lượng tuyệt vời và giao hàng nhanh chóng.",
            "created_at": "2022-12-02T14:30:00Z"
          },
          {
            "id": 3,
            "username": "Jim Smith",
            "rating": 3,
            "comment":
                "Sản phẩm tạm được, nhưng màu sắc không giống với mô tả.",
            "created_at": "2022-12-03T16:45:00Z"
          }
        ]
      },
      {
        "id": "7",
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
        ],
        "reviews": [
          {
            "id": 1,
            "username": "John Doe",
            "rating": 4,
            "comment":
                "Tôi rất hài lòng với sản phẩm này! Chất lượng tốt và giá cả phải chăng.",
            "created_at": "2022-12-01T12:00:00Z"
          },
          {
            "id": 2,
            "username": "Jane Doe",
            "rating": 5,
            "comment":
                "Tôi rất thích sản phẩm này! Chất lượng tuyệt vời và giao hàng nhanh chóng.",
            "created_at": "2022-12-02T14:30:00Z"
          },
          {
            "id": 3,
            "username": "Jim Smith",
            "rating": 3,
            "comment":
                "Sản phẩm tạm được, nhưng màu sắc không giống với mô tả.",
            "created_at": "2022-12-03T16:45:00Z"
          }
        ]
      },
      {
        "id": "8",
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
        ],
        "reviews": [
          {
            "id": 1,
            "username": "John Doe",
            "rating": 4,
            "comment":
                "Tôi rất hài lòng với sản phẩm này! Chất lượng tốt và giá cả phải chăng.",
            "created_at": "2022-12-01T12:00:00Z"
          },
          {
            "id": 2,
            "username": "Jane Doe",
            "rating": 5,
            "comment":
                "Tôi rất thích sản phẩm này! Chất lượng tuyệt vời và giao hàng nhanh chóng.",
            "created_at": "2022-12-02T14:30:00Z"
          },
          {
            "id": 3,
            "username": "Jim Smith",
            "rating": 3,
            "comment":
                "Sản phẩm tạm được, nhưng màu sắc không giống với mô tả.",
            "created_at": "2022-12-03T16:45:00Z"
          }
        ]
      },
    ]
  };
  static const Map<String, dynamic> MAIN_MARKETPLACE_BODY_CATEGORY_SELECTIONS =
      {
    "key": "",
    "data": [
      {
        "icon": MarketPlaceConstants.PATH_IMG + "Bách hóa Online.png",
        "title": "Thời Trang và Phụ Kiện",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "Balo & Túi ví Nam.png",
        "title": "Du Lịch & Hành Lý",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "Sắc đẹp.png",
        "title": "Sắc đẹp",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "Đồ chơi.png",
        "title": "Sức khỏe",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "Thiết bị điện gia dụng.png",
        "title": "Thiết Bị Điện Gia Dụng",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "Giày dép nam.png",
        "title": "Giày Dép",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "Điện thoại & Phụ kiện.png",
        "title": "Điện Thoại & Phụ kiện",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "Máy ảnh & Máy quay phim.png",
        "title": "Thiết Bị Âm Thanh",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "Chăm sóc thú cưng.png",
        "title": "Thực Phẩm Và Đồ Uống",
      },
      {
        "icon":
            MarketPlaceConstants.PATH_IMG + "Dụng cụ và thiết bị tiện ích.png",
        "title": "Chăm Sóc Thú Cưng",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "Máy tính & Laptop.png",
        "title": "Thời Trang Trẻ Em & Trẻ Sơ Sinh",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "Máy ảnh & Máy quay phim.png",
        "title": "Cameras & FlyCam",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "Nhà cửa đời sống.png",
        "title": "Nhà Cửa & Đời Sống",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "Thể thao & Du lịch.png",
        "title": "Thể Thao & Dã Ngoại",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "Sức khỏe.png",
        "title": "Văn Phòng Phẩm",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "Thời trang trẻ em.png",
        "title": "Sở Thích & Thực Phẩm",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "Nhà sách Online.png",
        "title": "Sách & Tạp Chí",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "Máy tính & Laptop.png",
        "title": "Máy Tính & Laptop",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "Ô tô & Xe máy & Xe đạp.png",
        "title": "Moto & Xe Máy"
      },
    ]
  };
  static const Map<String, dynamic> MAIN_MARKETPLACE_BODY_SORT_SELECTIONS = {
    "key": "",
    "data": [
      {
        "text": "Mới nhất",
        "icon": Icons.usb_rounded,
      },
      {
        "text": "Bán chạy",
        "icon": Icons.usb_rounded,
      },
      {
        "text": "Giá",
        "icon": Icons.usb_rounded,
        "sub_selections": ["Cao đến thấp", "Thấp đến cao"]
      },
    ]
  };
}

class PersonalMarketPlaceConstants {
  static String PERSONAL_MARKET_PLACE_TITLE = "Bạn";
  static const Map<String, dynamic>
      PERSONAL_MARKET_PLACE_PRODUCT_OF_YOU_CONTENTS = {
    "key": "product_of_you_contents",
    "data": [
      {
        "title": "Lời mời",
        "icon": FontAwesomeIcons.mailReply,
      },
      {
        "title": "Quan tâm",
        "icon": FontAwesomeIcons.star,
      },
      {
        "title": "Quản lý đơn hàng",
        "icon": FontAwesomeIcons.bagShopping,
      },
      {
        "title": "Quản lý sản phẩm",
        "icon": FontAwesomeIcons.bagShopping,
      },
      {
        "title": "Đơn mua",
        "icon": FontAwesomeIcons.moneyBill,
      },
      {
        "title": "Giỏ hàng",
        "icon": FontAwesomeIcons.cartArrowDown,
      },
    ]
  };

  static const Map<String, dynamic> PERSONAL_MARKET_PLACE_YOUR_SHOP = {
    "key": "your_shop",
    "data": [
      {
        "title": "Quản lý đơn hàng",
        "icon": FontAwesomeIcons.bagShopping,
      },
      {
        "title": "Quản lý sản phẩm",
        "icon": FontAwesomeIcons.bagShopping,
      },
      {
        "title": "Tạo sản phẩm mới",
        "icon": FontAwesomeIcons.add,
      },
    ]
  };
  static const Map<String, dynamic> PERSONAL_MARKET_PLACE_YOUR_ACCOUNT = {
    "key": "your_account",
    "data": [
      {
        "title": "Lời mời",
        "icon": FontAwesomeIcons.mailReply,
      },
      {
        "title": "Quan tâm",
        "icon": FontAwesomeIcons.star,
      },
      {
        "title": "Đơn mua của tôi",
        "icon": FontAwesomeIcons.bagShopping,
      },
    ]
  };
}

class DetailProductMarketConstants {
  static List<String> DETAIL_PRODUCT_MARKET_CONTENTS = [
    "Giới thiệu",
    "Đánh giá",
  ];

  static Map<String, dynamic> DETAIL_PRODUCT_MARKET_SHARE_SELECTIONS = {
    "key": "request_selections",
    "data": [
      {
        "key": "link",
        "title": "Link liên kết",
        "icon": FontAwesomeIcons.mailReply,
      },
      {
        "key": "share_on_story_table",
        "title": "Chia sẻ lên bảng tin",
        "icon": FontAwesomeIcons.star,
      },
      {
        "key": "share_on_group",
        "title": "Chia sẻ lên nhóm",
        "icon": FontAwesomeIcons.bagShopping,
      },
      {
        "key": "share_on_personal_page_of_friend",
        "title": "Chia sẻ lên trang cá nhân của bạn bè",
        "icon": FontAwesomeIcons.moneyBill,
      },
    ]
  };

  static Map<String, dynamic> DETAIL_PRODUCT_MARKET_GROUP_SHARE_SELECTIONS = {
    "key": "",
    "data": [
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Hoạt Hình Trung Quốc - Chinese Animation",
        "susbTitle": "Nhóm riêng tư - 4,9K thành viên",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_2.png",
        "title": "Nhóm thông tin sinh viên NEU",
        "susbTitle": "Nhóm công khai - 9K thành viên",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_3.png",
        "title": "Mobile Development Jobs VN",
        "susbTitle": "Nhóm riêng tư - 5K thành viên",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_4.png",
        "title": "Tuyển dụng Flutter tại Việt Nam",
        "susbTitle": "Nhóm công khai - 4K thành viên",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Hoạt Hình Trung Quốc - Chinese Animation",
        "susbTitle": "Nhóm riêng tư - 4,9K thành viên",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_2.png",
        "title": "Nhóm thông tin sinh viên NEU",
        "susbTitle": "Nhóm công khai - 9K thành viên",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_3.png",
        "title": "Mobile Development Jobs VN",
        "susbTitle": "Nhóm riêng tư - 5K thành viên",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_4.png",
        "title": "Tuyển dụng Flutter tại Việt Nam",
        "susbTitle": "Nhóm công khai - 4K thành viên",
      },
    ],
  };
  static Map<String, dynamic> DETAIL_PRODUCT_MARKET_FRIEND_SHARE_SELECTIONS = {
    "key": "",
    "data": [
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Nguyên Văn A",
        "subTitle": ""
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_2.png",
        "title": "Nguyên Văn B",
        "subTitle": ""
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_3.png",
        "title": "Tuyển dụng Flutter tại Việt Nam",
        "subTitle": ""
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_4.png",
        "title": "Mobile Development Jobs VN",
        "subTitle": ""
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Nguyên Văn C",
        "subTitle": ""
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_2.png",
        "title": "Nguyên Văn D",
        "subTitle": ""
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_3.png",
        "title": "Tuyển dụng Flutter tại Việt Nam",
        "subTitle": ""
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_4.png",
        "title": "Mobile Development Jobs VN",
        "subTitle": ""
      },
    ]
  };
}

class CreateProductMarketConstants {
  static String CREATE_PRODUCT_MARKET_ADD_IMG_TITLE = "Hình ảnh sản phẩm";
  static String CREATE_PRODUCT_MARKET_ADD_IMG_PLACEHOLDER = "Thêm ảnh";
  static String CREATE_PRODUCT_MARKET_ADD_IMG_WARING =
      "Vui lòng đăng tải tối thiểu 1 hình ảnh về sản phẩm này.";

  static String CREATE_PRODUCT_MARKET_PRODUCT_VIDEO_TITLE = "Video sản phẩm";
  static String CREATE_PRODUCT_MARKET_PRODUCT_VIDEO_PLACEHOLDER =
      "Tải lên Video Sản phẩm";
  static String CREATE_PRODUCT_MARKET_PRODUCT_VIDEO_WARING =
      "Vui lòng đăng tải tối thiểu 1 hình ảnh về sản phẩm này.";

  static const String CREATE_PRODUCT_MARKET_PRODUCT_NAME_TITLE = "Tên sản phẩm";
  static const String CREATE_PRODUCT_MARKET_PRODUCT_NAME_PLACEHOLDER =
      "Nhập tên sản phẩm";
  static String CREATE_PRODUCT_MARKET_PRODUCT_NAME_WARING =
      "Vui lòng nhập tên sản phẩm";

  static String CREATE_PRODUCT_MARKET_CATEGORY_TITLE = "Danh mục";
  static const List<String> CREATE_PRODUCT_MARKET_CATEGORY_SELECTIONS = [
    "Thời Trang và Phụ Kiện",
    "Du Lịch & Hành Lý",
    "Thời Trang và Phụ Kiện",
    "Thiết Bị Điện Gia Dụng",
    "Giày Dép",
    "Điện Thoại & Phụ kiện",
    "Thiết Bị Âm Thanh",
    "Thực Phẩm Và Đồ Uống",
    "Chăm Sóc Thú Cưng",
    "Thời Trang Trẻ Em & Trẻ Sơ Sinh",
    "Cameras & FlyCam",
    "Nhà Cửa & Đời Sống",
    "Thể Thao & Dã Ngoại",
    "Văn Phòng Phẩm",
    "Sở Thích & Thực Phẩm",
    "Sách & Tạp Chí",
    "Máy Tính & Laptop",
    "Moto & Xe Máy"
  ];
  static String CREATE_PRODUCT_MARKET_CATEGORY_WARING =
      "Vui lòng chọn Danh mục ";

  static String CREATE_PRODUCT_MARKET_BRANCH_PRODUCT_TITLE = "Ngành hàng";

  static String CREATE_PRODUCT_MARKET_BRANCH_PRODUCT_WARING =
      "Vui lòng chọn Ngành hàng";

  static String CREATE_PRODUCT_MARKET_DESCRIPTION_TITLE = "Mô tả sản phẩm";
  static const String CREATE_PRODUCT_MARKET_DESCRIPTION_PLACEHOLDER =
      "Nhập mô tả sản phẩm";

  static String CREATE_PRODUCT_MARKET_BRAND_TITLE = "Nhãn hiệu";
  static const String CREATE_PRODUCT_MARKET_BRAND_PLACEHOLDER =
      "Nhập nhãn hiệu";
  static String CREATE_PRODUCT_MARKET_BRAND_WARING =
      "Vui lòng điền vào Nhãn hiệu";

  static String CREATE_PRODUCT_MARKET_PRIVATE_RULE_TITLE = "Quyền riêng tư";
  static const List<Map<String, dynamic>>
      CREATE_PRODUCT_MARKET_PRIVATE_RULE_SELECTIONS = [
    {
      "key": "public",
      "icon": FontAwesomeIcons.earthAfrica,
      "title": "Công khai",
      "subTitle": "Tất cả mọi người"
    },
    {
      "key": "friend",
      "icon": FontAwesomeIcons.user,
      "title": "Bạn bè",
      "subTitle": "Bạn bè của bạn"
    },
    {
      "key": "private",
      "icon": FontAwesomeIcons.lock,
      "title": "Riêng tư",
      "subTitle": "Chỉ bạn bè được mời"
    },
  ];
  static String CREATE_PRODUCT_MARKET_PRIVATE_RULE_WARING =
      "Vui lòng chọn Ngành hàng";

  static String CREATE_PRODUCT_MARKET_CLASSIFY_CATEGORY_PRODUCT_TITLE =
      "Phân loại hàng";
  static String CREATE_PRODUCT_MARKET_ADD_CLASSIFY_GROUP =
      "Thêm nhóm phân loại";

  static String CREATE_PRODUCT_MARKET_PRICE_TITLE = "Giá";
  static String CREATE_PRODUCT_MARKET_PRICE_PLACEHOLDER =
      "Nhập giá của sản phẩm";

  static String CREATE_PRODUCT_MARKET_REPOSITORY_TITLE = "Kho hàng";
  static String CREATE_PRODUCT_MARKET_REPOSITORY_PLACEHOLDER =
      "Nhập tên kho hàng";
  static String CREATE_PRODUCT_MARKET_REPOSITORY_WARING =
      "Vui lòng nhập tên kho hàng";

  static String CREATE_PRODUCT_MARKET_SKU_TITLE = "SKU";
  static String CREATE_PRODUCT_MARKET_SKU_PLACEHOLDER = "Nhập SKU";
  // static String CREATE_PRODUCT_MARKET_SKU_WARING =
  //     "Vui lòng nhập tên kho hàng";
}

class SearchMarketConstants {
  static const SEARCH_MARKET_SEARCH_LIST_SELECTIONS =
      CreateProductMarketConstants.CREATE_PRODUCT_MARKET_CATEGORY_SELECTIONS;
}

class CartMarketConstants {
  static const CART_MARKET_CART_TITLE = "Giỏ hàng";
  static const CART_MARKET_ALL_TITLE = "Tất cả";
  static const CART_MARKET_ALL_PAYMENT = "Tổng thanh toán";
  static const CART_MARKET_BUY_PRODUCT = "Mua hàng";
  static const CART_MARKET_FIX_TITLE = "Sửa";
  static const CART_MARKET_DELETE_CART_TITLE = "Xóa";

  static const Map<String, dynamic> CART_MARKET_CART_DATA = {
    "items": [
      {
        "quantity": 10,
        "product_variant": {
          "id": "23",
          "product_id": 7,
          "title": "ÁO ĐẤU SÂN NHÀ REAL MADRID 21/22 - trắng",
          "price": 250000.0,
          "compare_at_price": null,
          "sku": "REALMADRID1",
          "position": 1,
          "option1": "White",
          "option2": null,
          "weight": 0.25,
          "weight_unit": "Kg",
          "inventory_quantity": 100,
          "old_inventory_quantity": 100,
          "requires_shipping": true,
          "created_at": "2022-12-27T11:53:40.201+07:00",
          "updated_at": "2022-12-27T11:53:40.201+07:00",
          "image": {
            "id": "109583844336412733",
            "type": "image",
            "url":
                "https://snapi.emso.asia/system/media_attachments/files/109/583/844/336/412/733/original/3041cb0fcfcac917.jpeg",
            "preview_url":
                "https://snapi.emso.asia/system/media_attachments/files/109/583/844/336/412/733/small/3041cb0fcfcac917.jpeg",
            "remote_url": null,
            "preview_remote_url": null,
            "text_url": null,
            "meta": {
              "original": {
                "width": 600,
                "height": 600,
                "size": "600x600",
                "aspect": 1.0,
                "average_color": "#c1bdc0"
              },
              "small": {
                "width": 400,
                "height": 400,
                "size": "400x400",
                "aspect": 1.0,
                "average_color": "#c1bdc0"
              }
            },
            "description": null,
            "blurhash": "UMNAh*_3~q-=?boz%g8_xVWCW?M{f5kCozWA",
            "status_id": "",
            "show_url": null,
            "created_at": "2022-12-27T11:52:45.384+07:00",
            "frame": null
          }
        }
      },
      {
        "quantity": 23,
        "product_variant": {
          "id": "23",
          "product_id": 7,
          "title": "ÁO ĐẤU  - trắng",
          "price": 250000.0,
          "compare_at_price": null,
          "sku": "REALMADRID1",
          "position": 1,
          "option1": "White",
          "option2": null,
          "weight": 0.25,
          "weight_unit": "Kg",
          "inventory_quantity": 100,
          "old_inventory_quantity": 100,
          "requires_shipping": true,
          "created_at": "2022-12-27T11:53:40.201+07:00",
          "updated_at": "2022-12-27T11:53:40.201+07:00",
          "image": {
            "id": "109583844336412733",
            "type": "image",
            "url":
                "https://snapi.emso.asia/system/media_attachments/files/109/583/844/336/412/733/original/3041cb0fcfcac917.jpeg",
            "preview_url":
                "https://snapi.emso.asia/system/media_attachments/files/109/583/844/336/412/733/small/3041cb0fcfcac917.jpeg",
            "remote_url": null,
            "preview_remote_url": null,
            "text_url": null,
            "meta": {
              "original": {
                "width": 600,
                "height": 600,
                "size": "600x600",
                "aspect": 1.0,
                "average_color": "#c1bdc0"
              },
              "small": {
                "width": 400,
                "height": 400,
                "size": "400x400",
                "aspect": 1.0,
                "average_color": "#c1bdc0"
              }
            },
            "description": null,
            "blurhash": "UMNAh*_3~q-=?boz%g8_xVWCW?M{f5kCozWA",
            "status_id": "",
            "show_url": null,
            "created_at": "2022-12-27T11:52:45.384+07:00",
            "frame": null
          }
        }
      },
      {
        "quantity": 10,
        "product_variant": {
          "id": "23",
          "product_id": 7,
          "title": "ÁO ĐẤU SÂN NHÀ REAL MADRID 21/22 - trắng",
          "price": 250000.0,
          "compare_at_price": null,
          "sku": "REALMADRID1",
          "position": 1,
          "option1": "White",
          "option2": null,
          "weight": 0.25,
          "weight_unit": "Kg",
          "inventory_quantity": 100,
          "old_inventory_quantity": 100,
          "requires_shipping": true,
          "created_at": "2022-12-27T11:53:40.201+07:00",
          "updated_at": "2022-12-27T11:53:40.201+07:00",
          "image": {
            "id": "109583844336412733",
            "type": "image",
            "url":
                "https://snapi.emso.asia/system/media_attachments/files/109/583/844/336/412/733/original/3041cb0fcfcac917.jpeg",
            "preview_url":
                "https://snapi.emso.asia/system/media_attachments/files/109/583/844/336/412/733/small/3041cb0fcfcac917.jpeg",
            "remote_url": null,
            "preview_remote_url": null,
            "text_url": null,
            "meta": {
              "original": {
                "width": 600,
                "height": 600,
                "size": "600x600",
                "aspect": 1.0,
                "average_color": "#c1bdc0"
              },
              "small": {
                "width": 400,
                "height": 400,
                "size": "400x400",
                "aspect": 1.0,
                "average_color": "#c1bdc0"
              }
            },
            "description": null,
            "blurhash": "UMNAh*_3~q-=?boz%g8_xVWCW?M{f5kCozWA",
            "status_id": "",
            "show_url": null,
            "created_at": "2022-12-27T11:52:45.384+07:00",
            "frame": null
          }
        }
      },
      {
        "quantity": 10,
        "product_variant": {
          "id": "23",
          "product_id": 7,
          "title": "ÁO ĐẤU SÂN NHÀ REAL MADRID 21/22 - trắng",
          "price": 250000.0,
          "compare_at_price": null,
          "sku": "REALMADRID1",
          "position": 1,
          "option1": "White",
          "option2": null,
          "weight": 0.25,
          "weight_unit": "Kg",
          "inventory_quantity": 100,
          "old_inventory_quantity": 100,
          "requires_shipping": true,
          "created_at": "2022-12-27T11:53:40.201+07:00",
          "updated_at": "2022-12-27T11:53:40.201+07:00",
          "image": {
            "id": "109583844336412733",
            "type": "image",
            "url":
                "https://snapi.emso.asia/system/media_attachments/files/109/583/844/336/412/733/original/3041cb0fcfcac917.jpeg",
            "preview_url":
                "https://snapi.emso.asia/system/media_attachments/files/109/583/844/336/412/733/small/3041cb0fcfcac917.jpeg",
            "remote_url": null,
            "preview_remote_url": null,
            "text_url": null,
            "meta": {
              "original": {
                "width": 600,
                "height": 600,
                "size": "600x600",
                "aspect": 1.0,
                "average_color": "#c1bdc0"
              },
              "small": {
                "width": 400,
                "height": 400,
                "size": "400x400",
                "aspect": 1.0,
                "average_color": "#c1bdc0"
              }
            },
            "description": null,
            "blurhash": "UMNAh*_3~q-=?boz%g8_xVWCW?M{f5kCozWA",
            "status_id": "",
            "show_url": null,
            "created_at": "2022-12-27T11:52:45.384+07:00",
            "frame": null
          }
        }
      }
    ]
  };
}

class InterestProductMarketConstants {
  static Map<String, dynamic> INTEREST_PRODUCT_BOTTOM_SELECTIONS = {
    "key": "interest_product_bottom_selections",
    "data": [
      {"icon": Icon(FontAwesomeIcons.envelope), "title": "Mời"},
      {"icon": Icon(FontAwesomeIcons.share), "title": "Chia sẻ"},
      {"icon": Icon(FontAwesomeIcons.copy), "title": "Sao chép"},
    ]
  };
  static const Map<String, dynamic> INTEREST_PRODUCT_BOTTOM_SHARE_SELECTIONS = {
    "key": "interest_product_bottom_selections",
    "data": [
      {"icon": Icon(FontAwesomeIcons.share), "title": "Chia sẻ ngay"},
      {
        "icon": Icon(FontAwesomeIcons.noteSticky),
        "title": "Chia sẻ lên bảng tin"
      },
      {
        "icon": Icon(FontAwesomeIcons.groupArrowsRotate),
        "title": "Chia sẻ lên nhóm"
      },
      {
        "icon": Icon(FontAwesomeIcons.noteSticky),
        "title": "Chia sẻ lên trang cá nhân"
      },
      {"icon": Icon(FontAwesomeIcons.copy), "title": "Sao chép liên kết"},
    ]
  };
  static Map<String, dynamic> INTEREST_PRODUCT_BOTTOM_GROUP_SHARE_SELECTIONS = {
    "key": "",
    "data": [
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Hoạt Hình Trung Quốc - Chinese Animation",
        "susbTitle": "Nhóm riêng tư - 4,9K thành viên",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_2.png",
        "title": "Nhóm thông tin sinh viên NEU",
        "susbTitle": "Nhóm công khai - 9K thành viên",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_3.png",
        "title": "Mobile Development Jobs VN",
        "susbTitle": "Nhóm riêng tư - 5K thành viên",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_4.png",
        "title": "Tuyển dụng Flutter tại Việt Nam",
        "susbTitle": "Nhóm công khai - 4K thành viên",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Hoạt Hình Trung Quốc - Chinese Animation",
        "susbTitle": "Nhóm riêng tư - 4,9K thành viên",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_2.png",
        "title": "Nhóm thông tin sinh viên NEU",
        "susbTitle": "Nhóm công khai - 9K thành viên",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_3.png",
        "title": "Mobile Development Jobs VN",
        "susbTitle": "Nhóm riêng tư - 5K thành viên",
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_4.png",
        "title": "Tuyển dụng Flutter tại Việt Nam",
        "susbTitle": "Nhóm công khai - 4K thành viên",
      },
    ],
  };
  static Map<String, dynamic> INTEREST_PRODUCT_BOTTOM_PERSONAL_PAGE_SELECTIONS =
      {
    "key": "",
    "data": [
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Nguyên Văn A",
        "subTitle": ""
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_2.png",
        "title": "Nguyên Văn B",
        "subTitle": ""
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_3.png",
        "title": "Tuyển dụng Flutter tại Việt Nam",
        "subTitle": ""
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_4.png",
        "title": "Mobile Development Jobs VN",
        "subTitle": ""
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_1.png",
        "title": "Nguyên Văn C",
        "subTitle": ""
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_2.png",
        "title": "Nguyên Văn D",
        "subTitle": ""
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_3.png",
        "title": "Tuyển dụng Flutter tại Việt Nam",
        "subTitle": ""
      },
      {
        "icon": MarketPlaceConstants.PATH_IMG + "cat_4.png",
        "title": "Mobile Development Jobs VN",
        "subTitle": ""
      },
    ]
  };

  static const String INTEREST_PRODUCT_SEARCH_GROUP_PLACEHOLDER =
      "Tìm kiếm nhóm của bạn";
  static const String INTEREST_PRODUCT_SEARCH_FRIEND_PLACEHOLDER =
      "Tìm kiếm bạn của bạn";
}

class ManageProductMarketConstants {
  static Map<String, dynamic> MANAGE_PRODUCT_BOTTOM_SELECTIONS = {
    "key": "manage_product_bottom_selections",
    "name": "Đồng Hồ Chế Tác Kim Cương Rolex Yacht Master Black Dial, 42mm",
    "data": [
      {
        "classify_category": "Black M",
        "sku": " CoolMax4",
        "price": Random().nextDouble() * 3000000,
        "repository": Random().nextInt(2000)
      },
      {
        "classify_category": "Black L",
        "sku": " CoolMax4",
        "price": Random().nextDouble() * 3000000,
        "repository": Random().nextInt(2000)
      },
      {
        "classify_category": "Black A",
        "sku": " CoolMax4",
        "price": Random().nextDouble() * 3000000,
        "repository": Random().nextInt(2000)
      },
      {
        "classify_category": "Black X",
        "sku": " CoolMax4",
        "price": Random().nextDouble() * 3000000,
        "repository": Random().nextInt(2000)
      },
      {
        "classify_category": "Black E",
        "sku": " CoolMax4",
        "price": Random().nextDouble() * 3000000,
        "repository": Random().nextInt(2000)
      },
      {
        "classify_category": "Black C",
        "sku": " CoolMax4",
        "price": Random().nextDouble() * 3000000,
        "repository": Random().nextInt(2000)
      },
      {
        "classify_category": "Black Y",
        "sku": " CoolMax4",
        "price": Random().nextDouble() * 3000000,
        "repository": Random().nextInt(2000)
      },
    ]
  };
}

class UpdateProductMarketConstants {
  static String UPDATE_PRODUCT_MARKET_ADD_IMG_TITLE = "Hình ảnh sản phẩm";
  static String UPDATE_PRODUCT_MARKET_ADD_IMG_PLACEHOLDER = "Thêm ảnh";
  static String UPDATE_PRODUCT_MARKET_ADD_IMG_WARING =
      "Vui lòng đăng tải tối thiểu 1 hình ảnh về sản phẩm này.";

  static String UPDATE_PRODUCT_MARKET_PRODUCT_VIDEO_TITLE = "Video sản phẩm";
  static String UPDATE_PRODUCT_MARKET_PRODUCT_VIDEO_PLACEHOLDER =
      "Tải lên Video Sản phẩm";
  static String UPDATE_PRODUCT_MARKET_PRODUCT_VIDEO_WARING =
      "Vui lòng đăng tải tối thiểu 1 hình ảnh về sản phẩm này.";

  static const String UPDATE_PRODUCT_MARKET_PRODUCT_NAME_TITLE = "Tên sản phẩm";
  static const String UPDATE_PRODUCT_MARKET_PRODUCT_NAME_PLACEHOLDER =
      "Nhập tên sản phẩm";
  static String UPDATE_PRODUCT_MARKET_PRODUCT_NAME_WARING =
      "Vui lòng nhập tên sản phẩm";

  static String UPDATE_PRODUCT_MARKET_CATEGORY_TITLE = "Danh mục";
  static const List<String> UPDATE_PRODUCT_MARKET_CATEGORY_SELECTIONS = [
    "Thời Trang và Phụ Kiện",
    "Du Lịch & Hành Lý",
    "Thời Trang và Phụ Kiện",
    "Thiết Bị Điện Gia Dụng",
    "Giày Dép",
    "Điện Thoại & Phụ kiện",
    "Thiết Bị Âm Thanh",
    "Thực Phẩm Và Đồ Uống",
    "Chăm Sóc Thú Cưng",
    "Thời Trang Trẻ Em & Trẻ Sơ Sinh",
    "Cameras & FlyCam",
    "Nhà Cửa & Đời Sống",
    "Thể Thao & Dã Ngoại",
    "Văn Phòng Phẩm",
    "Sở Thích & Thực Phẩm",
    "Sách & Tạp Chí",
    "Máy Tính & Laptop",
    "Moto & Xe Máy"
  ];
  static String UPDATE_PRODUCT_MARKET_CATEGORY_WARING =
      "Vui lòng chọn Danh mục ";

  static String UPDATE_PRODUCT_MARKET_BRANCH_PRODUCT_TITLE = "Ngành hàng";

  static String UPDATE_PRODUCT_MARKET_BRANCH_PRODUCT_WARING =
      "Vui lòng chọn Ngành hàng";

  static String UPDATE_PRODUCT_MARKET_DESCRIPTION_TITLE = "Mô tả sản phẩm";
  static const String UPDATE_PRODUCT_MARKET_DESCRIPTION_PLACEHOLDER =
      "Nhập mô tả sản phẩm";

  static String UPDATE_PRODUCT_MARKET_BRAND_TITLE = "Nhãn hiệu";
  static const String UPDATE_PRODUCT_MARKET_BRAND_PLACEHOLDER =
      "Nhập nhãn hiệu";
  static String UPDATE_PRODUCT_MARKET_BRAND_WARING =
      "Vui lòng điền vào Nhãn hiệu";

  static String UPDATE_PRODUCT_MARKET_PRIVATE_RULE_TITLE = "Quyền riêng tư";
  static const List<Map<String, dynamic>>
      UPDATE_PRODUCT_MARKET_PRIVATE_RULE_SELECTIONS = [
    {
      "key": "public",
      "icon": FontAwesomeIcons.earthAfrica,
      "title": "Công khai",
      "subTitle": "Tất cả mọi người"
    },
    {
      "key": "friend",
      "icon": FontAwesomeIcons.user,
      "title": "Bạn bè",
      "subTitle": "Bạn bè của bạn"
    },
    {
      "key": "private",
      "icon": FontAwesomeIcons.lock,
      "title": "Riêng tư",
      "subTitle": "Chỉ bạn bè được mời"
    },
  ];
  static String UPDATE_PRODUCT_MARKET_PRIVATE_RULE_WARING =
      "Vui lòng chọn Ngành hàng";

  static String UPDATE_PRODUCT_MARKET_CLASSIFY_CATEGORY_PRODUCT_TITLE =
      "Phân loại hàng";
  static String UPDATE_PRODUCT_MARKET_ADD_CLASSIFY_GROUP =
      "Thêm nhóm phân loại";

  static String UPDATE_PRODUCT_MARKET_PRICE_TITLE = "Giá";
  static String UPDATE_PRODUCT_MARKET_PRICE_PLACEHOLDER =
      "Nhập giá của sản phẩm";

  static String UPDATE_PRODUCT_MARKET_REPOSITORY_TITLE = "Kho hàng";
  static String UPDATE_PRODUCT_MARKET_REPOSITORY_PLACEHOLDER =
      "Nhập tên kho hàng";
  static String UPDATE_PRODUCT_MARKET_REPOSITORY_WARING =
      "Tên kho hàng không được để trống";

  static String UPDATE_PRODUCT_MARKET_SKU_TITLE = "SKU";
  static String UPDATE_PRODUCT_MARKET_SKU_PLACEHOLDER = "Nhập SKU";
}

class OrderProductMarketConstant {
  static List<Map<String, dynamic>> ORDER_PRODUCT_MARKET_TAB_LIST = [
    // {
    //   "key": "all",
    //   "icon": MarketPlaceConstants.PATH_ICON + "add_img_file_icon.svg",
    //   "title": "Tất cả",
    // },
    {
      "key": "pending",
      "icon": MarketPlaceConstants.PATH_ICON + "pending.png",
      "title": "Chờ thanh toán  ",
    },
    {
      "key": "delivered",
      "icon": MarketPlaceConstants.PATH_ICON + "delivered.png",
      "title": "Vận chuyển",
    },
    {
      "key": "shipping",
      "icon": MarketPlaceConstants.PATH_ICON + "shipping.png",
      "title": "Đang giao",
    },
    {
      "key": "finish",
      "icon": MarketPlaceConstants.PATH_ICON + "finish.png",
      "title": "Hoàn thành",
    },
    {
      "key": "cancelled",
      "icon": MarketPlaceConstants.PATH_ICON + "cancelled.png",
      "title": "Đã hủy        ",
    },
    {
      "key": "return",
      "icon": MarketPlaceConstants.PATH_ICON + "return.png",
      "title": "Trả hàng/ Hoàn tiền"
    },
  ];
}
