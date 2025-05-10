import '../models/bible_version.dart';

final List<BibleVersion> bibleVersions = [
  BibleVersion(name: "King James Version", code: 'kjv', file: "kjv.json"),
  BibleVersion(name: "World English Bible", code: 'web', file: "web.json"),
  BibleVersion(
    name: 'American Standard Version',
    code: 'asv',
    file: "asv.json",
  ),
  BibleVersion(name: 'Bible in Basic English', code: 'bbe', file: "bbe.json"),
  BibleVersion(name: 'World English Bible', code: 'web', file: "web.json"),
  BibleVersion(
    name: 'New Heart English Bible',
    code: 'nheb',
    file: "nheb.json",
  ),
];
