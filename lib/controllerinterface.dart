// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mayssa_app/homepage.dart';
import 'package:mayssa_app/loginpages/login.dart';
import 'package:mayssa_app/shared/constant.dart';
import 'package:mayssa_app/shared/controldirection.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ControllerInterface extends StatefulWidget {
  const ControllerInterface({super.key});

  @override
  State<ControllerInterface> createState() => _ControllerInterfaceState();
}

class _ControllerInterfaceState extends State<ControllerInterface> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                child: ToggleSwitch(
                  minWidth: 90.0,
                  cornerRadius: 20.0,
                  activeBgColors: [
                    [Colors.green[800]!],
                    [Colors.red[800]!]
                  ],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  initialLabelIndex: 1,
                  totalSwitches: 2,
                  labels: const ['On', 'Off'],
                  radiusStyle: true,
                  onToggle: (index) {
                    // print('switched to: $index');
                  },
                ),
              ),
            ),
            Column(
              children: [
                ControllDirection(
                    direction: "assets/images/up.svg", onPressed: () {}),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ControllDirection(
                        direction: "assets/images/left.svg", onPressed: () {}),
                    Container(
                      width: 100,
                      height: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: mainColor,
                      ),
                      child: Center(
                          child: GestureDetector(
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          if (!mounted) return;
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                              (route) => false);
                        },
                        child: Text(
                          "STOP",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.red),
                        ),
                      )),
                    ),
                    ControllDirection(
                        direction: "assets/images/right.svg", onPressed: () {}),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ControllDirection(
                    direction: "assets/images/down.svg", onPressed: () {}),
              ],
            ),
            InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Text(
                  "",
                  style: TextStyle(),
                )),
          ],
        ),
      ),
    ));
  }
}
