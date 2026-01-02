import 'package:flutter/material.dart';

const backgoundColor = Color.fromARGB(255, 255, 255, 255);
const foregroundColor = Color.fromARGB(255, 230, 240, 230);
const selectedDateColor = Color.fromARGB(255, 250, 238, 0);
const nonOfMonthColor = Color.fromARGB(255, 179, 179, 179);
const yinColor = Color.fromARGB(255, 20, 20, 230);
const yangColor = Color.fromARGB(255, 230, 0, 0);

enum HeavenlyStem {
  giap(0, "Giáp", "甲"),
  at(1, "Ất", "乙"),
  binh(2, "Bính", "丙"),
  dinh(3, "Đinh", "丁"),
  mau(4, "Mậu", "戊"),
  ky(5, "Kỷ", "己"),
  canh(6, "Canh", "庚"),
  tan(7, "Tân", "辛"),
  nham(8, "Nhâm", "壬"),
  quy(9, "Quý", "癸");

  final int value;
  final String vi;
  final String zh;

  const HeavenlyStem(this.value, this.vi, this.zh);

  static HeavenlyStem from(int value) =>
      HeavenlyStem.values.firstWhere((e) => e.value == value);
}

enum EarthlyBranch {
  ti(0, "Tý", "子", "assets/12_con_giap/01_ti.png"),
  suu(1, "Sửu", "丑", "assets/12_con_giap/02_suu.png"),
  dan(2, "Dần", "寅", "assets/12_con_giap/03_dan.png"),
  mao(3, "Mão", "卯", "assets/12_con_giap/04_mao.png"),
  thin(4, "Thìn", "辰", "assets/12_con_giap/05_thin.png"),
  ty(5, "Tỵ", "巳", "assets/12_con_giap/06_ty.png"),
  ngo(6, "Ngọ", "午", "assets/12_con_giap/07_ngo.png"),
  mui(7, "Mùi", "未", "assets/12_con_giap/08_mui.png"),
  than(8, "Thân", "申", "assets/12_con_giap/09_than.png"),
  dau(9, "Dậu", "酉", "assets/12_con_giap/10_dau.png"),
  tuat(10, "Tuất", "戌", "assets/12_con_giap/11_tuat.png"),
  hoi(11, "Hợi", "亥", "assets/12_con_giap/12_hoi.png");

  final int value;
  final String vi;
  final String zh;
  final String img;

  const EarthlyBranch(this.value, this.vi, this.zh, this.img);

  static EarthlyBranch from(int value) =>
      EarthlyBranch.values.firstWhere((e) => e.value == value);
}

enum DayOfWeekLocalize {
  mon(0, "Thứ Hai", "星 期 一", "Monday"),
  tue(1, "Thứ Ba", "星 期 二", "Tuesday"),
  wed(2, "Thứ Tư", "星 期 三", "Wednesday"),
  thu(3, "Thứ Năm", "星 期 四", "Thursday"),
  fri(4, "Thứ Sáu", "星 期 五", "Friday"),
  sat(5, "Thứ Bảy", "星 期 六", "Saturday"),
  sun(6, "Chủ Nhật", "星 期 日", "Sunday");

  final int value;
  final String vi;
  final String zh;
  final String en;

  const DayOfWeekLocalize(this.value, this.vi, this.zh, this.en);

  static DayOfWeekLocalize from(int value) =>
      DayOfWeekLocalize.values.firstWhere((e) => e.value == value);
}

enum MonthLocalize {
  jan(0, "Tháng 1", "January"),
  feb(1, "Tháng 2", "February"),
  mar(2, "Tháng 3", "March"),
  apr(3, "Tháng 4", "April"),
  may(4, "Tháng 5", "May"),
  jun(5, "Tháng 6", "June"),
  jul(6, "Tháng 7", "July"),
  aug(7, "Tháng 8", "August"),
  sep(8, "Tháng 9", "September"),
  oct(9, "Tháng 10", "October"),
  nov(10, "Tháng 11", "November"),
  dec(11, "Tháng 12", "December");

  final int value;
  final String vi;
  final String en;

  const MonthLocalize(this.value, this.vi, this.en);

  static MonthLocalize from(int value) =>
      MonthLocalize.values.firstWhere((e) => e.value == value);
}

enum LunarMonthLocalize {
  gieng(0, "Tháng Giêng", "正 月"),
  hai(1, "Tháng Hai", "二 月"),
  ba(2, "Tháng Ba", "三 月"),
  tu(3, "Tháng Tư", "四 月"),
  nam(4, "Tháng Năm", "五 月"),
  sau(5, "Tháng Sáu", "六 月"),
  bay(6, "Tháng Bảy", "七 月"),
  tam(7, "Tháng Tám", "八 月"),
  chin(8, "Tháng Chín", "九 月"),
  muoi(9, "Tháng Mười", "十 月"),
  muoimot(10, "Tháng Mười Một", "十 一 月"),
  chap(11, "Tháng Chạp", "腊 月");

  final int value;
  final String vi;
  final String zh;

  const LunarMonthLocalize(this.value, this.vi, this.zh);

  static LunarMonthLocalize from(int value) =>
      LunarMonthLocalize.values.firstWhere((e) => e.value == value);
}

