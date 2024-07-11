import 'package:flutter/services.dart';
import 'package:kajak/core/app_export.dart';
import 'package:kajak/widgets/app_bar/appbar_image.dart';
import 'package:kajak/widgets/app_bar/appbar_title.dart';
import 'package:kajak/widgets/app_bar/custom_app_bar.dart';
import 'package:kajak/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';

class HalamanAksaraJawaSubMenu extends StatefulWidget {
  int id = 0;

  HalamanAksaraJawaSubMenu(this.id, {Key? key}) : super(key: key);

  @override
  _HalamanAksaraJawaSubMenuState createState() =>
      _HalamanAksaraJawaSubMenuState(id);
}

class _HalamanAksaraJawaSubMenuState extends State<HalamanAksaraJawaSubMenu> {
  _HalamanAksaraJawaSubMenuState(this.id);

  int id = 0;

  var sejarahAksara = [
    {
      'title': 'Sejarah Aksara Jawa',
      'img': ImageConstant.imgFrame25,
      'meaning_in_java':
          'Jawa:\n\nDhuhul kala ana dhéwéké aneng praja Médhāngkamulan. Dhéwéké kui raja kang ganjen, arogan, ambisius, lan seneng mangan daging manungsa.Mungguh marang kegustiané mangan daging manungsa, dhéwéké nyekel wargaé supados maringi upeti dhumateng manungsa.\n\nNampa arogané Prabu Déwata Cangkar, sawijining becik marang saben bebrayané dumateng Raja Déwata Cangkar.Aji Saka njaluk sawijining pengembara kang namungsa Dora lan Sembada. Ing pitulasane menyang Médhāngkamulan,Aji Saka nganggo Dora, manawa Sembada tetep teka nggawe minangka kudu ngelakake pusaka sakti sing dimanggihake Aji Saka.Aji Saka nawani kanggo Sembada, manawa ora mlebu menyang pamardi wong sampeyan kanggo ninggalake pusaka iku,nanging ora bakal dilakokno kanggo wong liya nanging aku (Aji Saka).\n\nSawise sawetawis, Aji Saka nganti ing Médhāngkamulan sing sunyi. Warga ing praja iku ojo kaceluk, amarga resah mangan daging raja sing arogan.Aji Saka cepet menehi istana lan mbaleni patihé. Dheweke ngomong yen dheweke wis siap lan siap dak pangan kalih Prabu Déwata Cangkar.Nanging ing dinten mau dheweke bakal dipangan déning Prabu Déwata Cangkar. Sadurunge dipangan, prabu saged ngabènake siji kènèhé saka korban.Lan Aji Saka karo tentrem menehi dheweke dhèwèkè tanah ing langkung kepala. Nampa pitulungané Aji Saka, Prabu Déwata Cangkar mung meh nggelak nggelak lan langsung nampa.\n\ning ical kain kabuyutané. aji saka nggawa salah sijine kabuyutané, nanging liyane disedhèni déning prabu déwata cangkar.apiké, kabuyutané sugih kalebu marangé uga mlebu anaé prabu déwata cangkar. aji saka ngetokake kanggo cepet kabuyutané, nganti mebèk angranggèté lan kabuyutané.pitulung kula pindha dhisiké, "amarga sampeyan seneng mangan daging manungsa, sampeyan pantes dadi baya, lan panggonan sing trep kanggo baya iku ing laut,"sakidulna aji saka.\n\nsaka sak wong, karajan medhangkamulan dipanggedheni dening aji saka. sawijining raja kang pinter lan wicaksana. ing saiki aji saka nampaé pusaka saktiné,lan dikongkon dora kanggo ndeleng. nanging sembada ora arep ngladeni pusaka iki, amarga wong bakal ningal pesen aji saka.dene uga aran utawa pertarungan gedhé watara dora lan sembada. amarga gadhah elmu lan kasekten sing saimbang,mula kari dora lan sembada mati.\n\naji saka kang katebak pesené marang sembada, langsung ngandut. nanging ora cepet, amarga nalika sampun dhumateng ana,kaping loro abdidhé kang wiwit setia wis mati marang donyo. kanggo nglaras ing dhuwur, aji saka nggawa ing carik ing ngendi anengnggawe lambang kang ora saka aksara kanggo dumdumaké carangan lan tulisané:\n\nHa Na Ca Ra Ka (ono utusan = ana utusan)\nDa Ta Sa Wa La (padha kekerengan = padha nglawan)\nPa Da Ja Ya Nya (padha digdayane = padha saktiné)\nMa Ga Ba Tha Nga (padha nyunggi bathange = padha ndhuwur saha ing wungu)',
      'meaning_in_indo':
          // 'Indonesia:\n\nDahulu kala, di sebuah kerajaan Medhangkamulan, bertahta seorang raja bernama Dewata Cengkar,atau yang terkenal dengan nama Prabu Dewata Cengkar. Seorang raja yang sangat rakus, kejam, tamak,dan suka memakan daging manusia. Karena kegemarannya memakan daging manusia,maka secara bergilir rakyatnya pun dipaksa menyetor upeti berupa manusia.\n\nMendengar kekejaman Prabu Dewata Cengkar, seorang pengembara bernama Aji Saka bermaksud menghentikankebiasaan sang raja. Aji Saka memiliki dua orang abdi yang sangat setia bernama Dora dan Sembada.Dalam perjalanannya ke kerajaan Medhangkamulan, Aji Saka mengajak Dora, sedangkan Sembada tetapdi tempat karena harus menjaga sebuah pusaka sakti milik Aji Saka. Aji Saka memberi pesan kepada Sembada,agar jangan sampai pusaka itu diberikan kepada siapapun kecuali kepadanya (Aji Saka).\n\nSetelah beberapa waktu, Aji Saka tiba di kerajaan Medhangkamulan yang sepi. Rakyat di kerajaan itu takut keluar rumah,karena takut menjadi santapan lezat sang raja yang kejam. Aji Saka segera menuju istana dan menjumpai sang patih.Dia berkata bahwa dirinya sanggup dan siap dijadikan santapan Prabu Dewata Cengkar.Tiba pada hari dimana Aji Saka akan dimakan oleh Prabu Dewata Cengkar. Sebelum dimakan,sang prabu selalu mengabulkan satu permintaan dari calon korban. Dan Aji Saka dengan tenang meminta tanah seluas syurban kepalanya.Mendengar permintaan Aji Saka, Prabu Dewata Cengkar hanya tertawa terbahak-bahak dan langsung menyetujuinya.\n\nMaka dibukalah kain syurban penutup kepala Aji Saka. Aji Saka memegang salah satu ujung syurban, sedangkan yang lain dipegangoleh Prabu Dewata Cengkar. Anehnya, syurban itu seperti mengembang sehingga Dewata Cengkar harus berjalan mundur,mundur, dan mundur hingga sampai di tepi pantai selatan. Begitu Dewata Cengkar sampai di tepi pantai selatan,Aji Saka dengan cepat mengibaskan syurbannya sehingga membungkus badan Dewata Cengkar, damenendangnya hingga terjebur di laut selatan. Tiba-tiba tubuh Dewata Cengkar berubah menjadi buaya putih."Karena engkau suka memakan daging manusia, maka engkau pantas menjadi buaya, dan tempat yang tepat untukseekor buaya adalah di laut," demikian kata Aji Saka.\n\nSejak saat itu, Kerajaan Medhangkamulan dipimpin oleh Aji Saka. Seorang raja yang arif dan bijaksana.Tiba-tiba Aji Saka teringat akan pusaka saktinya, dan menyuruh Dora untuk mengambilnya.Namun Sembada tidak mau memberikan pusaka itu, karena teringat pesan Aji Saka.Maka terjadilah pertarungan hebat antara Dora dan Sembada. Karena memiliki ilmu dan kesaktian yang seimbang,maka meninggallah Dora dan Sembada secara bersamaan.\n\nAji Saka yang teringat akan pesannya kepada Sembada, segera menyusul.Namun terlambat, karena sesampai di sana, kedua abdinya yang sangat setia itu sudah meninggal dunia.Untuk mengenang keduanya, maka Aji Saka menggambarnya dalam sebuah aksara/huruf yang bunyi dan tulisannya:\n\nHa Na Ca Ra Ka (ono utusan = ada utusan)\nDa Ta Sa Wa La (padha kekerengan = saling berkelahi)\nPa Da Ja Ya Nya (padha digdayane = sama-sama saktinya)\nMa Ga Ba Tha Nga (padha nyunggi bathange = saling berpangku saat meninggal)',
          'Sumber : https://opac.perpusnas.go.id/DetailOpac.aspx?id=1142839',
      'is_open': true,
    }
  ];

