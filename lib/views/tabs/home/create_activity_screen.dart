import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kroma_sport/api/httpclient.dart';
import 'package:kroma_sport/api/httpresult.dart';
import 'package:kroma_sport/models/sport.dart';
import 'package:kroma_sport/themes/colors.dart';
import 'package:kroma_sport/utils/app_size.dart';
import 'package:kroma_sport/utils/extensions.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class CreateActivityScreen extends StatefulWidget {
  static const tag = '/createActivityScreen';

  CreateActivityScreen({Key? key}) : super(key: key);

  @override
  _CreateActivityScreenState createState() => _CreateActivityScreenState();
}

class _CreateActivityScreenState extends State<CreateActivityScreen> {
  KSHttpClient ksClient = KSHttpClient();
  List<FavoriteSport> favSportList = [];
  late int selectedSport;

  List<String> activityLevelList = ['Chill', 'Moderate', 'Intense'];
  late String selectedActivity;

  Widget buildNavbar() {
    return SliverAppBar(
      title: Text(
        'Add Activity',
        style:
            Theme.of(context).textTheme.headline6?.copyWith(color: whiteColor),
      ),
      backgroundColor: Colors.transparent,
      iconTheme: Theme.of(context).iconTheme.copyWith(color: whiteColor),
      pinned: true,
      elevation: 0.0,
      //forceElevated: true,
      //actions: [
      //  TextButton(
      //    onPressed: availablePost() ? onPost : null,
      //    child: Text(
      //      'Post',
      //      style: Theme.of(context).textTheme.bodyText1?.copyWith(
      //          color: availablePost() ? mainColor : Colors.green[200],
      //          fontWeight: FontWeight.w600),
      //    ),
      //  ),
      //],
    );
  }

