import '../config/app_configs.dart';

final String baseUrl = AppConfigs.baseUrl;
final String apiBaseUrl = AppConfigs.apiBaseUrl;
final String mediaUrl = AppConfigs.mediaUrl;

///---fcm
const String fcmService = 'https://fcm.googleapis.com/fcm/send';

///---auth
String signUpWithEmailURL = '${apiBaseUrl}auth/register';
String signInWithEmailURL = '${apiBaseUrl}auth/login';
String socialLoginURL = '${apiBaseUrl}auth/social_login';
String signOutURL = '${apiBaseUrl}auth/logout';
String deleteAccountURL = '${apiBaseUrl}auth/delete_account';
// String pusherBeamsURL = '${apiBaseUrl}pusher/beams-auth';

///---logged-in-user
String getLoggedInUserUrl = '${apiBaseUrl}auth/user';

String contactUsUrl = '${apiBaseUrl}contact';

//---edit-or-update-profile
String editUserProfileURL = '${apiBaseUrl}students/update_general_info';

///---consultant-profile-by-id
String getTeacherProfileUrl = '${apiBaseUrl}teachers/';

///--Profile-DropDowns
String countryURL = '${apiBaseUrl}countries';
String stateURL = '${apiBaseUrl}states?country_id=';
String cityURL = '${apiBaseUrl}cities?country_id=';

///---featured
String getFeaturedEvents = '${apiBaseUrl}featured_events';
String getFeaturedTeachers = '${apiBaseUrl}featured_teachers';

///---all listings
String getAllTeachers = '${apiBaseUrl}filter_teachers';
String getTeachersByCategory = '${apiBaseUrl}filter_teachers?teacher_category=';
String getTeachersBySubCategory =
    '${apiBaseUrl}filter_teachers?teacher_subcategory=';
String getAllBlogsPosts = '${apiBaseUrl}filter_posts';
String getAllEvents = '${apiBaseUrl}filter_events';
String getAllServices = '${apiBaseUrl}filter_services';
String getAllAcademies = '${apiBaseUrl}filter_academies';

///---categories
String getTeacherCategoriesURL = '${apiBaseUrl}teacher_categories';
String getTeacherMainCategoriesURL =
    '${apiBaseUrl}teacher_main_categories_with_childrens';

///---top-rated
String getTopRatedTeachers = '${apiBaseUrl}top_rated_teachers';

///---book-appointment
String getScheduleAvailableDaysURL =
    '${apiBaseUrl}get-scheduled-available-days';
String getScheduleSlotsForMenteeUrl = '${apiBaseUrl}get-date-schedule';
String bookAppointmentUrl = '${apiBaseUrl}bookAppointment';

///---appointment-log-user
String getAppointmentsDetailURL = '${apiBaseUrl}appointmentDetails';

/// Blogs
String categoriesBlogUrl = '${apiBaseUrl}categoriesBlogs';
String blogCategoriesUrl = '${apiBaseUrl}blogCategories';
String createConsultantBlogUrl = '${apiBaseUrl}create_consultant_blog';
String consultantBlogUrl = '${apiBaseUrl}consultant_blogs';
String blogDetailUrl = '${apiBaseUrl}blogDetail';
String updateConsultantBlogUrl = '${apiBaseUrl}update_consultant_blog';
String deleteConsultantBlogUrl = '${apiBaseUrl}delete_consultant_blog';

/// wallet
String getWalletBalanceURL = '${apiBaseUrl}get_current_balance';
String getWalletTransactionURL = '${apiBaseUrl}get_wallet_transactions';
String getWalletWithdrawalURL = '${apiBaseUrl}get_wallet_withdrawls';
String walletTopupURL = '${apiBaseUrl}add-to-wallet';

///---teacher-reviews
String getTeacherReviews = '${apiBaseUrl}filter_teacher_reviews';

///---teacher-podcasts
String getTeacherPodcasts = '${apiBaseUrl}filter_teacher_podcasts';

///---teacher-broadcasts
String getTeacherBroadcasts = '${apiBaseUrl}filter_teacher_broadcasts';

///---academy-reviews
String getAcademyReviews = '${apiBaseUrl}filter_academy_reviews';

///---agora
// String agoraTokenUrl = apiBaseUrl + 'agoraToken';
String agoraTokenUrl = '${apiBaseUrl}students/api_generate_agora_token';
String pusherBeamsAuthUrl = '${apiBaseUrl}pusher/beams-auth';

///---chat services
String getMessagesUrl = '${apiBaseUrl}students/api_get_chat_messages/';
String sendMessageUrl = '${apiBaseUrl}students/api_send_chat_message';

///---reset-password
String forgotPasswordUrl = '${apiBaseUrl}auth/forgot_password';
String newPasswordUrl = '${apiBaseUrl}reset-password';

/// All Settings
String getAllSettingUrl = '${apiBaseUrl}settings';

/// All Languages
String getAllLanguagesUrl = '${apiBaseUrl}get_all_languages';

/// Get Terms and Conditions
String getTermsConditionsUrl = '${apiBaseUrl}terms_conditions';

// Get Teacher Appointment Types
String getTeacherAppointmentTypes = '${apiBaseUrl}teachers/profile/';

// Get Teacher Book Appointment
String getTeacherBookAppointment = '${apiBaseUrl}teachers/profile/';

// Student Book Appointment
String studentBookAppointment = '${apiBaseUrl}students/book_appointment';

// Student Book Service
String studentBookService = '${apiBaseUrl}students/book_service';

// Stripe Payment API URL
String stripePaymentUrl = "https://api.stripe.com/v1/payment_intents";

// Get Student Appointment History
String getStudentAppointmentHistory =
    "${apiBaseUrl}students/get_filter_appointment_logs";

// Get Student Booked Services History
String getStudentBookedServicesHistory =
    "${apiBaseUrl}students/get_filter_service_logs";

// Content Pages URls
String contentPagesURL = "${apiBaseUrl}company_page";

// Content Pages URls
String getPaymentGatewaysURL = "${apiBaseUrl}gateways";

// Open Web View For Payment URls
String webViewPaymentURL = "${baseUrl}add_fund_confirm";
