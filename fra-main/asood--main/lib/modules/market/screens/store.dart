import 'dart:io';

import 'package:asood/models/market_model.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/location_model.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/screens/store_setting_screens/themes_screen/themes_screen.dart';
import '../../../shared/utils/snack_bar_util.dart';
import '../../../shared/widgets/comment_messagebox_widget.dart';
import '../../../shared/widgets/custom_bottom_navbar.dart';
import '../../../shared/widgets/map_widget_2.dart';
import '../../vendor/blocs/vendor/vendor_bloc.dart';
import '../../vendor/blocs/workspace/workspace_bloc.dart';
import '../blocs/bloc/market_bloc.dart';
import '../widgets/store_appbar.dart';

@RoutePage()
class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key, required this.market});
  final MarketModel market;

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {

  late VendorBloc bloc;
  late MarketBloc marketBloc;

  List<String> buttonTitles = ["محصولات", "ویژه ها", "نظرات", "ارتباط با ما"];

  int selectedIndex = 0;

  int currentSliderIndex = 0;

  int sliderLength = 6;

  Color initTopColor = Colora.primaryColor;
  Color initBackColor = Colora.scaffold;
  Color initSecondColor = Colora.lightBlue;

  String initFont = 'irs';
  Color initFontColor = Colora.scaffold;
  Color initFontSecondColor = Colora.primaryColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = BlocProvider.of<VendorBloc>(context);
    marketBloc = BlocProvider.of<MarketBloc>(context);
    loadSlider();
    initTheme();
  }

  void initTheme(){
    if(widget.market.theme != null){
      //top color
      if(widget.market.theme!.color != null){
        bloc.add(SelectTopColor(topColor: Color(int.parse('0xFF${widget.market.theme!.color}'))));
        initTopColor = Color(int.parse('0xFF${widget.market.theme!.color}'));
      }
      else{
        bloc.add(const SelectTopColor(topColor: Colora.primaryColor));
        initTopColor = Colora.primaryColor;
      }

      //background color
      if(widget.market.theme!.backgroundColor != null){
        bloc.add(SelectBackColor(backColor: Color(int.parse('0xFF${widget.market.theme!.backgroundColor}'))));
        initBackColor = Color(int.parse('0xFF${widget.market.theme!.backgroundColor}'));
      }
      else{
        bloc.add(const SelectBackColor(backColor: Colora.scaffold));
        initBackColor = Colora.scaffold;
      }

      //second color
      if(widget.market.theme!.secondaryColor != null){
        bloc.add(SelectSecondColor(secondColor: Color(int.parse('0xFF${widget.market.theme!.secondaryColor}'))));
        initSecondColor = Color(int.parse('0xFF${widget.market.theme!.secondaryColor}'));
      }
      else{
        bloc.add(const SelectSecondColor(secondColor: Colora.lightBlue));
        initSecondColor = Colora.lightBlue;
      }

      // font family
      if(widget.market.theme!.font != null){
        bloc.add(SelectFontFamily(fontFamily:  widget.market.theme!.font!));
        initFont = widget.market.theme!.font!;
      }
      else{
        bloc.add(const SelectFontFamily(fontFamily: 'irs'));
        initFont = 'irs';
      }

      //font color
      if(widget.market.theme!.fontColor != null){
        bloc.add(SelectFontColor(fontColor:  Color(int.parse('0xFF${widget.market.theme!.fontColor}'))));
        initFontColor = Color(int.parse('0xFF${widget.market.theme!.fontColor}'));
      }
      else{
        bloc.add(const SelectFontColor(fontColor: Colora.scaffold));
        initFontColor = Colora.scaffold;
      }

      //font second color
      if(widget.market.theme!.fontColor != null){
        bloc.add(SelectSecondFontColor(secondFontColor: Color(int.parse('0xFF${widget.market.theme!.secondaryFontColor}'))));
        initFontSecondColor = Color(int.parse('0xFF${widget.market.theme!.secondaryFontColor}'));
      }
      else{
        bloc.add(const SelectSecondFontColor(secondFontColor: Colora.primaryColor));
        initFontSecondColor = Colora.primaryColor;
      }

    }
    else{
      //top color
      bloc.add(const SelectTopColor(topColor: Colora.primaryColor));
      initTopColor = Colora.primaryColor;

      //second top color
      bloc.add(const SelectSecondColor(secondColor: Colora.lightBlue));
      initSecondColor = Colora.lightBlue;

      //back color
      bloc.add(const SelectBackColor(backColor: Colora.scaffold));
      initBackColor = Colora.scaffold;

      //font family
      bloc.add(const SelectFontFamily(fontFamily: 'irs'));
      initFont = 'irs';

      bloc.add(const SelectFontColor(fontColor: Colora.scaffold));
      initFontColor = Colora.scaffold;

      bloc.add(const SelectSecondFontColor(secondFontColor: Colora.primaryColor));
      initFontSecondColor = Colora.primaryColor;
    }
  }

  void loadSlider(){
    bloc.add(LoadSlider(marketId: widget.market.id!));
    // bloc.add(LoadComments(marketId: widget.market.id!));
  }

  void sliderImage(context, {bool isEditing = false, int sliderId = 0, String currentImage = ''}){
    String preview = '';
    XFile? image;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
        StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: SizedBox(
                height: Dimensions.height * 0.26,
                width: Dimensions.width * 0.7,
                child: BlocConsumer<VendorBloc, VendorState>(
                  listener: (context, state) {
                    if (state.sliderStatus == VendorStatus.success) {
                      loadSlider();
                      Navigator.pop(context);
                    }
                    else if (state.sliderStatus == VendorStatus.failure) {
                      showSnackBar(context, "مشکلی پیش آمده مجددا تلاش کنید");
                      Navigator.pop(context);
                    }
                  },
                  builder: (context, state){
                    return Column(
                      children: [

                        //title
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'عکس اسلایدر',
                            style: TextStyle(
                              color: Colora.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: Dimensions.width * 0.05
                            ),
                          ),
                        ),

                        const Divider(
                          color: Colora.primaryColor,
                        ),

                        //preview
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //add
                            Container(
                              width: Dimensions.width * 0.4,
                              padding: EdgeInsets.symmetric(
                                vertical: Dimensions.height * 0.01
                              ),
                              child: AspectRatio(
                                aspectRatio: 16/9,
                                child: InkWell(
                                  onTap: () async{
                                    var maxFileSizeInBytes = 5 * 1048576;

                                    final ImagePicker picker = ImagePicker();
                                    image = await picker.pickImage(source: ImageSource.gallery);

                                    var imagePath = await image!.readAsBytes();
                                    var fileSize = imagePath.length;

                                    if (fileSize <= maxFileSizeInBytes) {
                                      setState(() {
                                        preview = image!.path;
                                      });
                                    } else {
                                      showSnackBar(context, "حجم عکس بیش از ۵ مگابایت است");
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colora.primaryColor, width: 2),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: isEditing == true && preview == ''
                                          ?CachedNetworkImage(
                                            imageUrl: currentImage,
                                            imageBuilder: (context, imageProvider) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                ),
                                              );
                                            },
                                            placeholder: (context, url) => Shimmer.fromColors(
                                              baseColor: Colors.grey.withOpacity(0.2),
                                              highlightColor: Colors.black.withOpacity(0.2),
                                              direction: ShimmerDirection.rtl,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius: BorderRadius.circular(5)
                                                ),
                                              ),
                                            ),
                                            errorWidget: (context, url, error) => const Icon(Icons.error),
                                          )
                                          :preview == ''
                                            ?Icon(
                                              Icons.add_photo_alternate_rounded,
                                              color: Colora.primaryColor,
                                              size: Dimensions.width * 0.1,
                                            )
                                            :Image.file(
                                              File(preview),
                                              fit: BoxFit.cover,
                                            ),
                                      )
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        //back and save
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            //save
                            Align(
                              alignment: Alignment.centerLeft,
                              child: state.sliderStatus == VendorStatus.loading
                                ?Container(
                                  width: Dimensions.width * 0.3,
                                  height: Dimensions.height * 0.042,
                                  padding: EdgeInsets.symmetric(
                                      vertical: Dimensions.height * 0.01
                                  ),
                                  margin: EdgeInsets.only(
                                      top: Dimensions.height * 0.02
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colora.primaryColor,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: const Center(
                                    child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child:CircularProgressIndicator(
                                          color: Colora.scaffold_,
                                        )
                                    ),
                                  ),
                                )
                                :InkWell(
                                  onTap: () async{
                                    if(image != null){
                                      if(isEditing == false){
                                        bloc.add(AddSliderEvent(id: widget.market.id!, sliderImage: image!));
                                      }
                                      else{
                                        bloc.add(EditSliderEvent(id: sliderId, sliderImage: image!));
                                      }
                                    }
                                    else{
                                      showSnackBar(context, "لطفا عکس خود را انتخاب کنید");
                                    }
                                  },
                                  child: Container(
                                    width: Dimensions.width * 0.3,
                                    padding: EdgeInsets.symmetric(
                                        vertical: Dimensions.height * 0.01
                                    ),
                                    margin: EdgeInsets.only(
                                        top: Dimensions.height * 0.02
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colora.primaryColor,
                                        borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Center(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          isEditing == true
                                          ?'ویرایش'
                                          :'ذخیره',
                                          style: TextStyle(
                                            color: Colora.scaffold,
                                            fontSize: Dimensions.width * 0.033
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            //back
                            state.sliderStatus == VendorStatus.loading
                            ?const SizedBox()
                            :InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: Dimensions.width * 0.3,
                                padding: EdgeInsets.symmetric(
                                    vertical: Dimensions.height * 0.01
                                ),
                                margin: EdgeInsets.only(
                                    top: Dimensions.height * 0.02
                                ),
                                decoration: BoxDecoration(
                                    color: Colora.primaryColor,
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'بازگشت',
                                      style: TextStyle(
                                          color: Colora.scaffold,
                                          fontSize: Dimensions.width * 0.033
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),

                      ],
                    );
                  },
                  )
              ),
            );
          }
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }
        final NavigatorState navigator = Navigator.of(context);
        // final bool? shouldPop = await _showBackDialog();
        const bool shouldPop = true;
        BlocProvider.of<WorkspaceBloc>(context).add(LoadStores());
        if (shouldPop ?? false) {
          navigator.pop();
        }
      },
      child: BlocBuilder<VendorBloc, VendorState>(
        builder: (context, state) {
          return Container(
            color: state.topColor,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: state.backColor,
                body: SizedBox(
                  height: Dimensions.height,
                  width: Dimensions.width,
                  child: Stack(
                    children: [

                      //main items
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              SizedBox(
                                height: Dimensions.height * 0.27,
                              ),

                              //slider
                              SizedBox(
                                width: Dimensions.width,
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        currentSliderIndex = index;
                                      });
                                    },
                                    aspectRatio: 16 / 9,
                                    enlargeCenterPage: true,
                                    enableInfiniteScroll: false,
                                    disableCenter: false,
                                    pageSnapping: true,
                                    autoPlay: false,
                                  ),
                                  items: state.status == VendorStatus.loading
                                    ?List.generate(1, (index){
                                      return Container(
                                        width: Dimensions.width,
                                        margin: EdgeInsets.symmetric(
                                            vertical: Dimensions.height * 0.01
                                        ),
                                        padding: EdgeInsets.only(
                                            bottom: Dimensions.height * 0.01
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: state.topColor,
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 5,
                                                  spreadRadius: 1
                                              )
                                            ]
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey.withOpacity(0.2),
                                            highlightColor: Colors.black.withOpacity(0.2),
                                            direction: ShimmerDirection.rtl,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                            ),
                                          ),
                                        )
                                      );
                                    })
                                    :List.generate(
                                      state.sliderList.length >= sliderLength
                                        ?state.sliderList.length
                                        :state.sliderList.length + 1,
                                      (index) {
                                        if(index != state.sliderList.length){
                                          return Container(
                                            width: Dimensions.width,
                                            margin: EdgeInsets.symmetric(
                                                vertical: Dimensions.height * 0.01
                                            ),
                                            padding: EdgeInsets.only(
                                                bottom: Dimensions.height * 0.01
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: state.topColor,
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Colors.grey,
                                                      blurRadius: 5,
                                                      spreadRadius: 1
                                                  )
                                                ]
                                            ),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [

                                                    //image
                                                    if(state.sliderList[index].image!.contains('http'))...[
                                                      CachedNetworkImage(
                                                        imageUrl: state.sliderList[index].image.toString(),
                                                        imageBuilder: (context, imageProvider) {
                                                          return Container(
                                                            decoration: BoxDecoration(
                                                              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                                            ),
                                                          );
                                                        },
                                                        placeholder: (context, url) => Shimmer.fromColors(
                                                          baseColor: Colors.grey.withOpacity(0.2),
                                                          highlightColor: Colors.black.withOpacity(0.2),
                                                          direction: ShimmerDirection.rtl,
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                color: Colors.grey,
                                                                borderRadius: BorderRadius.circular(5)
                                                            ),
                                                          ),
                                                        ),
                                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                                      ),
                                                    ]
                                                    else...[
                                                      Image.file(
                                                        File(state.sliderList[index].image!),
                                                        fit: BoxFit.cover,
                                                      )
                                                    ],

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [

                                                        //edit
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colora.scaffold_,
                                                            border: Border.all(
                                                                color: state.topColor,
                                                                width: 2
                                                            )
                                                          ),
                                                          child: IconButton(
                                                            onPressed: (){
                                                              sliderImage(
                                                                context,
                                                                sliderId: state.sliderList[index].id!,
                                                                isEditing: true,
                                                                currentImage: state.sliderList[index].image.toString()
                                                              );
                                                            },
                                                            icon: Icon(
                                                              Icons.edit_rounded,
                                                              color: state.topColor,
                                                              size: Dimensions.width * 0.06,
                                                            )
                                                          ),
                                                        ),

                                                        SizedBox(width: Dimensions.width * 0.1,),

                                                        //remove
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: Colora.scaffold_,
                                                            border: Border.all(
                                                                color: state.topColor,
                                                                width: 2
                                                            )
                                                          ),
                                                          child: IconButton(
                                                              onPressed: (){
                                                                bloc.add(DeleteSliderEvent(id: state.sliderList[index].id!));
                                                                state.sliderList.removeAt(index);
                                                                setState(() {
                                                                  currentSliderIndex = index + 1;
                                                                });
                                                              },
                                                              icon: Icon(
                                                                Icons.delete_rounded,
                                                                color: Colors.redAccent,
                                                                size: Dimensions.width * 0.06,
                                                              )
                                                          ),
                                                        )

                                                      ],
                                                    )

                                                  ],
                                                ),
                                              )
                                          );
                                        }
                                        else{
                                          return Stack(
                                            children: [
                                              Container(
                                                  width: Dimensions.width,
                                                  margin: EdgeInsets.symmetric(
                                                    vertical: Dimensions.height * 0.01
                                                  ),
                                                  padding: EdgeInsets.only(
                                                    bottom: Dimensions.height * 0.01
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(20),
                                                    color: state.topColor,
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          color: Colors.grey,
                                                          blurRadius: 5,
                                                          spreadRadius: 1
                                                      )
                                                    ]
                                                  ),
                                                  child: InkWell(
                                                    onTap: (){
                                                      sliderImage(context, isEditing: false);
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        //image
                                                        Container(
                                                          width: Dimensions.width,
                                                          decoration: BoxDecoration(
                                                            color: Colora.scaffold,
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                          child: SvgPicture.asset(
                                                              'assets/images/logo_svg.svg',
                                                              colorFilter: ColorFilter.mode(state.topColor.withOpacity(0.7), BlendMode.srcIn)
                                                          )
                                                          // Image.asset(
                                                          //     'assets/images/logo.png'
                                                          // ),
                                                        ),

                                                        //add
                                                        Container(
                                                          width: Dimensions.width,
                                                          decoration: BoxDecoration(
                                                            color: Colora.scaffold.withOpacity(0.7),
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                          margin: EdgeInsets.only(
                                                            bottom: Dimensions.height * 0.01,
                                                            left: Dimensions.width * 0.02
                                                          ),
                                                          alignment: Alignment.bottomLeft,
                                                          child: Icon(
                                                            Icons.add_photo_alternate_rounded,
                                                            color: state.topColor,
                                                            size: Dimensions.width * 0.1,
                                                          ),

                                                        ),
                                                      ],
                                                    ),
                                                  )
                                              ),
                                            ],
                                          );
                                        }
                                      }
                                    ),
                                ),
                              ),

                              const SizedBox(
                                height: 7,
                              ),

                              //buttons
                              Container(
                                width: Dimensions.width,
                                margin: EdgeInsets.only(bottom: Dimensions.height * 0.02),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    ...List.generate(
                                    buttonTitles.length,
                                      (index) => AnimatedContainer(
                                        duration: const Duration(milliseconds: 500),
                                        width: Dimensions.width * 0.22,
                                        decoration: BoxDecoration(
                                          color: selectedIndex == index
                                            ?state.topColor
                                            :Colora.scaffold,
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: selectedIndex == index
                                              ?Colora.scaffold
                                              :state.topColor,
                                          )
                                        ),
                                        margin: EdgeInsets.symmetric(
                                          horizontal: Dimensions.width * 0.01
                                        ),
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                          vertical: Dimensions.height * 0.01
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          enableFeedback: false,
                                          focusColor: Colors.transparent,
                                          onTap: (){
                                            setState(() {
                                              selectedIndex = index;
                                            });
                                          },
                                          child: Text(
                                            buttonTitles[index],
                                            style: TextStyle(
                                              fontFamily: state.fontFamily,
                                              color: selectedIndex == index
                                                ? state.fontColor
                                                : state.secondFontColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: Dimensions.width * 0.035
                                            ),
                                          ),
                                        ),
                                      )
                                    )
                                  ],
                                ),
                              ),

                              //items
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 7),
                                child: selectPageView(selectedIndex, widget.market.id!, state, marketBloc),
                              )

                            ],
                          ),
                        ),
                      ),

                      //appbar
                      StoreAppbar2(
                        id: widget.market.id!,
                        title: widget.market.name!,
                        backImage: widget.market.backgroundImg.toString() == 'null' ? '' : widget.market.backgroundImg,
                        logoImage: widget.market.logoImg.toString() == 'null' ? '' : widget.market.logoImg,
                        mainColor: state.topColor,
                        fontColor: state.fontColor,
                        fontFamily: state.fontFamily,
                      ),

                      Positioned(
                        width: Dimensions.width,
                        height: Dimensions.height * 0.05,
                        top: Dimensions.height * 0.215,
                        child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: Dimensions.width * 0.1
                            ),
                            decoration: BoxDecoration(
                              color: state.topColor,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 2)
                                )
                              ]
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                //edit
                                InkWell(
                                  onTap: () {
                                    print("pressed");
                                  },
                                  // padding: const EdgeInsets.all(0),
                                  child: Icon(
                                    Icons.edit,
                                    color: state.fontColor,
                                    size: Dimensions.width * 0.055,
                                  ),
                                ),

                                //save
                                InkWell(
                                  onTap: () {
                                    print("pressed");
                                  },
                                  child: Icon(
                                    Icons.save,
                                    color: state.fontColor,
                                    size: Dimensions.width * 0.055,
                                  ),
                                ),

                                //mark
                                InkWell(
                                  onTap: () {
                                    print("pressed");
                                  },
                                  child: Icon(
                                    Icons.bookmark,
                                    color: state.fontColor,
                                    size: Dimensions.width * 0.055,
                                  ),
                                ),

                                //share
                                InkWell(
                                  onTap: () {
                                    print("pressed");
                                  },
                                  child: Icon(
                                    Icons.share,
                                    color: state.fontColor,
                                    size: Dimensions.width * 0.055,
                                  ),
                                ),

                                //upload
                                InkWell(
                                  onTap: () {
                                    print("pressed");
                                  },
                                  child: Icon(
                                    Icons.upload_file_outlined,
                                    color: state.fontColor,
                                    size: Dimensions.width * 0.055,
                                  ),
                                ),

                                //list
                                InkWell(
                                  onTap: () {
                                    print("pressed");
                                  },
                                  child: Icon(
                                    Icons.list_alt,
                                    color: state.fontColor,
                                    size: Dimensions.width * 0.055,
                                  ),
                                ),
                              ],
                            )
                        ),
                      ),

                      //bottom settings
                      Positioned(
                        bottom: 0,
                        child: CustomBottomNavigationBar(
                          marketId: widget.market.id!,
                          initTopColor: initTopColor,
                          initBackColor: initBackColor,
                          initSecondColor: initSecondColor,
                          initFont: initFont,
                          initFontColor: initFontColor,
                          initFontSecondColor: initFontSecondColor,
                        )
                      )

                    ],
                  ),
                ),
                // bottomNavigationBar: CustomBottomNavigationBar(
                //   marketId: widget.market.id!,
                //   initTopColor: initTopColor,
                //   initBackColor: initBackColor,
                //   initSecondColor: initSecondColor,
                //   initFont: initFont,
                //   initFontColor: initFontColor,
                //   initFontSecondColor: initFontSecondColor,
                // ),
              ),
            ),
          );
        }
      ),
    );
  }
}

