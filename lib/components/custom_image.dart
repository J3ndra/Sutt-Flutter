import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sutt/components/image_loader.dart';

class CustomImage extends StatefulWidget {
  const CustomImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  State<CustomImage> createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  late ImageStream _imageStream;
  late ImageInfo _imageInfo;

  late ImageDetail _imageDetail;
  late ImageValueNotifier _imageValueNotifier;

  @override
  void initState() {
    _imageDetail = ImageDetail();
    _imageValueNotifier = ImageValueNotifier(_imageDetail);

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));

    _animation = Tween<double>(begin: 600.0, end: 400.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _imageStream =
        NetworkImage(widget.imageUrl).resolve(const ImageConfiguration());

    _imageStream.addListener(ImageStreamListener((info, value) {
      _imageInfo = info;
      _imageValueNotifier.changeLoadingState(true);
      _animationController.forward();
    }, onChunk: (event) {
      _imageValueNotifier
          .changeCumulativeBytesLoaded(event.expectedTotalBytes!);
      _imageValueNotifier
          .changeCumulativeBytesLoaded(event.cumulativeBytesLoaded);
    }));

    super.initState();
  }

  @override
  void dispose() {
    _imageInfo.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _imageValueNotifier,
      builder: (context, ImageDetail value, child) {
        return Container(
          height: 100.0,
          width: MediaQuery.of(context).size.width,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(),
          child: !value.isLoaded
              ? Center(
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: Theme.of(context).colorScheme.onBackground,
                    size: 40,
                  ),
                )
              : Center(
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return OverflowBox(
                        child: SizedBox(
                          height: _animation.value,
                          width: _animation.value - 100.0,
                          child: child,
                        ),
                      );
                    },
                    child: RawImage(
                      image: _imageInfo.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
        );
      },
    );
  }
}
