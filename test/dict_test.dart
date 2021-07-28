import 'package:flutter_test/flutter_test.dart';

import 'package:dict2229/dict.dart';

void main() {
  var dict = Dict.newDict("neveris.one", 2628);
  const expDb = '''110 3 databases present
toki-pona "Toki Pona - English, 2020-02-11  https://jan-lope.github.io"
wikt-en-all "wikt-en-ALL-2018-05-15"
foldoc "The Free On-line Dictionary of Computing (2021-07-09)"
.
250 ok
''';
  const expDef = '''150 1 definitions retrieved
151 "vxworks" foldoc "The Free On-line Dictionary of Computing (2021-07-09)"
VxWorks

   <operating system> A {real-time} {multitasking} {operating
   system} from {Wind River Systems}.  Originally it used the
   {VRTX} {kernel} but this has been replaced by Wind River's own
   "Wind kernel 2.4".

   Before version 5.3 VxWorks included a {software development
   environment} but this is now called "Tornado".

   (1996-11-29)

.
250 ok [d/m/c = 1/0/31; 0.000r 0.000u 0.000s]
''';


  test('test databases', () async {
    var dbs = await dict.getDatabases();
    expect(dbs, expDb);
  });
  test('test definition', () async {
    var dbs = await dict.define("vxworks");
    expect(dbs, expDef);
  });
}