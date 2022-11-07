import 'dart:convert';

import 'package:diary/model/diary.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class DiaryService extends ChangeNotifier {
  DiaryService(this.preferences) {
    List<String> savedDiaryList = preferences.getStringList(
          "diaryList",
        ) ??
        [];

    for (String stringDiary in savedDiaryList) {
      // String -> Map
      Map<String, dynamic> jsonMap = json.decode(stringDiary);

      // Map -> Diary
      Diary diary = Diary.fromJson(jsonMap);
      diaryList.add(diary);
    }
  }

  SharedPreferences preferences;

  /// Diary 목록
  List<Diary> diaryList = [];

  /// 특정 날짜의 diary 조회
  List<Diary> getByDate(DateTime date) {
    return diaryList
        .where((diary) => isSameDay(date, diary.createdAt))
        .toList();
  }

  /// Diary 작성
  void create(String text, DateTime selectedDate) {
    DateTime now = DateTime.now();

    DateTime createdAt = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      now.hour,
      now.minute,
      now.second,
    );

    Diary newDiary = Diary(
      text: text,
      createdAt: createdAt,
    );

    diaryList.add(newDiary);

    notifyListeners();
    _saveDiaryList();
  }

  /// Diary 수정
  void update(DateTime createdAt, String newContent) {
    Diary diary = diaryList.firstWhere((diary) => diary.createdAt == createdAt);

    diary.text = newContent;

    notifyListeners();
    _saveDiaryList();
  }

  /// Diary 삭제
  void delete(DateTime createdAt) {
    diaryList.removeWhere((diary) => diary.createdAt == createdAt);
    notifyListeners();
    _saveDiaryList();
  }

  void _saveDiaryList() {
    // Diary라는 직접 만든 클래스는 shared preferences에 그대로 저장할 수 없습니다.
    // SharedPreferences에서 저장할 수 있는 String 형태로 변환을 해주겠습니다.
    // 나만의 규칙을 만들어 Diary를 String 형태로 변환할 수 있지만, 보통 json이라는 규칙을 이용합니다.
    // Diary -> Map -> String 순서로 변환합니다.
    List<String> stringDiaryList = [];
    for (Diary diary in diaryList) {
      // Diary -> Map
      Map<String, dynamic> jsonMap = diary.toJson();

      // Map -> String
      String stringDiary = json.encode(jsonMap);
      stringDiaryList.add(stringDiary);
    }
    preferences.setStringList("diaryList", stringDiaryList);
  }
}
