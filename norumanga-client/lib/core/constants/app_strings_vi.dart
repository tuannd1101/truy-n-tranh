/// Vietnamese String Constants for MangaFlow Application
/// 
/// This file contains all Vietnamese text constants used throughout the application.
/// Constants are organized by logical grouping for easy maintenance and reference.
/// 
/// Usage: Import this file and reference constants via AppStringsVi.constantName
/// Example: Text(AppStringsVi.loginTitle)
class AppStringsVi {
  // Private constructor to prevent instantiation
  AppStringsVi._();

  // ═══════════════════════════════════════════════════════
  // AUTHENTICATION
  // ═══════════════════════════════════════════════════════
  static const String loginTitle = 'ĐĂNG NHẬP';
  static const String loginSubtitle = 'Chào mừng trở lại';
  static const String emailLabel = 'Email';
  static const String emailHint = 'otaku@mangaflow.com';
  static const String passwordLabel = 'Mật khẩu';
  static const String passwordHint = '••••••••';
  static const String signInButton = 'ĐĂNG NHẬP';
  static const String forgotPassword = 'Quên mật khẩu?';
  static const String newUserPrompt = 'Người dùng mới? ';
  static const String startJourney = 'Bắt đầu hành trình';
  static const String registerTitle = 'ĐĂNG KÝ';
  static const String registerSubtitle = 'Tạo tài khoản mới';
  static const String confirmPasswordLabel = 'Xác nhận mật khẩu';
  static const String signUpButton = 'ĐĂNG KÝ';
  static const String alreadyHaveAccount = 'Đã có tài khoản? ';
  static const String signInLink = 'Đăng nhập';
  static const String enterTheFlow = 'BƯỚC VÀO DÒNG CHẢY';
  static const String newCreator = 'Người dùng mới? ';
  static const String signIn = 'ĐĂNG NHẬP';
  static const String joinTheSquad = 'THAM GIA CỘNG ĐỒNG';
  static const String usernameLabel = 'TÊN NGƯỜI DÙNG';
  static const String usernameHint = 'Nhập tên của bạn';
  static const String startCreating = 'BẮT ĐẦU TẠO';
  static const String alreadyMemberSignIn = 'ĐÃ CÓ TÀI KHOẢN? ĐĂNG NHẬP';
  static const String registerSuccessMessage = 'Đăng ký thành công! Vui lòng đăng nhập.';
  static const String fillAllFieldsMessage = 'Vui lòng điền đủ thông tin';

  // ═══════════════════════════════════════════════════════
  // NAVIGATION
  // ═══════════════════════════════════════════════════════
  static const String homeNav = 'Trang chủ';
  static const String searchNav = 'Tìm kiếm';
  static const String libraryNav = 'Thư viện';
  static const String profileNav = 'Hồ sơ';
  static const String settingsNav = 'Cài đặt';
  static const String adminDashboardNav = 'Bảng điều khiển';

  // ═══════════════════════════════════════════════════════
  // HOME SCREEN
  // ═══════════════════════════════════════════════════════
  static const String searchPlaceholder = 'Tìm kiếm truyện, tác giả...';
  static const String allGenres = 'Tất cả';
  static const String featuredToday = 'NỔI BẬT HÔM NAY';
  static const String recentlyUpdated = 'MỚI CẬP NHẬT';
  static const String viewAll = 'XEM TẤT CẢ';
  static const String noMangaAvailable = 'Chưa có truyện nào.';
  static const String hotTag = 'HOT';
  static const String newTag = 'NEW';

  // ═══════════════════════════════════════════════════════
  // MANGA DETAIL SCREEN
  // ═══════════════════════════════════════════════════════
  static const String synopsis = 'Tóm tắt';
  static const String chapters = 'Chương';
  static const String readNow = 'ĐỌC NGAY';
  static const String addToLibrary = 'THÊM VÀO THƯ VIỆN';
  static const String share = 'CHIA SẺ';
  static const String author = 'Tác giả';
  static const String artist = 'Họa sĩ';
  static const String status = 'Trạng thái';
  static const String statusOngoing = 'Đang tiến hành';
  static const String statusCompleted = 'Hoàn thành';
  static const String statusHiatus = 'Tạm ngưng';
  static const String genres = 'Thể loại';
  static const String rating = 'Đánh giá';

  // ═══════════════════════════════════════════════════════
  // READING SCREEN
  // ═══════════════════════════════════════════════════════
  static const String previousChapter = 'Chương trước';
  static const String nextChapter = 'Chương sau';
  static const String chapterList = 'Danh sách chương';
  static const String settings = 'Cài đặt';
  static const String readingMode = 'Chế độ đọc';
  static const String verticalScroll = 'Cuộn dọc';
  static const String horizontalPage = 'Lật ngang';

  // ═══════════════════════════════════════════════════════
  // PROFILE SCREEN
  // ═══════════════════════════════════════════════════════
  static const String myProfile = 'Hồ sơ của tôi';
  static const String readingHistory = 'Lịch sử đọc';
  static const String favorites = 'Yêu thích';
  static const String subscriptionStatus = 'Trạng thái đăng ký';
  static const String accountSettings = 'Cài đặt tài khoản';
  static const String logout = 'Đăng xuất';
  static const String editProfile = 'Chỉnh sửa hồ sơ';