enum SolarTermLocalize {
  lapxuan(0, "Lập Xuân", "立 春"),
  vuthuy(1, "Vũ Thủy", "雨 水"),
  kinhtrap(2, "Kinh Trập", "驚 蟄"),
  xuanphan(3, "Xuân Phân", "春 分"),
  thanhminh(4, "Thanh Minh", "清 明"),
  cocvu(5, "Cốc Vũ", "穀 雨"),
  lapha(6, "Lập Hạ", "立 夏"),
  tieuman(7, "Tiểu Mãn", "小 滿"),
  mangchung(8, "Mang Chủng", "芒 種"),
  hachi(9, "Hạ Chí", "夏 至"),
  tieuthu(10, "Tiểu Thử", "小 暑"),
  daithu(11, "Đại Thử", "大 暑"),
  lapthu(12, "Lập Thu", "立 秋"),
  xuthu(13, "Xử Thử", "處 暑"),
  bachlo(14, "Bạch Lộ", "白 露"),
  thuphan(15, "Thu Phân", "秋 分"),
  hanlo(16, "Hàn Lộ", "寒 露"),
  suonggiang(17, "Sương Giáng", "霜 降"),
  lapdong(18, "Lập Đông", "立 冬"),
  tieutuyet(19, "Tiểu Tuyết", "小 雪"),
  daituyet(20, "Đại Tuyết", "大 雪"),
  dongchi(21, "Đông Chí", "冬 至"),
  tieuhan(22, "Tiểu Hàn", "小 寒"),
  daihan(23, "Đại Hàn", "大 寒");

  final int value;
  final String vi;
  final String zh;

  const SolarTermLocalize(this.value, this.vi, this.zh);

  static SolarTermLocalize from(int value) =>
      SolarTermLocalize.values.firstWhere((e) => e.value == value);
}

enum LunarTimes {
  ti(0, EarthlyBranch.ti, "23h-01h"),
  suu(1, EarthlyBranch.suu, "01h-03h"),
  dan(2, EarthlyBranch.dan, "03h-05h"),
  mao(3, EarthlyBranch.mao, "05h-07h"),
  thin(4, EarthlyBranch.thin, "07h-09h"),
  ty(5, EarthlyBranch.ty, "09h-11h"),
  ngo(6, EarthlyBranch.ngo, "11h-13h"),
  mui(7, EarthlyBranch.mui, "13h-15h"),
  than(8, EarthlyBranch.than, "15h-17h"),
  dau(9, EarthlyBranch.dau, "17h-19h"),
  tuat(10, EarthlyBranch.tuat, "19h-21h"),
  hoi(11, EarthlyBranch.hoi, "21h-23h");

  final int value;
  final EarthlyBranch earthlyBranch;
  final String timeRange;

  const LunarTimes(this.value, this.earthlyBranch, this.timeRange);
}

const List<String> lunarDayChinese = [
  "初一",
  "初二",
  "初三",
  "初四",
  "初五",
  "初六",
  "初七",
  "初八",
  "初九",
  "初十",
  "十一",
  "十二",
  "十三",
  "十四",
  "十五",
  "十六",
  "十七",
  "十八",
  "十九",
  "二十",
  "二十一",
  "二十二",
  "二十三",
  "二十四",
  "二十五",
  "二十六",
  "二十七",
  "二十八",
  "二十九",
  "三十",
];

const List<String> lunarTimes = [
  "Tý(23h-1h)",
  "Sửu(1h-3h)",
  "Dần(3h-5h)",
  "Mão(5h-7h)",
  "Thìn(7h-9h)",
  "Tỵ(9h-11h)",
  "Ngọ(11h-13h)",
  "Mùi(13h-15h)",
  "Thân(15h-17h)",
  "Dậu(17h-19h)",
  "Tuất(19h-21h)",
  "Hợi(21h-23h)",
];

const List<List<int>> auspiciousTimeMatrix = [
  [0, 1, 4, 5, 7, 10],
  [0, 2, 3, 6, 7, 9],
  [2, 4, 5, 8, 9, 11],
  [1, 4, 6, 7, 10, 11],
  [0, 1, 3, 6, 8, 9],
  [2, 3, 4, 8, 10, 11],
  [0, 1, 4, 5, 7, 10],
  [0, 2, 3, 6, 7, 9],
  [2, 4, 5, 8, 9, 11],
  [1, 4, 6, 7, 10, 11],
  [0, 1, 3, 6, 8, 9],
  [2, 3, 4, 8, 10, 11],
];

const List<List<int>> auspiciousDateMatrix = [
  [2, 4, 5, 8, 9, 11],
  [1, 4, 6, 7, 10, 11],
  [0, 1, 3, 6, 8, 9],
  [2, 3, 5, 8, 10, 11],
  [0, 1, 4, 5, 7, 10],
  [0, 2, 3, 6, 7, 9],
  [2, 4, 5, 8, 9, 11],
  [1, 4, 6, 7, 10, 11],
  [0, 1, 3, 6, 8, 9],
  [2, 3, 5, 8, 10, 11],
  [0, 1, 4, 5, 7, 10],
  [0, 2, 3, 6, 7, 9],
];
