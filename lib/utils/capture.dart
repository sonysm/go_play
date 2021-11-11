import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class Capture{
    static Future<Uint8List?> toPngByte(GlobalKey key) async{
        if(key.currentContext != null) {
            final RenderRepaintBoundary? boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
            final img = await boundary?.toImage(pixelRatio: 2);
            final data = await img?.toByteData(format: ui.ImageByteFormat.png);
            return data!.buffer.asUint8List();
        }
        return null;
    }

    static Future<ui.Image> toImage(GlobalKey key) async{
        final RenderRepaintBoundary? boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
        final img = await boundary?.toImage(pixelRatio: 2);
        return img!;
    }
}