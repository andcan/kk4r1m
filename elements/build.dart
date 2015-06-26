/// Copyright (C) 2015  Andrea Cantafio
///
/// This program is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// This program is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with this program.  If not, see <http://www.gnu.org/licenses/>.
export 'package:polymer/default_build.dart';

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:stylus/stylus.dart';

final RegExp stylusFile = new RegExp(r'\.styl$');

void main(List<String> args) async {
  await for(FileSystemEntity entity in Directory.current.list(recursive: true)) {
    if (entity is File) {
      final path = entity.absolute.path;
      if (stylusFile.hasMatch(path)) {
        StylusProcess.start(new StylusOptions(path: path)).transform(ASCII.decoder).single.then((String css) {
          new File(path.replaceFirst(stylusFile, '.css')).writeAsString(css);
        });
      }
    }
  }
}