  // ═══════════════════════════════════════════════════════
  // SUBSCRIPTION SCREEN
  // ═══════════════════════════════════════════════════════
  static const String subscriptionTitle = 'ĐĂNG KÝ PREMIUM';
  static const String subscriptionSubtitle = 'Mở khóa toàn bộ nội dung';
  static const String monthlyPlan = 'Gói tháng';
  static const String yearlyPlan = 'Gói năm';
  static const String subscribe = 'ĐĂNG KÝ';
  static const String currentPlan = 'Gói hiện tại';
  static const String renewalDate = 'Ngày gia hạn';
  static const String cancelSubscription = 'Hủy đăng ký';

  // ═══════════════════════════════════════════════════════
  // PAYMENT SCREEN
  // ═══════════════════════════════════════════════════════
  static const String paymentTitle = 'THANH TOÁN';
  static const String selectPaymentMethod = 'Chọn phương thức thanh toán';
  static const String creditCard = 'Thẻ tín dụng';
  static const String momo = 'Ví MoMo';
  static const String zalopay = 'ZaloPay';
  static const String bankTransfer = 'Chuyển khoản ngân hàng';
  static const String proceedToPayment = 'TIẾN HÀNH THANH TOÁN';
  static const String orderSummary = 'Tóm tắt đơn hàng';
  static const String total = 'Tổng cộng';

  // ═══════════════════════════════════════════════════════
  // PAYMENT RESULT SCREEN
  // ═══════════════════════════════════════════════════════
  static const String paymentSuccess = 'Thanh toán thành công!';
  static const String paymentFailed = 'Thanh toán thất bại';
  static const String paymentPending = 'Đang xử lý thanh toán';
  static const String returnToHome = 'VỀ TRANG CHỦ';
  static const String tryAgain = 'THỬ LẠI';
  static const String transactionId = 'Mã giao dịch';

  // ═══════════════════════════════════════════════════════
  // SEARCH SCREEN
  // ═══════════════════════════════════════════════════════
  static const String searchTitle = 'TÌM KIẾM';
  static const String searchHint = 'Nhập tên truyện hoặc tác giả...';
  static const String recentSearches = 'Tìm kiếm gần đây';
  static const String popularSearches = 'Tìm kiếm phổ biến';
  static const String searchResults = 'Kết quả tìm kiếm';
  static const String noResults = 'Không tìm thấy kết quả';
  static const String clearHistory = 'Xóa lịch sử';

  // Manga Search feature
  static const String searchByTitleLabel = 'Tên truyện';
  static const String searchByTitleHint = 'Nhập tên truyện...';
  static const String searchByCreatorLabel = 'Tác giả / Họa sĩ';
  static const String searchByCreatorHint = 'Chọn tác giả hoặc họa sĩ';
  static const String searchByTagLabel = 'Thẻ';
  static const String searchByTagHint = 'Chọn thẻ';
  static const String searchSubmit = 'TÌM KIẾM';
  static const String searchClear = 'XÓA BỘ LỌC';
  static const String searchSelectCreatorTitle = 'CHỌN TÁC GIẢ / HỌA SĨ';
  static const String searchSelectTagTitle = 'CHỌN THẺ';
  static const String searchInitialPrompt =
      'Nhập từ khóa hoặc chọn bộ lọc để tìm truyện';
  static const String searchNoCreators = 'Chưa có tác giả nào.';
  static const String searchNoTags = 'Chưa có thẻ nào.';

  /// Result count phrase: "Tìm thấy {count} truyện"
  static String searchResultCount(int count) => 'Tìm thấy $count truyện';

  /// Page indicator: "Trang {current}/{total}"
  static String searchPageIndicator(int current, int total) =>
      'Trang $current/$total';

  // ═══════════════════════════════════════════════════════
  // LIBRARY SCREEN
  // ═══════════════════════════════════════════════════════
  static const String myLibrary = 'Thư viện của tôi';
  static const String reading = 'Đang đọc';
  static const String completed = 'Đã hoàn thành';
  static const String planToRead = 'Dự định đọc';
  static const String dropped = 'Đã bỏ';
  static const String sortBy = 'Sắp xếp theo';
  static const String sortByTitle = 'Tên truyện';
  static const String sortByDate = 'Ngày thêm';
  static const String sortByRating = 'Đánh giá';

  // ═══════════════════════════════════════════════════════
  // ADMIN DASHBOARD
  // ═══════════════════════════════════════════════════════
  static const String adminDashboard = 'BẢNG ĐIỀU KHIỂN QUẢN TRỊ';
  static const String manageManga = 'Quản lý Manga';
  static const String manageChapters = 'Quản lý chương';
  static const String manageUsers = 'Quản lý người dùng';
  static const String manageCreators = 'Quản lý tác giả';
  static const String manageTags = 'Quản lý thẻ';
  static const String statistics = 'Thống kê';
  static const String totalManga = 'Tổng số truyện';
  static const String totalUsers = 'Tổng số người dùng';
  static const String totalChapters = 'Tổng số chương';
  static const String recentActivity = 'Hoạt động gần đây';

