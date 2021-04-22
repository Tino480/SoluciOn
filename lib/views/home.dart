import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:solucion/providers/db_provider.dart';
import 'package:solucion/providers/auth_provider.dart';
import 'package:solucion/providers/home_page_providers.dart';
import 'package:solucion/providers/signup_page_providers.dart';
import 'package:solucion/components/alert.dart';
import 'package:solucion/models/user.dart';

class HomePage extends ConsumerWidget {
  void updateSoliciting(BuildContext context) {
    context.read(solicitingProvider).state = true;
    context.read(donatingProvider).state = false;
    context.read(profileProvider).state = false;
    context.read(messagingProvider).state = false;
    context.read(requirmentsProvider).state = false;
    context.read(selectedIndexProvider).state = 0;
  }

  void updateDonating(BuildContext context) {
    context.read(solicitingProvider).state = false;
    context.read(donatingProvider).state = true;
    context.read(profileProvider).state = false;
    context.read(messagingProvider).state = false;
    context.read(requirmentsProvider).state = false;
    context.read(selectedIndexProvider).state = 1;
  }

  void updateProfile(BuildContext context) {
    context.read(solicitingProvider).state = false;
    context.read(donatingProvider).state = false;
    context.read(profileProvider).state = true;
    context.read(messagingProvider).state = false;
    context.read(requirmentsProvider).state = false;
    context.read(selectedIndexProvider).state = 2;
  }

  void updateMessaging(BuildContext context) {
    context.read(solicitingProvider).state = false;
    context.read(donatingProvider).state = false;
    context.read(profileProvider).state = false;
    context.read(messagingProvider).state = true;
    context.read(requirmentsProvider).state = false;
    context.read(selectedIndexProvider).state = 3;
  }

  void updateRequirments(BuildContext context) {
    context.read(solicitingProvider).state = false;
    context.read(donatingProvider).state = false;
    context.read(profileProvider).state = false;
    context.read(messagingProvider).state = false;
    context.read(requirmentsProvider).state = true;
    context.read(selectedIndexProvider).state = 4;
  }

  void _onItemTapped(int index, context) {
    if (index == 0) {
      updateSoliciting(context);
    } else if (index == 1) {
      updateDonating(context);
    } else if (index == 2) {
      updateProfile(context);
    } else if (index == 3) {
      updateMessaging(context);
    } else if (index == 4) {
      updateRequirments(context);
    }
  }

  void updateUserName(BuildContext context, String userName) {
    context.read(updateUserNameProvider).state = userName;
  }

  void updatePhoneNumber(BuildContext context, int phoneNumber) {
    context.read(updatePhoneNumberProvider).state = phoneNumber;
  }

  void updateState(BuildContext context, String state) {
    context.read(updateStateProvider).state = state;
  }

  void updateMunicipality(BuildContext context, String municipality) {
    context.read(updateMunicipalityProvider).state = municipality;
  }