  var byId;

  var hanacaraka = [
    {
      'title': 'Aksara Jawa',
      'img': ImageConstant.imgFrame4,
      'is_open': true,
    },
    {
      'title': 'Pasangan Aksara Jawa',
      'img': ImageConstant.pasangan_aksara_jawa,
      'is_open': false,
    },
    {
      'title': 'Aksara Rekan',
      'img': ImageConstant.aksara_rekan,
      'is_open': false,
    },
    {
      'title': 'Angka Jawa',
      'img': ImageConstant.angka_jawa,
      'is_open': false,
    },
    {
      'title': 'Aksara Murda',
      'img': ImageConstant.aksara_murda,
      'is_open': false,
    },
    {
      'title': 'Aksara Swara',
      'img': ImageConstant.aksara_swara,
      'is_open': false,
    }
  ];

  var sandhangan = [
    {
      'title': 'Sandhangan Swara',
      'img': ImageConstant.sandhangan_swara,
      'is_open': true,
    },
    {
      'title': 'Sandhangan Panyigeg',
      'img': ImageConstant.sandhangan_sanyigeg,
      'is_open': false,
    },
    {
      'title': 'Aksara Mandraswara',
      'img': ImageConstant.aksara_mandraswara,
      'is_open': false,
    },
    {
      'title': 'Aksara Ganten',
      'img': ImageConstant.aksara_ganten,
      'is_open': false,
    },
    {
      'title': 'Pada',
      'img': ImageConstant.pada,
      'is_open': false,
    },
  ];

