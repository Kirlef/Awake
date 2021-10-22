import 'package:aibirdie/screens/Audio/audio_record.dart';
import 'package:aibirdie/services.dart/authentication.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import 'package:aibirdie/constants.dart';
import 'package:aibirdie/screens/landing_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:aibirdie/screens/Dashboard/dash.dart';
import 'package:aibirdie/screens/Dashboard/my_notes.dart';
import 'package:aibirdie/screens/Dashboard/checklist.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>
    with SingleTickerProviderStateMixin {
  TabController tc;
  SharedPreferences prefs;

  bool signedIn = false;
  bool showSpinner = false;

  int _selectedPage = 0;
  final _pages = [
    Dash(0),
    AudioRecord(),
    LandingPage(cameras),
  ];

  var appBarTitle = [
    "",
    "My Notes",
    "Checklist",
  ];

  @override
  void initState() {
    super.initState();
    tc = TabController(length: 3, vsync: this);
    getSignInStatus();
  }

  void getSignInStatus() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      signedIn = prefs.getBool('SignInStatus');
    });
  }

  @override
  void dispose() {
    tc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Drawer(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                children: <Widget>[
 //                 signedIn ? signedInWidget() : notSignedInWidget(),
 //                 signedIn ? Container() : signInWithGoogleButton(),
                  // Above line is temporarily commented
                  ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      color: darkPurple,
                    ),
                    title: Text(
                      "Sobre Awake",
                      style: level2softdp,
                    ),
                    onTap: (() => Alert(
                          context: context,
                          type: AlertType.info,
                          style: AlertStyle(
                              animationDuration: Duration(milliseconds: 500),
                              animationType: AnimationType.grow,
                              descStyle: level2softdp,
                              titleStyle: level1dp.copyWith(fontSize: 25)),
                          title: "Awake",
                          desc:
                              "Awake travel es más que una plataforma digital de viajes,\nsomos un puente donde conectamos a viajeros con\ncomunidades locales y destinos de naturaleza,\nusando el turismo como una herramienta para \nproteger nuestra biodiversidad y ofrecer a nuestros viajeros las\nmejores experiencias de viaje.",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "OK",
                                style: level1w,
                              ),
                              color: softGreen,
                              onPressed: () => Navigator.pop(context),
                              width: 120,
                            )
                          ],
                        ).show()),
                  ),
                  ListTile(
                    leading: Icon(
                      // Icons.share,
                      FontAwesomeIcons.shareSquare,
                      color: darkPurple,
                    ),
                    title: Text(
                      "Compartir",
                      style: level2softdp,
                    ),
                    onTap: (() => Share.share(
                        "Hola! Te comparto esta excelente app llamada Awake")),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.mail_outline,
                      color: darkPurple,
                    ),
                    title: Text(
                      "Escríbenos",
                      style: level2softdp,
                    ),
                    onTap: () async {
                      final Email email = Email(
                        body: 'Compártenos tu experiencia.',
                        subject: 'Comentarios Awake App',
                        recipients: ['awake@gmail.com'],
                        isHTML: false,
                      );

                      await FlutterEmailSender.send(email);
                    },
                  ),
                  /*
                  ListTile(
                    // enabled: true,
                    leading: Icon(
                      Icons.healing,
                      color: darkPurple,
                    ),
                    title: Text(
                      "Veterinary Services",
                      style: level2softdp,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => VServices()),
                      );
                    },
                  ),
                  ListTile(
                    onTap: () {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          action: SnackBarAction(
                            label: 'OK',
                            onPressed: () {},
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          backgroundColor: darkPurple,
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            'Settings are not available yet. Be patient.',
                            style: level2softw,
                          ),
                        ),
                      );
                    },
                    leading: Icon(
                      Icons.settings,
                      color: darkPurple,
                    ),
                    title: Text(
                      "Settings",
                      style: level2softdp,
                    ),
                  ),
                  */
                  Spacer(),
         //         signedIn?
                       FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          // onPressed: signOut,
                          onPressed: () async {
                            var connectivityResult =
                                await (Connectivity().checkConnectivity());
                            if (connectivityResult == ConnectivityResult.none) {
                              Alert(
                                  context: context,
                                  title: "Error de Conexión",
                                  type: AlertType.error,
                                  desc:
                                      "Your phone is not connected to the internet.\nCheck your connection and try again",
                                  style: AlertStyle(
                                    descStyle: level2softdp,
                                    isCloseButton: false,
                                    titleStyle: level2softdp.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                  closeFunction: () {
                                    Navigator.of(context).pop();
                                  },
                                  buttons: [
                                    DialogButton(
                                      radius: BorderRadius.circular(100),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      color: softGreen,
                                      child: Text(
                                        "OK",
                                        style: level2softw,
                                      ),
                                    ),
                                  ]).show();
                              // Navigator.of(context).pop();
                            } else {
                              setState(() {
                                showSpinner = true;
                              });
                              await signOut();
                              setState(() {
                                showSpinner = false;
                                signedIn = false;
                              });
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  action: SnackBarAction(
                                      label: 'OK', onPressed: () {}),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: darkPurple,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    'Salir.',
                                    style: level2softw,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Text(
                            "Salir",
                            style: level2softw,
                          ),
                          color: softGreen,
                        )
                      //: Container(),
                ],
              ),
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: darkPurple,
            leading: _menuButton(),
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            stretch: true,
            bottom: _selectedPage == 0
                ? PreferredSize(
                    preferredSize: Size(100, 60),
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      height: 40,
                      child: TabBar(
                        indicator: BoxDecoration(
                          color: softGreen,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        labelColor: Colors.white,
                        labelStyle: level2softdp,
                        unselectedLabelColor: Colors.white,
                        unselectedLabelStyle: level2softdp,
                        controller: tc,
                        onTap: (index) {
                          setState(() {
                            _pages[0] = Dash(index);
                          });
                        },
                        tabs: <Widget>[
                          Tab(
                            child: Text("Inicio"),
                          ),
                          Tab(
                            child: Text("Imágenes"),
                          ),
                          Tab(
                            child: Text("Audios"),
                          ),
                        ],
                      ),
                    ),
                  )
                : null,
            stretchTriggerOffset: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                appBarTitle[_selectedPage],
                style: level2softdp.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'images/8.jpg',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, 0.7),
                        end: Alignment(0.0, 0.0),
                        colors: <Color>[
                          darkPurple.withOpacity(0.80),
                          Colors.transparent,
                          // Color(0x60000000),
                          // Color(0x00000000),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: _pages[_selectedPage],
            ),
          ),
        ],
      ),
      /*
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: darkPurple,
            selectedItemColor: softGreen,
            selectedLabelStyle: level2softg.copyWith(fontSize: 12),
            currentIndex: _selectedPage,
            showUnselectedLabels: false,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              if (index == 3) {
                LandingPage.controller.animateToPage(1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              } else
                setState(() => _selectedPage = index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                title: Text("Dashboard"),
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.note),
                title: Text("Notes"),
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.playlist_add_check),
                title: Text("Audio"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.camera_alt),
                title: Text("Camera"),
              ),
            ],
          ),
        ),
      ),
      */
    );
  }

  Widget signedInWidget() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(),
      accountEmail: Text(
        "${prefs.getString('userEmail')}",
        style: level2softdp,
      ),
      accountName: Text(
        "${prefs.getString('userName')}",
        style: level2softdp.copyWith(fontWeight: FontWeight.bold),
      ),
      currentAccountPicture: Material(
          elevation: 5.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          child: ClipOval(
              child: signedIn
                  ? Image.network(
                      "${prefs.getString('userPhotoUrl')}",
                      // loadingBuilder: (context, child, loadingProgress) =>
                      //     CircularProgressIndicator(),
                    )
                  : Container())),
    );
  }

  Widget notSignedInWidget() {
    return UserAccountsDrawerHeader(
      onDetailsPressed: () {
        Scaffold.of(context).showSnackBar(SnackBar(
            action: SnackBarAction(label: 'OK', onPressed: () {}),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            backgroundColor: darkPurple,
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Functionality temporarily disabled. Crowd sourcing module is pending.',
              style: level2softw,
            )));
      },
      decoration: BoxDecoration(),
      accountEmail: Text(
        "Ingresa con tu cuenta de Google",
        style: level2softdp,
      ),
      accountName: Text(
        "Ingresar",
        style: level1dp,
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(Icons.account_circle, size: 60, color: softGreen),
      ),
    );
  }

  Widget signInWithGoogleButton() {
    return Container(
      width: 220,
      child: RaisedButton(
        elevation: 5.0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Image.asset(
              'images/google_logo.png',
              width: 25,
            ),
            // SizedBox(width: 10,),
            Text(
              "Sign In with Google",
              style: level2softdp,
            ),
          ],
        ),
        // onPressed: signIn,
        onPressed: () async {
          var connectivityResult = await (Connectivity().checkConnectivity());
          if (connectivityResult == ConnectivityResult.none) {
            Alert(
                context: context,
                title: "Network Error",
                type: AlertType.error,
                desc:
                    "Your phone is not connected to the internet.\nCheck your connection and try again",
                style: AlertStyle(
                  descStyle: level2softdp,
                  isCloseButton: false,
                  titleStyle: level2softdp.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
                closeFunction: () {
                  Navigator.of(context).pop();
                },
                buttons: [
                  DialogButton(
                    radius: BorderRadius.circular(100),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: softGreen,
                    child: Text(
                      "OK",
                      style: level2softw,
                    ),
                  ),
                ]).show();
            // Navigator.of(context).pop();
          } else {
            setState(() {
              showSpinner = true;
            });
            await signInWithGoogle();
            setState(() {
              showSpinner = false;
              signedIn = true;
            });
            Scaffold.of(context).showSnackBar(
              SnackBar(
                action: SnackBarAction(label: 'OK', onPressed: () {}),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: darkPurple,
                behavior: SnackBarBehavior.floating,
                content: Text(
                  'Signed in successfully.',
                  style: level2softw,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _menuButton() {
    return Padding(
      padding: EdgeInsets.only(
        // top: 15,
        top: 0.0,
      ),
      child: RawMaterialButton(
        onPressed: (() => _scaffoldKey.currentState.openDrawer()),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 6.0),
                height: 2.00,
                width: 22.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.00),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 6.0),
                height: 2.00,
                width: 15.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.00),
                ),
              ),
              Container(
                height: 2.00,
                // width: 11.00,
                width: 22.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.00),
                ),
              ),
            ]),
      ),
    );
  }
}
