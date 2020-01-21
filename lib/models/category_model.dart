class Category {
  Category({this.title, this.categoryId, this.selected});
  final String title;
  final int categoryId;
  bool selected;
  @override
  String toString() => '$runtimeType("title:$title,categoryId:$categoryId,selected:$selected")';
}

List<Category> allCategories = <Category>[
  Category(
    title: '全部分类',
    categoryId: 0,
    selected: true,
  ),
  Category(
    title: '家教',
    categoryId: 1,
    selected: false,
  ),
  Category(
    title: '跑腿',
    categoryId: 2,
    selected: false,
  ),
  Category(
    title: '代购',
    categoryId: 3,
    selected: false,
  ),
  Category(
    title: '维修',
    categoryId: 4,
    selected: false,
  ),
  Category(
    title: '设计',
    categoryId: 5,
    selected: false,
  ),
  Category(
    title: '制造',
    categoryId: 6,
    selected: false,
  ),
  Category(
    title: '互联网',
    categoryId: 7,
    selected: false,
  ),
  Category(
    title: '翻译',
    categoryId: 8,
    selected: false,
  ),
  Category(
    title: '程序',
    categoryId: 9,
    selected: false,
  ),
  Category(
    title: '房地产',
    categoryId: 10,
    selected: false,
  ),
  Category(
    title: '编程',
    categoryId: 11,
    selected: false,
  ),
  Category(
    title: '开发',
    categoryId: 12,
    selected: false,
  ),
  Category(
    title: '搬家',
    categoryId: 13,
    selected: false,
  ),
  Category(
    title: '货运',
    categoryId: 14,
    selected: false,
  ),
  Category(
    title: '游戏',
    categoryId: 15,
    selected: false,
  ),
  Category(
    title: '广告',
    categoryId: 16,
    selected: false,
  ),
  Category(
    title: '兼职',
    categoryId: 17,
    selected: false,
  ),
  Category(
    title: '印刷',
    categoryId: 18,
    selected: false,
  ),
  Category(
    title: '工艺礼品',
    categoryId: 19,
    selected: false,
  ),
  Category(
    title: '营销',
    categoryId: 20,
    selected: false,
  ),
  Category(
    title: '加工',
    categoryId: 21,
    selected: false,
  ),
  Category(
    title: '文案',
    categoryId: 22,
    selected: false,
  ),
  Category(
    title: '包装',
    categoryId: 23,
    selected: false,
  ),
  Category(
    title: 'IT',
    categoryId: 24,
    selected: false,
  ),
  Category(
    title: '造价',
    categoryId: 25,
    selected: false,
  ),
  Category(
    title: '财务',
    categoryId: 26,
    selected: false,
  ),
];
