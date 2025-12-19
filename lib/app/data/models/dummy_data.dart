// lib/app/data/models/dummy_data.dart
import 'package:flutter/material.dart';

final List<Map<String, dynamic>> popularMochisData = [
  {
    "id": "strawberry",
    "name": "Strawberry",
    "price": "4.500",
    "emoji": "🍓",
    "bg": const Color(0xFFFFF0F5),
    "short": "Fresh strawberry wrapped in sweet mochi.",
    "description":
        "Mochi lembut dengan isian strawberry segar, manis alami, dan tekstur kenyal yang menyenangkan.",
    "ingredients": [
      "Beras ketan",
      "Strawberry segar",
      "Gula",
      "Krim susu"
    ],
    "calories": 120,
    "stock": 24,
    "reviews": [],
  },
  {
    "id": "matcha",
    "name": "Matcha",
    "price": "5.000",
    "emoji": "🍵",
    "bg": const Color(0xFFF0FFF0),
    "short": "Earthy matcha cream inside soft mochi.",
    "description":
        "Mochi dengan krim matcha Jepang yang earthy dan lembut, cocok untuk pecinta teh hijau.",
    "ingredients": [
      "Beras ketan",
      "Matcha powder",
      "Krim susu",
      "Gula"
    ],
    "calories": 130,
    "stock": 18,
    "reviews": [],
  },
  {
    "id": "choco",
    "name": "Chocolate",
    "price": "5.000",
    "emoji": "🍫",
    "bg": const Color(0xFFFFF8F0),
    "short": "Rich chocolate center — pure comfort.",
    "description":
        "Isian cokelat pekat yang lumer di dalam mochi kenyal. Comfort food sejati.",
    "ingredients": [
      "Beras ketan",
      "Dark chocolate",
      "Krim susu",
      "Gula"
    ],
    "calories": 150,
    "stock": 20,
    "reviews": [],
  },
  {
    "id": "mango",
    "name": "Mango",
    "price": "5.500",
    "emoji": "🥭",
    "bg": const Color(0xFFFFFBE6),
    "short": "Tropical mango filling — juicy and bright.",
    "description":
        "Isian mangga tropis yang juicy dengan rasa segar dan sedikit asam.",
    "ingredients": [
      "Beras ketan",
      "Mangga",
      "Gula"
    ],
    "calories": 125,
    "stock": 15,
    "reviews": [],
  },
  {
    "id": "black_sesame",
    "name": "Black Sesame",
    "price": "5.200",
    "emoji": "🌑",
    "bg": const Color(0xFFF6F6F8),
    "short": "Nutty, slightly savory black sesame paste.",
    "description":
        "Pasta wijen hitam dengan rasa gurih-manis yang unik dan beraroma kuat.",
    "ingredients": [
      "Beras ketan",
      "Wijen hitam",
      "Gula"
    ],
    "calories": 145,
    "stock": 10,
    "reviews": [],
  },
  {
    "id": "taro",
    "name": "Taro",
    "price": "5.300",
    "emoji": "🍠",
    "bg": const Color(0xFFFFF0F8),
    "short": "Creamy taro goodness inside chewy mochi.",
    "description":
        "Krim taro yang creamy dan wangi, berpadu dengan mochi kenyal.",
    "ingredients": [
      "Beras ketan",
      "Taro",
      "Krim susu",
      "Gula"
    ],
    "calories": 135,
    "stock": 16,
    "reviews": [],
  },
  {
    "id": "yuzu",
    "name": "Yuzu",
    "price": "5.700",
    "emoji": "🍋",
    "bg": const Color(0xFFFFFCE6),
    "short": "Citrusy yuzu filling for a zesty surprise.",
    "description":
        "Isian yuzu citrus khas Jepang dengan rasa segar dan aroma tajam.",
    "ingredients": [
      "Beras ketan",
      "Yuzu",
      "Gula"
    ],
    "calories": 110,
    "stock": 12,
    "reviews": [],
  },
  {
    "id": "blueberry",
    "name": "Blueberry",
    "price": "5.400",
    "emoji": "🫐",
    "bg": const Color(0xFFF0F8FF),
    "short": "Sweet-tart blueberry jam wrapped in mochi.",
    "description":
        "Selai blueberry manis-asam dibalut mochi lembut.",
    "ingredients": [
      "Beras ketan",
      "Blueberry",
      "Gula"
    ],
    "calories": 128,
    "stock": 14,
    "reviews": [],
  },
];

final List<Map<String, dynamic>> specialMochisData = [
  {
    "id": "strawberry_daifuku",
    "title": "Strawberry Daifuku",
    "price": "5.000",
    "emoji": "🍡",
    "tags": ["Sweet", "Fruity", "Soft"],
    "description":
        "Fresh strawberry wrapped in red bean paste and soft mochi rice cake.",
    "ingredients": [
      "Beras ketan",
      "Strawberry",
      "Kacang merah",
      "Gula"
    ],
    "calories": 160,
    "stock": 10,
    "reviews": [
      {
        "rating": 5,
        "text": "Enak, teksturnya lembut banget!",
        "author": "Ayu"
      }
    ],
  },
  {
    "id": "mochi_bites",
    "title": "Mochi Bites",
    "price": "6.000",
    "emoji": "🟤",
    "tags": ["Crunchy", "Assorted", "Snack"],
    "description":
        "Bite-sized mochi with assorted fillings: chocolate, matcha, caramel.",
    "ingredients": [
      "Beras ketan",
      "Cokelat",
      "Matcha",
      "Karamel"
    ],
    "calories": 180,
    "stock": 20,
    "reviews": [
      {
        "rating": 5,
        "text": "Sempurna untuk cemilan.",
        "author": "Citra"
      }
    ],
  },
  {
    "id": "mochi_cheesecake",
    "title": "Mochi Cheesecake",
    "price": "8.500",
    "emoji": "🧀",
    "tags": ["Creamy", "Rich", "Dessert"],
    "description":
        "Silky cheesecake filling wrapped in thin mochi. Creamy and chewy.",
    "ingredients": [
      "Cream cheese",
      "Beras ketan",
      "Gula",
      "Telur"
    ],
    "calories": 220,
    "stock": 6,
    "reviews": [
      {
        "rating": 5,
        "text": "Kombinasi mochi + cheesecake bikin nagih!",
        "author": "Ira"
      },
      {
        "rating": 4,
        "text": "Lembut dan elegan, cocok untuk dessert spesial.",
        "author": "Rian"
      }
    ],
  },
];

final List<Map<String, dynamic>> categoryItemsData = [
  {'label': 'All', 'active': true},
  {'label': 'Sweet', 'active': false},
  {'label': 'Fruity', 'active': false},
  {'label': 'Ice', 'active': false},
  {'label': 'Snack', 'active': false},
];
