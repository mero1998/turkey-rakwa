mixin ApiKey {
  static const String baseUrl = 'https://rakwa.com/api/';
  static const String baseUrl2 = 'https://rakwa.me/api/v2/client/vendor/';
  static const String baseUrl3 = 'https://rakwa.me/api/v2/client/';
  static const String baseUrl4 = 'https://rakwa.me/api/user/';
  static const String baseUrl5 = 'https://rakwa.me/api/v2/';
  static const String baseUrl6 = 'https://rakwa.me/api/v2/vendor/';


  //
  static const String subscriptions = '${baseUrl}subscriptions';
  static const String create_ads = '${baseUrl}create-smartads';

  // Auth Url
  static const String register = '${baseUrl}register';
  static const String registerUser = '${baseUrl}register-user';
  static const String login = '${baseUrl}login';
  static const String logout = '${baseUrl}logout';
  static const String forgetPassword = '${baseUrl}password/email';
  static const String checkCode = '${baseUrl}password/code/check';
  static const String resetPassword = '${baseUrl}password/reset';
  static const String emailVerification = '${baseUrl}resend/email';

  // Home Url
  static const String appInterface = '${baseUrl}app_interface';
  static const String allCategories = '${baseUrl}all-categories';
  static const String allClassifiedCtegories =
      '${baseUrl}all-classified-categories';
  static const String paidItems = '${baseUrl}paid-items/v1';
  static const String res = '${baseUrl}restaurant-menu';
  static const String superMarkets = '${baseUrl}supermarket-menu';
  static const String candies = '${baseUrl}candies-menu';
  static const String bakeries = '${baseUrl}bakeries-menu';
  static const String meats = '${baseUrl}meat-menu';
  static const String nearestItems = '${baseUrl}nearby-items/v1';
  static const String paidClassified = '${baseUrl}paid-classified';
  static const String popularItems = '${baseUrl}popular-items/v1';
  static const String popularClassified = '${baseUrl}popular-classified/v1';
  static const String nearestClassified = '${baseUrl}nearby-classified/v1';
  static const String latestItems = '${baseUrl}latest-items/v1';
  static const String latestClassified = '${baseUrl}latest-classified/v1';
  static const String backgroundImage = '${baseUrl}background-image';
  static const String verifiedEmail = '${baseUrl}profile-user/';

  // Artical Url
  static const String artical = '${baseUrl}blog/v1';

  // Last Activities
  static const String lastActivites = '${baseUrl}last-activity';

  // Classified By ID Url
  static const String classifiedById = '${baseUrl}user/';

  // List Url
  static const String country = '${baseUrl}user/country';
  static const String city = '${baseUrl}user/city';
  static const String state = '${baseUrl}user/state';
  static const String category = '${baseUrl}user/category';
  static const String addList = '${baseUrl}user/';

  // details
  static const String itemDetails = '${baseUrl}item/';
  static const String classifiedDetails = '${baseUrl}classified/';
  static const String nearbyItems = '${baseUrl}nearby-items';

  // User
  static const String user = '${baseUrl}user/';

  // Item and classified with category
  // static const String itemWithCategory = '${user}category-item/';
  static const String itemWithCategory = '${baseUrl}category_item_v4/';
  // static const String classifiedWithCategory = '${user}classified-categorys/';
  static const String classifiedWithCategory =
      '${user}classified-categorys-test/';

  // Classified Category
  static const String classifiedCategory = '${baseUrl}user/classified-category';

  // Search
  static const String search = '${baseUrl}search?';

  // Custom Fields
  static const String customFields = '${baseUrl}custom-fields';
  static const String customClassifiedFields = '${baseUrl}custom-field';

  // Cotact About Url
  static const String about = '${baseUrl}about';
  static const String contact = '${baseUrl}contact';
  static const String createContact = '${baseUrl}create-contact';
  static const String termsOfService = '${baseUrl}terms-of-service';
  static const String privacyPolicy = '${baseUrl}privacy-policy';

  // FCM token
  static const String fcmToken = '${baseUrl}store';

  // Create Review
  static const String createReview = '${baseUrl}create-reviews/';

  // Create comments
  static const String createComment = '${baseUrl}create-comments';
  static const String createReplayComment = '${baseUrl}reply-comments/';

  // Question and Answer
  static const String questions = '${baseUrl}questions';
  static const String createQuestion = '${baseUrl}create-question';
  static const String createAnswer = '${baseUrl}create-answer';
  static const String answers = '${baseUrl}question-answer/';
  static const String like = '${baseUrl}create-review';
  static const String dislike = '${baseUrl}delete-review/';
  static const String updateAnswer = '${baseUrl}update-answer/';
  static const String deleteAnswer = '${baseUrl}delete-answer/';
  static const String replyAnswer = '${baseUrl}reply-answer/';

  // report

  static const String createReport = '${baseUrl}create-report';

  // menu
  static const String menu = '${baseUrl2}restaurant/';
  static const String categoryItems = '/category/items';

  // cart
  static const String addToCart = '${baseUrl2}cart-add';
  static const String getCart = '${baseUrl2}cart-getContent/';
  static const String updateCart = '${baseUrl2}update-cart/';
  static const String destroyCart = '${baseUrl2}destroy-cart/';
  static const String destroyAllCart = '${baseUrl6}destroy-cart/';

  // register users to new website
  static const String registerToNewWebsite =
      'https://rakwa.me/api/v2/client/auth/registers';
  static const String getNewToken =
      'https://rakwa.me/api/v2/client/auth/gettoken';

  //address
  static const String add_address = '${baseUrl3}addresses';
  static const String create_orders = '${baseUrl3}orders/orders';
  static const String create_book_orders = '${baseUrl3}orders/orders/v1';
  static const String all_orders = '${baseUrl3}orders/all/';

  // Terms
  static const String terms = '${baseUrl3}terms';

  // delivery cost
  static const String fees = '${baseUrl3}fees-v1/';

  //https://rakwa.me/api/v2/client/event
  static const String create_event = '${baseUrl3}event';
  static const String show_all_event = '${baseUrl3}show-all-event/';

  // coupon
  static const String coupon = '${baseUrl6}coupon';
}
