import 'package:cuaca/api.dart';
import 'package:cuaca/weathermodel.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiResponse? response;
  bool inProgress = false;
  String message = "Search for the location to get weather data";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Weather App'),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueGrey, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchWidget(),
                const SizedBox(height: 20),
                if (inProgress)
                  const Center(child: CircularProgressIndicator())
                else
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildWeatherWidget(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: SearchBar(
        hintText: "Search any location",
        onSubmitted: (value) {
          _getWeatherData(value);
        },
      ),
    );
  }

  Widget _buildWeatherWidget() {
    if (response == null) {
      return Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationRow(),
          const SizedBox(height: 10),
          _buildTemperatureRow(),
          Center(
            child: SizedBox(
              height: 200,
              child: Image.network(
                "https:${response?.current?.condition?.icon}"
                    .replaceAll("64x64", "128x128"),
                scale: 0.7,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildWeatherDetailsCard(),
        ],
      );
    }
  }

  Widget _buildLocationRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Icon(
          Icons.location_on,
          size: 50,
          color: Colors.white,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              response?.location?.name ?? "",
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
            Text(
              response?.location?.country ?? "",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTemperatureRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${response?.current?.tempC ?? ""} °C",
            style: const TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          response?.current?.condition?.text ?? "",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetailsCard() {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildWeatherDetailRow(
            "Humidity",
            response?.current?.humidity?.toString() ?? "",
            "Wind Speed",
            "${response?.current?.windKph?.toString() ?? ""} km/h",
          ),
          _buildWeatherDetailRow(
            "UV",
            response?.current?.uv?.toString() ?? "",
            "Precipitation",
            "${response?.current?.precipMm?.toString() ?? ""} mm",
          ),
          _buildWeatherDetailRow(
            "Local Time",
            response?.location?.localtime?.split(" ").last ?? "",
            "Local Date",
            response?.location?.localtime?.split(" ").first ?? "",
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetailRow(
      String title1, String data1, String title2, String data2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _dataAndTitleWidget(title1, data1),
        _dataAndTitleWidget(title2, data2),
      ],
    );
  }

  Widget _dataAndTitleWidget(String title, String data) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            data,
            style: const TextStyle(
              fontSize: 27,
              color: Colors.blueGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getWeatherData(String location) async {
    setState(() {
      inProgress = true;
    });

    try {
      response = await WeatherApi().getCurrentWeather(location);
    } catch (e) {
      setState(() {
        message = "Failed to get weather";
        response = null;
      });
    } finally {
      setState(() {
        inProgress = false;
      });
    }
  }
}
