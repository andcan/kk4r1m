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
@HtmlImport('timepicker.html')
library elements.timepicker;

import 'dart:html';

import 'package:elements/elements/number_input.dart' as elements;
import 'package:polymer/polymer.dart';

@CustomTag('timepicker-element')
class TimePickerElement extends PolymerElement {
  TimePickerElement.created() : super.created();

  void attached() {
    super.attached();
    _hinput = $['hinput'];
    _minput = $['minput'];
    _sinput = $['sinput'];
  }

  void reset() {
    _hinput.value = 0;
    _minput.value = 0;
    _sinput.value = 0;
  }

  int get hour => _hinput.value;

  int get minute => _minput.value;

  int get second => _sinput.value;

  set hour(int hour) => _hinput.value = hour;

  set minute(int minute) => _minput.value = minute;

  set second(int second) => _sinput.value = second;

  elements.NumberInputElement _hinput, _minput, _sinput;

  final String DOWN_ARROW = '\u25BC', UP_ARROW = '\u25B2';
}