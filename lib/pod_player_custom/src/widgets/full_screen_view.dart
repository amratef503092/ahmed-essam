part of '../pod_player.dart';

class FullScreenView extends StatefulWidget {
  final String tag;
  const FullScreenView({
    required this.tag,
    super.key,
  });

  @override
  State<FullScreenView> createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<FullScreenView>
    with TickerProviderStateMixin {
  late PodGetXVideoController _podCtr;
  String? phoneNumberUser;
  @override
  void initState() {
    _podCtr = Get.find<PodGetXVideoController>(tag: widget.tag);
    _podCtr.fullScreenContext = context;
    _podCtr.keyboardFocusWeb?.removeListener(_podCtr.keyboadListner);
    getUserPhoneNumber();
    numberDisplay();
    super.initState();
  }

  @override
  void dispose() {
    _podCtr.keyboardFocusWeb?.requestFocus();
    _podCtr.keyboardFocusWeb?.addListener(_podCtr.keyboadListner);
    super.dispose();
  }

  void getUserPhoneNumber() async {
    print(phoneNumberUser);
    setState(() async {
      phoneNumberUser = await SharedPreferenceHelper().getPhoneNumber();
    });
  }

  bool display = true;
  void numberDisplay() {
    Timer.periodic(Duration(seconds: 10), (timer) {
      setState(() {
        display = !display;
        random();
      });
    });
  }

  int randomTop = Random().nextInt(100);
  int randomLeft = Random().nextInt(200);
  int randomRight = Random().nextInt(200);
  int randomBottom = Random().nextInt(100);
  bool randomPosition = false;
  bool randomPosition2 = true;
  void random() {
    randomTop = Random().nextInt(100);
    randomLeft = Random().nextInt(100);
    randomRight = Random().nextInt(100);
    randomBottom = Random().nextInt(100);
     randomPosition = Random().nextBool();
    randomPosition2 = Random().nextBool();
    print(randomPosition);
    print(randomPosition2);
  }

  @override
  Widget build(BuildContext context) {
    final loadingWidget = _podCtr.onLoading?.call(context) ??
        const CircularProgressIndicator(
          backgroundColor: Colors.black87,
          color: Colors.white,
          strokeWidth: 2,
        );

    return WillPopScope(
      onWillPop: () async {
        if (kIsWeb) {
          await _podCtr.disableFullScreen(
            context,
            widget.tag,
            enablePop: false,
          );
        }
        if (!kIsWeb) await _podCtr.disableFullScreen(context, widget.tag);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GetBuilder<PodGetXVideoController>(
          tag: widget.tag,
          builder: (podCtr) => Stack(
            children: [
              Center(
                child: ColoredBox(
                  color: Colors.black,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: podCtr.videoCtr == null
                          ? loadingWidget
                          : podCtr.videoCtr!.value.isInitialized
                              ? _PodCoreVideoPlayer(
                                  tag: widget.tag,
                                  videoPlayerCtr: podCtr.videoCtr!,
                                  videoAspectRatio:
                                      podCtr.videoCtr?.value.aspectRatio ??
                                          16 / 9,
                                )
                              : loadingWidget,
                    ),
                  ),
                ),
              ),
              display
                  ? randomPosition
                      ? Positioned(
                          top: randomTop.toDouble(),
                          left: randomLeft.toDouble(),
                          child: Text(
                            phoneNumberUser ?? "",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : randomPosition2
                          ? Positioned(
                              top: randomTop.toDouble(),
                              right: randomRight.toDouble(),
                              child: Text(
                                phoneNumberUser ?? "",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          : randomPosition
                              ? Positioned(
                                  bottom: randomBottom.toDouble(),
                                  right: randomRight.toDouble(),
                                  child: Text(
                                    phoneNumberUser ?? "",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Positioned(
                                  bottom: randomBottom.toDouble(),
                                  left: randomRight.toDouble(),
                                  child: Text(
                                    phoneNumberUser ?? "",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
