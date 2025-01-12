import 'package:ecoalmaty/AppSizes.dart';
import 'package:ecoalmaty/permission.dart';
import 'package:ecoalmaty/request.dart';
import 'package:flutter/material.dart';
import "package:percent_indicator/percent_indicator.dart";

class PageInfo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PageInfoState();
  }
}

class _PageInfoState extends State<PageInfo> {
  final AppPermission appPermission = AppPermission();

  String _currentTime = "00:00";

  void _updateTime() {
    setState(() {
      DateTime now = DateTime.now();
      _currentTime = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    });
  }

  String? temperature;
  Color? color;
  String? ecoText;
  String? humidity;
  String? time;
  int? pollutionLevel;
  Icon? icon;
  bool isLoading = true; // Флаг загрузки
  bool loading = false; // Флаг загрузки

  void dataRequest() {
    _updateTime();
    temperature =
        RequestCheck.temperature; // Обновляем состояние после загрузки данных
    color = RequestCheck.pollutionLevelColor;
    ecoText = RequestCheck.pollutionLevelText;
    pollutionLevel = RequestCheck.pollutionLevel;
    humidity = RequestCheck.humidity;
    time = RequestCheck.time;
    icon = RequestCheck.icon;
    isLoading = false; // Убираем флаг загрузки
  }

  // Метод для обработки разрешений и загрузки данных
  Future<void> handlePermissionCheck() async {
    await await AppPermission.checkAndRequestLocationPermission();
    await RequestCheck.init(); // Ожидаем загрузки данных
    setState(() {
      dataRequest();
    });
  }

