/* global exports */
"use strict";

// module Control.Monad.Eff.Ref

exports.newRef = function (val) {
  return function () {
    return { value: val };
  };
};

exports.readRef = function (ref) {
  return function () {
    return ref.value;
  };
};

exports.modifyRef = function (ref) {
  return function (f) {
    return function () {
      /* jshint boss: true */
      return ref.value = f(ref.value);
    };
  };
};

exports.writeRef = function (ref) {
  return function (val) {
    return function () {
      ref.value = val;
      return {};
    };
  };
};
