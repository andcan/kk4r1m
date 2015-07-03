/// Copyright (C) 2015  Andrea Cantafio kk4r.1m@gmail.com
/// This file is part of kk4r1m.
///
/// kk4r1m is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// kk4r1m is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with kk4r1m.  If not, see <http://www.gnu.org/licenses/>.

part of kk4r1m.task;

const String COPYRIGHT = '/// Copyright (C) {{YEAR}}  {{AUTHOR}}';

final PersistentMap<String, String> LICENSE_HEADER =
    new PersistentMap<String, String>.fromMap(<String, String>{
  'GPLv3': '''/// This file is part of {{PROJECT_NAME}}.
///
/// {{PROJECT_NAME}} is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// {{PROJECT_NAME}} is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with {{PROJECT_NAME}}.  If not, see <http://www.gnu.org/licenses/>.
'''
});

/// Contains license's urls.
final PersistentMap<String, String> LICENSE_URL =
    new PersistentMap<String, String>.fromMap(
        <String, String>{'GPLv3': 'https://www.gnu.org/licenses/gpl.txt'});

Future _addHeader(
    TaskContext ctx, Directory dir, String header, RegExp regexp) async {
  await for (var entity in dir
      .list(followLinks: false, recursive: true)
      .where((e) => !e.path.contains('packages'))) {
    if (entity is File) {
      var content = (entity as File).readAsStringSync();
      if (content.startsWith('/// Copyright (C)')) {
        ctx.info('Skipped ${entity.path}');
      } else {
        if (regexp.hasMatch(basename(entity.path))) {
          final buf = new StringBuffer(header);
          buf.write(content);
          entity.writeAsStringSync(buf.toString());
        }
        ctx.info('Added header to ${entity.path}');
      }
    }
  }
}

Task _license() {
  var parser = new ArgParser();
  parser.addOption('match',
      abbr: 'm',
      defaultsTo: r'\.dart',
      help: 'Filter files using regular expression.');
  parser.addOption('license',
      abbr: 'l',
      allowed: const <String>['GPLv3'],
      defaultsTo: 'GPLv3',
      help: 'License type.',
      valueHelp: 'license');
  parser.addOption('path',
      abbr: 'p',
      defaultsTo: current,
      help: 'Target directory path.',
      valueHelp: 'directory');
  parser.addOption('year',
      abbr: 'y',
      defaultsTo: new DateTime.now().year.toString(),
      help: 'Copyright year/s.');
  return new Task((TaskContext ctx) async {
    final args = ctx.arguments;
    final license = args['license'];
    final path = args['path'];
    final pubspecpath = join(path, 'pubspec.yaml');
    switch (FileSystemEntity.typeSync(path)) {
      case FileSystemEntityType.DIRECTORY:
        switch (FileSystemEntity.typeSync(pubspecpath)) {
          case FileSystemEntityType.FILE:
            // Fetching LICENSE
            final resp = await (await new HttpClient()
                .getUrl(Uri.parse(LICENSE_URL[license]))).close();
            if (HttpStatus.OK != resp.statusCode) {
              ctx.fail(
                  'Unable to get license from ${LICENSE_URL[license]}: status code is ${resp.statusCode}');
              return;
            }
            final buf = new StringBuffer();
            await for (var content in resp.transform(UTF8.decoder)) {
              buf.write(content);
            }
            new File(join(path, 'LICENSE'))
                .writeAsString(buf.toString())
                .then((_) => ctx.info('Downloaded $license.'),
                    onError: (e) => ctx.fail(e.toString()));
            // Adding copyright header
            final pubspec = loadYaml(new File(pubspecpath).readAsStringSync());
            final header = new StringBuffer(COPYRIGHT
                .replaceFirst('{{AUTHOR}}', pubspec['author'])
                .replaceFirst('{{YEAR}}', args['year']))
              ..write('\n')
              ..write(LICENSE_HEADER[license].replaceAll(
                  '{{PROJECT_NAME}}', pubspec['name']))
              ..write('\n');
            final regexp = new RegExp(args['match']);
            await _addHeader(
                ctx, new Directory(join(path, 'lib')), header.toString(), regexp);
            break;
          default:
            ctx.fail('Invalid project: file $pubspecpath not foud.');
            return;
        }
        break;
      default:
        ctx.fail('Option "path" must be a directory');
        return;
    }
  }, argParser: parser, description: 'Installs license.');
}
