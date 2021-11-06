import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              top: 100,
              bottom: 0,
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
                  webViewXController.setIgnoreAllGestures(false);
                },
              ),
            ),
            // 마우스 이벤트 어떻게 처리할지
            // 드롭다운 -> 블럭 선택
            // 컬러 -> 컬러팔레트
            // 파일 다운로드
            Positioned(
              height: 100,
              left: 0,
              right: 0,
              child: Container(
                color: Color.fromRGBO(173, 216, 236, 1),
                child: Row(
                  children: [
                    const FlutterLogo(size: 70),
                    SizedBox(width: 5),
                    Text("Flutter\nController"),
                    SizedBox(width: 10),
                    CupertinoButton(
                      color: Colors.blue,
                      child: Text("FRONT"),
                      onPressed: () {
                        callMethod('global_camera_frontView');
                      },
                    ),
                    CupertinoButton(
                      color: Colors.blue,
                      child: Text("TOP"),
                      onPressed: () {
                        callMethod('global_camera_topView');
                      },
                    ),
                    CupertinoButton(
                      color: Colors.blue,
                      child: Text("CUBE-RED"),
                      onPressed: () {
                        callMethod('global_control_selectColor', params: [2]);
                        callMethod('global_control_selectShape', params: [1]);
                      },
                    ),
                    CupertinoButton(
                      color: Colors.blue,
                      child: Text("OBJ"),
                      onPressed: () {
                        String result = callMethod('global_control_getObjCode');
                        print(result);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  dynamic callMethod(String name, {List<dynamic>? params}) {
    html.Element? frame = html.querySelector('iframe');
    var jsFrame = js.JsObject.fromBrowserObject(frame!);
    js.JsObject jsDocument = jsFrame['contentWindow'];
    js.JsObject jsGlobal = jsDocument['globalThis'];
    return jsGlobal.callMethod(name, params);
  }

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
