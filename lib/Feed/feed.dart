import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clubHouseLite/Feed/feed_widgets.dart';
import 'package:clubHouseLite/Feed/post.dart';
import 'package:clubHouseLite/Feed/post_widget.dart';
import 'package:clubHouseLite/constants/Constantcolors.dart';
import 'package:clubHouseLite/home_pages/feed_and_msg_controller.dart';
import 'package:clubHouseLite/home_pages/home_page.dart';
import 'package:clubHouseLite/services/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:blurhash/blurhash.dart' as blueHashGenerator;
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserFeed extends StatefulWidget {
  final User currentUser;
  UserFeed({this.currentUser});
  @override
  _UserFeedState createState() => _UserFeedState();
}

class _UserFeedState extends State<UserFeed> {
  TextEditingController captionEditingController = TextEditingController();
  TextEditingController locationEditingController = TextEditingController();

  ImagePicker postImagePicker;
  bool isUploadingPost = false;
  File uploadPostFile;
  String uploadImageDownloadUrl;
  String postUid = Uuid().v4();

  bool isFetchingPost = true;
  List<PostCard> allPostList;

  @override
  void initState() {
    super.initState();
    getAllPosts();
    postImagePicker = new ImagePicker();
  }

  @override
  void dispose() {
    super.dispose();
    captionEditingController.dispose();
    locationEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, appTheme, _) => Scaffold(
          drawer: FeedWidgets.customDrawer(context),
          appBar: AppBar(
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  FontAwesomeIcons.buffer,
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            iconTheme: IconThemeData(color: appTheme.msgIconColor),
            actions: [
              Consumer<FNMPageViewController>(
                builder: (context, fnM, _) => IconButton(
                  onPressed: () {
                    fnM.jumpToPage(1);
                  },
                  icon: Icon(
                    FontAwesomeIcons.facebookMessenger,
                    color: appTheme.msgIconColor,
                  ),
                ),
              ),
            ],
            elevation: 0,
            automaticallyImplyLeading: true,
            centerTitle: true,
            backgroundColor: appTheme.bottomNavBar,
            title: Bounce(
              onPressed: () {
                showSelectImageBottomSheet(context);
              },
              child: RichText(
                text: TextSpan(
                    text: "ClubHouse",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        color: appTheme.darkOnLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    children: <TextSpan>[
                      TextSpan(
                        text: "Lite",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: appTheme.darkOnLight.withOpacity(0.6),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      )
                    ]),
              ),
            ),
          ),
          body: isFetchingPost
              ? Center(
                  child: Image.asset('assets/gifs/empty.gif'),
                )
              : RefreshIndicator(
                  child: buildFeed(),
                  onRefresh: getAllPosts,
                )),
    );
  }

  Future<void> getAllPosts() async {
    allPostList = [];
    QuerySnapshot allPostQuerySnapshot =
        await postRef.orderBy('timeStamp', descending: true).get();
    allPostQuerySnapshot.docs.forEach((doc) {
      // print(doc.data());
      allPostList.add(PostCard(
        postData: Post.from(doc),
        currentUser: widget.currentUser,
      ));
    });
    setState(() {
      isFetchingPost = false;
    });
  }

  buildFeed() {
    return ListView.builder(
      cacheExtent: 20,
      physics: BouncingScrollPhysics(),
      itemCount: allPostList.length,
      itemBuilder: (context, index) {
        return allPostList[index];
      },
    );
  }

  showSelectImageBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Consumer<AppTheme>(
            builder: (context, apptheme, _) => Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: apptheme.bottomSheetColor),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      color: ConstantColors.whiteColor,
                      thickness: 4,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          _handleChossePhotoFroGallery();
                          Navigator.pop(context);
                        },
                        color: ConstantColors.blueColor,
                        child: Text(
                          "Gallery",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: ConstantColors.whiteColor),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          _handleTakePhoto();
                          Navigator.pop(context);
                        },
                        color: ConstantColors.blueColor,
                        child: Text(
                          "Camera",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: ConstantColors.whiteColor),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  _handleTakePhoto() async {
    PickedFile pickedFile =
        await postImagePicker.getImage(source: ImageSource.camera);
    final File file = File(pickedFile.path);
  }

  Future<File> _cropImage(File originalFile) async {
    AppTheme appTheme = Provider.of<AppTheme>(context, listen: false);

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: originalFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            cropFrameStrokeWidth: 10,
            cropGridStrokeWidth: 20,
            dimmedLayerColor: Colors.black,
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    return croppedFile;
  }

  _handleChossePhotoFroGallery() async {
    File croppedImageFile;
    PickedFile pickedFile =
        await postImagePicker.getImage(source: ImageSource.gallery);
    uploadPostFile = File(pickedFile.path);

    if (pickedFile != null) {
      croppedImageFile = await _cropImage(uploadPostFile);
      uploadPostFile = croppedImageFile;
    }

    // pickedFile != null
    //     ? uploadPostFile = File(pickedFile.path)
    //     : print("File not loaded");

    uploadPostFile != null
        ? showImagePreview(context)
        : print("canot show imagePreview");
  }

  showImagePreview(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Consumer<AppTheme>(
            builder: (context, appTheme, _) => Container(
              padding: EdgeInsets.only(bottom: 10),
              height: 400,
              // height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: appTheme.bottomSheetColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 150, vertical: 10),
                    decoration: BoxDecoration(
                        color: ConstantColors.whiteColor,
                        borderRadius: BorderRadius.circular(10)),
                    height: 6,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ConstantColors.transperant),
                    child: Image(
                      fit: BoxFit.fill,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        return Center(child: child);
                      },
                      image: FileImage(
                        uploadPostFile,
                      ),
                      height: 250,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: _handleChossePhotoFroGallery,
                        // color: ConstantColors.whiteColor,
                        child: Text(
                          "ReSelect",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: ConstantColors.whiteColor),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                          showFinalPostSheet(context);
                        },
                        color: ConstantColors.blueColor,
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: ConstantColors.whiteColor),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  showFinalPostSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Consumer<AppTheme>(
            builder: (context, appTheme, _) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setSheet) =>
                  Container(
                height: MediaQuery.of(context).size.height * 0.85,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: appTheme.bottomSheetColor,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      margin:
                          EdgeInsets.symmetric(horizontal: 150, vertical: 10),
                      decoration: BoxDecoration(
                          color: ConstantColors.whiteColor,
                          borderRadius: BorderRadius.circular(10)),
                      height: 6,
                    ),
                    FeedWidgets.finalImagePreviewToUser(file: uploadPostFile),
                    Divider(
                      height: 30,
                    ),
                    //location
                    Row(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset('assets/images/location.jpg'),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 6),
                          height: 30,
                          width: 5,
                          color: ConstantColors.blueColor,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 30,
                          width: 330,
                          child: TextField(
                            textCapitalization: TextCapitalization.words,
                            maxLengthEnforced: true,
                            controller: locationEditingController,
                            style: TextStyle(
                                color: ConstantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            decoration: InputDecoration(
                              hintText: "Enter photo location",
                              hintStyle: TextStyle(
                                  color: ConstantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            cursorWidth: 4,
                            cursorHeight: 20,
                            maxLines: 1,
                          ),
                        )
                      ],
                    ),
                    Divider(
                      height: 20,
                    ), //caption row
                    Row(
                      children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset('assets/images/sun.png'),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 6),
                          height: 110,
                          width: 5,
                          color: ConstantColors.blueColor,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          height: 120,
                          width: 330,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(100),
                            ],
                            maxLength: 100,
                            maxLengthEnforced: true,
                            controller: captionEditingController,
                            style: TextStyle(
                                color: ConstantColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            decoration: InputDecoration(
                              hintText: "Add a caption..",
                              hintStyle: TextStyle(
                                  color: ConstantColors.whiteColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            cursorWidth: 4,
                            cursorHeight: 22,
                            maxLines: 3,
                          ),
                        )
                      ],
                    ),
                    Divider(
                      height: 20,
                    ),
                    isUploadingPost
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  height: 180,
                                  width: 200,
                                  child: Image.asset('assets/gifs/pica.gif')),
                              Text(
                                "Uploading..",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.orangeAccent),
                              )
                            ],
                          )
                        : //material buttons [cancel] & [Post]
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                // color: ConstantColors.whiteColor,
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: ConstantColors.whiteColor),
                                ),
                              ),
                              MaterialButton(
                                onPressed: isUploadingPost
                                    ? null
                                    : () {
                                        setSheet(() {
                                          isUploadingPost = true;
                                          print(
                                              "isUpload-------$isUploadingPost");
                                        });
                                        _handlePostSubmit();
                                      },
                                color: ConstantColors.blueColor,
                                child: Text(
                                  "Post",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: ConstantColors.whiteColor),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  compressImg() async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(uploadPostFile.readAsBytesSync());
    final File compressedPostImg = File("$path/img_$postUid.jpg")
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 60));
    setState(() {
      uploadPostFile = compressedPostImg;
    });
  }

  _handlePostSubmit() async {
    //1 Compressing Image
    await compressImg();
    String photoUrl = await uplaodImageToFirestore(uploadPostFile);
    String blurHash = await generateBlurHash(uploadPostFile);
    createPostInFirestore(
      caption: captionEditingController.text,
      location: locationEditingController.text,
      photoUrl: photoUrl,
      blurHash: blurHash,
    );

    getAllPosts();
  }

  Future<String> uplaodImageToFirestore(imageFile) async {
    Reference imageRef = storageRef.child('post_${postUid}_.jpg');
    UploadTask uploadTask = imageRef.putFile(imageFile);
    await uploadTask.whenComplete(() => print("File Uploaded"));
    String downloadUrl = await imageRef.getDownloadURL();
    return downloadUrl;
  }

  void createPostInFirestore(
      {String caption, String location, String photoUrl, String blurHash}) {
    postRef.doc(postUid).set({
      'ownerId': widget.currentUser.uid,
      'postId': postUid,
      'postUrl': photoUrl,
      'ownerName': widget.currentUser.displayName,
      'caption': caption,
      'location': location,
      'timeStamp': DateTime.now(),
      'ownerAvatarUrl': widget.currentUser.photoURL,
      'likes': {},
      'blurHash': blurHash
    });
    captionEditingController.clear();
    locationEditingController.clear();
    setState(() {
      isUploadingPost = false;
      uploadPostFile = null;
      postUid = Uuid().v4();
    });
    Navigator.pop(context);
  }

  Future<String> generateBlurHash(File postFile) async {
    Uint8List bytes = await postFile.readAsBytes();
    String blurHash = await blueHashGenerator.BlurHash.encode(bytes, 2, 2);
    return blurHash;
  }
}
