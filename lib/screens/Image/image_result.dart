import 'dart:io';
import 'package:ai_birdie_image/aibirdieimage.dart';
// import 'package:aibirdie/APIs/image_api/classification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:aibirdie/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
// import 'package:aibirdie/APIs/aibirdie_image_api/aibirdie_image_classification.dart';
// import 'package:aibirdie/APIs/aibirdie_image_api/generated/image_classification.pbgrpc.dart';

class ImageResult extends StatefulWidget {
  final File imageInputFile;


  ImageResult(this.imageInputFile);

  @override
  _ImageResultState createState() => _ImageResultState();
}

class _ImageResultState extends State<ImageResult> {

  bool _showSpinner = false;

  List<int> ids = [];
  List<String> labels = [];
  List<double> accuracy = [];
  List<String> accuracyStrings = [];
  List<DocumentSnapshot> docSpecies = [];


  @override
  void initState() {
    super.initState();
    //_doPrediction();
  }

    void _doPrediction() async {
    Firestore db = Firestore.instance;
    CollectionReference refBirdSpecies = db.collection("bird-species");
    CollectionReference refImages = db.collection("images");
    print(refImages);

    // bird-specie document contains images collection and each id represents image id of document images collection
    // image document has uri
    // use firebase storage to fetch image

    var classifier = AIBirdieImage.classification();

    var predictionResult =
        await classifier.predict([widget.imageInputFile.path]);
    for (Map result in predictionResult) {
      ids = List.castFrom<dynamic, int>(result['id']);

      for (var e in ids) {
        docSpecies.add(await refBirdSpecies.document(e.toString()).get());
      }

      accuracy = List.castFrom<dynamic, double>(result['probabilities']);
    }

    setState(() {
      labels = docSpecies.map<String>((e) => e.data["name"]).toList();
      accuracyStrings = accuracy
          .map<String>((e) => '${(e * 100).toString().substring(0, 5)} %')
          .toList();
      _showSpinner = false;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        // color: darkPurple,
        progressIndicator: CircularProgressIndicator(),

        inAsyncCall: _showSpinner,
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Resultados",
                      style: level2softg.copyWith(
                          fontSize: 35, fontFamily: 'OS_semi_bold'),
                    ),
                    SizedBox(
                      height: 40,
                    ),

                    GestureDetector(
                      onTap: () {
                        var show = Alert(
                            style: AlertStyle(
                                titleStyle: level2softdp.copyWith(
                                    fontSize: 25, fontWeight: FontWeight.bold)),
                            title: 'Rock Bunting',
                            type: AlertType.info,
                            content: Column(
                              children: <Widget>[
                                Text(
                                  "It breeds in northwest Africa, southern Europe east to central Asia, and the Himalayas.This bird is 16 cm in length. The breeding male has chestnut upperparts, unmarked deep buff underparts, and a pale grey head marked with black striping. The female rock bunting is a washed-out version of the male, with paler underparts, a grey-brown back and a less contrasted head. The juvenile is similar to the female, but with a streaked head.The rock bunting breeds in open dry rocky mountainous areas.",
                                  style: level2softdp,
                                  textAlign: TextAlign.justify,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text("Learn more",
                                        style: level2softdp.copyWith(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            context: context,
                            buttons: [
                              DialogButton(
                                  color: softGreen,
                                  child: Text(
                                    "OK",
                                    style: level2softw,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  })
                            ]);
                        show.show();
                      },
                      child: Container(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Halcón",
                                    style: level2softdp,
                                    textAlign: TextAlign.justify,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        "Nombre científico: Falco",
                                        style: level2softdp,
                                        textAlign: TextAlign.justify,
                                      ),
                                      Text("Velocidad: 390 Km/h",
                                          style: level2softdp.copyWith(
                                            color: Colors.blue,
                                            decoration: TextDecoration.underline,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          margin:
                          EdgeInsets.only(bottom: 20, left: 30, right: 30),
                          height: 70,
                          decoration: BoxDecoration(
                            color: Color(0xfff5f5f5),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(-6.00, -6.00),
                                color: Color(0xffffffff).withOpacity(0.80),
                                blurRadius: 10,
                              ),
                              BoxShadow(
                                offset: Offset(6.00, 6.00),
                                color: Color(0xff000000).withOpacity(0.20),
                                blurRadius: 10,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15.00),
                          )),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
