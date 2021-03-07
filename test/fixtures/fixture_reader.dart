import 'dart:io';

String readFixture(final String name) =>
    File('test/fixtures/$name').readAsStringSync();
