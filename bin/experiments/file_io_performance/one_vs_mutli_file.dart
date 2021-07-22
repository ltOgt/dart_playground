import 'dart:convert';
import 'dart:io';

import 'package:ltogt_utils/ltogt_utils.dart';

/// . Working on Brunnr / MN.
///   . File structure considerations
///     § relationType
///       ~: `{"name": <name>, "slots": [...], "instances": [...]}`
///     -- *[one file]
///       + human readability
///       °+ quicker access if want whole file
///       °- wasted time decoding unneeded info when only want § "instances"
///     -- *[multi file]
///       - human readability
///       °- slower access to whole information
///       °+ only decoding needed info when only want § "instances"
///
///     0 measure both usecases for both approaches
///       e access of specific field
///       e access of whole data
///
///     ** obviously this is not really a meaningful test, but it should give me a bit of a better idea

const BASE_PATH = "/home/omni/repos/playground/dart_playground/bin/experiments/file_io_performance/ovmf_files/";

void main() async {
  await test_whole();
}

Future<void> runTimed(int runs, Future<void> Function() f) async {
  Duration dOF = Duration();
  for (int i = 0; i < runs; i++) {
    final t0 = DateTime.now();
    await f();
    dOF += DateTime.now().difference(t0);
  }
  print("--- => avg ${dOF.inMilliseconds / runs}ms over $runs runs (total=$dOF)");
}

// --------------------------------------------- SPECIFIC FIELD

Future<void> test_specific() async {
  /// makes no sense to run with multiple runs, since file is cached in ram
  /// first run is probably more representative
  final runs = 1;

  print("Read Specific");
  print("- List 1");
  print("-- *[one file]");
  await runTimed(runs, readSpecific_list1_oneFile);
  print("-- *[multi file]");
  await runTimed(runs, readSpecific_list1_multiFile);

  /* (Aggregated over multiple manual runs picked at random)
  Read Specific
  - List 1
  -- *[one file]
  --- => avg 21.0ms over 1 runs (total=0:00:00.021983)
  --- => avg 25.0ms over 1 runs (total=0:00:00.025165)
  --- => avg 22.0ms over 1 runs (total=0:00:00.022218)
  --- => avg 22.0ms over 1 runs (total=0:00:00.022841)
  -- *[multi file]
  --- => avg 1.0ms over 1 runs (total=0:00:00.001144)
  --- => avg 1.0ms over 1 runs (total=0:00:00.001286)
  --- => avg 0.0ms over 1 runs (total=0:00:00.000958)
  --- => avg 0.0ms over 1 runs (total=0:00:00.001082)
  */
}

Future<void> readSpecific_list1_oneFile() async {
  final file = File(BASE_PATH + "name.json");
  // implementation calls open and close on file
  String content = await file.readAsString();
  Map json = jsonDecode(content);
  List<String> target = (json["list-1"] as List).cast();
  return; // breakpoint to check correct parsing
}

Future<void> readSpecific_list1_multiFile() async {
  final file = File(BASE_PATH + "name/list-1.list");
  List<String> target = await file.readAsLines();
  return; // breakpoint to check correct parsing
}

// --------------------------------------------- WHOLE OBJECT

Future<void> test_whole() async {
  /// makes no sense to run with multiple runs, since file is cached in ram
  /// first run is probably more representative
  final runs = 1;

  print("Read Whole");
  print("- List 1");
  print("-- *[one file]");
  await runTimed(runs, readWhole_oneFile);
  print("-- *[multi file]");
  await runTimed(runs, readWhole_multiFile);

  /* (Aggregated over multiple manual runs picked at random)
  Read Whole
  - List 1
  -- oneFile
  --- => avg 19.0ms over 1 runs (total=0:00:00.019762)
  --- => avg 20.0ms over 1 runs (total=0:00:00.020165)
  --- => avg 19.0ms over 1 runs (total=0:00:00.019439)
  --- => avg 19.0ms over 1 runs (total=0:00:00.019516)
  -- *[multi file]
  --- => avg 19.0ms over 1 runs (total=0:00:00.019160)
  --- => avg 19.0ms over 1 runs (total=0:00:00.019910)
  --- => avg 20.0ms over 1 runs (total=0:00:00.020556)
  --- => avg 19.0ms over 1 runs (total=0:00:00.019697)
  */
}

Future<void> readWhole_oneFile() async {
  final file = File(BASE_PATH + "name.json");
  // implementation calls open and close on file
  String content = await file.readAsString();
  Map json = jsonDecode(content);
  return; // breakpoint to check correct parsing
}