  void updateUser(
    BuildContext context,
    userName,
    phoneNumber,
    state,
    municipality,
  ) {
    if (userName != null) {
      user.userName = userName;
    }
    if (phoneNumber != null) {
      user.phoneNumber = phoneNumber;
    }
    if (state != null) {
      user.state = state;
    }
    if (municipality != null) {
      user.municipality = municipality;
    }
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final soliciting = watch(solicitingProvider).state;
    final donating = watch(donatingProvider).state;
    final profile = watch(profileProvider).state;
    final messaging = watch(messagingProvider).state;
    final requirments = watch(requirmentsProvider).state;
    final userName = watch(updateUserNameProvider).state;
    final phoneNumber = watch(updatePhoneNumberProvider).state;
    final state = watch(updateStateProvider).state;
    final states = watch(statesProvider).state;
    final municipality = watch(updateMunicipalityProvider).state;
    final municipalities = watch(municipalitiesProvider).state;
    final _selectedIndex = watch(selectedIndexProvider).state;
    final _db = watch(dbServicesProvider);
    List<String> defaultMunicipality = ['Escoge un estado primero!!'];
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: (soliciting != false)
              ? Text('Mis solicitudes')
              : (donating != false)
                  ? Text('Solicitudes para donar')
                  : (profile != false)
                      ? Text('Mi perfil')
                      : (messaging != false)
                          ? Text('Mis mensages')
                          : (requirments != false)
                              ? Text('Requisitos para donar')
                              : Container(),
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: <Widget>[
            Consumer(builder: (context, watch, child) {
              final _auth = watch(authServicesProvider);
              return Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: GestureDetector(
                      child: const Icon(Icons.exit_to_app, size: 30.0),
                      onTap: () {
                        _auth.signOut(context);
                      },
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: HexColor("#e30713"),
            image: const DecorationImage(
              image: const AssetImage("assets/redblood.jpeg"),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Consumer(builder: (context, watch, child) {
            final cards = watch(cardStreamProvider);
            final requests = watch(requestsStreamProvider);
            return (soliciting != false)
                ? requests.when(
                    data: (request) => ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: request.length,
                        itemBuilder: (BuildContext context, int index) {
                          final name = request[index]['Description'];
                          final municipality = request[index]['Municipality'];
                          final bloodType = request[index]['Blood Type'];
                          final date = request[index]['Create Date'];
                          return InkWell(
                            splashColor: Colors.black,
                            onTap: municipality != ''
                                ? () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          String blood;
                                          String description;
                                          return AlertDialog(
                                            scrollable: true,
                                            title: Text("Actualizar solicitud"),
                                            content: StatefulBuilder(builder:
                                                (BuildContext context,
                                                    StateSetter setState) {
                                              return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    const Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 0.0),
                                                      child: const Text(
                                                        "Descripción",
                                                        style: const TextStyle(
                                                            color: Colors.red,
                                                            fontSize: 16.0),
                                                      ),
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          width: 1.0,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.0),
                                                      ),
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10.0,
                                                          horizontal: 20.0),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Container(
                                                            height: 30.0,
                                                            width: 1.0,
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.5),
                                                            margin:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 00.0,
                                                                    right:
                                                                        10.0),
                                                          ),
                                                          Expanded(
                                                            child: TextField(
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText: name,
                                                                hintStyle: const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              onChanged: (value) =>
                                                                  description =
                                                                      value,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      children: [
                                                        const Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 0.0),
                                                          child: const Text(
                                                            "Tipo de sangre",
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        16.0),
                                                          ),
                                                        ),
                                                        Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            border: Border.all(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5),
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                          ),
                                                          margin:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical:
                                                                      10.0,
                                                                  horizontal:
                                                                      20.0),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                height: 30.0,
                                                                width: 1.0,
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                                margin: const EdgeInsets
                                                                        .only(
                                                                    left: 00.0,
                                                                    right:
                                                                        10.0),
                                                              ),
                                                              Expanded(
                                                                  child:
                                                                      DropdownButton(
                                                                value: blood,
                                                                hint: Text(
                                                                    bloodType),
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() =>
                                                                      blood =
                                                                          value);
                                                                },
                                                                items: bloodTypes
                                                                    .map(
                                                                        (location) {
                                                                  return DropdownMenuItem(
                                                                    child: Text(
                                                                        location,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.red)),
                                                                    value:
                                                                        location,
                                                                  );
                                                                }).toList(),
                                                              ))
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 20.0),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20.0,
                                                              right: 20.0),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: TextButton(
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  shadowColor:
                                                                      Colors
                                                                          .red,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30.0),
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    const Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              20.0),
                                                                      child:
                                                                          const Text(
                                                                        "Actualizar",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 18.0),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Container(),
                                                                    ),
                                                                    Transform
                                                                        .translate(
                                                                      offset: Offset(
                                                                          5.0,
                                                                          0.0),
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            const EdgeInsets.all(5.0),
                                                                        child: TextButton(
                                                                            style: TextButton.styleFrom(
                                                                              shadowColor: Colors.white,
                                                                              backgroundColor: Colors.white,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(28.0),
                                                                              ),
                                                                            ),
                                                                            child: const Icon(
                                                                              Icons.check,
                                                                              color: Colors.black,
                                                                            ),
                                                                            onPressed: () => {
                                                                                  _db.updateBloodRequest(date, description, blood, name, bloodType),
                                                                                  context.refresh(requestsStreamProvider),
                                                                                  Navigator.pop(context)
                                                                                }),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                onPressed:
                                                                    () => {
                                                                          _db.updateBloodRequest(
                                                                              date,
                                                                              description,
                                                                              blood,
                                                                              name,
                                                                              bloodType),
                                                                          context
                                                                              .refresh(requestsStreamProvider),
                                                                          Navigator.pop(
                                                                              context)
                                                                        }),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 20.0),
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20.0,
                                                              right: 20.0),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Expanded(
                                                            child: TextButton(
                                                                style: TextButton
                                                                    .styleFrom(
                                                                  shadowColor:
                                                                      Colors
                                                                          .red,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30.0),
                                                                  ),
                                                                ),
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    const Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              20.0),
                                                                      child:
                                                                          const Text(
                                                                        "Borrar",
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 18.0),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Container(),
                                                                    ),
                                                                    Transform
                                                                        .translate(
                                                                      offset: Offset(
                                                                          5.0,
                                                                          0.0),
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            const EdgeInsets.all(5.0),
                                                                        child: TextButton(
                                                                            style: TextButton.styleFrom(
                                                                              shadowColor: Colors.white,
                                                                              backgroundColor: Colors.white,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(28.0),
                                                                              ),
                                                                            ),
                                                                            child: const Icon(
                                                                              Icons.check,
                                                                              color: Colors.black,
                                                                            ),
                                                                            onPressed: () => {
                                                                                  _db.deleteBloodRequest(date),
                                                                                  context.refresh(requestsStreamProvider),
                                                                                  Navigator.pop(context)
                                                                                }),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                onPressed:
                                                                    () => {
                                                                          _db.deleteBloodRequest(
                                                                              date),
                                                                          context
                                                                              .refresh(requestsStreamProvider),
                                                                          Navigator.pop(
                                                                              context)
                                                                        }),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ]);
                                            }),
                                          );
                                        });
                                  }
                                : () {},
                            child: Card(
                              color: Colors.white.withOpacity(0.9),
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      name,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      municipality,
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                    loading: () => Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (error, __) => showErrorDialog(context, error),
                  )
                : (donating != false)
                    ? cards.when(
                        data: (card) => ListView.builder(
                            itemCount: card.length,
                            itemBuilder: (BuildContext context, int index) {
                              final name = card[index]['Name'];
                              final description = card[index]['Description'];
                              final municipality = card[index]['Municipality'];
                              final toUid = card[index]['User'];
                              return Card(
                                color: Colors.white.withOpacity(0.9),
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        description,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        municipality,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    ButtonBar(
                                      alignment: MainAxisAlignment.start,
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            shadowColor: Colors.red,
                                            textStyle:
                                                TextStyle(color: Colors.black),
                                          ),
                                          onPressed: toUid != null
                                              ? () {
                                                  _db.setAndCreateCombined(
                                                      toUid, name);
                                                  CircularProgressIndicator();
                                                  Future.delayed(
                                                      Duration(seconds: 2), () {
                                                    context.refresh(
                                                        cardStreamProvider);
                                                    context.refresh(
                                                        chatStreamProvider);
                                                    Navigator.pushNamed(
                                                        context, '/Chat');
                                                  });
                                                }
                                              : () {},
                                          child: const Text(
                                            'Donar',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }),
                        loading: () => Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (error, __) => showErrorDialog(context, error),
                      )
                    : (profile != false)
                        ? SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Padding(
                                  padding: const EdgeInsets.only(left: 40.0),
                                  child: const Text(
                                    "Nombre de usuario",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      const Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 15.0),
                                        child: const Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        height: 30.0,
                                        width: 1.0,
                                        color: Colors.grey.withOpacity(0.5),
                                        margin: const EdgeInsets.only(
                                            left: 00.0, right: 10.0),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: user.userName,
                                            hintStyle: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                          onChanged: (value) =>
                                              updateUserName(context, value),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: const EdgeInsets.only(left: 40.0),
                                  child: const Text(
                                    "Número de teléfono",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      const Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 15.0),
                                        child: const Icon(
                                          Icons.phone,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        height: 30.0,
                                        width: 1.0,
                                        color: Colors.grey.withOpacity(0.5),
                                        margin: const EdgeInsets.only(
                                            left: 00.0, right: 10.0),
                                      ),
                                      Expanded(
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText:
                                                user.phoneNumber.toString(),
                                            hintStyle: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                          onChanged: (value) =>
                                              updatePhoneNumber(
                                                  context, int.parse(value)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: const EdgeInsets.only(left: 40.0),
                                  child: const Text(
                                    "Estado",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      const Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 15.0),
                                        child: const Icon(
                                          Icons.map,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        height: 30.0,
                                        width: 1.0,
                                        color: Colors.grey.withOpacity(0.5),
                                        margin: const EdgeInsets.only(
                                            left: 00.0, right: 10.0),
                                      ),
                                      Expanded(
                                          child: DropdownButton(
                                        hint: Text(user.state),
                                        value: state,
                                        onChanged: (newValue) {
                                          updateState(context, newValue);
                                        },
                                        items: states.map((location) {
                                          return DropdownMenuItem(
                                            child: Text(location,
                                                style: const TextStyle(
                                                    color: Colors.red)),
                                            value: location,
                                          );
                                        }).toList(),
                                      ))
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: const EdgeInsets.only(left: 40.0),
                                  child: const Text(
                                    "Municipio",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      const Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 15.0),
                                        child: const Icon(
                                          Icons.home,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Container(
                                        height: 30.0,
                                        width: 1.0,
                                        color: Colors.grey.withOpacity(0.5),
                                        margin: const EdgeInsets.only(
                                            left: 00.0, right: 10.0),
                                      ),
                                      Expanded(
                                          child: (state != null)
                                              ? DropdownButton(
                                                  hint: Text(user.municipality),
                                                  value: municipality,
                                                  onChanged: (newValue) {
                                                    updateMunicipality(
                                                        context, newValue);
                                                  },
                                                  items: municipalities[state]
                                                      .map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (location) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      child: Text(location,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .red)),
                                                      value: location,
                                                    );
                                                  }).toList(),
                                                )
                                              : DropdownButton<String>(
                                                  hint: Text(user.municipality),
                                                  value: municipality,
                                                  onChanged: (newValue) {
                                                    updateMunicipality(
                                                        context, newValue);
                                                  },
                                                  items: defaultMunicipality
                                                      .map((location) {
                                                    return DropdownMenuItem(
                                                      child: Text(location,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .red)),
                                                      value: location,
                                                    );
                                                  }).toList(),
                                                )),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 20.0),
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: TextButton(
                                            style: TextButton.styleFrom(
                                              shadowColor: Colors.white,
                                              backgroundColor: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                const Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: const Text(
                                                    "Actualizar",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.0),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(),
                                                ),
                                                Transform.translate(
                                                  offset: Offset(5.0, 0.0),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          shadowColor:
                                                              Colors.white,
                                                          backgroundColor:
                                                              Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        28.0),
                                                          ),
                                                        ),
                                                        child: const Icon(
                                                          Icons.check,
                                                          color: Colors.black,
                                                        ),
                                                        onPressed: () => {
                                                              updateUser(
                                                                context,
                                                                userName,
                                                                phoneNumber,
                                                                state,
                                                                municipality,
                                                              ),
                                                              _db.updateFirebaseUser(),
                                                              Navigator.of(
                                                                      context)
                                                                  .pushNamed(
                                                                      '/Splash')
                                                            }),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            onPressed: () => {
                                                  updateUser(
                                                    context,
                                                    userName,
                                                    phoneNumber,
                                                    state,
                                                    municipality,
                                                  ),
                                                  _db.updateFirebaseUser(),
                                                  Navigator.of(context)
                                                      .pushNamed('/Splash')
                                                }),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(
                                      top: 50.0, bottom: 100.0),
                                  child: Column(
                                    children: <Widget>[
                                      const Padding(
                                          padding: const EdgeInsets.only(
                                              top: 200.0)),
                                      const Text(
                                        "Unidos Por La Vida",
                                        style: const TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : (messaging != false)
                            ? ListView(children: <Widget>[
                                Container(
                                  child: Consumer(
                                      builder: (context, watch, child) {
                                    final chats = watch(chatStreamProvider);
                                    final _db = watch(dbServicesProvider);
                                    return chats.when(
                                      data: (chat) => ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: chat.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            String contact =
                                                chat[index]['contact'];
                                            String combined =
                                                chat[index]['Combined Uid'];
                                            String toUid =
                                                chat[index]['contact uid'];
                                            return Column(children: <Widget>[
                                              ListTile(
                                                tileColor: Colors.white,
                                                title: Text('$contact'),
                                                trailing: IconButton(
                                                  icon: const Icon(
                                                      Icons.delete_forever),
                                                  onPressed: () {
                                                    _db.deleteConversation(
                                                        toUid, combined);
                                                    Future.delayed(
                                                        Duration(seconds: 2),
                                                        () {
                                                      context.refresh(
                                                          chatStreamProvider);
                                                      context.refresh(
                                                          cardStreamProvider);
                                                    });
                                                  },
                                                ),
                                                onTap: () {
                                                  user.combined = combined;
                                                  Navigator.of(context)
                                                      .pushNamed('/Chat');
                                                },
                                              ),
                                              Divider(
                                                color: Colors.red,
                                                thickness: 5,
                                                height: 5,
                                              )
                                            ]);
                                          }),
                                      loading: () => Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      error: (error, __) =>
                                          showErrorDialog(context, error),
                                    );
                                  }),
                                ),
                              ])
                            : (requirments != false)
                                ? ListView(
                                    children: <Widget>[
                                      ListTile(
                                        title: Text(
                                          '⚪ Mayor de 18 años y menor de 65.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          '⚪ Peso minimo de 55kg.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          '⚪ No estar enfermo en el momento actual, no ser diabetico, no hipertenso.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          '⚪ No estar embarazada ni lactando.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          '⚪ No haber tenido mas de 4 embarazos incluyendo abortos.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          '⚪ No andar menstruando (mínimo 5 días después de la ultima regla).',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          '⚪ No haber padecido hepatitis, fiebre tifoidea, brucelosis, paludismo, tuberculosis.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          '⚪ No bebidas alcohólicas o analgésicos (48 horas antes).',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          '⚪ No padecer alergias o estar ingiriendo algún medicamento (sobre todo aspirina).',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          '⚪ No tatuajes, perforaciones ni acupuntura en el ultimo año.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          '⚪ No haberse aplicado vacunas un mes antes.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          '⚪ No venir desvelado (8 horas de sueño).',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          '⚪ Acudir con un mínimo de ayuno de 8 horas (lácteos, carnes, grasas).',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          '⚪ No ser usuario de drogas de ninguna clase.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          '⚪ No haber recibido transfusiones.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          '⚪ No practicar la prostitución.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          '⚪ No tener más de una pareja sexual.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          '⚪ No ser homosexual ni bisexual.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          '⚪ Disponer de un mínimo de 2 a 3 horas para los exámenes y la donación.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ListTile(
                                        title: Text(
                                          '⚪ Estatura mínima de 150 cm.',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container();
          }),
        ),
        floatingActionButton: (soliciting != false)
            ? FloatingActionButton(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        bool isUser = false;
                        String blood;
                        String description;
                        return AlertDialog(
                          scrollable: true,
                          title: Text("Solicitud para donación"),
                          content: StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(children: [
                                    Text("Es para mí?"),
                                    Switch(
                                        value: isUser,
                                        onChanged: (value) {
                                          setState(() => isUser = value);
                                        }),
                                    (isUser != false) ? Text('Si') : Text('No'),
                                  ]),
                                  const Padding(
                                    padding: const EdgeInsets.only(left: 0.0),
                                    child: const Text(
                                      "Descripción",
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 16.0),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 30.0,
                                          width: 1.0,
                                          color: Colors.grey.withOpacity(0.5),
                                          margin: const EdgeInsets.only(
                                              left: 00.0, right: 10.0),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              hintStyle: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                            onChanged: (value) =>
                                                description = value,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  (isUser != false)
                                      ? Container()
                                      : Column(
                                          children: [
                                            const Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0.0),
                                              child: const Text(
                                                "Tipo de sangre",
                                                style: const TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 16.0),
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  width: 1.0,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 20.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    height: 30.0,
                                                    width: 1.0,
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 00.0,
                                                            right: 10.0),
                                                  ),
                                                  Expanded(
                                                      child: DropdownButton(
                                                    value: blood,
                                                    onChanged: (value) {
                                                      setState(
                                                          () => blood = value);
                                                    },
                                                    items: bloodTypes
                                                        .map((location) {
                                                      return DropdownMenuItem(
                                                        child: Text(location,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .red)),
                                                        value: location,
                                                      );
                                                    }).toList(),
                                                  ))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 20.0),
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                shadowColor: Colors.red,
                                                backgroundColor: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  const Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20.0),
                                                    child: const Text(
                                                      "Solicitar",
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18.0),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Container(),
                                                  ),
                                                  Transform.translate(
                                                    offset: Offset(5.0, 0.0),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: TextButton(
                                                          style: TextButton
                                                              .styleFrom(
                                                            shadowColor:
                                                                Colors.white,
                                                            backgroundColor:
                                                                Colors.white,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          28.0),
                                                            ),
                                                          ),
                                                          child: const Icon(
                                                            Icons.check,
                                                            color: Colors.black,
                                                          ),
                                                          onPressed: () => {
                                                                _db.makeBloodRequest(
                                                                    blood,
                                                                    description,
                                                                    context),
                                                                context.refresh(
                                                                    requestsStreamProvider),
                                                                Navigator.pop(
                                                                    context)
                                                              }),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () => {
                                                    _db.makeBloodRequest(blood,
                                                        description, context),
                                                    context.refresh(
                                                        requestsStreamProvider),
                                                    Navigator.pop(context)
                                                  }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]);
                          }),
                        );
                      });
                },
                child: Icon(Icons.add),
                tooltip: 'Solicitar',
              )
            : null,
        bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.format_list_bulleted),
                label: 'Solicitar sangre',
                backgroundColor: Colors.red,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.card_giftcard_outlined),
                label: 'Donar sangre',
                backgroundColor: Colors.red,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.supervised_user_circle_outlined),
                label: 'Perfil',
                backgroundColor: Colors.red,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message),
                label: 'Mensages',
                backgroundColor: Colors.red,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info_outline),
                label: 'Requisitos',
                backgroundColor: Colors.red,
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: (index) => _onItemTapped(index, context)),
      ),
    );
  }
}