/*
class ScrollableButtonList extends StatefulWidget {
  @override
  _ScrollableButtonListState createState() => _ScrollableButtonListState();
}

class _ScrollableButtonListState extends State<ScrollableButtonList> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 50,
        child: Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: buttonTitles.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 3.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: selectedIndex == index
                        ? MaterialStateProperty.all(Colora.primaryColor)
                        : MaterialStateProperty.all(Colors.white),
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                    elevation:
                        MaterialStateProperty.all(0), // Remove box shadow
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: const BorderSide(
                          color:
                              Colora.primaryColor, // Specify the border color
                        ),
                      ),
                    ),
                  ),
                  child: Text(
                    buttonTitles[index],
                    style: TextStyle(
                        color: selectedIndex == index
                            ? Colors.white
                            : Colora.primaryColor),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}*/

selectPageView(index, int marketId, styleState, MarketBloc marketBloc) {
  switch (index) {
    case 0:
      return productView(marketId, styleState, marketBloc);
    case 1:
      return specialView(styleState);
    case 2:
      return commentView();
    case 3:
      return contactUsView(styleState);
    default:
  }
}

productView(int marketId, styleState, MarketBloc marketBloc) {

  Widget templateWidget(int template){

    switch (template) {
      case 0:
        return buildProductGridView0(isSelected: true, marketId: marketId);
      case 1:
        return buildProductGridView1();
      case 2:
        return buildProductGridView2();
      case 3:
        return buildProductGridView3();
      case 4:
        return buildProductGridView4();
      case 5:
        return buildProductGridView5();
      case 6:
        return buildProductGridView6();
      case 7:
        return buildProductGridView7();
      case 8:
        return buildProductGridView8();
      case 9:
        return buildProductGridView9();
      case 10:
        return buildProductGridView10();
      case 11:
        return buildProductGridView11();
      case 12:
        return buildProductGridView12();
      case 13:
        return buildProductGridView13();
      case 14:
        return buildProductGridView14();
      case 15:
        return buildProductGridView15();
      case 16:
        return buildProductGridView16();
      case 17:
        return buildProductGridView17();
      default:
        return const SizedBox.shrink();
    }
  }

  return BlocBuilder<MarketBloc, MarketState>(
    builder: (context, state) => Column(
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 2,
              width: Dimensions.width * 0.3,
              color: styleState.topColor,
            ),
            SizedBox(
              width: Dimensions.width * 0.3,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "فروش ابزار یراق",
                    style: TextStyle(
                      color: styleState.topColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: styleState.fontFamily,
                      fontSize: Dimensions.width * 0.035
                    ),
                  ),
                )
              ),
            ),
            Container(
              height: 2,
              width: Dimensions.width * 0.3,
              color: styleState.topColor,
            ),
          ],
        ),

        // Container(
        //   width: Dimensions.width,
        //   height: Dimensions.height * 0.07,
        //   margin: EdgeInsets.symmetric(
        //     vertical: Dimensions.height * 0.01
        //   ),
        //   decoration: BoxDecoration(
        //     color: styleState.secondColor,
        //     borderRadius: BorderRadius.circular(10)
        //   ),
        //   child: MaterialButton(
        //     onPressed: (){
        //       marketBloc.add(ShowTemplatesEvent(isShow: !state.showTemplates));
        //     },
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //
        //         Text(
        //           'اضافه کردن قالب جدید',
        //           style: TextStyle(
        //             color: styleState.fontColor,
        //             fontFamily: styleState.fontFamily
        //           ),
        //         ),
        //
        //         SizedBox(width: Dimensions.width * 0.01,),
        //
        //         Icon(
        //           Icons.add_box,
        //           color: styleState.fontColor,
        //         )
        //       ],
        //     ),
        //   ),
        // ),

        //all templates
        if(state.showTemplates == true)...[
          SizedBox(
            width: Dimensions.width,
            height: Dimensions.height * 0.45,
            child: const MultiViewSliderScreen(),
          )
        ],

        //selected templates
        BlocBuilder<MarketBloc, MarketState>(
          builder: (context, state) {
            if(state.templateList.isEmpty){

              return const Center(child: Text(''),);

            }
            else{
              return ListView.builder(
                itemCount: state.templateList.length,
                shrinkWrap: true,
                reverse: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {

                  return Column(
                    children: [

                      Container(
                        width: Dimensions.width,
                        margin: EdgeInsets.symmetric(
                          vertical: Dimensions.height * 0.0
                        ),
                        child: templateWidget(state.templateList[index]),
                      ),

                      // SizedBox(
                      //   height: Dimensions.height * 0.05,
                      //   width: Dimensions.width,
                      //   child: Row(
                      //     children: [
                      //       IconButton(
                      //         onPressed: (){
                      //           marketBloc.add(RemoveTemplateEvent(index: index));
                      //           // state.templateList.removeAt(index);
                      //         },
                      //         icon: const Icon(
                      //           Icons.delete_rounded,
                      //           color: Colors.redAccent,
                      //         )
                      //       )
                      //     ],
                      //   ),
                      // )

                    ],
                  );

                },
              );
            }

          },
        ),

        SizedBox(
          height: Dimensions.height * 0.05,
        )


      ]
    )
  );
}

