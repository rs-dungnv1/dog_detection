// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';

// class CustomCamera extends StatefulWidget {
//   const CustomCamera({super.key});

//   @override
//   State<CustomCamera> createState() => _CustomCameraState();
// }

// class _CustomCameraState extends State<CustomCamera> {
//   late CameraController cameraController;
//   @override
//   void initState() {
//      cameraController=  CameraController();
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {


//     return AspectRatio(
//           aspectRatio: cameraController.value.aspectRatio,
//           child: Stack(fit: StackFit.expand, children: [
//             CameraPreview(cameraController),
//             cameraOverlay(
//                 padding: 50, aspectRatio: 1, color: Color(0x55000000))
//           ]));
//   }

//   Widget cameraOverlay({required double padding, required double aspectRatio, required Color color}) {
//     return LayoutBuilder(builder: (context, constraints) {
//       double parentAspectRatio = constraints.maxWidth / constraints.maxHeight;
//       double horizontalPadding;
//       double verticalPadding;

//       if (parentAspectRatio < aspectRatio) {
//         horizontalPadding = padding;
//         verticalPadding = (constraints.maxHeight -
//                 ((constraints.maxWidth - 2 * padding) / aspectRatio)) /
//             2;
//       } else {
//         verticalPadding = padding;
//         horizontalPadding = (constraints.maxWidth -
//                 ((constraints.maxHeight - 2 * padding) * aspectRatio)) /
//             2;
//       }
//       return Stack(fit: StackFit.expand, children: [
//         Align(
//             alignment: Alignment.centerLeft,
//             child: Container(width: horizontalPadding, color: color)),
//         Align(
//             alignment: Alignment.centerRight,
//             child: Container(width: horizontalPadding, color: color)),
//         Align(
//             alignment: Alignment.topCenter,
//             child: Container(
//                 margin: EdgeInsets.only(
//                     left: horizontalPadding, right: horizontalPadding),
//                 height: verticalPadding,
//                 color: color)),
//         Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//                 margin: EdgeInsets.only(
//                     left: horizontalPadding, right: horizontalPadding),
//                 height: verticalPadding,
//                 color: color)),
//         Container(
//           margin: EdgeInsets.symmetric(
//               horizontal: horizontalPadding, vertical: verticalPadding),
//           decoration: BoxDecoration(border: Border.all(color: Colors.cyan)),
//         )
//       ]);
//     });
//   }
// }

import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  offset: Offset(1.0, 2.0),
                  blurRadius: 8.0,
                  spreadRadius: 2.0)
            ]),
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                    width: 48.0,
                    height: 48.0,
                    alignment: Alignment.centerLeft,
                    decoration: const BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    child: const Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.settings))),
                const Expanded(
                    child: Center(
                  child: Text("Hellow world",
                      // style: Theme.of(context)
                      //     .textTheme
                      //     .headline6
                      //     .copyWith(color: Colors.black),
                          ),
                )),
              ],
            ),
            SizedBox.expand(
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(onTap: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}