// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../util/app_constant.dart';
// import 'package:pinput/pinput.dart';
//
// class CustomLockScreen extends StatefulWidget {
//   const CustomLockScreen({Key? key}) : super(key: key);
//
//   @override
//   State<CustomLockScreen> createState() => _CustomLockScreenState();
// }
//
// class _CustomLockScreenState extends State<CustomLockScreen> {
//   final pinController = TextEditingController();
//   final focusNode = FocusNode();
//   @override
//   Widget build(BuildContext context) {
//     final defaultPinTheme = PinTheme(
//       width: 45.w,
//       height: 45.w,
//       textStyle: TextStyle(
//         fontSize: 22,
//         color: AppColors.white,
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10.r),
//         color: AppColors.textFiledLabelColor,
//       ),
//     );
//     return Stack(
//       children: [
//         Container(
//           height: 1.sh,
//           width: 1.sw,
//           child: Image.asset(
//             AppImage.imgBg,
//             fit: BoxFit.cover,
//           ),
//         ),
//         Scaffold(
//           backgroundColor: AppColors.homeBGColor,
//           body: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 margin: EdgeInsets.all(10.w),
//                 padding: EdgeInsets.all(15.w),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10.r),
//                   // color: AppColors.white,
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 30.h,
//                     ),
//                     Text(
//                       "Welcome",
//                       style: TextStyle(
//                           fontSize: 22.sp,
//                           color: AppColors.white,
//                           fontWeight: FontWeight.w600),
//                     ),
//                     SizedBox(
//                       height: 8.h,
//                     ),
//                     Text(
//                       "Enter your 6 digit PIN",
//                       style: TextStyle(fontSize: 16.sp, color: AppColors.white),
//                     ),
//                     SizedBox(
//                       height: 8.h,
//                     ),
//                     Directionality(
//                       textDirection: TextDirection.ltr,
//                       child: Pinput(
//                         controller: pinController,
//                         focusNode: focusNode,
//                         length: 6,
//                         // androidSmsAutofillMethod:
//                         // AndroidSmsAutofillMethod.smsUserConsentApi,
//                         // listenForMultipleSmsOnAndroid: true,
//                         defaultPinTheme: defaultPinTheme,
//                         // validator: (value) {
//                         //   return value == '2222' ? null : 'Pin is incorrect';
//                         // },
//                         // onClipboardFound: (value) {
//                         //   debugPrint('onClipboardFound: $value');
//                         //   pinController.setText(value);
//                         // },
//                         hapticFeedbackType: HapticFeedbackType.lightImpact,
//                         onCompleted: (pin) {
//                           debugPrint('onCompleted: $pin');
//                         },
//                         onChanged: (value) {
//                           debugPrint('onChanged: $value');
//                         },
//                         cursor: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Container(
//                               margin: EdgeInsets.only(bottom: 9),
//                               width: 22,
//                               height: 1,
//                               color: AppColors.white,
//                             ),
//                           ],
//                         ),
//                         focusedPinTheme: defaultPinTheme.copyWith(
//                           decoration: defaultPinTheme.decoration!.copyWith(
//                             borderRadius: BorderRadius.circular(10.r),
//                             color: AppColors.textFiledLabelColor,
//                           ),
//                         ),
//                         submittedPinTheme: defaultPinTheme.copyWith(
//                           decoration: defaultPinTheme.decoration!.copyWith(
//                             color: AppColors.textFiledLabelColor,
//                             borderRadius: BorderRadius.circular(10.r),
//                             // border: Border.all(color: focusedBorderColor),
//                           ),
//                         ),
//                         // errorPinTheme: defaultPinTheme.copyBorderWith(
//                         //   border: Border.all(color: Colors.redAccent),
//                         // ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10.h,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text(
//                           "Next",
//                           style: TextStyle(
//                               fontSize: 16.sp, color: AppColors.white),
//                         ),
//                         SizedBox(
//                           width: 6.h,
//                         ),
//                         Icon(
//                           Icons.arrow_forward_outlined,
//                           color: AppColors.white,
//                           size: 20.w,
//                         )
//                       ],
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
