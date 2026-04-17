import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:resize/resize.dart';
import '../../multi_language/language_constants.dart';
import '../api_services/get_service.dart';
import '../api_services/urls.dart';
import '../config/app_colors.dart';
import '../config/app_text_styles.dart';
import '../controllers/all_settings_controller.dart';
import '../controllers/general_controller.dart';
import '../controllers/teacher_book_appointment_controller.dart';
import '../controllers/payment_gateways_controller.dart';
import '../controllers/wallet_controller.dart';
import '../repositories/get_payment_gateways_repo.dart';
import '../repositories/get_wallet_balance_repo.dart';
import '../repositories/get_wallet_transactions_repo.dart';
import '../routes.dart';

import '../widgets/appbar_widget.dart';
import '../widgets/button_widget.dart';
import '../widgets/custom_skeleton_loader.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => WalletScreenState();
}

class WalletScreenState extends State<WalletScreen> {
  final items = List<String>.generate(20, (i) => 'Item ${i + 1}');
  final paymentGatewaysLogic = Get.put(PaymentGatewaysController());
  final walletLogic = Get.put(WalletController());
  final teacherAppointmentSchdulelogic =
      Get.put(TeacherAppointmentScheduleController());
  bool isVisibleTransactionsHistory = true;
  String? fromWebView = Get.parameters["fromWebView"];

  @override
  void initState() {
    super.initState();
    // Get All Wallet Balance
    getMethod(context, getWalletBalanceURL, null, true, getWalletBalanceRepo);
    // Get All Wallet Transactions
    getMethod(context, getWalletTransactionURL, null, true,
        getWalletTransactionsRepo);
    // Get All Payment Gateways
    getMethod(
        context, getPaymentGatewaysURL, null, false, getPaymentGatewaysRepo);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(builder: (generalController) {
      return GetBuilder<WalletController>(builder: (walletController) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: AppBarWidget(
              leadingIcon: 'assets/icons/Expand_left.png',
              leadingOnTap: () {
                fromWebView == "Yes"
                    ? Get.toNamed(PageRoutes.homeScreen)
                    : Get.back();
              },
              titleText: LanguageConstant.wallet.tr,
            ),
          ),
          body: !walletController.allWalletTransactionLoader
              ? CustomVerticalSkeletonLoader(
                  height: 200.h,
                  highlightColor: AppColors.grey,
                  seconds: 2,
                  totalCount: 5,
                  width: 140.w,
                )
              : Padding(
                  padding: EdgeInsets.fromLTRB(18.w, 0, 18.w, 0),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(18.w, 36.h, 18.w, 36.h),
                        decoration: BoxDecoration(
                          gradient: AppColors.gradientOne,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  Get.find<GetAllSettingsController>()
                                      .getDisplayAmount(int.parse(
                                          walletController
                                              .getWalletBalanceModel.data)),
                                  style: AppTextStyles.bodyTextStyle17,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  LanguageConstant.availableAmount.tr,
                                  style: AppTextStyles.bodyTextStyle16,
                                ),
                              ],
                            ),
                            ButtonWidgetOne(
                              borderRadius: 40,
                              buttonColor: AppColors.gradientFour,
                              buttonText: LanguageConstant.addToWallet.tr,
                              buttonTextStyle: AppTextStyles.buttonTextStyle7,
                              onTap: () {
                                Get.toNamed(PageRoutes.walletTopUpScreen);
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            LanguageConstant.transactionsHistory.tr,
                            style: AppTextStyles.headingTextStyle1,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 2,
                              visualDensity: const VisualDensity(
                                  horizontal: 0, vertical: 0),
                              backgroundColor: AppColors.primaryColor,
                              // minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              LanguageConstant.transactions.tr,
                              style: AppTextStyles.buttonTextStyle2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18.h),
                      walletController.walletTransactionForPagination.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: walletController
                                    .walletTransactionForPagination.length,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        14, 17, 14, 17),
                                    margin: const EdgeInsets.only(bottom: 18),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.4),
                                          spreadRadius: 0.5,
                                          blurRadius: 4,
                                          offset: Offset(0,
                                              5), // changes position of shadow
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${walletController.walletTransactionForPagination[index].id}",
                                          style: AppTextStyles.bodyTextStyle18,
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: Text(
                                            "${walletController.walletTransactionForPagination[index].type}",
                                            style:
                                                AppTextStyles.bodyTextStyle18,
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Text(
                                          Get.find<GetAllSettingsController>()
                                              .getDisplayAmount(int.parse(
                                                  walletController
                                                      .walletTransactionForPagination[
                                                          index]
                                                      .amount!)),
                                          style: AppTextStyles.bodyTextStyle18,
                                        ),
                                        SizedBox(width: 12.w),
                                        Text(
                                          generalController.displayDate(
                                              walletController
                                                  .walletTransactionForPagination[
                                                      index]
                                                  .createdAt),
                                          style: AppTextStyles.bodyTextStyle18,
                                        )
                                      ],
                                    ),
                                    // ),
                                  );
                                },
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.fromLTRB(0, 100.h, 0, 100.h),
                              child: Center(
                                child: Text(
                                  LanguageConstant.noDataFound.tr,
                                  style: AppTextStyles.bodyTextStyle2,
                                ),
                              ),
                            ),
                      walletController.walletTransactionForPagination.length >=
                              walletController.getWalletTransactionsModel.data!
                                  .meta!.perPage!
                          ? walletController
                                      .walletTransactionForPagination.length ==
                                  walletController.getWalletTransactionsModel
                                      .data!.data!.length
                              ? Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 18),
                                  width:
                                      MediaQuery.of(context).size.width * .35,
                                  child: generalController
                                          .getPaginationProgressCheck
                                      ? Container(
                                          height: generalController
                                                  .getPaginationProgressCheck
                                              ? 50.0
                                              : 0,
                                          color: Colors.transparent,
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                        )
                                      : ButtonWidgetOne(
                                          buttonText:
                                              LanguageConstant.loadMore.tr,
                                          onTap: () {
                                            walletController
                                                .walletTransactionPaginationDataLoad(
                                                    context);
                                          },
                                          buttonTextStyle:
                                              AppTextStyles.buttonTextStyle1,
                                          borderRadius: 40,
                                          buttonColor: AppColors.gradientOne,
                                        ))
                              : const SizedBox()
                          : const SizedBox(),
                    ],
                  ),
                ),
        );
      });
    });
  }
}