  // ═══════════════════════════════════════════════════════
  // ADMIN CHAPTER SCREEN
  // ═══════════════════════════════════════════════════════
  static const String chapterManagement = 'QUẢN LÝ CHƯƠNG';
  static const String addChapter = 'THÊM CHƯƠNG';
  static const String editChapter = 'CHỈNH SỬA CHƯƠNG';
  static const String deleteChapter = 'XÓA CHƯƠNG';
  static const String chapterNumber = 'Số chương';
  static const String chapterTitle = 'Tiêu đề chương';
  static const String uploadPages = 'Tải lên trang';
  static const String publishDate = 'Ngày xuất bản';
  static const String chapterStatus = 'Trạng thái chương';
  static const String published = 'Đã xuất bản';
  static const String draft = 'Bản nháp';

  // ═══════════════════════════════════════════════════════
  // ADMIN CHAPTER DETAIL SCREEN
  // ═══════════════════════════════════════════════════════
  static const String chapterDetails = 'CHI TIẾT CHƯƠNG';
  static const String pageCount = 'Số trang';
  static const String views = 'Lượt xem';
  static const String likes = 'Lượt thích';
  static const String comments = 'Bình luận';
  static const String reorderPages = 'Sắp xếp lại trang';
  static const String replacePages = 'Thay thế trang';

  // ═══════════════════════════════════════════════════════
  // COMMON ACTIONS
  // ═══════════════════════════════════════════════════════
  static const String save = 'Lưu';
  static const String cancel = 'Hủy';
  static const String delete = 'Xóa';
  static const String edit = 'Chỉnh sửa';
  static const String add = 'Thêm';
  static const String update = 'Cập nhật';
  static const String confirm = 'Xác nhận';
  static const String close = 'Đóng';
  static const String back = 'Quay lại';
  static const String next = 'Tiếp theo';
  static const String previous = 'Trước';
  static const String submit = 'Gửi';
  static const String reset = 'Đặt lại';

  // ═══════════════════════════════════════════════════════
  // STATUS MESSAGES
  // ═══════════════════════════════════════════════════════
  static const String success = 'Thành công';
  static const String error = 'Lỗi';
  static const String loading = 'Đang tải...';
  static const String processing = 'Đang xử lý...';
  static const String saved = 'Đã lưu';
  static const String deleted = 'Đã xóa';
  static const String updated = 'Đã cập nhật';

  // ═══════════════════════════════════════════════════════
  // ERROR MESSAGES
  // ═══════════════════════════════════════════════════════
  static const String errorGeneric = 'Đã xảy ra lỗi. Vui lòng thử lại.';
  static const String errorNetwork = 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối của bạn.';
  static const String errorAuth = 'Xác thực thất bại. Vui lòng đăng nhập lại.';
  static const String errorNotFound = 'Không tìm thấy nội dung.';
  static const String errorPermission = 'Bạn không có quyền thực hiện hành động này.';
  static const String errorTimeout = 'Yêu cầu hết thời gian chờ. Vui lòng thử lại.';

  // ═══════════════════════════════════════════════════════
  // VALIDATION MESSAGES
  // ═══════════════════════════════════════════════════════
  static const String validationRequired = 'Trường này là bắt buộc';
  static const String validationEmail = 'Email không hợp lệ';
  static const String validationPassword = 'Mật khẩu phải có ít nhất 6 ký tự';
  static const String validationPasswordMatch = 'Mật khẩu không khớp';
  static const String validationMinLength = 'Độ dài tối thiểu là';
  static const String validationMaxLength = 'Độ dài tối đa là';
  static const String validationNumeric = 'Chỉ được nhập số';
  static const String validationEmailPassword = 'Vui lòng nhập email và mật khẩu';

  // ═══════════════════════════════════════════════════════
  // MANGA TERMINOLOGY (PRESERVED)
  // ═══════════════════════════════════════════════════════
  static const String manga = 'Manga';
  static const String chapter = 'Chapter';
  static const String premium = 'Premium';
  static const String free = 'Free';
  static const String vol = 'VOL';

  // ═══════════════════════════════════════════════════════
  // DUAL LABELS (Japanese + Vietnamese)
  // ═══════════════════════════════════════════════════════
  static const String genreShounen = '少年 Thiếu Niên';
  static const String genreShoujo = '少女 Thiếu Nữ';
  static const String genreSeinen = '青年 Thanh Niên';
  static const String genreJosei = '女性 Phụ Nữ';
  static const String genreKodomo = '子供 Trẻ Em';

  // ═══════════════════════════════════════════════════════
  // ADDITIONAL COMMON STRINGS
  // ═══════════════════════════════════════════════════════
  static const String okaeri = 'Okaeri!';
  static const String shounen = 'Shounen';
  static const String action = 'Action';
  static const String romance = 'Romance';
  static const String fantasy = 'Fantasy';
  static const String sciFi = 'Sci-fi';
  static const String horror = 'Horror';
}
