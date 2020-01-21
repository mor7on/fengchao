// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Raw data for the animation demo.

import 'package:flutter/material.dart';

const Color _mariner = Color(0xFF3B5F8F);
const Color _mediumPurple = Color(0xFF8266D4);
const Color _tomato = Color(0xFFF95B57);
const Color _mySin = Color(0xFFF3A646);


class SectionDetail {
  const SectionDetail({
    this.title,
    this.subtitle,
    this.imageAsset,
  });
  final String title;
  final String subtitle;
  final String imageAsset;
}

class Section {
  const Section({
    this.title,
    this.backgroundAsset,
    this.leftColor,
    this.rightColor,
    this.details,
  });
  final String title;
  final String backgroundAsset;
  final Color leftColor;
  final Color rightColor;
  final List<SectionDetail> details;

  @override
  bool operator==(Object other) {
    if (other is! Section)
      return false;
    final Section otherSection = other;
    return title == otherSection.title;
  }

  @override
  int get hashCode => title.hashCode;
}


// TODO(hansmuller): replace the SectionDetail images and text. Get rid of
// the const vars like _eyeglassesDetail and insert a variety of titles and
// image SectionDetails in the allSections list.

const SectionDetail _eyeglassesDetail = SectionDetail(
  imageAsset: 'assets/images/gallery/sunnies.png',
  title: 'Flutter enables interactive animation',
  subtitle: '3K views - 5 days',
);

const SectionDetail _eyeglassesImageDetail = SectionDetail(
  imageAsset: 'assets/images/gallery/sunnies.png',
);

const SectionDetail _seatingDetail = SectionDetail(
  imageAsset: 'assets/images/gallery/table.png',
  title: 'Flutter enables interactive animation',
  subtitle: '3K views - 5 days',
);

const SectionDetail _seatingImageDetail = SectionDetail(
  imageAsset: 'assets/images/gallery/table.png',
);

const SectionDetail _decorationDetail = SectionDetail(
  imageAsset: 'assets/images/gallery/earrings.png',
  title: 'Flutter enables interactive animation',
  subtitle: '3K views - 5 days',
);

const SectionDetail _decorationImageDetail = SectionDetail(
  imageAsset: 'assets/images/gallery/earrings.png',
);

const SectionDetail _protectionDetail = SectionDetail(
  imageAsset: 'assets/images/gallery/hat.png',
  title: 'Flutter enables interactive animation',
  subtitle: '3K views - 5 days',
);

const SectionDetail _protectionImageDetail = SectionDetail(
  imageAsset: 'assets/images/gallery/hat.png',
);

final List<Section> allSections = <Section>[
  const Section(
    title: 'COMPANY',
    leftColor: _mediumPurple,
    rightColor: _mariner,
    backgroundAsset: 'assets/images/gallery/sunnies.png',
    details: <SectionDetail>[
      _eyeglassesDetail,
      _eyeglassesImageDetail,
      _eyeglassesDetail,
      _eyeglassesDetail,
      _eyeglassesDetail,
      _eyeglassesDetail,
      _eyeglassesDetail,
      _eyeglassesDetail,
      _eyeglassesDetail,
      _eyeglassesDetail,
    ],
  ),
  const Section(
    title: 'MISSION',
    leftColor: _tomato,
    rightColor: _mediumPurple,
    backgroundAsset: 'assets/images/gallery/table.png',
    details: <SectionDetail>[
      _seatingDetail,
      _seatingImageDetail,
      _seatingDetail,
      _seatingDetail,
      _seatingDetail,
      _seatingDetail,
      _seatingDetail,
      _seatingDetail,
      _seatingDetail,
      _seatingDetail,
    ],
  ),
  const Section(
    title: 'KNOW-HOW',
    leftColor: _mySin,
    rightColor: _tomato,
    backgroundAsset: 'assets/images/gallery/earrings.png',
    details: <SectionDetail>[
      _decorationDetail,
      _decorationImageDetail,
      _decorationDetail,
      _decorationDetail,
      _decorationDetail,
      _decorationDetail,
      _decorationDetail,
      _decorationDetail,
      _decorationDetail,
      _decorationDetail,
    ],
  ),
  const Section(
    title: 'ARTICLE',
    leftColor: Colors.white,
    rightColor: _tomato,
    backgroundAsset: 'assets/images/gallery/hat.png',
    details: <SectionDetail>[
      _protectionDetail,
      _protectionImageDetail,
      _protectionDetail,
      _protectionDetail,
      _protectionDetail,
      _protectionDetail,
      _protectionDetail,
      _protectionDetail,
      _protectionDetail,
      _protectionDetail,
      _protectionDetail,
      _protectionDetail,
      _protectionDetail,
    ],
  ),
];
