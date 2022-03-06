import 'package:flutter/material.dart';
import 'package:avatar_glow/avatar_glow.dart';

class RequiredIcon extends StatelessWidget {
  final IconData? iconData;
  final Function onPressed;
  final double radius;
  final double iconSize;
  RequiredIcon(
      {this.iconData,
      required this.onPressed,
      required this.radius,
      required this.iconSize});
  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      glowColor: Color(0xFFF9287B),
      duration: Duration(milliseconds: 20000),
      repeatPauseDuration: Duration(milliseconds: 0),
      endRadius: 50,
      child: AvatarGlow(
        glowColor: Color(0xFFF9287B),
        duration: Duration(milliseconds: 19000),
        repeatPauseDuration: Duration(milliseconds: 0),
        endRadius: 50,
        child: AvatarGlow(
          glowColor: Color(0xFFF9287B),
          duration: Duration(milliseconds: 18000),
          repeatPauseDuration: Duration(milliseconds: 0),
          endRadius: 50,
          child: AvatarGlow(
            glowColor: Color(0xFFF9287B),
            duration: Duration(milliseconds: 17000),
            repeatPauseDuration: Duration(milliseconds: 0),
            endRadius: 50,
            child: AvatarGlow(
              glowColor: Color(0xFFF9287B),
              duration: Duration(milliseconds: 16000),
              repeatPauseDuration: Duration(milliseconds: 0),
              endRadius: 50,
              child: AvatarGlow(
                glowColor: Color(0xFFF9287B),
                duration: Duration(milliseconds: 15000),
                repeatPauseDuration: Duration(milliseconds: 0),
                endRadius: 50,
                child: AvatarGlow(
                  glowColor: Color(0xFFF9287B),
                  duration: Duration(milliseconds: 14000),
                  repeatPauseDuration: Duration(milliseconds: 0),
                  endRadius: 50,
                  child: AvatarGlow(
                    glowColor: Color(0xFFF9287B),
                    duration: Duration(milliseconds: 13000),
                    repeatPauseDuration: Duration(milliseconds: 0),
                    endRadius: 50,
                    child: AvatarGlow(
                      glowColor: Color(0xFFF9287B),
                      duration: Duration(milliseconds: 12000),
                      repeatPauseDuration: Duration(milliseconds: 0),
                      endRadius: 50,
                      child: AvatarGlow(
                        glowColor: Color(0xFFF9287B),
                        duration: Duration(milliseconds: 11000),
                        repeatPauseDuration: Duration(milliseconds: 0),
                        endRadius: 50,
                        child: AvatarGlow(
                          glowColor: Color(0xFFF9287B),
                          duration: Duration(milliseconds: 10000),
                          repeatPauseDuration: Duration(milliseconds: 0),
                          endRadius: 50,
                          child: AvatarGlow(
                            glowColor: Color(0xFFF9287B),
                            duration: Duration(milliseconds: 9000),
                            repeatPauseDuration: Duration(milliseconds: 0),
                            endRadius: 50,
                            child: AvatarGlow(
                              glowColor: Color(0xFF7E1CEA),
                              duration: Duration(milliseconds: 8000),
                              repeatPauseDuration: Duration(milliseconds: 0),
                              endRadius: 50,
                              child: AvatarGlow(
                                glowColor: Color(0xFFF9287B),
                                duration: Duration(milliseconds: 7000),
                                repeatPauseDuration: Duration(milliseconds: 0),
                                endRadius: 50,
                                child: AvatarGlow(
                                  glowColor: Color(0xFF7E1CEA),
                                  duration: Duration(milliseconds: 6000),
                                  repeatPauseDuration:
                                      Duration(milliseconds: 0),
                                  endRadius: 50,
                                  child: AvatarGlow(
                                    glowColor: Color(0xFFF9287B),
                                    duration: Duration(milliseconds: 5000),
                                    repeatPauseDuration:
                                        Duration(milliseconds: 0),
                                    endRadius: 50,
                                    child: AvatarGlow(
                                        glowColor: Color(0xFF7E1CEA),
                                        endRadius: 50,
                                        duration: Duration(milliseconds: 4000),
                                        animate: true,
                                        showTwoGlows: true,
                                        repeatPauseDuration:
                                            Duration(milliseconds: 0),
                                        child: CircleAvatar(
                                          radius: radius,
                                          backgroundColor: Color(0xFF36274A),
                                          child: IconButton(
                                            iconSize: iconSize,
                                            icon: Icon(
                                              iconData,
                                            ),
                                            color: Colors.white,
                                            onPressed:
                                                onPressed as void Function()?,
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OtherButton extends StatelessWidget {
  final IconData? iconData;
  final Function onPressed;
  final double radius;
  final Color? color;
  final double iconSize;
  OtherButton(
      {required this.iconSize,
      required this.radius,
      this.iconData,
      this.color,
      required this.onPressed});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Color(0xFF36274A),
      child: IconButton(
        iconSize: iconSize,
        icon: Icon(
          iconData,
        ),
        color: color == null ? Colors.white : color,
        onPressed: onPressed as void Function()?,
      ),
    );
  }
}
