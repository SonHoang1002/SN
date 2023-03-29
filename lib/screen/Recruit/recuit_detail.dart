import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/providers/recruit/recruit_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class RecruitDetail extends ConsumerStatefulWidget {
  final dynamic data;
  const RecruitDetail({Key? key, this.data}) : super(key: key);

  @override
  ConsumerState<RecruitDetail> createState() => _RecruitDetailState();
}

class _RecruitDetailState extends ConsumerState<RecruitDetail> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(
          Duration.zero,
              () =>
              ref
                  .read(recruitControllerProvider.notifier)
                  .getDetailRecruit(widget.data['id']));
    }
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var recruitDetail = ref.watch(recruitControllerProvider).detailRecruit;
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          alignment: Alignment.centerLeft,
          icon: Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(width: 0.2, color: greyColor)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(FontAwesomeIcons.angleLeft, color: Colors.white, size: 18),
              ],
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0.0,
      ),
      body: recruitDetail.isNotEmpty
          ? Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0.0, 2.0),
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Hero(
                        tag: recruitDetail['banner']['url'] ?? "",
                        child: ClipRRect(
                          child: ImageCacheRender(
                            path: recruitDetail['banner']['url'] ?? "",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    // Hàng 1
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            leading: Icon(Icons.access_alarm),
                            title: Text('Title 1'),
                            subtitle: Text('Subtitle 1'),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            leading: Icon(Icons.access_time),
                            title: Text('Title 2'),
                            subtitle: Text('Subtitle 2'),
                          ),
                        ),
                      ],
                    ),
                    // Hàng 2
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            leading: Icon(Icons.account_balance),
                            title: Text('Title 3'),
                            subtitle: Text('Subtitle 3'),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            leading: Icon(Icons.account_box),
                            title: Text('Title 4'),
                            subtitle: Text('Subtitle 4'),
                          ),
                        ),
                      ],
                    ),
                    // Hàng 3
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            leading: Icon(Icons.add_alarm),
                            title: Text('Title 5'),
                            subtitle: Text('Subtitle 5'),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            leading: Icon(Icons.add_circle),
                            title: Text('Title 6'),
                            subtitle: Text('Subtitle 6'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // SizedBox(
                //   child: Padding(
                //       padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                //       child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               (DateTime.parse(growDetail['due_date']).isBefore(DateTime.parse(DateTime.now().toString())))
                //                   == false ? GetTimeAgo.parse(
                //                 DateTime.parse(growDetail['due_date']),
                //               ) : 'Dự án đã kết thúc',
                //               style: const TextStyle(
                //                   fontSize: 16,
                //                   fontWeight: FontWeight.normal,
                //                   color: Colors.red),
                //             ),
                //             const SizedBox(
                //               height: 5,
                //             ),
                //             Text(
                //               growDetail['title'],
                //               maxLines: 2,
                //               style: const TextStyle(
                //                 fontSize: 24,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //             const SizedBox(
                //               height: 5,
                //             ),
                //             growDetail['project_relationship']['host_project'] == false ? Row(
                //               crossAxisAlignment:
                //               CrossAxisAlignment.start,
                //               mainAxisAlignment:
                //               MainAxisAlignment.spaceAround,
                //               children: [
                //                 InkWell(
                //                   onTap: () {
                //                     showModalBottomSheet(
                //                         shape:
                //                         const RoundedRectangleBorder(
                //                           borderRadius:
                //                           BorderRadius.vertical(
                //                             top: Radius.circular(15),
                //                           ),
                //                         ),
                //                         context: context,
                //                         builder: (context) => (DateTime.parse(growDetail['due_date']).isBefore(DateTime.parse(DateTime.now().toString()))) == false ? SizedBox(
                //                           height: 250,
                //                           child: ListView.builder(
                //                             itemCount:
                //                             growPriceTitle.length,
                //                             itemBuilder:
                //                                 (BuildContext context,
                //                                 int indexTitle) {
                //                               return ListTile(
                //                                 title: Text(
                //                                     '${growPriceTitle[indexTitle]['title']}',
                //                                     style: const TextStyle(
                //                                         fontWeight:
                //                                         FontWeight
                //                                             .w700)),
                //                                 subtitle: Text(
                //                                     '${growPriceTitle[indexTitle]['subTitle']}'),
                //                                 onTap: () {
                //                                   Navigator.pop(
                //                                       context);
                //                                   indexTitle != 2
                //                                       ? showModalBottomSheet(
                //                                       shape:
                //                                       const RoundedRectangleBorder(
                //                                         borderRadius:
                //                                         BorderRadius
                //                                             .vertical(
                //                                           top: Radius.circular(
                //                                               15),
                //                                         ),
                //                                       ),
                //                                       context:
                //                                       context,
                //                                       isScrollControlled:
                //                                       true,
                //                                       isDismissible:
                //                                       true,
                //                                       builder:
                //                                           (context) =>
                //
                //                                           SingleChildScrollView(
                //                                             primary: true,
                //                                             padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                //                                             child:ModalPayment(title: 'Tặng xu để ủng hộ ${growPriceTitle[indexTitle]['title'].toString().toLowerCase()} ${growDetail['title']}', buttonTitle: growPriceTitle[indexTitle]['title'], updateApi: (params) {
                //                                               if(params.isNotEmpty) {
                //                                                 ref
                //                                                     .read(growControllerProvider.notifier)
                //                                                     .updateTransactionDonate({
                //                                                   "amount": params['amount'],
                //                                                   "detail_type": growPriceTitle[indexTitle]['type'].toString()
                //                                                 }, growDetail['id']);
                //                                               }
                //                                             },),
                //                                           ) )
                //                                       : null;
                //                                 },
                //                               );
                //                             },
                //                           ),
                //                         ): const SizedBox(
                //                           height: 50,
                //                           child: Text('Dự án đã kết thúc'),
                //                         ));
                //                   },
                //                   child: Container(
                //                       height: 32,
                //                       width: MediaQuery.of(context)
                //                           .size
                //                           .width *
                //                           0.4,
                //                       decoration: BoxDecoration(
                //                           color: secondaryColor,
                //                           borderRadius:
                //                           BorderRadius.circular(4),
                //                           border: Border.all(
                //                               width: 0.2,
                //                               color: greyColor)),
                //                       child: Row(
                //                         mainAxisAlignment:
                //                         MainAxisAlignment.center,
                //                         children: const [
                //                           Icon(
                //                               FontAwesomeIcons
                //                                   .circleDollarToSlot,
                //                               color: Colors.white,
                //                               size: 14),
                //                           SizedBox(
                //                             width: 5.0,
                //                           ),
                //                           Text(
                //                             'Ủng hộ',
                //                             textAlign: TextAlign.center,
                //                             style: TextStyle(
                //                               fontSize: 12.0,
                //                               color: Colors.white,
                //                               fontWeight: FontWeight.w700,
                //                             ),
                //                           ),
                //                         ],
                //                       )),
                //                 ),
                //                 const SizedBox(width: 5),
                //                 InkWell(
                //                   onTap: () {
                //                     if (growButtonFollower) {
                //                       ref
                //                           .read(growControllerProvider
                //                           .notifier)
                //                           .updateStatusGrow(
                //                           growDetail['id'], false);
                //                     } else {
                //                       ref
                //                           .read(growControllerProvider
                //                           .notifier)
                //                           .updateStatusGrow(
                //                           growDetail['id'], true);
                //                     }
                //                     setState(() {
                //                       growButtonFollower =
                //                       !growButtonFollower;
                //                     });
                //                   },
                //                   child: Container(
                //                       height: 32,
                //                       width: MediaQuery.of(context)
                //                           .size
                //                           .width *
                //                           0.36,
                //                       decoration: BoxDecoration(
                //                           color:
                //                           growButtonFollower == true
                //                               ? secondaryColor
                //                               .withOpacity(0.45)
                //                               : const Color.fromARGB(
                //                               189, 202, 202, 202),
                //                           borderRadius:
                //                           BorderRadius.circular(4),
                //                           border: Border.all(
                //                               width: 0.2,
                //                               color: greyColor)),
                //                       child: Row(
                //                         mainAxisAlignment:
                //                         MainAxisAlignment.center,
                //                         children: [
                //                           Icon(FontAwesomeIcons.solidStar,
                //                               color: growButtonFollower ==
                //                                   true
                //                                   ? secondaryColor
                //                                   : Colors.black,
                //                               size: 14),
                //                           const SizedBox(
                //                             width: 5.0,
                //                           ),
                //                           Text(
                //                             'Quan tâm',
                //                             textAlign: TextAlign.center,
                //                             style: TextStyle(
                //                               fontSize: 12.0,
                //                               color: growButtonFollower ==
                //                                   true
                //                                   ? secondaryColor
                //                                   : Colors.black,
                //                               fontWeight: FontWeight.w700,
                //                             ),
                //                           ),
                //                         ],
                //                       )),
                //                 ),
                //                 const SizedBox(width: 5),
                //                 InkWell(
                //                   onTap: () {
                //                     showModalBottomSheet(
                //                       context: context,
                //                       builder: (context) => Container(
                //                         margin: const EdgeInsets.only(
                //                             left: 8.0, top: 15.0),
                //                         width: MediaQuery.of(context)
                //                             .size
                //                             .width,
                //                         height: MediaQuery.of(context)
                //                             .size
                //                             .height *
                //                             0.3 +
                //                             30,
                //                         child: Column(
                //                           children: [
                //                             ListView.builder(
                //                               scrollDirection:
                //                               Axis.vertical,
                //                               shrinkWrap: true,
                //                               physics:
                //                               const NeverScrollableScrollPhysics(),
                //                               itemCount:
                //                               iconActionEllipsis
                //                                   .length,
                //                               itemBuilder:
                //                               ((context, index) {
                //                                 return Padding(
                //                                   padding:
                //                                   const EdgeInsets
                //                                       .only(
                //                                       bottom: 10.0),
                //                                   child: InkWell(
                //                                     onTap: () {
                //                                       showModalBottomSheet(
                //                                           context:
                //                                           context,
                //                                           isScrollControlled:
                //                                           true,
                //                                           barrierColor: Colors
                //                                               .transparent,
                //                                           clipBehavior: Clip
                //                                               .antiAliasWithSaveLayer,
                //                                           shape: const RoundedRectangleBorder(
                //                                               borderRadius:
                //                                               BorderRadius.vertical(
                //                                                   top: Radius.circular(
                //                                                       10))),
                //                                           builder:
                //                                               (context) =>
                //                                               SizedBox(
                //                                                 height:
                //                                                 MediaQuery.of(context).size.height * 0.9,
                //                                                 width: MediaQuery.of(context)
                //                                                     .size
                //                                                     .width,
                //                                                 child:
                //                                                 ActionEllipsis(menuSelected: iconActionEllipsis[index]),
                //                                               ));
                //                                     },
                //                                     child: Row(
                //                                       children: [
                //                                         CircleAvatar(
                //                                           radius: 18.0,
                //                                           backgroundColor:
                //                                           greyColor[
                //                                           350],
                //                                           child: Icon(
                //                                             iconActionEllipsis[
                //                                             index]
                //                                             ["icon"],
                //                                             size: 18.0,
                //                                             color: Colors
                //                                                 .black,
                //                                           ),
                //                                         ),
                //                                         Container(
                //                                           margin: const EdgeInsets
                //                                               .only(
                //                                               left: 10.0),
                //                                           child: Text(
                //                                               iconActionEllipsis[
                //                                               index]
                //                                               [
                //                                               "label"],
                //                                               style: const TextStyle(
                //                                                   fontSize:
                //                                                   14.0,
                //                                                   fontWeight:
                //                                                   FontWeight.w500)),
                //                                         ),
                //                                       ],
                //                                     ),
                //                                   ),
                //                                 );
                //                               }),
                //                             ),
                //                           ],
                //                         ),
                //                       ),
                //                     );
                //                   },
                //                   child: Container(
                //                     height: 32,
                //                     width: MediaQuery.of(context)
                //                         .size
                //                         .width *
                //                         0.1,
                //                     decoration: BoxDecoration(
                //                         color: const Color.fromARGB(
                //                             189, 202, 202, 202),
                //                         borderRadius:
                //                         BorderRadius.circular(4),
                //                         border: Border.all(
                //                             width: 0.2,
                //                             color: greyColor)),
                //                     child: Column(
                //                       mainAxisAlignment:
                //                       MainAxisAlignment.center,
                //                       children: const [
                //                         Icon(FontAwesomeIcons.ellipsis,
                //                             color: Colors.black,
                //                             size: 14),
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ) : Padding(
                //               padding: const EdgeInsets.fromLTRB(2, 0, 3, 0),
                //               child: Row(children: [
                //                 InkWell(
                //                   onTap: () {
                //                     showBarModalBottomSheet(
                //                         context: context,
                //                         backgroundColor: Colors.white,
                //                         builder: (context) =>
                //                             SizedBox(
                //                                 height:
                //                                 MediaQuery.of(context).size.height * 0.9,
                //                                 child: const InviteFriend()));
                //                   },
                //                   child: Container(
                //                       height: 32,
                //                       width: MediaQuery.of(context)
                //                           .size
                //                           .width *
                //                           0.4,
                //                       decoration: BoxDecoration(
                //                           color:
                //
                //                           const Color.fromARGB(
                //                               189, 202, 202, 202),
                //                           borderRadius:
                //                           BorderRadius.circular(4),
                //                           border: Border.all(
                //                               width: 0.2,
                //                               color: greyColor)),
                //                       child: Row(
                //                         mainAxisAlignment:
                //                         MainAxisAlignment.center,
                //                         children: const [
                //                           Icon(FontAwesomeIcons.solidEnvelope,
                //                               color:
                //                               Colors.black,
                //                               size: 14),
                //                           SizedBox(
                //                             width: 5.0,
                //                           ),
                //                           Text(
                //                             'Mời',
                //                             textAlign: TextAlign.center,
                //                             style: TextStyle(
                //                               fontSize: 12.0,
                //                               color: Colors.black,
                //                               fontWeight: FontWeight.w700,
                //                             ),
                //                           ),
                //                         ],
                //                       )),
                //                 ),
                //                 const SizedBox(width: 10),
                //                 InkWell(
                //                   onTap: () {
                //                   },
                //                   child: Container(
                //                       height: 32,
                //                       width: MediaQuery.of(context)
                //                           .size
                //                           .width *
                //                           0.36,
                //                       decoration: BoxDecoration(
                //                           color:
                //
                //                           const Color.fromARGB(
                //                               189, 202, 202, 202),
                //                           borderRadius:
                //                           BorderRadius.circular(4),
                //                           border: Border.all(
                //                               width: 0.2,
                //                               color: greyColor)),
                //                       child: Row(
                //                         mainAxisAlignment:
                //                         MainAxisAlignment.center,
                //                         children: const[
                //                           Text(
                //                             'Dự án',
                //                             textAlign: TextAlign.center,
                //                             style: TextStyle(
                //                               fontSize: 12.0,
                //                               color: Colors.black,
                //                               fontWeight: FontWeight.w700,
                //                             ),
                //                           ),
                //                         ],
                //                       )),
                //                 ),
                //                 const SizedBox(width: 10),
                //                 InkWell(
                //                   onTap: () {
                //                     showModalBottomSheet(
                //                       context: context,
                //                       builder: (context) => Container(
                //                         margin: const EdgeInsets.only(
                //                             left: 8.0, top: 15.0),
                //                         width: MediaQuery.of(context)
                //                             .size
                //                             .width,
                //                         height: MediaQuery.of(context)
                //                             .size
                //                             .height *
                //                             0.3 +
                //                             30,
                //                         child: Column(
                //                           children: [
                //                             ListView.builder(
                //                               scrollDirection:
                //                               Axis.vertical,
                //                               shrinkWrap: true,
                //                               physics:
                //                               const NeverScrollableScrollPhysics(),
                //                               itemCount:
                //                               iconActionEllipsis
                //                                   .length ,
                //                               itemBuilder:
                //                               ((context, index) {
                //                                 if (index == 0) {
                //                                   return const SizedBox.shrink();
                //                                 }
                //                                 return Padding(
                //                                   padding:
                //                                   const EdgeInsets
                //                                       .only(
                //                                       bottom: 10.0),
                //                                   child: InkWell(
                //                                     onTap: () {
                //                                       showModalBottomSheet(
                //                                           context:
                //                                           context,
                //                                           isScrollControlled:
                //                                           true,
                //                                           barrierColor: Colors
                //                                               .transparent,
                //                                           clipBehavior: Clip
                //                                               .antiAliasWithSaveLayer,
                //                                           shape: const RoundedRectangleBorder(
                //                                               borderRadius:
                //                                               BorderRadius.vertical(
                //                                                   top: Radius.circular(
                //                                                       10))),
                //                                           builder:
                //                                               (context) =>
                //                                               SizedBox(
                //                                                 height:
                //                                                 MediaQuery.of(context).size.height * 0.9,
                //                                                 width: MediaQuery.of(context)
                //                                                     .size
                //                                                     .width,
                //                                                 child:
                //                                                 ActionEllipsis(menuSelected: iconActionEllipsis[index]),
                //                                               ));
                //                                     },
                //                                     child: Row(
                //                                       children: [
                //                                         CircleAvatar(
                //                                           radius: 18.0,
                //                                           backgroundColor:
                //                                           greyColor[
                //                                           350],
                //                                           child: Icon(
                //                                             iconActionEllipsis[
                //                                             index]
                //                                             ["icon"],
                //                                             size: 18.0,
                //                                             color: Colors
                //                                                 .black,
                //                                           ),
                //                                         ),
                //                                         Container(
                //                                           margin: const EdgeInsets
                //                                               .only(
                //                                               left: 10.0),
                //                                           child: Text(
                //                                               iconActionEllipsis[
                //                                               index]
                //                                               [
                //                                               "label"],
                //                                               style: const TextStyle(
                //                                                   fontSize:
                //                                                   14.0,
                //                                                   fontWeight:
                //                                                   FontWeight.w500)),
                //                                         ),
                //                                       ],
                //                                     ),
                //                                   ),
                //                                 );
                //                               }),
                //                             ),
                //                           ],
                //                         ),
                //                       ),
                //                     );
                //                   },
                //                   child: Container(
                //                     height: 32,
                //                     width: MediaQuery.of(context)
                //                         .size
                //                         .width *
                //                         0.1,
                //                     decoration: BoxDecoration(
                //                         color: const Color.fromARGB(
                //                             189, 202, 202, 202),
                //                         borderRadius:
                //                         BorderRadius.circular(4),
                //                         border: Border.all(
                //                             width: 0.2,
                //                             color: greyColor)),
                //                     child: Column(
                //                       mainAxisAlignment:
                //                       MainAxisAlignment.center,
                //                       children: const [
                //                         Icon(FontAwesomeIcons.ellipsis,
                //                             color: Colors.black,
                //                             size: 14),
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //               ],),
                //             ),
                //             const SizedBox(
                //               height: 10,
                //             ),
                //             Column(
                //               crossAxisAlignment:
                //               CrossAxisAlignment.start,
                //               children: [
                //                 Padding(
                //                   padding:
                //                   const EdgeInsets.only(bottom: 8.0),
                //                   child: Row(
                //                     mainAxisAlignment:
                //                     MainAxisAlignment.start,
                //                     children: [
                //                       const Icon(
                //                           FontAwesomeIcons.stopwatch,
                //                           size: 20),
                //                       const SizedBox(
                //                         width: 9.0,
                //                       ),
                //                       Padding(
                //                         padding: const EdgeInsets.only(
                //                             top: 4.0),
                //                         child: Text(
                //                           (DateTime.parse(growDetail['due_date']).isBefore(DateTime.parse(DateTime.now().toString()))) == false ?  GetTimeAgo.parse(
                //                             DateTime.parse(
                //                                 growDetail['due_date']),
                //                           ): 'Dự án đã kết thúc',
                //                           textAlign: TextAlign.center,
                //                           style: const TextStyle(
                //                             fontSize: 12.0,
                //                             fontWeight: FontWeight.w500,
                //                           ),
                //                         ),
                //                       )
                //                     ],
                //                   ),
                //                 ),
                //                 Padding(
                //                   padding:
                //                   const EdgeInsets.only(bottom: 8.0),
                //                   child: Row(
                //                     mainAxisAlignment:
                //                     MainAxisAlignment.start,
                //                     children: [
                //                       const Icon(
                //                           FontAwesomeIcons.solidUser,
                //                           size: 20),
                //                       const SizedBox(
                //                         width: 9.0,
                //                       ),
                //                       Padding(
                //                         padding: const EdgeInsets.only(
                //                             top: 4.0),
                //                         child: RichText(
                //                           text: TextSpan(
                //                             text: 'Dự án của ',
                //                             style:  TextStyle(
                //                                 fontSize: 12,
                //                                 fontWeight:
                //                                 FontWeight.w500,
                //                                 color: colorWord(context)),
                //                             children: <TextSpan>[
                //                               TextSpan(
                //                                   text: growDetail[
                //                                   'account']
                //                                   ['display_name'],
                //                                   style:  TextStyle(
                //                                       fontSize: 12,
                //                                       fontWeight:
                //                                       FontWeight.bold,
                //                                       color: colorWord(context))),
                //                             ],
                //                           ),
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //                 Padding(
                //                   padding:
                //                   const EdgeInsets.only(bottom: 8.0),
                //                   child: Row(
                //                     mainAxisAlignment:
                //                     MainAxisAlignment.start,
                //                     children: [
                //                       const Icon(
                //                           FontAwesomeIcons.clipboardCheck,
                //                           size: 20),
                //                       const SizedBox(
                //                         width: 9.0,
                //                       ),
                //                       Padding(
                //                         padding: const EdgeInsets.only(
                //                             top: 4.0),
                //                         child: Text(
                //                           '${growDetail['followers_count'].toString()} người quan tâm · ${growDetail['backers_count'].toString()} người ủng hộ',
                //                           textAlign: TextAlign.center,
                //                           style: const TextStyle(
                //                             fontSize: 12.0,
                //                             fontWeight: FontWeight.w500,
                //                           ),
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //                 Padding(
                //                   padding:
                //                   const EdgeInsets.only(bottom: 8.0),
                //                   child: Row(
                //                     mainAxisAlignment:
                //                     MainAxisAlignment.start,
                //                     children: const [
                //                       Icon(FontAwesomeIcons.earthAmericas, size: 20),
                //                       SizedBox(
                //                         width: 9.0,
                //                       ),
                //                       Padding(
                //                         padding:
                //                         EdgeInsets.only(top: 4.0),
                //                         child: Text(
                //                           'Công khai · Tất cả mọi người trong hoặc ngoài EMSO',
                //                           textAlign: TextAlign.center,
                //                           style: TextStyle(
                //                             fontSize: 12.0,
                //                             fontWeight: FontWeight.w500,
                //                           ),
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //                 Row(
                //                   mainAxisAlignment:
                //                   MainAxisAlignment.start,
                //                   children: [
                //                     const Icon(FontAwesomeIcons.bullseye,
                //                         size: 20),
                //                     const SizedBox(
                //                       width: 9.0,
                //                     ),
                //                     Padding(
                //                       padding:
                //                       const EdgeInsets.only(top: 4.0),
                //                       child: RichText(
                //                         text: TextSpan(
                //                           text: 'Số vốn cần gọi ',
                //                           style:  TextStyle(
                //                               fontSize: 12,
                //                               fontWeight: FontWeight.w500,
                //                               color: colorWord(context)),
                //                           children: <TextSpan>[
                //                             TextSpan(
                //                                 text:
                //                                 '${convertNumberToVND(growDetail['target_value'] ~/ 1)} VNĐ',
                //                                 style:  TextStyle(
                //                                     fontSize: 12,
                //                                     fontWeight:
                //                                     FontWeight.bold,
                //                                     color: colorWord(context))),
                //                           ],
                //                         ),
                //                       ),
                //                     ),
                //                   ],
                //                 ),
                //                 Padding(
                //                     padding: const EdgeInsets.fromLTRB(
                //                         4, 16, 4, 10),
                //                     child: Column(
                //                       children: [
                //                         ClipRRect(
                //                           borderRadius:
                //                           BorderRadius.circular(8),
                //                           child: SizedBox(
                //                             height: 10,
                //                             child:
                //                             LinearProgressIndicator(
                //                               value:
                //                               valueLinearProgressBar / 100, // percent filled
                //                               valueColor:
                //                               const   AlwaysStoppedAnimation<
                //                                   Color>(
                //                                   secondaryColor),
                //                               backgroundColor:
                //                               secondaryColor
                //                                   .withOpacity(0.5),
                //                             ),
                //                           ),
                //                         ),
                //                         Padding(
                //                           padding: const EdgeInsets.only(
                //                               top: 8.0),
                //                           child: Row(
                //                             mainAxisAlignment:
                //                             MainAxisAlignment
                //                                 .spaceBetween,
                //                             children: [
                //                               RichText(
                //                                 text: TextSpan(
                //                                   text: 'Đã ủng hộ được ',
                //                                   style:  TextStyle(
                //                                       fontSize: 12,
                //                                       fontWeight:
                //                                       FontWeight.w500,
                //                                       color:
                //                                       colorWord(context)),
                //                                   children: <TextSpan>[
                //                                     TextSpan(
                //                                         text: '${convertNumberToVND(growDetail['real_value'] ~/ 1)} VNĐ',
                //                                         style: TextStyle(
                //                                             fontSize: 12,
                //                                             fontWeight:
                //                                             FontWeight
                //                                                 .bold,
                //                                             color: colorWord(context))),
                //                                   ],
                //                                 ),
                //                               ),
                //                               Text('${valueLinearProgressBar == 0 ? 0 : valueLinearProgressBar.toStringAsFixed(2)}%')
                //                             ],
                //                           ),
                //                         )
                //                       ],
                //                     )),
                //               ],
                //             ),
                //           ])),
                // ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(15, 10, 16, 0),
                //   child: Row(
                //     children: [
                //       InkWell(
                //           onTap: () {
                //             setState(() {
                //               growStatus = true;
                //             });
                //           },
                //           child: Container(
                //             height: 35,
                //             width:
                //             MediaQuery.of(context).size.width * 0.44,
                //             decoration: BoxDecoration(
                //                 color: growStatus
                //                     ? secondaryColor.withOpacity(0.4)
                //                     : const Color.fromARGB(
                //                     189, 202, 202, 202),
                //                 borderRadius: BorderRadius.circular(16),
                //                 border: Border.all(
                //                     width: 0.2, color: greyColor)),
                //             child: Column(
                //                 mainAxisAlignment:
                //                 MainAxisAlignment.center,
                //                 children: [
                //                   Text(
                //                     'Giới thiệu',
                //                     textAlign: TextAlign.center,
                //                     style: TextStyle(
                //                       fontSize: 12.0,
                //                       color: growStatus
                //                           ? secondaryColor
                //                           : Colors.black,
                //                       fontWeight: FontWeight.w700,
                //                     ),
                //                   ),
                //                 ]),
                //           )),
                //       const SizedBox(width: 10),
                //       InkWell(
                //         onTap: () {
                //           setState(() {
                //             growStatus = false;
                //           });
                //         },
                //         child: Container(
                //           height: 35,
                //           width: MediaQuery.of(context).size.width * 0.44,
                //           decoration: BoxDecoration(
                //               color: !growStatus
                //                   ? secondaryColor.withOpacity(0.4)
                //                   : const Color.fromARGB(
                //                   189, 202, 202, 202),
                //               borderRadius: BorderRadius.circular(16),
                //               border: Border.all(
                //                   width: 0.2, color: greyColor)),
                //           child: Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             children: [
                //               Text(
                //                 'Cuộc thảo luận',
                //                 textAlign: TextAlign.center,
                //                 style: TextStyle(
                //                   fontSize: 12.0,
                //                   color: !growStatus
                //                       ? secondaryColor
                //                       : Colors.black,
                //                   fontWeight: FontWeight.w700,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // ),
                // const Padding(
                //   padding: EdgeInsets.only(top: 5.0),
                //   child: Divider(
                //     thickness: 1,
                //   ),
                // ),
                // growStatus
                //     ? GrowIntro(data: growDetail)
                //     : GrowDiscuss(data: growDetail),
                const SizedBox(height: 70),
              ],
            ),
          ),
          // !growDetail['project_relationship']['host_project'] &&  (DateTime.parse(growDetail['due_date']).isBefore(DateTime.parse(DateTime.now().toString()))) == false ? Visibility(
          //   visible: _isVisible,
          //   child: Positioned(
          //     bottom: 0,
          //     left: 0,
          //     right: 0,
          //     child: Container(
          //       height: 70,
          //       color: Colors.white,
          //       padding: const EdgeInsets.only(left: 25.0, right: 18.0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: List.generate(
          //           growPriceTitle.length,
          //               (indexButton) {
          //             final button = growPriceTitle[indexButton];
          //             if (indexButton == 2) {
          //               return const SizedBox();
          //             } else {
          //               return Container(
          //                 height: 35,
          //                 width: MediaQuery.of(context).size.width * 0.43,
          //                 decoration: BoxDecoration(
          //                   color: secondaryColor,
          //                   borderRadius: BorderRadius.circular(4),
          //                   border:
          //                   Border.all(width: 0.2, color: greyColor),
          //                 ),
          //                 child: InkWell(
          //                   onTap: () {
          //                     showModalBottomSheet(
          //                         shape: const RoundedRectangleBorder(
          //                           borderRadius: BorderRadius.vertical(
          //                             top: Radius.circular(15),
          //                           ),
          //                         ),
          //                         context: context,
          //                         isScrollControlled: true,
          //                         isDismissible: true,
          //                         builder: (context) =>
          //                             SingleChildScrollView(
          //                               primary: true,
          //                               padding: EdgeInsets.only(
          //                                   bottom: MediaQuery.of(context)
          //                                       .viewInsets
          //                                       .bottom),
          //                               child: ModalPayment(title: growPriceTitle[indexButton]['title'], buttonTitle: growPriceTitle[indexButton]['title'], updateApi: (params) {
          //                                 ref
          //                                     .read(growControllerProvider.notifier)
          //                                     .updateTransactionDonate({
          //                                   "amount": params['amount'],
          //                                   "detail_type": growPriceTitle[indexButton]['type'].toString()
          //                                 }, growDetail['id']);
          //                               },),
          //                             )) ;
          //                   },
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       Padding(
          //                         padding:
          //                         const EdgeInsets.only(bottom: 3.0),
          //                         child: Icon(button['icon'],
          //                             size: 16, color: Colors.white),
          //                       ),
          //                       const SizedBox(width: 10),
          //                       Text(button['title'],
          //                           textAlign: TextAlign.center,
          //                           style: const TextStyle(
          //                               color: Colors.white)),
          //                     ],
          //                   ),
          //                 ),
          //               );
          //             }
          //           },
          //         )
          //             .expand(
          //                 (widget) => [widget, const SizedBox(width: 15)])
          //             .toList(),
          //       ),
          //     ),
          //   ),
          // ) : const SizedBox(),
        ],
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}