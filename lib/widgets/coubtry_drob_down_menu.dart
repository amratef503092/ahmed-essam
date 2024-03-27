import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/country_model.dart';
import '../providers/countery.dart';
class CountriesWidget extends StatelessWidget 
{
  const CountriesWidget({super.key , required this.onChanged});
  final Function? onChanged;

  @override
  Widget build(BuildContext context) 
  {
    return ChangeNotifierProvider(
      create: (context) => CountryProvider()..getCountry(),
     child: Consumer<CountryProvider>(
       builder: (context, country, child) => country.loading
           ? const Center(child:  CircularProgressIndicator())
           : DropdownButton<Countries>(
            borderRadius: BorderRadius.circular(10),
            isExpanded: true,
               hint: const Text('Select Country'),
               value: country.value,
               onChanged: (Countries? value) 
               {

                  onChanged!(value);
                  context.read<CountryProvider>().setValue(value!);

               },
               items: country.countryModel!.countries!
                   .map<DropdownMenuItem<Countries>>(
                     (Countries value) => DropdownMenuItem<Countries>(
                       value: value,
                       child: Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Text(value.nameEn!),
                       ),
                     ),
                   )
                   .toList(),
             ),
     ));
  }
}