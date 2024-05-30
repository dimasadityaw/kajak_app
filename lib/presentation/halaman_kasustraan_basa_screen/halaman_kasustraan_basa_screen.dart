// import 'package:flutter/cupertino.dart';
// import 'package:kajak/core/app_export.dart';
//
// class WulanganmenuItemWidget extends StatelessWidget {
//   const WulanganmenuItemWidget({Key? key})
//       : super(
//     key: key,
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Padding(
//         padding: EdgeInsets.only(
//           left: 1.h,
//           top: 19.v,
//         ),
//         child: ListView.separated(
//             physics: BouncingScrollPhysics(),
//             shrinkWrap: true,
//             separatorBuilder: (
//                 context,
//                 index,
//                 ) {
//               return SizedBox(
//                 height: 12.v,
//               );
//             },
//             itemCount: 1,
//             itemBuilder: (context, index) {
//               return Column(
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(context, AppRoutes.halamanKawruhBasaSubMenuArananAnakKewanOpenScreen);
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 29.h,
//                         vertical: 13.v,
//                       ),
//                       decoration: AppDecoration.outlineBlack900.copyWith(
//                         borderRadius: BorderRadiusStyle.roundedBorder10,
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SizedBox(height: 3.v),
//                           Text(
//                             "Paribasan",
//                             style: theme.textTheme.titleMedium,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(
//                               top: 3.v,
//                               right: 22.h,
//                             ),
//                             child: Text(
//                               "Pelajari apa saja Paribasan (Pribahasa dalam bahasa jawa)"
//                                   "                        ",
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: CustomTextStyles.labelLargeMedium,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 12.v,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(context, AppRoutes.halamanKawruhBasaSubMenu);
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 29.h,
//                         vertical: 13.v,
//                       ),
//                       decoration: AppDecoration.outlineBlack900.copyWith(
//                         borderRadius: BorderRadiusStyle.roundedBorder10,
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SizedBox(height: 3.v),
//                           Text(
//                             "Tembang",
//                             style: theme.textTheme.titleMedium,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(
//                               top: 3.v,
//                               right: 22.h,
//                             ),
//                             child: Text(
//                               "Pelajari apa saja tembang (Lirik/Sajak) dalam bahasa jawa"
//                                   "                        ",
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: CustomTextStyles.labelLargeMedium,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 12.v,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       Navigator.pushNamed(context, AppRoutes.halamanKawruhBasaSubMenuArananWektuOpenScreen);
//                     },
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 29.h,
//                         vertical: 13.v,
//                       ),
//                       decoration: AppDecoration.outlineBlack900.copyWith(
//                         borderRadius: BorderRadiusStyle.roundedBorder10,
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           SizedBox(height: 3.v),
//                           Text(
//                             "Parikan",
//                             style: theme.textTheme.titleMedium,
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(
//                               top: 3.v,
//                               right: 22.h,
//                             ),
//                             child: Text(
//                               "Pelajari apa saja Parikan (Puisi) dalam bahasa jawa"
//                                   "                        ",
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: CustomTextStyles.labelLargeMedium,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//
//                 ],
//               );
//             }),
//       ),
//     );
//   }
// }