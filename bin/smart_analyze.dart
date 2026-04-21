import 'dart:io';
import 'dart:convert';
import 'package:args/args.dart';

void main(List<String> args) async {
  final parser = ArgParser()
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show this help message.')
    ..addOption('mode',
        abbr: 'm',
        defaultsTo: 'error',
        allowed: ['error', 'warning', 'info'],
        help: 'The analysis mode (what levels of issues to show).',
        allowedHelp: {
          'error': 'Show only critical errors.',
          'warning': 'Show errors and warnings.',
          'info': 'Show errors, warnings, and info/hints.'
        });

  ArgResults results;
  try {
    results = parser.parse(args);
  } catch (e) {
    print('❌ Error: ${e.toString()}');
    printUsage(parser);
    exit(1);
  }

  if (results['help'] == true) {
    printUsage(parser);
    exit(0);
  }

  final List<String> targetPaths = results.rest.isNotEmpty ? results.rest : ['.'];
  final String mode = results['mode'];

  // Check if fvm is available
  bool useFvm = false;
  try {
    final fvmCheck = await Process.run('fvm', ['--version'], runInShell: true);
    if (fvmCheck.exitCode == 0) {
      useFvm = true;
    }
  } catch (_) {
    useFvm = false;
  }

  final String cmd = useFvm ? 'fvm' : 'flutter';
  
  print('🔍 Smart Analyze: Scanning in [$mode] mode using $cmd...');
  print('Target: ${targetPaths.join(', ')}\n');
  
  final List<String> analyzeArgs = useFvm 
      ? ['flutter', 'analyze', ...targetPaths]
      : ['analyze', ...targetPaths];

  final process = await Process.start(
    cmd,
    analyzeArgs,
    workingDirectory: Directory.current.path,
    runInShell: true,
  );

  int errorCount = 0;
  int warningCount = 0;
  int infoCount = 0;

  // Function to check if a line should be printed based on mode
  void handleLine(String line) {
    final trimmed = line.trim();
    bool shouldPrint = false;
    
    if (trimmed.startsWith('error •') || trimmed.startsWith('error -')) {
      shouldPrint = true;
      errorCount++;
    } else if (trimmed.startsWith('warning •') || trimmed.startsWith('warning -')) {
      if (mode == 'warning' || mode == 'info') {
        shouldPrint = true;
      }
      warningCount++;
    } else if (trimmed.startsWith('info •') || trimmed.startsWith('info -')) {
      if (mode == 'info') {
        shouldPrint = true;
      }
      infoCount++;
    }

    if (shouldPrint) {
      print(line);
    }
  }

  process.stdout
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .listen(handleLine);

  process.stderr
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .listen(handleLine);

  await process.exitCode;

  print('\n---------------------------------------');
  print('📊 Summary:');
  print('• Errors: $errorCount');
  
  if (mode != 'error') {
    print('• Warnings: $warningCount');
  }
  if (mode == 'info') {
    print('• Info/Hints: $infoCount');
  }

  if (errorCount > 0) {
    print('\n❌ FAILED: Found $errorCount critical errors.');
    exit(1); 
  } else {
    print('\n✅ SUCCESS: No critical errors found.');
    exit(0);
  }
}

void printUsage(ArgParser parser) {
  print('Smart Analyze - A clean Flutter analyzer for AI-friendly output.\n');
  print('Usage: smart_analyze [options] [paths...]\n');
  print('Options:');
  print(parser.usage);
}