  var snackBar = SnackBar(
    backgroundColor: Colors.grey,
    behavior: SnackBarBehavior.floating,
    content: Text('Link berhasil di salin'),
  );

  @override
  void initState() {
    if (id == 2) {
      byId = hanacaraka;
    } else if (id == 3) {
      byId = sandhangan;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            appBar: CustomAppBar(
                leadingWidth: 38.h,
                leading: AppbarImage(
                    svgPath: ImageConstant.imgArrowleft,
                    margin:
                        EdgeInsets.only(left: 13.h, top: 15.v, bottom: 15.v),
                    onTap: () {
                      onTapArrowleftone(context);
                    }),
                centerTitle: true,
                title: AppbarTitle(
                    text:
                        "Aksara Jawa (${(id == 1) ? 'Sejarah Aksara Jawa' : (id == 2) ? 'Ha na Ca ra Ka' : 'Sandhangan'})")),
            body: SizedBox(
                width: mediaQueryData.size.width,
                child: Padding(
                    padding: EdgeInsets.only(top: 16.v),
                    child: Container(
                      // height: 502.v,
                      width: 329.h,
                      margin:
                          EdgeInsets.only(left: 25.h, right: 25.h, bottom: 5.v),
                      child: (id == 1)
                          ? ListView.separated(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              separatorBuilder: (
                                context,
                                index,
                              ) {
                                return SizedBox(
                                  height: 10.v,
                                );
                              },
                              itemCount: (sejarahAksara != null)
                                  ? sejarahAksara.length
                                  : 0,
                              itemBuilder: (context, index) {
                                return (sejarahAksara[index]['is_open'] == true)
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CustomOutlinedButton(
                                              onTap: () {
                                                sejarahAksara[index]
                                                    ['is_open'] = false;
                                                setState(() {});
                                              },
                                              width: 329.h,
                                              text: sejarahAksara[index]
                                                      ['title']
                                                  .toString(),
                                              alignment: Alignment.topCenter),
                                          Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12.h,
                                                      vertical: 30.v),
                                                  decoration: AppDecoration
                                                      .outlineBlack901,
                                                  child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        CustomImageView(
                                                            imagePath:
                                                                sejarahAksara[
                                                                            index]
                                                                        ['img']
                                                                    .toString(),
                                                            height: 83.v,
                                                            width: 174.h),
                                                        SizedBox(height: 25.v),
                                                        SizedBox(
                                                            width: 300.h,
                                                            child: Text(
                                                                sejarahAksara[
                                                                            index]
                                                                        [
                                                                        'meaning_in_java']
                                                                    .toString(),
                                                                maxLines: 99999,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: theme
                                                                    .textTheme
                                                                    .labelLarge)),
                                                        SizedBox(height: 23.v),
                                                        SizedBox(
                                                            width: 305.h,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                Clipboard.setData(
                                                                        ClipboardData(
                                                                            text:
                                                                                'https://opac.perpusnas.go.id/DetailOpac.aspx?id=1142839'))
                                                                    .then(
                                                                        (value) {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .hideCurrentSnackBar();
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .grey,
                                                                    behavior:
                                                                        SnackBarBehavior
                                                                            .floating,
                                                                    content: Text(
                                                                        'Link berhasil di salin.'),
                                                                  ));
                                                                });
                                                              },
                                                              child: Text(
                                                                  sejarahAksara[
                                                                              index]
                                                                          [
                                                                          'meaning_in_indo']
                                                                      .toString(),
                                                                  maxLines:
                                                                      99999,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: CustomTextStyles
                                                                      .labelLarge_1),
                                                            )),
                                                        SizedBox(height: 23.v)
                                                      ])))
                                        ],
                                      )
                                    : CustomOutlinedButton(
                                        onTap: () {
                                          sejarahAksara[index]['is_open'] =
                                              true;
                                          setState(() {});
                                        },
                                        width: 329.h,
                                        text: sejarahAksara[index]['title']
                                            .toString(),
                                        alignment: Alignment.topCenter);
                              })
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              separatorBuilder: (
                                context,
                                index,
                              ) {
                                return SizedBox(
                                  height: 10.v,
                                );
                              },
                              itemCount: (byId != null) ? byId.length : 0,
                              itemBuilder: (context, index) {
                                return (byId[index]['is_open'] == true)
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CustomOutlinedButton(
                                              onTap: () {
                                                byId[index]['is_open'] = false;
                                                setState(() {});
                                              },
                                              width: 329.h,
                                              text: byId[index]['title']
                                                  .toString(),
                                              alignment: Alignment.topCenter),
                                          Align(
                                              alignment: Alignment.center,
                                              child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 12.h,
                                                      vertical: 15.v),
                                                  decoration: AppDecoration
                                                      .outlineBlack901,
                                                  child: CustomImageView(
                                                      fit: BoxFit.contain,
                                                      imagePath: byId[index]
                                                              ['img']
                                                          .toString(),
                                                      width: 304.h)))
                                        ],
                                      )
                                    : CustomOutlinedButton(
                                        onTap: () {
                                          byId[index]['is_open'] = true;
                                          setState(() {});
                                        },
                                        width: 329.h,
                                        text: byId[index]['title'].toString(),
                                        alignment: Alignment.topCenter);
                              }),
                    )))));
  }

  /// Navigates back to the previous screen.
  ///
  /// This function takes a [BuildContext] object as a parameter, which is used
  /// to navigate back to the previous screen.
  onTapArrowleftone(BuildContext context) {
    Navigator.pop(context);
  }
}
