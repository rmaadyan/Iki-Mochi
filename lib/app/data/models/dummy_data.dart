// lib/app/data/models/dummy_data.dart

import 'package:flutter/material.dart';

final List<Map<String, dynamic>> popularMochisData = [
  {"id":"strawberry","name":"Strawberry","price":"4.500","emoji":"🍓","bg":const Color(0xFFFFF0F5),"short":"Fresh strawberry wrapped in sweet mochi."},
  {"id":"matcha","name":"Matcha","price":"5.000","emoji":"🍵","bg":const Color(0xFFF0FFF0),"short":"Earthy matcha cream inside soft mochi."},
  {"id":"choco","name":"Chocolate","price":"5.000","emoji":"🍫","bg":const Color(0xFFFFF8F0),"short":"Rich chocolate center — pure comfort."},
  {"id":"mango","name":"Mango","price":"5.500","emoji":"🥭","bg":const Color(0xFFFFFBE6),"short":"Tropical mango filling — juicy and bright."},
  {"id":"black_sesame","name":"Black Sesame","price":"5.200","emoji":"🌑","bg":const Color(0xFFF6F6F8),"short":"Nutty, slightly savory black sesame paste."},
  {"id":"taro","name":"Taro","price":"5.300","emoji":"🍠","bg":const Color(0xFFFFF0F8),"short":"Creamy taro goodness inside chewy mochi."},
  {"id":"yuzu","name":"Yuzu","price":"5.700","emoji":"🍋","bg":const Color(0xFFFFFCE6),"short":"Citrusy yuzu filling for a zesty surprise."},
  {"id":"blueberry","name":"Blueberry","price":"5.400","emoji":"🫐","bg":const Color(0xFFF0F8FF),"short":"Sweet-tart blueberry jam wrapped in mochi."},
];

final List<Map<String, dynamic>> specialMochisData = [
  {"id":"strawberry_daifuku","title":"Strawberry Daifuku","price":"5.000","emoji":"🍡","tags":["Sweet","Fruity","Soft"],"description":"Strawberry Daifuku features a fresh strawberry wrapped in red bean paste and soft mochi rice cake. Balanced and delightful.","reviews":[{"rating":5,"text":"Enak, teksturnya lembut banget!","author":"Ayu"}]},
  {"id":"mochi_bites","title":"Mochi Bites","price":"6.000","emoji":"🟤","tags":["Crunchy","Assorted","Snack"],"description":"Bite-sized mochi with assorted fillings: chocolate, matcha cream, caramel. Perfect for sharing.","reviews":[{"rating":5,"text":"Sempurna untuk cemilan.","author":"Citra"}]},
  {"id":"mochi_cheesecake","title":"Mochi Cheesecake","price":"8.500","emoji":"🧀","tags":["Creamy","Rich","Dessert"],"description":"Mochi Cheesecake: silky cheesecake filling wrapped in a thin mochi layer. A fusion dessert — creamy, slightly tangy, and delightfully chewy.","reviews":[{"rating":5,"text":"Kombinasi mochi + cheesecake bikin nagih!","author":"Ira"},{"rating":4,"text":"Lembut dan elegan, cocok untuk dessert spesial.","author":"Rian"}]},
];

final List<Map<String, dynamic>> categoryItemsData = [
  {'label': 'All', 'active': true},
  {'label': 'Sweet', 'active': false},
  {'label': 'Fruity', 'active': false},
  {'label': 'Ice', 'active': false},
  {'label': 'Snack', 'active': false},
];
