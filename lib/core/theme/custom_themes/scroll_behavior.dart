import 'package:flutter/material.dart';

ScrollBehavior get constScrollBehavior =>
    const MaterialScrollBehavior().copyWith(physics: BouncingScrollPhysics());
