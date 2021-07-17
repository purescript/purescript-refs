"use strict";

export var _new = function (val) {
  return function () {
    return { value: val };
  };
};

export var newWithSelf = function (f) {
  return function () {
    var ref = { value: null };
    ref.value = f(ref);
    return ref;
  };
};

export var read = function (ref) {
  return function () {
    return ref.value;
  };
};

export var modifyImpl = function (f) {
  return function (ref) {
    return function () {
      var t = f(ref.value);
      ref.value = t.state;
      return t.value;
    };
  };
};

export var write = function (val) {
  return function (ref) {
    return function () {
      ref.value = val;
    };
  };
};
