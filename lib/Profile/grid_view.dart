import 'package:clubHouseLite/constants/Constantcolors.dart';
import 'package:flutter/material.dart';

List<String> _imageUrlList = [
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
  'https://cdn1-www.superherohype.com/assets/uploads/2013/11/batmane3-1.jpg',
];

class PostGridView extends StatefulWidget {
  PostGridView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PostGridViewState createState() => _PostGridViewState();
}

class _PostGridViewState extends State<PostGridView> {
  final snackBar = SnackBar(content: Text('Image is tapped.'));

  OverlayEntry _popupDialog;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      addAutomaticKeepAlives: true,
      cacheExtent: 10,
      padding: EdgeInsets.all(10),
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1.0,
      children: _imageUrlList.map(_createGridTileWidget).toList(),
    );
  }

  // create a tile widget from image url
  Widget _createGridTileWidget(String url) => Builder(
        // use Builder here in order to show the snakbar
        builder: (context) => GestureDetector(
          // keep the OverlayEntry instance, and insert it into Overlay
          onLongPress: () {
            _popupDialog = _createPopupDialog(url);
            Overlay.of(context).insert(_popupDialog);
          },
          // remove the OverlayEntry from Overlay, so it would be hidden
          onLongPressEnd: (details) => _popupDialog?.remove(),

          onTap: () => Scaffold.of(context).showSnackBar(snackBar),
          child: Image.network(url, fit: BoxFit.cover),
        ),
      );

  OverlayEntry _createPopupDialog(String url) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createPopupContent(url),
      ),
    );
  }

  // this is the main popup dialog content, which includes:
  // 1. a container with border radius
  // 2. a title bar
  // 3. a larger image in the middle
  // 4. a bottom action bar
  Widget _createPopupContent(String url) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // _createPhotoTitle(),
              Image.network(url, fit: BoxFit.fitWidth),
              _createActionBar(),
            ],
          ),
        ),
      );

  Widget _createPhotoTitle() => Container(
        padding: EdgeInsets.fromLTRB(10.0, 16.0, 10.0, 16.0),
        width: double.infinity,
        color: Colors.white,
        child: Text(
          'this is a large image',
        ),
      );

  Widget _createActionBar() => Container(
        padding: EdgeInsets.fromLTRB(10, 12, 10, 12),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
                onPanUpdate: (aas) {
                  print("liked");
                },
                child: Icon(Icons.favorite_border,
                    color: ConstantColors.blueColor)),
            Icon(Icons.chat_bubble_outline, color: ConstantColors.blueColor),
            Icon(Icons.send, color: ConstantColors.blueColor),
          ],
        ),
      );
}

// This a widget to implement the image scale animation, and background grey out effect.
class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> opacityAnimation;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo);
    opacityAnimation = Tween<double>(begin: 0.0, end: 0.6).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo));

    controller.addListener(() => setState(() {}));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(opacityAnimation.value),
      child: Center(
        child: FadeTransition(
          opacity: scaleAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
