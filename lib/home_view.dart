import 'dart:convert' as convert;
import 'dart:ui';

import 'package:brick_craft/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:webviewx/webviewx.dart';

import 'dart:html' as html;
import 'dart:js' as js;

// flutter run -d chrome --web-renderer html
// flutter build web --web-renderer html

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late WebViewXController webViewXController;

  PackageInfo? packageInfo;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) {
      packageInfo = value;
      setState(() {});
    });
  }

  double blockElevation = 5;
  double colorElevation = 5;
  double clockElevation = 5;
  double counterclockElevation = 5;
  double trashElevation = 5;
  double shareElevation = 5;
  double viewpointElevation = 5;

  bool isShapeSelector = false;
  bool isColorPallete = false;

  bool isDelete = false;

  int currentColorIndex = 1;
  int currentShapeIndex = 1;

  late double toolbarHeight;

  int shapeRotation = 0;

  int mobileWidth = 750;
  bool isMobile = false;

  bool isStart = true;
  double startWindowOpacity = 1;

  @override
  Widget build(BuildContext context) {
    isMobile = MediaQuery.of(context).size.width < mobileWidth;

    toolbarHeight = isMobile ? 210 : 120;

    List<Widget> bottomWidgets = [
      SizedBox(width: 20),

      ///
      /// Block Selector
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: GestureDetector(
          onTapDown: (_) {
            blockElevation = 0;
            setState(() {});
          },
          onTapUp: (_) {
            blockElevation = 5;

            isShapeSelector = !isShapeSelector;
            webViewXController.setIgnoreAllGestures(isShapeSelector);

            setState(() {});
          },
          child: Card(
            elevation: blockElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              width: 75,
              height: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    height: 55,
                    image: AssetImage("assets/thumbnail$currentShapeIndex.png"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),

      ///
      ///
      ///
      ///
      ///
      ///
      /// Color Picker
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: GestureDetector(
          onTapDown: (_) {
            colorElevation = 0;
            setState(() {});
          },
          onTapUp: (_) {
            colorElevation = 5;

            isColorPallete = !isColorPallete;
            webViewXController.setIgnoreAllGestures(isColorPallete);

            setState(() {});
          },
          child: Card(
            elevation: colorElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(70),
            ),
            child: Container(
              width: 70,
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(55),
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(55),
                        boxShadow: [
                          BoxShadow(
                              color: palleteColors[currentColorIndex - 1][1]),
                          BoxShadow(
                            color: palleteColors[currentColorIndex - 1][0],
                            offset: Offset(0, 2),
                            spreadRadius: 0.0,
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),

      ///
      ///
      ///
      ///
      ///
      /// Roatate block
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: GestureDetector(
          onTapDown: (_) {
            clockElevation = 0;
            setState(() {});
          },
          onTapUp: (_) {
            clockElevation = 5;
            rotateBlock(true);
            setState(() {});
          },
          child: Card(
            elevation: clockElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              width: 75,
              height: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.arrow_clockwise,
                    size: 40,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: GestureDetector(
          onTapDown: (_) {
            counterclockElevation = 0;
            setState(() {});
          },
          onTapUp: (_) {
            counterclockElevation = 5;
            rotateBlock(false);
            setState(() {});
          },
          child: Card(
            elevation: counterclockElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              width: 75,
              height: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.arrow_counterclockwise,
                    size: 40,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      ///
      ///
      ///
      ///
      /// Delete Mode
      if (!isMobile) deleteButton(),

      ///
      ///
      ///
      ///
      /// viewpoint
      if (!isMobile)
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Container(
            width: 1,
            height: 60,
            color: Colors.grey.shade300,
          ),
        ),
      if (!isMobile)
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Card(
            elevation: viewpointElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image(image: AssetImage("assets/viewpoint.png")),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTapDown: (_) {
                              viewpointElevation = 0;
                              setState(() {});
                            },
                            onTapUp: (_) {
                              viewpointElevation = 5;
                              callMethod("global_camera_topView");
                              setState(() {});
                            },
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTapDown: (_) {
                                    viewpointElevation = 0;
                                    setState(() {});
                                  },
                                  onTapUp: (_) {
                                    viewpointElevation = 5;
                                    callMethod("global_camera_frontView");
                                    setState(() {});
                                  },
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTapDown: (_) {
                                    viewpointElevation = 0;
                                    setState(() {});
                                  },
                                  onTapUp: (_) {
                                    viewpointElevation = 5;
                                    callMethod("global_camera_rightSideView");
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Container(
          width: 1,
          height: 60,
          color: Colors.grey.shade300,
        ),
      ),

      ///
      ///
      ///
      ///
      /// Download OBJ
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: GestureDetector(
          onTapDown: (_) {
            shareElevation = 0;
            setState(() {});
          },
          onTapUp: (_) {
            shareElevation = 5;

            exportObjFile("output");

            setState(() {});
          },
          child: Card(
            elevation: shareElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              width: 75,
              height: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.arrow_down_circle,
                    size: 40,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      SizedBox(width: 20),
    ];

    ///
    ///
    ///
    ///
    ///
    ///
    ///
    ///
    ///
    ///
    ///
    ///

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: toolbarHeight,
              right: 0,
              left: 0,
              child: WebViewX(
                ignoreAllGestures: true,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                initialContent: initialContent,
                initialSourceType: SourceType.html,
                onWebViewCreated: (WebViewXController wvxController) {
                  webViewXController = wvxController;
                  webViewXController.setIgnoreAllGestures(true);
                },
              ),
            ),
            // 마우스 이벤트 어떻게 처리할지
            // 드롭다운 -> 블럭 선택
            // 컬러 -> 컬러팔레트
            // 파일 다운로드
            Positioned(
              top: 30,
              left: 30,
              child: Row(
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(100),
                          offset: Offset(0, 3),
                          blurRadius: 7,
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image(
                        height: 60,
                        image: AssetImage("logo.png"),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "BrickCraft",
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: "nanum",
                      fontWeight: FontWeight.w900,
                      color: Color.fromRGBO(30, 30, 30, 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              height: toolbarHeight,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: toolbarHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      offset: Offset(0, -3),
                      blurRadius: 25,
                    )
                  ],
                ),
                child: isMobile
                    ? Column(
                        children: [
                          SizedBox(height: 12),
                          Container(
                            height: 85,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: bottomWidgets,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          deleteButton(
                            width: MediaQuery.of(context).size.width - 50,
                            height: 65,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: bottomWidgets,
                      ),
              ),
            ),

            Positioned(
              bottom: toolbarHeight + 25,
              right: 30,
              child: Text(
                packageInfo != null
                    ? "v${packageInfo!.version}+${packageInfo!.buildNumber}"
                    : "",
                style: TextStyle(
                  fontFamily: "nanum",
                  fontSize: 20,
                  color: Colors.black.withAlpha(75),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            if (isShapeSelector)
              Positioned(
                bottom: toolbarHeight,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 200,
                        width: 320,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(100),
                              offset: Offset(0, 3),
                              blurRadius: 7,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    blockButton("assets/thumbnail1.png", 1),
                                    blockButton("assets/thumbnail2.png", 2),
                                    blockButton("assets/thumbnail3.png", 3),
                                  ],
                                ),
                                Row(
                                  children: [
                                    blockButton("assets/thumbnail4.png", 4),
                                    blockButton("assets/thumbnail5.png", 5),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (isColorPallete)
              Positioned(
                bottom: toolbarHeight,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 200,
                        width: 320,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(100),
                              offset: Offset(0, 3),
                              blurRadius: 7,
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    colorButton(palleteColors[0][0],
                                        palleteColors[0][1], 1),
                                    colorButton(palleteColors[1][0],
                                        palleteColors[1][1], 2),
                                    colorButton(palleteColors[2][0],
                                        palleteColors[2][1], 3),
                                  ],
                                ),
                                Row(
                                  children: [
                                    colorButton(palleteColors[3][0],
                                        palleteColors[3][1], 4),
                                    colorButton(palleteColors[4][0],
                                        palleteColors[4][1], 5),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (isStart)
              AnimatedOpacity(
                duration: Duration(milliseconds: 250),
                opacity: startWindowOpacity,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(45),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha(100),
                                  offset: Offset(0, 3),
                                  blurRadius: 7,
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(45),
                              child: Image(
                                height: 120,
                                image: AssetImage("logo.png"),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "BrickCraft",
                            style: TextStyle(
                              fontSize: 35,
                              fontFamily: "nanum",
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 20),
                          CustomButton(
                            size: 180,
                            height: 50,
                            color: [
                              Colors.blueAccent,
                              Colors.blueAccent.shade700,
                            ],
                            colorTapDown: [
                              Colors.blueAccent.shade700,
                              Colors.blueAccent,
                            ],
                            borderColor: Colors.blue.shade800,
                            child: Text(
                              "Start to build!",
                              style: TextStyle(
                                fontFamily: "nanum",
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            onPressed: () {
                              startWindowOpacity = 0;
                              setState(() {});

                              Future.delayed(Duration(milliseconds: 250))
                                  .then((value) {
                                webViewXController.setIgnoreAllGestures(false);
                                isStart = false;
                                setState(() {});
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void rotateBlock(bool isClockwise) {
    webViewXController.setIgnoreAllGestures(false);
    int changeShape = 0;

    if (isClockwise) {
      shapeRotation += 1;
      if (shapeRotation >= 4) shapeRotation = 0;
    } else {
      shapeRotation -= 1;
      if (shapeRotation < 0) shapeRotation = 3;
    }

    switch (currentShapeIndex) {
      case 1:
        changeShape = 1;
        break;
      case 2:
        changeShape = 2 + shapeRotation;
        break;
      case 3:
        changeShape = 6 + shapeRotation;
        break;
      case 4:
        changeShape = 10;
        break;
      case 5:
        changeShape = 11;
        break;
    }
    callMethod("global_control_selectShape", params: [changeShape]);
  }

  List<List<Color>> palleteColors = [
    [Color.fromRGBO(68, 68, 68, 1), Colors.black],
    [Color.fromRGBO(255, 106, 128, 1), Colors.red.shade900],
    [Color.fromRGBO(91, 123, 255, 1), Colors.purple.shade900],
    [Color.fromRGBO(114, 251, 144, 1), Colors.green.shade900],
    [Colors.white, Colors.grey],
  ];

  Widget deleteButton({double width = 75, double height = 75}) => Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: GestureDetector(
          onTapDown: (_) {
            trashElevation = 0;
            setState(() {});
          },
          onTapUp: (_) {
            trashElevation = 5;
            isDelete = !isDelete;
            if (isDelete)
              callMethod("global_control_delete");
            else
              callMethod("global_control_create");

            setState(() {});
          },
          child: Card(
            elevation: trashElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: isDelete ? Colors.red : Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.trash,
                    size: width > height ? height - 35 : width - 35,
                    color: isDelete ? Colors.white : Colors.grey.shade600,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  dynamic callMethod(String name, {List<dynamic>? params}) {
    html.Element? frame = html.querySelector('iframe');
    var jsFrame = js.JsObject.fromBrowserObject(frame!);
    js.JsObject jsDocument = jsFrame['contentWindow'];
    js.JsObject jsGlobal = jsDocument['globalThis'];
    return jsGlobal.callMethod(name, params);
  }

  void exportObjFile(String filename) {
    String objCode = callMethod("global_control_getObjCode");

    // https://stackoverflow.com/questions/59783344/flutter-web-download-option
    // https://stackoverflow.com/questions/59663377/how-to-save-and-download-text-file-in-flutter-web-application
    // prepare
    final bytes = convert.utf8.encode(objCode);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = filename + ".obj";
    html.document.body!.children.add(anchor);

    // download
    anchor.click();

    // cleanup
    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }

  Widget blockButton(String assetName, int index) => Padding(
        padding: const EdgeInsets.all(3.0),
        child: GestureDetector(
          onTapDown: (_) {
            blockElevation = 0;
            setState(() {});
          },
          onTapUp: (_) {
            blockElevation = 5;

            isShapeSelector = false;
            isColorPallete = false;

            webViewXController.setIgnoreAllGestures(false);
            currentShapeIndex = index;

            switch (index) {
              case 1:
                index = 1;
                break;
              case 2:
                index = 2 + shapeRotation;
                break;
              case 3:
                index = 6 + shapeRotation;
                break;
              case 4:
                index = 10;
                break;
              case 5:
                index = 11;
                break;
            }

            callMethod("global_control_selectShape", params: [index]);
            setState(() {});
          },
          child: Card(
            elevation: blockElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Container(
              width: 75,
              height: 75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    height: 55,
                    image: AssetImage(assetName),
                  )
                ],
              ),
            ),
          ),
        ),
      );

  Widget colorButton(Color btnColor, Color btnColorShadow, int index) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: GestureDetector(
          onTapDown: (_) {
            colorElevation = 0;
            setState(() {});
          },
          onTapUp: (_) {
            colorElevation = 5;

            isShapeSelector = false;
            isColorPallete = false;

            currentColorIndex = index;

            callMethod("global_control_selectColor", params: [index]);

            webViewXController.setIgnoreAllGestures(false);
            setState(() {});
          },
          child: Card(
            elevation: colorElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(70),
            ),
            child: Container(
              width: 70,
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(55),
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(55),
                        boxShadow: [
                          BoxShadow(color: btnColorShadow),
                          BoxShadow(
                            color: btnColor,
                            offset: Offset(0, 2),
                            spreadRadius: 0.0,
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );

  final initialContent = """
    <!DOCTYPE html>
    <html>
      <head>

        <script src="./modeler.js" type="module"></script>
        <link rel="stylesheet" href="./modeler_style.css" type="text/css">

      </head>
      <body>

        <canvas id="c">
          Your browser doesn't support the HTML5 canvas element
        </canvas>

      </body>
    </html>
  """;
}
