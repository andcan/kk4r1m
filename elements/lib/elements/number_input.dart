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
@HtmlImport('number_input.html')
library elements.number_input;

import 'dart:html';

import 'package:core_elements/core_icon.dart';
import 'package:paper_elements/paper_icon_button.dart';
import 'package:paper_elements/paper_input.dart';
import 'package:kk4r1m/kk4r1m.dart';
import 'package:polymer/polymer.dart';

@CustomTag('number-input-element')
class NumberInputElement extends PolymerElement {
  NumberInputElement.created() : super.created();

  void _setWidth(int length) {
    if (0 == length) {
      _input.style.width = '0.5em';
      return;
    }
    _input.style.width = '${(length / 2).toStringAsFixed(1)}em';
  }

  int add (int value) {
    final v = this.value;
    return this.value = (null == v ? 0 : v) + value;
  }

  void decrease() {
    try {
      add(-1);
    } on ArgumentError {}
  }

  void handleKeyDown(KeyboardEvent e) {
    if (e.keyCode == KeyCode.BACKSPACE) {
      _setWidth(length - 1);
    }
  }

  void handleKeyPress(KeyboardEvent e) {
    final code = e.charCode;
    if (isDigitCode(code)) {
      final current = _input.value;
      if (-1 != maxLength && current.length >= maxLength) {
        e.preventDefault();
      } else {
        int pos = _input.$['input'].selectionStart;
        var v = '${current.substring(0, pos)}${new String.fromCharCode(code)}${current.substring(pos)}';
        final val = int.parse(v);
        if (val < min || val > max) {
          e.preventDefault();
        } else {
          _setWidth(v.length);
        }
      }
    } else {
      e.preventDefault();
    }
  }

  void increase() {
    try {
      add(1);
    } on ArgumentError {}
  }

  void ready() {
    super.ready();
    _input = $['input'];
    value = 0;
    onKeyDown.listen(handleKeyDown, cancelOnError: false);
    onKeyPress.listen(handleKeyPress, cancelOnError: false);
    InputElement inp = _input.$['input'];
  }

  int get length {
    if (null == _input) {
      return 0;
    }
    var v = _input.value;
    return v is int ? v.toString().length : v.length;
  }

  @PublishedProperty(reflect: true) int get max => readValue(#max, () => 0x7FFFFFFFFFFFFFFF);

  @PublishedProperty(reflect: true) int get maxLength => readValue(#maxLength, () => -1);

  @PublishedProperty(reflect: true) int get min => readValue(#min, () => -0x8000000000000000);

  int get value {
    if (null == _input) {
      return null;
    }
    final v = _input.value;
    return v is int ? v : int.parse(v, onError: (_) => null);
  }

  set maxLength(int length) {
    if(length < 0) {
      if(-1 == length) {
        writeValue(#maxLength, -1);
      } else {
        throw new ArgumentError('Length must be >0 or -1 (unlimited).');
      }
    } else if (0 == length) {
      throw new ArgumentError('Length must be >0 or -1 (unlimited).');
    }
    if (this.length > length) {
      value = int.parse(value.toString().substring(0, length));
    }
    writeValue(#maxLength, length);
  }

  set max(int max) {
    if (max < min) {
      throw new ArgumentError('max must be >= min.');
    }
    writeValue(#max, max);
    final v = value;
    if (null != v && v > max) {
      value = max;
    }
  }

  set min(int min) {
    if (min > max) {
      throw new ArgumentError('min must be <= max.');
    }
    writeValue(#min, min);
    final v = value;
    if (null != v && v < min) {
      value = min;
    }
  }

  set value(int value) {
    if (value < min || value > max) {
      throw new ArgumentError('value ($value) must be between $min and $max.');
    }
    final maxLen = maxLength;
    final val = value.toString();
    if (-1 != maxLen && val.length > maxLen) {
      throw new ArgumentError('value length (${val.length}) must be <= $maxLen');
    }
    _setWidth(val.length);
    writeValue(#value, val);
    _input.value = val;
  }
  PaperInput _input;
}