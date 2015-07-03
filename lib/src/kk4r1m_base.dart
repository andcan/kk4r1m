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

library kk4r1m.base;

/// A Pair.
abstract class Pair<S, T> {
  /// Returns a [MutablePair] if [immutable] is false, otherwise returns an [ImmutablePair].
  /// Defaults to a [MutablePair].
  factory Pair(S first, T second, {immutable: false}) =>
      immutable ? new ImmutablePair(first, second) : new MutablePair(first, second);
  /// First element.
  S get first;
  /// Second element.
  T get second;
}

/// An immutable pair.
class ImmutablePair<S, T> implements Pair<S, T> {
  /// Returns an immutable pair.
  ImmutablePair(this._first, this._second);
  /// First element.
  S get first => _first;
  /// Second element.
  T get second => _second;
  /// First element.
  S _first;
  /// Second element.
  T _second;
}

/// A mutable pair.
class MutablePair<S, T> implements Pair<S, T> {
  /// Returns a mutable pair.
  MutablePair(this.first, this.second);
  /// First element.
  S first;
  /// Second element.
  T second;
}
