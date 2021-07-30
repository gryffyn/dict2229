/*
 * Copyright (c) gryffyn 2021.
 * Licensed under the MIT license. See LICENSE file in the project root for details.
 */

import 'package:flutter_test/flutter_test.dart';

import 'package:dict2229/dict.dart';

void main() {
  var dict = Dict.newDict("dict.neveris.one", 2628);
  const expDb = {
    'gcide': '"The Collaborative International Dictionary of English v.0.48"',
    'wn': '"WordNet (r) 3.1 (2011)"',
    'moby-thesaurus': '"Moby Thesaurus II by Grady Ward, 1.0"',
    'jargon': '"Jargon File (4.0.0/24 July 1996)"',
    'foldoc': '"The Free On-line Dictionary of Computing (2021-07-09)"',
    'vera': '"Virtual Entity of Relevant Acronyms (Version 1.9, June 2002)"',
    'devils': '"The Devil\'s Dictionary (1881-1906)"',
    'elements': '"The Elements (22Oct97)"',
    'world95': '"The CIA World Factbook (1995)"',
    'toki-pona': '"Toki Pona - English, 2020-02-11  https://jan-lope.github.io"'
  };

  const expDef = '''

   <operating system> A {real-time} {multitasking} {operating
   system} from {Wind River Systems}.  Originally it used the
   {VRTX} {kernel} but this has been replaced by Wind River's own
   "Wind kernel 2.4".

   Before version 5.3 VxWorks included a {software development
   environment} but this is now called "Tornado".

   (1996-11-29)
''';

  test('test connection', () async {
    var dbs = await dict.info();
    expect(dbs.isNotEmpty, true);
  });

  test('test databases', () async {
    var dbs = await dict.getDatabases();
    expect(dbs, expDb);
  });

  test('test definition', () async {
    var dbs = await dict.define("vxworks");
    expect(dbs[0].numDefinitions, 1);
    expect(dbs[1].body, expDef);
  });
}