specialView(styleState) {
  return const SingleChildScrollView(
    child: Column(children: [
      Center(
        child: Text("ویژه‌ها"),
      ),
    ]),
  );
}

commentView() {

  return SingleChildScrollView(
    child: Column(
      children: [
        // Row(
        //   children: [
        //     Expanded(
        //       flex: 5,
        //       child: SizedBox(
        //         height: 35,
        //         child: CustomTextField(
        //             color: Colora.lightBlue,
        //             controller: TextEditingController(),
        //             hintStyle: const TextStyle(color: Colors.white),
        //             text: 'نام و نام خانوادگی'),
        //       ),
        //     ),
        //     Expanded(
        //       flex: 5,
        //       child: SizedBox(
        //         height: 35,
        //         child: CustomTextField(
        //           color: Colora.lightBlue,
        //           controller: TextEditingController(),
        //           hintStyle: const TextStyle(color: Colors.white),
        //           text: 'شماره موبایل',
        //           keyboardType: TextInputType.number,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        // const SizedBox(height: 7),
        // Container(
        //   width: Dimensions.width,
        //   child: Stack(
        //     children: [
        //       CustomTextField(
        //           color: Colora.lightBlue,
        //           maxLine: 7,
        //           hintStyle: const TextStyle(color: Colors.white),
        //           controller: TextEditingController(),
        //           text: "پیام شما ..."),
        //       Positioned(
        //           bottom: 10,
        //           left: 20,
        //           child: CustomButton(
        //             width: 100,
        //             onPress: () {},
        //             text: "ارسال",
        //             color: Colora.primaryColor,
        //           )),
        //     ],
        //   ),
        // ),
        const CMBox(
          senderName: 'میلاد',
          messageText: 'سلام محصولاتتون عالی هستند',
          senderImageUrl: 'https://via.placeholder.com/150',
        ),
      ]
    ),
  );
}