  Widget buildAddPhotoWidget() {
    return Container(
      width: AppSize(context).appWidth(100),
      height: AppSize(context).appWidth(100),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green,
            Colors.green[600]!,
            Colors.green[700]!,
            Colors.teal[600]!,
            Colors.teal[700]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: images.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                24.height,
                Icon(Feather.camera, color: whiteColor),
                8.height,
                Text(
                  'Add a photo',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 16.0,
                  ),
                ),
                8.height,
                Text(
                  'Selfies are always encouraged!',
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: 14.0,
                  ),
                ),
              ],
            )
          : AssetThumb(
              asset: images[0],
              width: images[0].originalWidth!,
              height: images[0].originalHeight!,
            ),
    );
  }

  Widget buildSportOption(FavoriteSport data) {
    return ElevatedButton(
      onPressed: () {
        setState(() => selectedSport = data.sport.id);
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        foregroundColor: MaterialStateProperty.all(
            data.sport.id == selectedSport
                ? whiteColor
                : Theme.of(context).textTheme.bodyText2?.color),
        backgroundColor: MaterialStateProperty.all(
            data.sport.id == selectedSport
                ? Colors.teal
                : Theme.of(context).primaryColor),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: data.sport.id == selectedSport
                ? BorderSide.none
                : BorderSide(color: Colors.blueGrey),
          ),
        ),
      ),
      child: Text(data.sport.name),
    );
  }

  Widget buildActivityLevel(String activity) {
    return ElevatedButton(
      onPressed: () {
        setState(() => selectedActivity = activity);
      },
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        foregroundColor: MaterialStateProperty.all(activity == selectedActivity
            ? whiteColor
            : Theme.of(context).textTheme.bodyText2?.color),
        backgroundColor: MaterialStateProperty.all(activity == selectedActivity
            ? Colors.teal
            : Theme.of(context).primaryColor),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: activity == selectedActivity
                ? BorderSide.none
                : BorderSide(color: Colors.blueGrey),
          ),
        ),
      ),
      child: Text(activity),
    );
  }

  Widget buildScrollBody() {
    Color iconColor = Theme.of(context).brightness == Brightness.light
        ? Colors.grey
        : Colors.grey[300]!;
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          InkWell(
            onTap: () {
              print('Add photo___________');
              getImage();
            },
            child: Container(
              width: AppSize(context).appWidth(100),
              height: AppSize(context).appWidth(100) -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top -
                  64.0,
              color: Colors.transparent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  margin: EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Feather.clock, color: iconColor),
                          16.width,
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                print('____________set time');
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tue 11 May',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text(
                                    '5:30 pm to 6:30 pm',
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  16.height,
                                  Divider(
                                    color: Colors.blueGrey[100],
                                    thickness: 1,
                                    height: 0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      16.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Feather.map_pin, color: iconColor),
                          16.width,
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                print('____________set location');
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Add location (Optional)',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).brightness == Brightness.light ? Colors.blueGrey[600] : whiteColor
                                    ),
                                  ),
                                  16.height,
                                  Divider(
                                    color: Colors.blueGrey[100],
                                    thickness: 1,
                                    height: 0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      16.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          40.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                favSportList.isNotEmpty
                                    ? Wrap(
                                        spacing: 8.0,
                                        children: List.generate(
                                            favSportList.length, (index) {
                                          final sport =
                                              favSportList.elementAt(index);
                                          return buildSportOption(sport);
                                        }),
                                      )
                                    : SizedBox(),
                                16.height,
                                Divider(
                                  color: Colors.blueGrey[100],
                                  thickness: 1,
                                  height: 0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      16.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          40.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Activity level',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                8.height,
                                Wrap(
                                  spacing: 8.0,
                                  children: List.generate(
                                    activityLevelList.length,
                                    (index) {
                                      final activity =
                                          activityLevelList.elementAt(index);
                                      return buildActivityLevel(activity);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  margin: EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Feather.bookmark, color: iconColor),
                          16.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name',
                                  style: Theme.of(context).textTheme.bodyText1?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                8.height,
                                TextField(
                                  style: Theme.of(context).textTheme.bodyText2,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: 'Name of activity (Required)',
                                    hintStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                                16.height,
                                Divider(
                                  color: Colors.blueGrey[100],
                                  thickness: 1,
                                  height: 0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      16.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Feather.bookmark, color: iconColor),
                          16.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  style: Theme.of(context).textTheme.bodyText2,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: 'Description (Optional)',
                                    hintStyle:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                                16.height,
                                Divider(
                                  color: Colors.blueGrey[100],
                                  thickness: 1,
                                  height: 0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 48.0,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty.all(Colors.teal),
                    ),
                    child: Text(
                      'Next: Who are with you?',
                      style: TextStyle(fontSize: 16.0, color: whiteColor),
                    ),
                  ),
                ),
                16.height,
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildAddPhotoWidget(),
          CustomScrollView(
            slivers: [
              buildNavbar(),
              buildScrollBody(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getFavoriteSport();
    selectedActivity = activityLevelList[0];
  }

  void getFavoriteSport() async {
    var data = await ksClient.getApi('/user/favorite/sport');
    if (data != null) {
      if (data is! HttpResult) {
        favSportList =
            List.from((data as List).map((e) => FavoriteSport.fromJson(e)));
        if (favSportList.isNotEmpty)
          selectedSport = favSportList.elementAt(0).sport.id;
        setState(() {});
      }
    }
  }

  List<Asset> images = <Asset>[];

  Future getImage() async {
    //final pickedFile = await picker.getImage(source: ImageSource.gallery);

    //setState(() {
    //  if (pickedFile != null) {
    //    imageFile = File(pickedFile.path);
    //    reuseImage = File(pickedFile.path);
    //  } else {
    //    print('No image selected.');
    //  }
    //});

    List<Asset>? assetList;
    //String imageKey = 'images';
    try {
      assetList = await MultiImagePicker.pickImages(
        maxImages: 1,
      );
    } on Exception catch (_) {}

    if (!mounted) return;

    if (assetList != null) {
      images = assetList;
      setState(() {});
    }

    //if (assetList != null) {
    //  Future.forEach(assetList, (element) async {
    //    {
    //      ByteData byteData = await (element as Asset).getByteData();
    //      List<int> imageData = byteData.buffer.asUint8List();

    //      files.add(MultipartFile.fromBytes(
    //        imageKey,
    //        imageData,
    //        filename: 'FD' +
    //            DateTime.now().millisecondsSinceEpoch.toString() +
    //            '.jpg',
    //      ));
    //    }
    //  }).then((value) {
    //    //showKSLoading(context);
    //    //TmsService().uploadPhotoGallery(files: files).then((user) {
    //    //  if (user != null) {
    //    //    widget.userDetails.user = user;
    //    //    TMS.shared.user = user;
    //    //    Navigator.pop(context);
    //    //    setState(() {});
    //    //  }
    //    //});
    //  });
    //}
  }
}
