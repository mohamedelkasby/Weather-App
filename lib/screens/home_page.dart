import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubits/weather_cubit.dart';
import 'package:weather_app/cubits/weather_states.dart';
import 'package:weather_app/screens/search_dailog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherCubit, WeatherState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is WeatherLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          );
        } else if (state is WeatherLoadedState) {
          final weatherModel = state.weatherModel;
          final bool isDay = (weatherModel.isDay == 1);

          // Color Scheme
          final primaryColor = isDay ? Colors.blue[800]! : Colors.indigo[900]!;
          final secondaryColor =
              isDay ? Colors.blue[100]! : Colors.blueGrey[800]!;
          final textColor = isDay ? Colors.grey[900]! : Colors.white;

          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDay
                      ? [Colors.blue[100]!, Colors.blue[400]!]
                      : [Colors.indigo[900]!, Colors.blueGrey[900]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Header Section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${weatherModel.region}, ${weatherModel.country}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                weatherModel.condition,
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      textColor.withAlpha((0.8 * 255).toInt()),
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => const SearchDialog(),
                              ).then((value) {
                                if (value != null && context.mounted) {
                                  WeatherCubit.get(context).getWeather(value);
                                }
                              });
                            },
                            icon: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color:
                                    primaryColor.withAlpha((0.2 * 255).toInt()),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Icon(
                                Icons.search,
                                color: textColor,
                                size: 28,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    // Main Weather Card
                    Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: primaryColor.withAlpha((0.15 * 255).toInt()),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withAlpha((0.1 * 255).toInt()),
                            blurRadius: 20,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          // Temperature Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${weatherModel.temp}°',
                                style: TextStyle(
                                  fontSize: 72,
                                  fontWeight: FontWeight.w300,
                                  color: textColor,
                                  height: 0.9,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  'C',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: textColor
                                        .withAlpha((0.7 * 255).toInt()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Feels like ${weatherModel.tempFeelslike}°',
                            style: TextStyle(
                              fontSize: 16,
                              color: textColor.withAlpha((0.8 * 255).toInt()),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Weather Icon
                          CachedNetworkImage(
                            imageUrl: "https:${weatherModel.icon}",
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Additional Info Cards
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            // Hourly Forecast
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: secondaryColor
                                    .withAlpha((0.2 * 255).toInt()),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildForecastItem(
                                    context,
                                    weatherModel.nextDayDate.substring(5),
                                    weatherModel.nextDayicon,
                                    weatherModel.nextDayTemp.toString(),
                                    textColor,
                                  ),
                                  _buildForecastItem(
                                    context,
                                    weatherModel.dayAfterTomorrowDate
                                        .substring(5),
                                    weatherModel.dayAfterTomorrowicon,
                                    weatherModel.dayAfterTomorrowTemp
                                        .toString(),
                                    textColor,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Last Updated
                            Text(
                              'Last updated: ${weatherModel.lastUpdated}',
                              style: TextStyle(
                                fontSize: 14,
                                color: textColor.withAlpha((0.6 * 255).toInt()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[100]!, Colors.blue[400]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 50, color: Colors.white),
                    const SizedBox(height: 20),
                    const Text(
                      'No Connection',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Please check your internet connection',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () =>
                          WeatherCubit.get(context).getWeather('Cairo'),
                      child: const Text(
                        'Retry',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildForecastItem(BuildContext context, String date, String icon,
      String temp, Color textColor) {
    return Column(
      children: [
        Text(
          date,
          style: TextStyle(
            fontSize: 14,
            color: textColor.withAlpha((0.8 * 255).toInt()),
          ),
        ),
        const SizedBox(height: 8),
        CachedNetworkImage(
          imageUrl: "https:$icon",
          width: 40,
          height: 40,
          placeholder: (context, url) => const CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$temp°',
          style: TextStyle(
            fontSize: 18,
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
