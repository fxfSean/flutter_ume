

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

    test('tab debugPrint', () async {
      await driver.tap(find.text('debugPrint'));
      expect(await driver.getText(find.text('1')), '1');
      await driver.tap(find.text('debugPrint'));
      expect(await driver.getText(find.text('2')), '2');
    });

  });
}