  @override
  void initState() {
    super.initState();
    loading = RequestCheck.loading;
    if (!loading) {
      handlePermissionCheck();
    }
    else {
      setState(() {
        dataRequest();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: AppSizes.width * 0.05, right: AppSizes.width * 0.05),
                child: Column(
                  children: [
                    SizedBox(
                      height: AppSizes.height * 0.1,
                    ),
                    Text(
                      'Текущая погода и качество воздуха',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppSizes.width * 0.1,
                      ),
                      softWrap: true,
                    ),
                    SizedBox(
                      height: AppSizes.height * 0.05,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: AppSizes.width * 0.44,
                            height: AppSizes.height * 0.56,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.lightBlue),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.all(AppSizes.width * 0.05),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Сейчас',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: AppSizes.width * 0.06),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '$temperature°C',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    AppSizes.width * 0.07),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Дым',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        AppSizes.width * 0.035),
                                              ),
                                              Text(
                                                'Осадки:0%',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        AppSizes.width * 0.035),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: AppSizes.height * 0.04,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'AQI',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    AppSizes.width * 0.045),
                                          ),
                                          Text(
                                            '$pollutionLevel $ecoText',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    AppSizes.width * 0.045),
                                          ),
                                        ],
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        // Центрируем оба элемента
                                        children: [
                                          // Линия
                                          Container(
                                            height: AppSizes.height * 0.01,
                                            width: AppSizes.width * 0.35,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFF00FF00),
                                                  Color(0xFFFFFF00),
                                                  Color(0xFFFFA500),
                                                  Color(0xFFFF0000),
                                                  Color(0xFF800080),
                                                  Color(0xFF4B0082),
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ),
                                            ),
                                          ),
                                          // Круг
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            // Смещаем круг влево от центра
                                            child: Container(
                                              width: AppSizes.width * 0.05,
                                              height: AppSizes.height * 0.05,
                                              decoration: BoxDecoration(
                                                color: color,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width:
                                                        AppSizes.width * 0.005),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    offset: Offset(5, 5),
                                                    blurRadius: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/container1_info.png',
                                  // Путь к вашему изображению
                                  width: AppSizes.width * 0.4,
                                  height: AppSizes.height * 0.3,
                                  fit: BoxFit
                                      .cover, // Как изображение должно вписываться
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: AppSizes.width * 0.01,
                          ),
                          Column(
                            children: [
                              Container(
                                width: AppSizes.width * 0.44,
                                height: AppSizes.height * 0.28,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Color(0xFFFF81F9),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(AppSizes.width * 0.05),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Текст сверху
                                      Text(
                                        "Хорошее",
                                        style: TextStyle(
                                          color: Colors.purple, // Цвет текста
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppSizes.width * 0.05,
                                        ),
                                      ),

                                      Text(
                                        "O₃ (Озон)",
                                        style: TextStyle(
                                          color: Colors.purple,
                                          fontSize: AppSizes.width * 0.035,
                                        ),
                                      ),

                                      // Индикатор прогресса
                                      CircularPercentIndicator(
                                        radius: AppSizes.width * 0.15,
                                        // Радиус индикатора
                                        lineWidth: 12.0,
                                        // Толщина линии
                                        percent: 0.15,
                                        // Процент прогресса (0.0 до 1.0)
                                        center: Text(
                                          "15",
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        // Скругленные концы
                                        backgroundColor: Colors.white,
                                        // Цвет фона линии
                                        linearGradient: LinearGradient(
                                          colors: [
                                            Colors.purple,
                                            Colors.deepPurple,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: AppSizes.height * 0.005,
                              ),
                              Container(
                                height: AppSizes.height * 0.28,
                                width: AppSizes.width * 0.44,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Color(0xFFA7EC6A),
                                ),
                                child: Padding(
                                  padding:
                                      EdgeInsets.all(AppSizes.width * 0.05),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Влажность",
                                        style: TextStyle(
                                          color: Color(0xFF419800),
                                          fontWeight: FontWeight.bold,
                                          fontSize: AppSizes.width * 0.05,
                                        ),
                                      ),
                                      Text(
                                        "$humidity%",
                                        style: TextStyle(
                                          color: Color(0xFF419800),
                                          fontSize: AppSizes.width * 0.035,
                                        ),
                                      ),
                                      SizedBox(
                                        height: AppSizes.height * 0.02,
                                      ),
                                      Image.asset(
                                        'assets/images/container3_info.png',
                                        // Путь к вашему изображению
                                        width: AppSizes.width * 0.24,
                                        height: AppSizes.height * 0.13,
                                        fit: BoxFit
                                            .cover, // Как изображение должно вписываться
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: AppSizes.height * 0.01,
                    ),
                    Container(
                      width: AppSizes.width * 0.9,
                      height: AppSizes.height * 0.23,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Color(0xFF627EF9),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(AppSizes.width * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: AppSizes.width * 0.05,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Алмалинский район",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppSizes.width * 0.05,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.sunny_snowing,
                                      color: Colors.white,
                                      size: AppSizes.width * 0.1,
                                    ),
                                    SizedBox(
                                      width: AppSizes.width * 0.02,
                                    ),
                                    Text(
                                      "$temperature",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppSizes.width * 0.1,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: AppSizes.width * 0.02,
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.sunny,
                                      color: Colors.white,
                                      size: AppSizes.width * 0.07,
                                    ),
                                    Text('ср',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: AppSizes.width * 0.05,
                                        )),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.sunny,
                                      color: Colors.white,
                                      size: AppSizes.width * 0.07,
                                    ),
                                    Text(
                                      'чт',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.width * 0.05,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.sunny,
                                      color: Colors.white,
                                      size: AppSizes.width * 0.07,
                                    ),
                                    Text(
                                      'пт',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: AppSizes.width * 0.05,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "$_currentTime",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppSizes.width * 0.05,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isLoading = true;
                                      handlePermissionCheck();
                                    });
                                  },
                                  icon: Icon(
                                    Icons.restart_alt,
                                    size: AppSizes.width * 0.05,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // AppBar должен быть сверху и фиксированным
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: Padding(
                padding: EdgeInsets.only(
                  top: AppSizes.height * 0.08, // Отступ сверху
                  right: AppSizes.width * 0.05, // Отступ справа
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Первый контейнер с иконкой
                      Container(
                        height: AppSizes.height * 0.055,
                        width: AppSizes.width * 0.125,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xFF303030),
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.assignment,
                              size: AppSizes.height * 0.035,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: AppSizes.width * 0.03),
                      // Второй контейнер с иконкой
                      Container(
                        height: AppSizes.height * 0.055,
                        width: AppSizes.width * 0.125,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xFF303030),
                        ),
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.apps,
                              size: AppSizes.height * 0.035,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
