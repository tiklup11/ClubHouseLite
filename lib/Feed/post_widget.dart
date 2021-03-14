import 'package:clubHouseLite/Feed/post.dart';
import 'package:clubHouseLite/constants/Constantcolors.dart';
import 'package:clubHouseLite/services/app_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_button/flutter_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:provider/provider.dart';
import 'package:clubHouseLite/home_pages/home_page.dart';

class PostCard extends StatelessWidget {
  final Post postData;
  final User currentUser;
  PostCard({this.postData, this.currentUser});
  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(
      builder: (context, appTheme, _) => Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        // height: MediaQuery.of(context).size.height * 0.58,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 4),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(postData.ownerAvatarUrl),
                    backgroundColor: ConstantColors.greyColor,
                    radius: 20,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: RichText(
                          text: TextSpan(
                            text: postData.ownerName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: appTheme.bnw,
                                fontFamily: "Poppins",
                                fontSize: 14),
                          ),
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: ConstantColors.lightColor.withOpacity(0.8),
                            ),
                            RichText(
                              text: TextSpan(
                                  text: "${postData.location},",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ConstantColors.blueColor,
                                      fontFamily: "Poppins",
                                      fontSize: 12),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "   10 Hours ago.",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: ConstantColors.lightColor
                                                .withOpacity(0.8)))
                                  ]),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: BlurHash(
                hash: postData.blurHash,
                image: postData.postUrl,
                imageFit: BoxFit.contain,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, top: 4, bottom: 0),
              child: Text(
                postData.caption,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: appTheme.bnw,
                    fontFamily: "Poppins",
                    fontSize: 14),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20),
                  // width: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Bounce(
                        child: Icon(
                          FontAwesomeIcons.heart,
                          size: 22,
                          color: ConstantColors.redColor,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "0",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: appTheme.bnw),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Bounce(
                        child: Icon(
                          FontAwesomeIcons.comment,
                          size: 22,
                          color: ConstantColors.blueColor,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "0",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: appTheme.bnw),
                      )
                    ],
                  ),
                ),
                Spacer(),
                postData.ownerUid == currentUser.uid
                    ? IconButton(
                        icon: Icon(
                          EvaIcons.moreVertical,
                          color: appTheme.bnw,
                        ),
                        onPressed: () {
                          _deletePost(postData.postId);
                        })
                    : Container()
              ],
            )
          ],
        ),
      ),
    );
  }

  _deletePost(String postId) {
    postRef.doc(postId).delete();
    storageRef.child("post_${postId}_.jpg").delete();
  }
}
