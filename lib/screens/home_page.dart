import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubits/weather_cubit.dart';
import 'package:weather_app/cubits/weather_states.dart';
import 'package:weather_app/screens/search_dailog.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherCubit, WeatherState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is WeatherLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is WeatherLoadedState) {
          final weatherModel = state.weatherModel;

          final bool isDay = (weatherModel.isDay == 1);

          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDay
                      ? [Colors.white, Colors.blue[200]!]
                      : [
                          Colors.deepPurple[900]!,
                          const Color.fromARGB(255, 6, 27, 57)
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  // stops: [.3, .9],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              weatherModel.condition.replaceFirst(" ", "\n"),
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  fontSize: 30,
                                  color: isDay ? Colors.black : Colors.white),
                            ),
                            Text(
                              weatherModel.isDay == 1 ? "day" : "night",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: isDay ? Colors.black : Colors.white),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const SearchDialog(),
                            ).then((value) {
                              if (value != null) {
                                WeatherCubit.get(context).getWeather(value);
                              }
                            });
                          },
                          icon: Transform.flip(
                            flipX: true,
                            child: Icon(
                              Icons.search_rounded,
                              color: isDay ? Colors.black : Colors.white,
                              size: 34,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Last Update",
                    style: TextStyle(
                        fontSize: 20,
                        color: isDay ? Colors.black : Colors.white),
                  ),
                  Text(
                    weatherModel.lastUpdated,
                    style: TextStyle(
                        fontSize: 25,
                        color: isDay ? Colors.black : Colors.white),
                  ),
                  CachedNetworkImage(
                    imageUrl: "https:${weatherModel.icon}",
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "${weatherModel.region}:${weatherModel.country}",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            color: isDay ? Colors.black : Colors.white),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${weatherModel.temp}°",
                            style: TextStyle(
                                fontSize: 80,
                                color: isDay ? Colors.black : Colors.white),
                          ),
                          Text(
                            "Feels like ${weatherModel.tempFeelslike}°",
                            style: TextStyle(
                                color: isDay ? Colors.black : Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                weatherModel.nextDayDate.substring(5),
                                style: TextStyle(
                                    color: isDay ? Colors.black : Colors.white),
                              ),
                              CachedNetworkImage(
                                  imageUrl:
                                      "https:${weatherModel.nextDayicon}"),
                              Text(
                                "${weatherModel.nextDayTemp}°",
                                style: TextStyle(
                                    color: isDay ? Colors.black : Colors.white),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                weatherModel.dayAfterTomorrowDate.substring(5),
                                style: TextStyle(
                                    color: isDay ? Colors.black : Colors.white),
                              ),
                              CachedNetworkImage(
                                  imageUrl:
                                      "https:${weatherModel.dayAfterTomorrowicon}"),
                              Text(
                                "${weatherModel.dayAfterTomorrowTemp}°",
                                style: TextStyle(
                                    color: isDay ? Colors.black : Colors.white),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        } else {
          return const AlertDialog(
            title: Text("There is no data ....\ncheck your conection"),
          );
        }
      },
    );
  }
}