Future<void> readWhole_multiFile() async {
  final dir = Directory(BASE_PATH + "name");
  Map content = {};

  // just a wrapper for dir.list to handle stream conversion
  // plus a filter for File
  for (final file in await FileHelper.listFilesInDirectory(dir)) {
    // wrapper around path.basename
    List<String> nameType = FileHelper.fileName(file).split(".");

    switch (nameType.last) {
      case "txt":
        content[nameType.first] = await file.readAsString();
        break;
      case "list":
        content[nameType.first] = await file.readAsLines();
        break;
      case "json":
        content[nameType.first] = jsonDecode(await file.readAsString());
        break;
    }
  }
  return; // breakpoint to check correct parsing
}

/// > Time Complexity
///   e read specific
///     => 20X overhead for oneFile in this ~representative~ case
///     ```
///     Read Specific
///     - List 1
///     -- *[one file]
///     --- => avg 21.0ms over 1 runs (total=0:00:00.021983)
///     --- => avg 25.0ms over 1 runs (total=0:00:00.025165)
///     --- => avg 22.0ms over 1 runs (total=0:00:00.022218)
///     --- => avg 22.0ms over 1 runs (total=0:00:00.022841)
///     -- *[multi file]
///     --- => avg 1.0ms over 1 runs (total=0:00:00.001144)
///     --- => avg 1.0ms over 1 runs (total=0:00:00.001286)
///     --- => avg 0.0ms over 1 runs (total=0:00:00.000958)
///     --- => avg 0.0ms over 1 runs (total=0:00:00.001082)
///     ```
///   e read whole
///     => about same performance
///     ```
///     - List 1
///     -- *[one file]
///     --- => avg 19.0ms over 1 runs (total=0:00:00.019762)
///     --- => avg 20.0ms over 1 runs (total=0:00:00.020165)
///     --- => avg 19.0ms over 1 runs (total=0:00:00.019439)
///     --- => avg 19.0ms over 1 runs (total=0:00:00.019516)
///     -- *[multi file]
///     --- => avg 19.0ms over 1 runs (total=0:00:00.019160)
///     --- => avg 19.0ms over 1 runs (total=0:00:00.019910)
///     --- => avg 20.0ms over 1 runs (total=0:00:00.020556)
///     --- => avg 19.0ms over 1 runs (total=0:00:00.019697)
///     ```
///

/// > Space Complexity
///   § _
///     ```
///     $ du -ach
///     4,0K    ./name/map-1.json
///     4,0K    ./name/field-4.txt
///     4,0K    ./name/map-2.json
///     4,0K    ./name/nested-map.json
///     4,0K    ./name/field-1.txt
///     4,0K    ./name/list-2.txt
///     4,0K    ./name/field-2.txt
///     4,0K    ./name/field-3.txt
///     4,0K    ./name/list-1.txt
///     40K     ./name
///     4,0K    ./name.json
///     ```
///
///   -- *[one file]
///     : 4kb (4096 byte)
///       <- Size of one block
///         ( inode inline data may reduce this for small files )
///           // https://lwn.net/Articles/469805/
///   -- *[multi file]
///     : 40kb
///     : n*4kb
///       <- Each data point occupies one block
///
///   => For sparse data this incurrs a significant overhead
///     . ~1000-4000 chars to fill block
///       . assuming utf-8 encoded files
///         ( 1-4 bytes per char )
///
///     ```
///     $ du -ach
///     4,0K    ./1block.txt
///     8,0K    ./2block.txt
///     ```
///     ```
///     $ wc -c 1block.txt 2block.txt
///     3839 1block.txt
///     4400 2block.txt
///     ```
///
///
///
///
///
///
/// ========================================
/// > Results of primitive benchmark
///   -- one file
///     + *[space complexity] minimal
///       ~ 4kByte per 4000 characters
///     - *[single field access] json decode overhead
///       [_] test for multiple json lengths to see how this grows roughly
///         < even O(n) would still be a lot as files grow over time
///     ~ *[whole file access] same time as mutli file approach
///   -- *[multi file]
///     - *[space complexity] overhead per field
///       ~ 4kByte per 4000 characters per field
///         ! less of a problem iff
///           > few fields
///           > number of fields ~constant over time
///           > content of fields grows over time
///           S single value fields that dont grow over time
///             § name, type, color, ...
///             ?= maybe group these single value fields in one svf.json file
///     + *[single field access] no json decode overhead
///     ~ *[whole file access] same time as one file approach
///       [!] test this for larger files as well, but dont assume this changes much
///
///   => conside using *[multi file] approach iff
///     x split data that is accessed alone
///     ? group single field data
