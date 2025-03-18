enum HeatmapLocaleType { en, zh }

final _i18nModel = <HeatmapLocaleType, Map<String, Object>>{
  HeatmapLocaleType.en: {
    'monthShort': ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    'monthLong': ['', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
    'weekLabel': ['', 'Sun', 'Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat'],
    'more': 'more',
    'less': 'less'
  },
  HeatmapLocaleType.zh: {
    'monthLong': ['', '一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
    'monthShort': ['', '1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
    'weekLabel': ['', '周日', '周一', '周二', '周三', '周四', '周五', '周六'],
    'more': '多',
    'less': '少'
  },
};

/// Get international object for [localeType]
Map<String, Object> i18nObjInLocale(HeatmapLocaleType? localeType) => _i18nModel[localeType] ?? _i18nModel[HeatmapLocaleType.en] as Map<String, Object>;

String i18nObjInLocaleLookupString(HeatmapLocaleType localeType, String key) {
  final i18n = i18nObjInLocale(localeType);
  return i18n[key] as String;
}

/// Get international lookup for a [localeType], [key]
List<String> i18nObjInLocaleLookup(HeatmapLocaleType localeType, String key) {
  final i18n = i18nObjInLocale(localeType);
  return i18n[key] as List<String>;
}

List<String> shortMonthLabelInLocale(HeatmapLocaleType localeType) {
  final i18n = i18nObjInLocale(localeType);
  return i18n['monthShort'] as List<String>;
}

List<String> monthLabelInLocale(HeatmapLocaleType localeType) {
  final i18n = i18nObjInLocale(localeType);
  return i18n['monthLong'] as List<String>;
}

List<String> weekLabelInLocale(HeatmapLocaleType localeType) {
  final i18n = i18nObjInLocale(localeType);
  return i18n['weekLabel'] as List<String>;
}
