

import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('test App', () {
    final flutterLogoFinder = find.byTooltip('Open ume panel');

    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() {
      driver.close();
    });
    
    test('Find tips', () async {
      final diagnostics = await driver.getWidgetDiagnostics(flutterLogoFinder);
      final properties = diagnostics['properties'] as List<dynamic>;
      bool findTips = false;

      for(var m in properties){
        if(m['value'].toString() == 'Open ume panel') {
          findTips = true;
          break;
        }
      }
      expect(findTips, isTrue);
    });

    test('tab flutter logo', () async {
      await driver.tap(flutterLogoFinder);
      expect(await driver.getText(find.text('UME')), 'UME');
    });

    test('Drag Flutter logo vertically', () async {
      await driver.runUnsynchronized(() async{
        const double dy = 100;
        await driver.waitFor(flutterLogoFinder);
        var oldPos = await driver.getBottomLeft(flutterLogoFinder);
        await driver.scroll(flutterLogoFinder, 0, -dy, Duration(milliseconds: 1500));
        var newPos = await driver.getBottomLeft(flutterLogoFinder);
        expect(oldPos.dy - newPos.dy - dy < 0.0001, true);
      });
    });

    test('Drag Flutter logo horizontally', () async {
      await driver.runUnsynchronized(() async {
        const double dx = 100;
        await driver.waitFor(flutterLogoFinder);
        var oldPos = await driver.getBottomLeft(flutterLogoFinder);
        await driver.scroll(flutterLogoFinder, -dx, 0, Duration(milliseconds: 1500));
        final newPos = await driver.getBottomLeft(flutterLogoFinder);
        expect(newPos.dx - oldPos.dx - dx < 0.0001, true);
      });
    });

    test('Drag toolbar vertically', () async {
      await driver.runUnsynchronized(() async {
        const double dy = 100;
        var toolbar = find.text('UME');
        var oldPos = await driver.getBottomLeft(toolbar);
        print("oldPos: $oldPos");
        await driver.scroll(toolbar, 0, -dy, Duration(seconds: 1));
        var newPos = await driver.getBottomLeft(toolbar);
        print("newPos: $newPos");
        expect(oldPos.dy - newPos.dy - dy > 0, true);
      });
    });
    
    test('Tab debugPrint', () async {
      var debugPrint = find.text('debugPrint');
      await driver.tap(debugPrint);
      var pushDetailPage = find.text('Push Detail Page');
      await driver.tap(pushDetailPage);
      expect(await driver.getText(find.byValueKey('DetailPageKey')), 'Detail Page');
      sleep(Duration(seconds: 1));
      await driver.tap(find.byTooltip('Back'));
      expect(await driver.getText(find.text('UME')), 'UME');
    });

  });
}