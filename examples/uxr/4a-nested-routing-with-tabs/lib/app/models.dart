import 'package:collection/collection.dart';

enum Section { audiobook, fiction }

const defaultSection = Section.audiobook;

String sectionName(Section section) =>
    section.toString().replaceAll(RegExp(r'.*\.'), '');

Section? fromSectionName(String? name) => name?.trim().isNotEmpty == true
    ? Section.values.firstWhereOrNull((section) => sectionName(section) == name)
    : null;

enum SectionTab { all, favorites, staffPicks }

const defaultSectionTab = SectionTab.all;

String sectionTabName(SectionTab sectionTab) =>
    sectionTab.toString().replaceAll(RegExp(r'.*\.'), '');

SectionTab? fromSectionTabName(String? name) => name?.trim().isNotEmpty == true
    ? SectionTab.values.firstWhereOrNull((tab) => sectionTabName(tab) == name)
    : null;
