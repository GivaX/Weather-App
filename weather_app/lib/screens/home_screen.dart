import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/bloc/weather_bloc_bloc.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double toDouble(TimeOfDay time) {
    return time.hour + time.minute / 60;
  }

  Widget getGreeting() {
    if (toDouble(TimeOfDay.now()) > 0 && toDouble(TimeOfDay.now()) < 11.98) {
      return const Text(
        'Good Morning',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (toDouble(TimeOfDay.now()) > 12 &&
        toDouble(TimeOfDay.now()) < 16.98) {
      return const Text(
        'Good Afternoon',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (toDouble(TimeOfDay.now()) > 17 &&
        toDouble(TimeOfDay.now()) < 0.98) {
      return const Text(
        'Good Evening',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return const Text(
        'Sup',
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  Widget getWeatherIcon(
      int code, DateTime currentTime, DateTime sunrise, DateTime sunset) {
    if ((currentTime.compareTo(sunset) > 0) ||
        (sunrise.compareTo(currentTime) > 0)) {
      switch (code) {
        case >= 200 && < 300:
          return Image.asset(
            'assets/1.png',
          );
        case >= 300 && < 400:
          return Image.asset(
            'assets/2.png',
          );
        case >= 500 && < 600:
          return Image.asset(
            'assets/3.png',
          );
        case >= 600 && < 700:
          return Image.asset(
            'assets/4.png',
          );
        case >= 700 && < 800:
          return Image.asset(
            'assets/5.png',
          );
        case 800:
          return Image.asset(
            'assets/12.png',
          );
        case >= 801 && < 805:
          return Image.asset(
            'assets/8.png',
          );
      }
    } else {
      switch (code) {
        case >= 200 && < 300:
          return Image.asset(
            'assets/1.png',
          );
        case >= 300 && < 400:
          return Image.asset(
            'assets/2.png',
          );
        case >= 500 && < 600:
          return Image.asset(
            'assets/3.png',
          );
        case >= 600 && < 700:
          return Image.asset(
            'assets/4.png',
          );
        case >= 700 && < 800:
          return Image.asset(
            'assets/5.png',
          );
        case 800:
          return Image.asset(
            'assets/6.png',
          );
        case >= 801 && < 805:
          return Image.asset(
            'assets/7.png',
          );
      }
    }
    return Image.asset(
      'assets/error.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color(0xffffb56b),
        Color(0xfff39060),
        Color(0xffe16b5c),
        Color(0xffca485c),
        Color(0xffac255e),
        Color(0xff870160),
        Color(0xff5b0060),
        Color(0xff1f005c)
      ], transform: GradientRotation(math.pi / 2))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            getGreeting();
            Position position = await determinePosition();
            BlocProvider.of<WeatherBlocBloc>(context)
                .add(FetchWeather(position));
          },
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    40, 0.85 * kToolbarHeight, 40, 20),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Stack(children: [
                    BlocBuilder<WeatherBlocBloc, WeatherBlocState>(
                      builder: (context, state) {
                        if (state is WeatherBlocSuccess) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '📍 ${state.weather.areaName}',
                                  style: const TextStyle(
                                    //fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                getGreeting(),
                                getWeatherIcon(
                                    state.weather.weatherConditionCode!,
                                    state.weather.date!,
                                    state.weather.sunrise!,
                                    state.weather.sunset!),
                                Center(
                                  child: Text(
                                    '${state.weather.temperature!.celsius!.round()}°C',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 50,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    state.weather.weatherMain!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    DateFormat('EEEE dd ·')
                                        .add_jm()
                                        .format(state.weather.date!),
                                    //'${state.weather.date}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/11.png',
                                          scale: 8,
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Sunrise',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              DateFormat().add_jm().format(
                                                  state.weather.sunrise!),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/12.png',
                                          scale: 8,
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Sunset',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              DateFormat().add_jm().format(
                                                  state.weather.sunset!),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Divider(color: Colors.grey),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/14.png',
                                          scale: 8,
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Min Temp',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              '${state.weather.tempMin!.celsius!.round()}°C',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/13.png',
                                          scale: 8,
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Max Temp',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              '${state.weather.tempMax!.celsius!.round()}°C',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    )
                  ]),
                )),
          ),
        ),
      ),
    );
  }
}