contactUsView(styleState) {
  return SingleChildScrollView(
    child: Column(
      children: [

        //title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 2,
              width: Dimensions.width * 0.3,
              color: styleState.topColor,
            ),
            SizedBox(
              width: Dimensions.width * 0.3,
              child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "فروش ابزار یراق",
                      style: TextStyle(
                          color: styleState.topColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: styleState.fontFamily,
                          fontSize: Dimensions.width * 0.035
                      ),
                    ),
                  )
              ),
            ),
            Container(
              height: 2,
              width: Dimensions.width * 0.3,
              color: styleState.topColor,
            ),
          ],
        ),

        SizedBox(
          height: Dimensions.height * 0.01,
        ),

        //contact
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //title
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'راه های ارتباطی:',
                style: TextStyle(
                    color: styleState.topColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: styleState.fontFamily,
                    fontSize: Dimensions.width * 0.044
                ),
              ),
            ),

            SizedBox(
              height: Dimensions.height * 0.01,
            ),

            //phone
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "۰۹۱۹۱۲۳۴۵۶۲",
                  style: TextStyle(
                    color: styleState.fontColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: styleState.fontFamily,
                    fontSize: Dimensions.width * 0.044
                  ),
                ),
                Icon(
                  Icons.phone,
                  color: styleState.fontColor,
                ),
              ],
            ),
          ],
        ),

        SizedBox(
          height: Dimensions.height * 0.01,
        ),

        //social networks
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            'شبکه‌های اجتماعی:',
            style: TextStyle(
                color: styleState.topColor,
                fontWeight: FontWeight.bold,
                fontFamily: styleState.fontFamily,
                fontSize: Dimensions.width * 0.044
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: (){},
                icon: Icon(
                  Icons.telegram,
                  color: styleState.fontColor,
                ),
              ),
              IconButton(
                onPressed: (){},
                icon: Icon(
                  Icons.telegram,
                  color: styleState.fontColor,
                ),
              ),
              IconButton(
                onPressed: (){},
                icon: Icon(
                  Icons.telegram,
                  color: styleState.fontColor,
                ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: Dimensions.height * 0.01,
        ),

        //map
        Container(
          height: 200,
          width: Dimensions.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colora.scaffold,
            border: Border.all(color: styleState.topColor, width: 3),
          ),
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: MapScreen(
                isSelecting: false,
                initialLocation: LocationModel(lat: 35.6783, lon: 51.4161),
              ),
            )
          ),
        ),

        SizedBox(
          height: Dimensions.height * 0.01,
        ),

        //address
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'آدرس : ',
              style: TextStyle(
                color: styleState.topColor,
                fontFamily: styleState.fontFamily,
                fontSize: Dimensions.width * 0.044,
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              'زنجان',
              style: TextStyle(
                color: styleState.fontColor,
                fontSize: 12,
                fontFamily: styleState.fontFamily
              ),
            ),
          ],
        ),

        SizedBox(
          height: Dimensions.height * 0.05,
        ),

      ],
    ),
  );
}
