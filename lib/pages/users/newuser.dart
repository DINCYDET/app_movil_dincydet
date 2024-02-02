import 'package:app_movil_dincydet/pages/home/myscaffold.dart';
import 'package:app_movil_dincydet/pages/users/useredit.dart';
import 'package:app_movil_dincydet/providers/users/newuser_provider.dart';
import 'package:app_movil_dincydet/src/utils/info.dart';
import 'package:app_movil_dincydet/src/utils/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NuevoUsuario extends StatelessWidget {
  const NuevoUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      drawer: false,
      title: 'Nuevo usuario',
      section: DrawerSection.other,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ChangeNotifierProvider<NewUserProvider>(
            create: (context) => NewUserProvider(),
            child: Consumer<NewUserProvider>(
              builder: (context, provider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'DATOS',
                                  style: TextStyle(
                                    color: MC_darkblue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InputDecorator(
                              decoration: const InputDecoration(
                                isDense: true,
                                icon: Icon(
                                  Icons.badge_rounded,
                                  size: 36,
                                  color: MC_darkblue,
                                ),
                                label: Text('Grado'),
                                border: OutlineInputBorder(),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: provider.gradeValue,
                                  isExpanded: true,
                                  isDense: true,
                                  items:
                                      List.generate(gradeTypes.length, (index) {
                                    return DropdownMenuItem(
                                      value: index,
                                      child: Text(gradeTypes[index]),
                                    );
                                  }),
                                  onChanged: provider.onChangedGrade,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            UserField(
                              controller: provider.nameController,
                              label: 'Nombres',
                              icon: Icons.people,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            UserField(
                              controller: provider.lastnameController,
                              label: 'Apellidos',
                              icon: Icons.people,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InputDecorator(
                              decoration: const InputDecoration(
                                isDense: true,
                                icon: Icon(
                                  Icons.wallet_travel_outlined,
                                  size: 36,
                                  color: MC_darkblue,
                                ),
                                label: Text('Cargo'),
                                border: OutlineInputBorder(),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: provider.positionValue,
                                  isExpanded: true,
                                  isDense: true,
                                  items: List.generate(cargosDincydet.length,
                                      (index) {
                                    return DropdownMenuItem(
                                      value: index,
                                      child: Text(cargosDincydet[index]),
                                    );
                                  }),
                                  onChanged: provider.onChangedPosition,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InputDecorator(
                              decoration: const InputDecoration(
                                isDense: true,
                                icon: Icon(
                                  Icons.location_searching,
                                  size: 36,
                                  color: MC_darkblue,
                                ),
                                label: Text('Area'),
                                border: OutlineInputBorder(),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: provider.areaValue,
                                  isExpanded: true,
                                  isDense: true,
                                  items: List.generate(areasDincydet.length,
                                      (index) {
                                    return DropdownMenuItem(
                                      value: index,
                                      child: Text(areasDincydet[index]),
                                    );
                                  }),
                                  onChanged: provider.onChangedArea,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            UserField(
                              controller: provider.addressController,
                              label: 'Direccion',
                              icon: Icons.location_city,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InputDecorator(
                              decoration: const InputDecoration(
                                isDense: true,
                                icon: Icon(
                                  Icons.bloodtype,
                                  size: 36,
                                  color: MC_darkblue,
                                ),
                                label: Text('Tipo de sangre'),
                                border: OutlineInputBorder(),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: provider.bloodValue,
                                  isExpanded: true,
                                  isDense: true,
                                  items:
                                      List.generate(bloodTypes.length, (index) {
                                    return DropdownMenuItem(
                                      value: index,
                                      child: Text(bloodTypes[index]),
                                    );
                                  }),
                                  onChanged: provider.onChangedBlood,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            UserField(
                              controller: provider.phoneController,
                              label: 'N° Celular',
                              icon: Icons.phone,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            UserField(
                              controller: provider.emailController,
                              label: 'Email',
                              icon: Icons.email,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            UserField(
                              controller: provider.contactController,
                              label: 'Contacto',
                              icon: Icons.emoji_people,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextField(
                              controller: provider.dateController,
                              style: const TextStyle(fontSize: 14.0),
                              readOnly: true,
                              decoration: const InputDecoration(
                                isDense: true,
                                icon: Icon(
                                  Icons.cake,
                                  size: 36,
                                  color: MC_darkblue,
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(10.0, 2.0, 2.0, 2.0),
                                suffixIcon: Icon(Icons.calendar_month),
                                labelText: 'Fecha de nacimiento',
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                              ),
                              onTap: provider.onTapDate,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            UserField(
                              controller: provider.cipController,
                              label: 'CIP',
                              icon: Icons.wb_iridescent_rounded,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(8),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InputDecorator(
                              decoration: const InputDecoration(
                                isDense: true,
                                icon: Icon(
                                  Icons.edit_note_rounded,
                                  size: 36,
                                  color: MC_darkblue,
                                ),
                                label: Text('Condición Laboral'),
                                border: OutlineInputBorder(),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: provider.userLaboralValue,
                                  isExpanded: true,
                                  isDense: true,
                                  items: List.generate(
                                      userLaboralConditions.length, (index) {
                                    return DropdownMenuItem(
                                      value: index,
                                      child: Text(userLaboralConditions[index]),
                                    );
                                  }),
                                  onChanged: provider.onChangedUserLaboral,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            InputDecorator(
                              decoration: const InputDecoration(
                                isDense: true,
                                icon: Icon(
                                  Icons.edit_document,
                                  size: 36,
                                  color: MC_darkblue,
                                ),
                                label: Text('Condición Temporal'),
                                border: OutlineInputBorder(),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: provider.userTemporalValue,
                                  isExpanded: true,
                                  isDense: true,
                                  items: List.generate(
                                      userTemporalConditions.length, (index) {
                                    return DropdownMenuItem(
                                      value: index,
                                      child:
                                          Text(userTemporalConditions[index]),
                                    );
                                  }),
                                  onChanged: provider.onChangedUserTemporal,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            UserField(
                              controller: provider.dniController,
                              label: 'DNI',
                              icon: Icons.add_card_sharp,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(8),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            UserField(
                              controller: provider.passController,
                              label: 'Contraseña',
                              icon: Icons.password,
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: UpdatePhoto(
                                updatephotoprovider:
                                    provider.updatephotoprovider,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: MC_darkblue,
                                ),
                                onPressed: provider.onTapCreateUser,
                                child: const Text('Crear usuario'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class UserField extends StatelessWidget {
  const UserField({
    super.key,
    required this.controller,
    required this.icon,
    required this.label,
    this.validator,
    this.inputFormatters,
  });
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        isDense: true,
        border: const OutlineInputBorder(),
        label: Text(
          label,
        ),
        icon: Icon(
          icon,
          size: 36,
          color: MC_darkblue,
        ),
      ),
    );
  }
}

class UpdateButton extends StatelessWidget {
  const UpdateButton({super.key, required this.onTap});
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 60),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade900,
              shape: const CircleBorder(),
              fixedSize: const Size(40, 40),
              padding: const EdgeInsets.all(5.0),
              alignment: Alignment.center,
            ),
            child: const Icon(
              Icons.add,
              size: 36,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            'Registrar',
            style: TextStyle(
                fontSize: 28,
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
