import 'package:flutter/material.dart';

Widget statuspendingColor({@required text, double fontSize = 8}) => text ==
        "Pending"
    ? Container(
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        decoration: const BoxDecoration(
          color: Color(0xFFFFF3E0),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Text(
          text.toString(),
          style: TextStyle(
              fontSize: fontSize ?? 10,
              color: const Color(0xffFF9800),
              fontWeight: FontWeight.w600),
        ),
      )
    : text == "Rejected"
        ? Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            decoration: const BoxDecoration(
              color: Color(0xFFFFCDD2),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Text(
              text.toString(),
              style: TextStyle(
                  fontSize: fontSize ?? 10,
                  color: const Color(0xffE53935),
                  fontWeight: FontWeight.w600),
            ),
          )
        : text == "Cancelled"
            ? Container(
                margin: const EdgeInsets.all(5.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFCDD2),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Text(
                  text.toString(),
                  style: TextStyle(
                      fontSize: fontSize ?? 10,
                      color: const Color(0xffE53935),
                      fontWeight: FontWeight.w600),
                ),
              )
            : Container(
                margin: const EdgeInsets.all(5.0),
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                decoration: const BoxDecoration(
                  color: Color(0xFFC8E6C9),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Text(
                  text.toString(),
                  style: TextStyle(
                      fontSize: fontSize ?? 12,
                      color: const Color(0xff4CAF50),
                      fontWeight: FontWeight.w600),
                ),
              );

Widget appovalpending({@required text, double fontSize = 12}) =>
    text == "Approved"
        ? Container(
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
          )
        : text == "Rejected"
            ? Container(
                child: const Icon(
                  Icons.clear_outlined,
                  color: Colors.red,
                ),
              )
            : Container(
                child: const Icon(
                  Icons.date_range,
                  color: Colors.orange,
                ),
              );
