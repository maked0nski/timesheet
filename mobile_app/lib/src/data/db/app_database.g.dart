// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ClientsTable extends Clients with TableInfo<$ClientsTable, Client> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _geolocationMeta = const VerificationMeta(
    'geolocation',
  );
  @override
  late final GeneratedColumn<String> geolocation = GeneratedColumn<String>(
    'geolocation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDefaultClientMeta = const VerificationMeta(
    'isDefaultClient',
  );
  @override
  late final GeneratedColumn<bool> isDefaultClient = GeneratedColumn<bool>(
    'is_default_client',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default_client" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    address,
    geolocation,
    phone,
    email,
    description,
    isDefaultClient,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Client> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('geolocation')) {
      context.handle(
        _geolocationMeta,
        geolocation.isAcceptableOrUnknown(
          data['geolocation']!,
          _geolocationMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_default_client')) {
      context.handle(
        _isDefaultClientMeta,
        isDefaultClient.isAcceptableOrUnknown(
          data['is_default_client']!,
          _isDefaultClientMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Client map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Client(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      geolocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}geolocation'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      isDefaultClient: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default_client'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ClientsTable createAlias(String alias) {
    return $ClientsTable(attachedDatabase, alias);
  }
}

class Client extends DataClass implements Insertable<Client> {
  final int id;
  final String name;
  final String? address;
  final String? geolocation;
  final String? phone;
  final String? email;
  final String? description;
  final bool isDefaultClient;
  final bool isActive;
  final DateTime createdAt;
  const Client({
    required this.id,
    required this.name,
    this.address,
    this.geolocation,
    this.phone,
    this.email,
    this.description,
    required this.isDefaultClient,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || geolocation != null) {
      map['geolocation'] = Variable<String>(geolocation);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_default_client'] = Variable<bool>(isDefaultClient);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ClientsCompanion toCompanion(bool nullToAbsent) {
    return ClientsCompanion(
      id: Value(id),
      name: Value(name),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      geolocation: geolocation == null && nullToAbsent
          ? const Value.absent()
          : Value(geolocation),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isDefaultClient: Value(isDefaultClient),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Client.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Client(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      address: serializer.fromJson<String?>(json['address']),
      geolocation: serializer.fromJson<String?>(json['geolocation']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      description: serializer.fromJson<String?>(json['description']),
      isDefaultClient: serializer.fromJson<bool>(json['isDefaultClient']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'address': serializer.toJson<String?>(address),
      'geolocation': serializer.toJson<String?>(geolocation),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'description': serializer.toJson<String?>(description),
      'isDefaultClient': serializer.toJson<bool>(isDefaultClient),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Client copyWith({
    int? id,
    String? name,
    Value<String?> address = const Value.absent(),
    Value<String?> geolocation = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> description = const Value.absent(),
    bool? isDefaultClient,
    bool? isActive,
    DateTime? createdAt,
  }) => Client(
    id: id ?? this.id,
    name: name ?? this.name,
    address: address.present ? address.value : this.address,
    geolocation: geolocation.present ? geolocation.value : this.geolocation,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    description: description.present ? description.value : this.description,
    isDefaultClient: isDefaultClient ?? this.isDefaultClient,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  Client copyWithCompanion(ClientsCompanion data) {
    return Client(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      address: data.address.present ? data.address.value : this.address,
      geolocation: data.geolocation.present
          ? data.geolocation.value
          : this.geolocation,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      description: data.description.present
          ? data.description.value
          : this.description,
      isDefaultClient: data.isDefaultClient.present
          ? data.isDefaultClient.value
          : this.isDefaultClient,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Client(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('geolocation: $geolocation, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('description: $description, ')
          ..write('isDefaultClient: $isDefaultClient, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    address,
    geolocation,
    phone,
    email,
    description,
    isDefaultClient,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Client &&
          other.id == this.id &&
          other.name == this.name &&
          other.address == this.address &&
          other.geolocation == this.geolocation &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.description == this.description &&
          other.isDefaultClient == this.isDefaultClient &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class ClientsCompanion extends UpdateCompanion<Client> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> address;
  final Value<String?> geolocation;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> description;
  final Value<bool> isDefaultClient;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const ClientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.address = const Value.absent(),
    this.geolocation = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.description = const Value.absent(),
    this.isDefaultClient = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ClientsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.address = const Value.absent(),
    this.geolocation = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.description = const Value.absent(),
    this.isDefaultClient = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Client> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? address,
    Expression<String>? geolocation,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? description,
    Expression<bool>? isDefaultClient,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (address != null) 'address': address,
      if (geolocation != null) 'geolocation': geolocation,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (description != null) 'description': description,
      if (isDefaultClient != null) 'is_default_client': isDefaultClient,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ClientsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? address,
    Value<String?>? geolocation,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String?>? description,
    Value<bool>? isDefaultClient,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return ClientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      geolocation: geolocation ?? this.geolocation,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      description: description ?? this.description,
      isDefaultClient: isDefaultClient ?? this.isDefaultClient,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (geolocation.present) {
      map['geolocation'] = Variable<String>(geolocation.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isDefaultClient.present) {
      map['is_default_client'] = Variable<bool>(isDefaultClient.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('address: $address, ')
          ..write('geolocation: $geolocation, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('description: $description, ')
          ..write('isDefaultClient: $isDefaultClient, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<int> clientId = GeneratedColumn<int>(
    'client_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clients (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _billingTypeMeta = const VerificationMeta(
    'billingType',
  );
  @override
  late final GeneratedColumn<String> billingType = GeneratedColumn<String>(
    'billing_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('hourly'),
  );
  static const VerificationMeta _hourlyRateMeta = const VerificationMeta(
    'hourlyRate',
  );
  @override
  late final GeneratedColumn<double> hourlyRate = GeneratedColumn<double>(
    'hourly_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fixedRateMeta = const VerificationMeta(
    'fixedRate',
  );
  @override
  late final GeneratedColumn<double> fixedRate = GeneratedColumn<double>(
    'fixed_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _defaultBreakMinutesMeta =
      const VerificationMeta('defaultBreakMinutes');
  @override
  late final GeneratedColumn<int> defaultBreakMinutes = GeneratedColumn<int>(
    'default_break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _overtimeEnabledMeta = const VerificationMeta(
    'overtimeEnabled',
  );
  @override
  late final GeneratedColumn<bool> overtimeEnabled = GeneratedColumn<bool>(
    'overtime_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("overtime_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _overtimeAfterMinutesMeta =
      const VerificationMeta('overtimeAfterMinutes');
  @override
  late final GeneratedColumn<int> overtimeAfterMinutes = GeneratedColumn<int>(
    'overtime_after_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(480),
  );
  static const VerificationMeta _overtimeMultiplierMeta =
      const VerificationMeta('overtimeMultiplier');
  @override
  late final GeneratedColumn<double> overtimeMultiplier =
      GeneratedColumn<double>(
        'overtime_multiplier',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(1.5),
      );
  static const VerificationMeta _nightEnabledMeta = const VerificationMeta(
    'nightEnabled',
  );
  @override
  late final GeneratedColumn<bool> nightEnabled = GeneratedColumn<bool>(
    'night_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("night_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nightStartMinuteMeta = const VerificationMeta(
    'nightStartMinute',
  );
  @override
  late final GeneratedColumn<int> nightStartMinute = GeneratedColumn<int>(
    'night_start_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1320),
  );
  static const VerificationMeta _nightEndMinuteMeta = const VerificationMeta(
    'nightEndMinute',
  );
  @override
  late final GeneratedColumn<int> nightEndMinute = GeneratedColumn<int>(
    'night_end_minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(360),
  );
  static const VerificationMeta _nightMultiplierMeta = const VerificationMeta(
    'nightMultiplier',
  );
  @override
  late final GeneratedColumn<double> nightMultiplier = GeneratedColumn<double>(
    'night_multiplier',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.25),
  );
  static const VerificationMeta _holidayEnabledMeta = const VerificationMeta(
    'holidayEnabled',
  );
  @override
  late final GeneratedColumn<bool> holidayEnabled = GeneratedColumn<bool>(
    'holiday_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("holiday_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _holidayMultiplierMeta = const VerificationMeta(
    'holidayMultiplier',
  );
  @override
  late final GeneratedColumn<double> holidayMultiplier =
      GeneratedColumn<double>(
        'holiday_multiplier',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(2.0),
      );
  static const VerificationMeta _isBillableDefaultMeta = const VerificationMeta(
    'isBillableDefault',
  );
  @override
  late final GeneratedColumn<bool> isBillableDefault = GeneratedColumn<bool>(
    'is_billable_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_billable_default" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    clientId,
    name,
    billingType,
    hourlyRate,
    fixedRate,
    defaultBreakMinutes,
    overtimeEnabled,
    overtimeAfterMinutes,
    overtimeMultiplier,
    nightEnabled,
    nightStartMinute,
    nightEndMinute,
    nightMultiplier,
    holidayEnabled,
    holidayMultiplier,
    isBillableDefault,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Project> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('billing_type')) {
      context.handle(
        _billingTypeMeta,
        billingType.isAcceptableOrUnknown(
          data['billing_type']!,
          _billingTypeMeta,
        ),
      );
    }
    if (data.containsKey('hourly_rate')) {
      context.handle(
        _hourlyRateMeta,
        hourlyRate.isAcceptableOrUnknown(data['hourly_rate']!, _hourlyRateMeta),
      );
    }
    if (data.containsKey('fixed_rate')) {
      context.handle(
        _fixedRateMeta,
        fixedRate.isAcceptableOrUnknown(data['fixed_rate']!, _fixedRateMeta),
      );
    }
    if (data.containsKey('default_break_minutes')) {
      context.handle(
        _defaultBreakMinutesMeta,
        defaultBreakMinutes.isAcceptableOrUnknown(
          data['default_break_minutes']!,
          _defaultBreakMinutesMeta,
        ),
      );
    }
    if (data.containsKey('overtime_enabled')) {
      context.handle(
        _overtimeEnabledMeta,
        overtimeEnabled.isAcceptableOrUnknown(
          data['overtime_enabled']!,
          _overtimeEnabledMeta,
        ),
      );
    }
    if (data.containsKey('overtime_after_minutes')) {
      context.handle(
        _overtimeAfterMinutesMeta,
        overtimeAfterMinutes.isAcceptableOrUnknown(
          data['overtime_after_minutes']!,
          _overtimeAfterMinutesMeta,
        ),
      );
    }
    if (data.containsKey('overtime_multiplier')) {
      context.handle(
        _overtimeMultiplierMeta,
        overtimeMultiplier.isAcceptableOrUnknown(
          data['overtime_multiplier']!,
          _overtimeMultiplierMeta,
        ),
      );
    }
    if (data.containsKey('night_enabled')) {
      context.handle(
        _nightEnabledMeta,
        nightEnabled.isAcceptableOrUnknown(
          data['night_enabled']!,
          _nightEnabledMeta,
        ),
      );
    }
    if (data.containsKey('night_start_minute')) {
      context.handle(
        _nightStartMinuteMeta,
        nightStartMinute.isAcceptableOrUnknown(
          data['night_start_minute']!,
          _nightStartMinuteMeta,
        ),
      );
    }
    if (data.containsKey('night_end_minute')) {
      context.handle(
        _nightEndMinuteMeta,
        nightEndMinute.isAcceptableOrUnknown(
          data['night_end_minute']!,
          _nightEndMinuteMeta,
        ),
      );
    }
    if (data.containsKey('night_multiplier')) {
      context.handle(
        _nightMultiplierMeta,
        nightMultiplier.isAcceptableOrUnknown(
          data['night_multiplier']!,
          _nightMultiplierMeta,
        ),
      );
    }
    if (data.containsKey('holiday_enabled')) {
      context.handle(
        _holidayEnabledMeta,
        holidayEnabled.isAcceptableOrUnknown(
          data['holiday_enabled']!,
          _holidayEnabledMeta,
        ),
      );
    }
    if (data.containsKey('holiday_multiplier')) {
      context.handle(
        _holidayMultiplierMeta,
        holidayMultiplier.isAcceptableOrUnknown(
          data['holiday_multiplier']!,
          _holidayMultiplierMeta,
        ),
      );
    }
    if (data.containsKey('is_billable_default')) {
      context.handle(
        _isBillableDefaultMeta,
        isBillableDefault.isAcceptableOrUnknown(
          data['is_billable_default']!,
          _isBillableDefaultMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}client_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      billingType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}billing_type'],
      )!,
      hourlyRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hourly_rate'],
      )!,
      fixedRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fixed_rate'],
      )!,
      defaultBreakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}default_break_minutes'],
      )!,
      overtimeEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}overtime_enabled'],
      )!,
      overtimeAfterMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}overtime_after_minutes'],
      )!,
      overtimeMultiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}overtime_multiplier'],
      )!,
      nightEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}night_enabled'],
      )!,
      nightStartMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}night_start_minute'],
      )!,
      nightEndMinute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}night_end_minute'],
      )!,
      nightMultiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}night_multiplier'],
      )!,
      holidayEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}holiday_enabled'],
      )!,
      holidayMultiplier: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}holiday_multiplier'],
      )!,
      isBillableDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_billable_default'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final int id;
  final int? clientId;
  final String name;
  final String billingType;
  final double hourlyRate;
  final double fixedRate;
  final int defaultBreakMinutes;
  final bool overtimeEnabled;
  final int overtimeAfterMinutes;
  final double overtimeMultiplier;
  final bool nightEnabled;
  final int nightStartMinute;
  final int nightEndMinute;
  final double nightMultiplier;
  final bool holidayEnabled;
  final double holidayMultiplier;
  final bool isBillableDefault;
  final bool isActive;
  final DateTime createdAt;
  const Project({
    required this.id,
    this.clientId,
    required this.name,
    required this.billingType,
    required this.hourlyRate,
    required this.fixedRate,
    required this.defaultBreakMinutes,
    required this.overtimeEnabled,
    required this.overtimeAfterMinutes,
    required this.overtimeMultiplier,
    required this.nightEnabled,
    required this.nightStartMinute,
    required this.nightEndMinute,
    required this.nightMultiplier,
    required this.holidayEnabled,
    required this.holidayMultiplier,
    required this.isBillableDefault,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || clientId != null) {
      map['client_id'] = Variable<int>(clientId);
    }
    map['name'] = Variable<String>(name);
    map['billing_type'] = Variable<String>(billingType);
    map['hourly_rate'] = Variable<double>(hourlyRate);
    map['fixed_rate'] = Variable<double>(fixedRate);
    map['default_break_minutes'] = Variable<int>(defaultBreakMinutes);
    map['overtime_enabled'] = Variable<bool>(overtimeEnabled);
    map['overtime_after_minutes'] = Variable<int>(overtimeAfterMinutes);
    map['overtime_multiplier'] = Variable<double>(overtimeMultiplier);
    map['night_enabled'] = Variable<bool>(nightEnabled);
    map['night_start_minute'] = Variable<int>(nightStartMinute);
    map['night_end_minute'] = Variable<int>(nightEndMinute);
    map['night_multiplier'] = Variable<double>(nightMultiplier);
    map['holiday_enabled'] = Variable<bool>(holidayEnabled);
    map['holiday_multiplier'] = Variable<double>(holidayMultiplier);
    map['is_billable_default'] = Variable<bool>(isBillableDefault);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      clientId: clientId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientId),
      name: Value(name),
      billingType: Value(billingType),
      hourlyRate: Value(hourlyRate),
      fixedRate: Value(fixedRate),
      defaultBreakMinutes: Value(defaultBreakMinutes),
      overtimeEnabled: Value(overtimeEnabled),
      overtimeAfterMinutes: Value(overtimeAfterMinutes),
      overtimeMultiplier: Value(overtimeMultiplier),
      nightEnabled: Value(nightEnabled),
      nightStartMinute: Value(nightStartMinute),
      nightEndMinute: Value(nightEndMinute),
      nightMultiplier: Value(nightMultiplier),
      holidayEnabled: Value(holidayEnabled),
      holidayMultiplier: Value(holidayMultiplier),
      isBillableDefault: Value(isBillableDefault),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<int>(json['id']),
      clientId: serializer.fromJson<int?>(json['clientId']),
      name: serializer.fromJson<String>(json['name']),
      billingType: serializer.fromJson<String>(json['billingType']),
      hourlyRate: serializer.fromJson<double>(json['hourlyRate']),
      fixedRate: serializer.fromJson<double>(json['fixedRate']),
      defaultBreakMinutes: serializer.fromJson<int>(
        json['defaultBreakMinutes'],
      ),
      overtimeEnabled: serializer.fromJson<bool>(json['overtimeEnabled']),
      overtimeAfterMinutes: serializer.fromJson<int>(
        json['overtimeAfterMinutes'],
      ),
      overtimeMultiplier: serializer.fromJson<double>(
        json['overtimeMultiplier'],
      ),
      nightEnabled: serializer.fromJson<bool>(json['nightEnabled']),
      nightStartMinute: serializer.fromJson<int>(json['nightStartMinute']),
      nightEndMinute: serializer.fromJson<int>(json['nightEndMinute']),
      nightMultiplier: serializer.fromJson<double>(json['nightMultiplier']),
      holidayEnabled: serializer.fromJson<bool>(json['holidayEnabled']),
      holidayMultiplier: serializer.fromJson<double>(json['holidayMultiplier']),
      isBillableDefault: serializer.fromJson<bool>(json['isBillableDefault']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clientId': serializer.toJson<int?>(clientId),
      'name': serializer.toJson<String>(name),
      'billingType': serializer.toJson<String>(billingType),
      'hourlyRate': serializer.toJson<double>(hourlyRate),
      'fixedRate': serializer.toJson<double>(fixedRate),
      'defaultBreakMinutes': serializer.toJson<int>(defaultBreakMinutes),
      'overtimeEnabled': serializer.toJson<bool>(overtimeEnabled),
      'overtimeAfterMinutes': serializer.toJson<int>(overtimeAfterMinutes),
      'overtimeMultiplier': serializer.toJson<double>(overtimeMultiplier),
      'nightEnabled': serializer.toJson<bool>(nightEnabled),
      'nightStartMinute': serializer.toJson<int>(nightStartMinute),
      'nightEndMinute': serializer.toJson<int>(nightEndMinute),
      'nightMultiplier': serializer.toJson<double>(nightMultiplier),
      'holidayEnabled': serializer.toJson<bool>(holidayEnabled),
      'holidayMultiplier': serializer.toJson<double>(holidayMultiplier),
      'isBillableDefault': serializer.toJson<bool>(isBillableDefault),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Project copyWith({
    int? id,
    Value<int?> clientId = const Value.absent(),
    String? name,
    String? billingType,
    double? hourlyRate,
    double? fixedRate,
    int? defaultBreakMinutes,
    bool? overtimeEnabled,
    int? overtimeAfterMinutes,
    double? overtimeMultiplier,
    bool? nightEnabled,
    int? nightStartMinute,
    int? nightEndMinute,
    double? nightMultiplier,
    bool? holidayEnabled,
    double? holidayMultiplier,
    bool? isBillableDefault,
    bool? isActive,
    DateTime? createdAt,
  }) => Project(
    id: id ?? this.id,
    clientId: clientId.present ? clientId.value : this.clientId,
    name: name ?? this.name,
    billingType: billingType ?? this.billingType,
    hourlyRate: hourlyRate ?? this.hourlyRate,
    fixedRate: fixedRate ?? this.fixedRate,
    defaultBreakMinutes: defaultBreakMinutes ?? this.defaultBreakMinutes,
    overtimeEnabled: overtimeEnabled ?? this.overtimeEnabled,
    overtimeAfterMinutes: overtimeAfterMinutes ?? this.overtimeAfterMinutes,
    overtimeMultiplier: overtimeMultiplier ?? this.overtimeMultiplier,
    nightEnabled: nightEnabled ?? this.nightEnabled,
    nightStartMinute: nightStartMinute ?? this.nightStartMinute,
    nightEndMinute: nightEndMinute ?? this.nightEndMinute,
    nightMultiplier: nightMultiplier ?? this.nightMultiplier,
    holidayEnabled: holidayEnabled ?? this.holidayEnabled,
    holidayMultiplier: holidayMultiplier ?? this.holidayMultiplier,
    isBillableDefault: isBillableDefault ?? this.isBillableDefault,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      name: data.name.present ? data.name.value : this.name,
      billingType: data.billingType.present
          ? data.billingType.value
          : this.billingType,
      hourlyRate: data.hourlyRate.present
          ? data.hourlyRate.value
          : this.hourlyRate,
      fixedRate: data.fixedRate.present ? data.fixedRate.value : this.fixedRate,
      defaultBreakMinutes: data.defaultBreakMinutes.present
          ? data.defaultBreakMinutes.value
          : this.defaultBreakMinutes,
      overtimeEnabled: data.overtimeEnabled.present
          ? data.overtimeEnabled.value
          : this.overtimeEnabled,
      overtimeAfterMinutes: data.overtimeAfterMinutes.present
          ? data.overtimeAfterMinutes.value
          : this.overtimeAfterMinutes,
      overtimeMultiplier: data.overtimeMultiplier.present
          ? data.overtimeMultiplier.value
          : this.overtimeMultiplier,
      nightEnabled: data.nightEnabled.present
          ? data.nightEnabled.value
          : this.nightEnabled,
      nightStartMinute: data.nightStartMinute.present
          ? data.nightStartMinute.value
          : this.nightStartMinute,
      nightEndMinute: data.nightEndMinute.present
          ? data.nightEndMinute.value
          : this.nightEndMinute,
      nightMultiplier: data.nightMultiplier.present
          ? data.nightMultiplier.value
          : this.nightMultiplier,
      holidayEnabled: data.holidayEnabled.present
          ? data.holidayEnabled.value
          : this.holidayEnabled,
      holidayMultiplier: data.holidayMultiplier.present
          ? data.holidayMultiplier.value
          : this.holidayMultiplier,
      isBillableDefault: data.isBillableDefault.present
          ? data.isBillableDefault.value
          : this.isBillableDefault,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('name: $name, ')
          ..write('billingType: $billingType, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('fixedRate: $fixedRate, ')
          ..write('defaultBreakMinutes: $defaultBreakMinutes, ')
          ..write('overtimeEnabled: $overtimeEnabled, ')
          ..write('overtimeAfterMinutes: $overtimeAfterMinutes, ')
          ..write('overtimeMultiplier: $overtimeMultiplier, ')
          ..write('nightEnabled: $nightEnabled, ')
          ..write('nightStartMinute: $nightStartMinute, ')
          ..write('nightEndMinute: $nightEndMinute, ')
          ..write('nightMultiplier: $nightMultiplier, ')
          ..write('holidayEnabled: $holidayEnabled, ')
          ..write('holidayMultiplier: $holidayMultiplier, ')
          ..write('isBillableDefault: $isBillableDefault, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    clientId,
    name,
    billingType,
    hourlyRate,
    fixedRate,
    defaultBreakMinutes,
    overtimeEnabled,
    overtimeAfterMinutes,
    overtimeMultiplier,
    nightEnabled,
    nightStartMinute,
    nightEndMinute,
    nightMultiplier,
    holidayEnabled,
    holidayMultiplier,
    isBillableDefault,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.name == this.name &&
          other.billingType == this.billingType &&
          other.hourlyRate == this.hourlyRate &&
          other.fixedRate == this.fixedRate &&
          other.defaultBreakMinutes == this.defaultBreakMinutes &&
          other.overtimeEnabled == this.overtimeEnabled &&
          other.overtimeAfterMinutes == this.overtimeAfterMinutes &&
          other.overtimeMultiplier == this.overtimeMultiplier &&
          other.nightEnabled == this.nightEnabled &&
          other.nightStartMinute == this.nightStartMinute &&
          other.nightEndMinute == this.nightEndMinute &&
          other.nightMultiplier == this.nightMultiplier &&
          other.holidayEnabled == this.holidayEnabled &&
          other.holidayMultiplier == this.holidayMultiplier &&
          other.isBillableDefault == this.isBillableDefault &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<int> id;
  final Value<int?> clientId;
  final Value<String> name;
  final Value<String> billingType;
  final Value<double> hourlyRate;
  final Value<double> fixedRate;
  final Value<int> defaultBreakMinutes;
  final Value<bool> overtimeEnabled;
  final Value<int> overtimeAfterMinutes;
  final Value<double> overtimeMultiplier;
  final Value<bool> nightEnabled;
  final Value<int> nightStartMinute;
  final Value<int> nightEndMinute;
  final Value<double> nightMultiplier;
  final Value<bool> holidayEnabled;
  final Value<double> holidayMultiplier;
  final Value<bool> isBillableDefault;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.name = const Value.absent(),
    this.billingType = const Value.absent(),
    this.hourlyRate = const Value.absent(),
    this.fixedRate = const Value.absent(),
    this.defaultBreakMinutes = const Value.absent(),
    this.overtimeEnabled = const Value.absent(),
    this.overtimeAfterMinutes = const Value.absent(),
    this.overtimeMultiplier = const Value.absent(),
    this.nightEnabled = const Value.absent(),
    this.nightStartMinute = const Value.absent(),
    this.nightEndMinute = const Value.absent(),
    this.nightMultiplier = const Value.absent(),
    this.holidayEnabled = const Value.absent(),
    this.holidayMultiplier = const Value.absent(),
    this.isBillableDefault = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProjectsCompanion.insert({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    required String name,
    this.billingType = const Value.absent(),
    this.hourlyRate = const Value.absent(),
    this.fixedRate = const Value.absent(),
    this.defaultBreakMinutes = const Value.absent(),
    this.overtimeEnabled = const Value.absent(),
    this.overtimeAfterMinutes = const Value.absent(),
    this.overtimeMultiplier = const Value.absent(),
    this.nightEnabled = const Value.absent(),
    this.nightStartMinute = const Value.absent(),
    this.nightEndMinute = const Value.absent(),
    this.nightMultiplier = const Value.absent(),
    this.holidayEnabled = const Value.absent(),
    this.holidayMultiplier = const Value.absent(),
    this.isBillableDefault = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Project> custom({
    Expression<int>? id,
    Expression<int>? clientId,
    Expression<String>? name,
    Expression<String>? billingType,
    Expression<double>? hourlyRate,
    Expression<double>? fixedRate,
    Expression<int>? defaultBreakMinutes,
    Expression<bool>? overtimeEnabled,
    Expression<int>? overtimeAfterMinutes,
    Expression<double>? overtimeMultiplier,
    Expression<bool>? nightEnabled,
    Expression<int>? nightStartMinute,
    Expression<int>? nightEndMinute,
    Expression<double>? nightMultiplier,
    Expression<bool>? holidayEnabled,
    Expression<double>? holidayMultiplier,
    Expression<bool>? isBillableDefault,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (name != null) 'name': name,
      if (billingType != null) 'billing_type': billingType,
      if (hourlyRate != null) 'hourly_rate': hourlyRate,
      if (fixedRate != null) 'fixed_rate': fixedRate,
      if (defaultBreakMinutes != null)
        'default_break_minutes': defaultBreakMinutes,
      if (overtimeEnabled != null) 'overtime_enabled': overtimeEnabled,
      if (overtimeAfterMinutes != null)
        'overtime_after_minutes': overtimeAfterMinutes,
      if (overtimeMultiplier != null) 'overtime_multiplier': overtimeMultiplier,
      if (nightEnabled != null) 'night_enabled': nightEnabled,
      if (nightStartMinute != null) 'night_start_minute': nightStartMinute,
      if (nightEndMinute != null) 'night_end_minute': nightEndMinute,
      if (nightMultiplier != null) 'night_multiplier': nightMultiplier,
      if (holidayEnabled != null) 'holiday_enabled': holidayEnabled,
      if (holidayMultiplier != null) 'holiday_multiplier': holidayMultiplier,
      if (isBillableDefault != null) 'is_billable_default': isBillableDefault,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProjectsCompanion copyWith({
    Value<int>? id,
    Value<int?>? clientId,
    Value<String>? name,
    Value<String>? billingType,
    Value<double>? hourlyRate,
    Value<double>? fixedRate,
    Value<int>? defaultBreakMinutes,
    Value<bool>? overtimeEnabled,
    Value<int>? overtimeAfterMinutes,
    Value<double>? overtimeMultiplier,
    Value<bool>? nightEnabled,
    Value<int>? nightStartMinute,
    Value<int>? nightEndMinute,
    Value<double>? nightMultiplier,
    Value<bool>? holidayEnabled,
    Value<double>? holidayMultiplier,
    Value<bool>? isBillableDefault,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      name: name ?? this.name,
      billingType: billingType ?? this.billingType,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      fixedRate: fixedRate ?? this.fixedRate,
      defaultBreakMinutes: defaultBreakMinutes ?? this.defaultBreakMinutes,
      overtimeEnabled: overtimeEnabled ?? this.overtimeEnabled,
      overtimeAfterMinutes: overtimeAfterMinutes ?? this.overtimeAfterMinutes,
      overtimeMultiplier: overtimeMultiplier ?? this.overtimeMultiplier,
      nightEnabled: nightEnabled ?? this.nightEnabled,
      nightStartMinute: nightStartMinute ?? this.nightStartMinute,
      nightEndMinute: nightEndMinute ?? this.nightEndMinute,
      nightMultiplier: nightMultiplier ?? this.nightMultiplier,
      holidayEnabled: holidayEnabled ?? this.holidayEnabled,
      holidayMultiplier: holidayMultiplier ?? this.holidayMultiplier,
      isBillableDefault: isBillableDefault ?? this.isBillableDefault,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<int>(clientId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (billingType.present) {
      map['billing_type'] = Variable<String>(billingType.value);
    }
    if (hourlyRate.present) {
      map['hourly_rate'] = Variable<double>(hourlyRate.value);
    }
    if (fixedRate.present) {
      map['fixed_rate'] = Variable<double>(fixedRate.value);
    }
    if (defaultBreakMinutes.present) {
      map['default_break_minutes'] = Variable<int>(defaultBreakMinutes.value);
    }
    if (overtimeEnabled.present) {
      map['overtime_enabled'] = Variable<bool>(overtimeEnabled.value);
    }
    if (overtimeAfterMinutes.present) {
      map['overtime_after_minutes'] = Variable<int>(overtimeAfterMinutes.value);
    }
    if (overtimeMultiplier.present) {
      map['overtime_multiplier'] = Variable<double>(overtimeMultiplier.value);
    }
    if (nightEnabled.present) {
      map['night_enabled'] = Variable<bool>(nightEnabled.value);
    }
    if (nightStartMinute.present) {
      map['night_start_minute'] = Variable<int>(nightStartMinute.value);
    }
    if (nightEndMinute.present) {
      map['night_end_minute'] = Variable<int>(nightEndMinute.value);
    }
    if (nightMultiplier.present) {
      map['night_multiplier'] = Variable<double>(nightMultiplier.value);
    }
    if (holidayEnabled.present) {
      map['holiday_enabled'] = Variable<bool>(holidayEnabled.value);
    }
    if (holidayMultiplier.present) {
      map['holiday_multiplier'] = Variable<double>(holidayMultiplier.value);
    }
    if (isBillableDefault.present) {
      map['is_billable_default'] = Variable<bool>(isBillableDefault.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('name: $name, ')
          ..write('billingType: $billingType, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('fixedRate: $fixedRate, ')
          ..write('defaultBreakMinutes: $defaultBreakMinutes, ')
          ..write('overtimeEnabled: $overtimeEnabled, ')
          ..write('overtimeAfterMinutes: $overtimeAfterMinutes, ')
          ..write('overtimeMultiplier: $overtimeMultiplier, ')
          ..write('nightEnabled: $nightEnabled, ')
          ..write('nightStartMinute: $nightStartMinute, ')
          ..write('nightEndMinute: $nightEndMinute, ')
          ..write('nightMultiplier: $nightMultiplier, ')
          ..write('holidayEnabled: $holidayEnabled, ')
          ..write('holidayMultiplier: $holidayMultiplier, ')
          ..write('isBillableDefault: $isBillableDefault, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TimeEntriesTable extends TimeEntries
    with TableInfo<$TimeEntriesTable, TimeEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimeEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<int> clientId = GeneratedColumn<int>(
    'client_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clients (id)',
    ),
  );
  static const VerificationMeta _startAtMeta = const VerificationMeta(
    'startAt',
  );
  @override
  late final GeneratedColumn<DateTime> startAt = GeneratedColumn<DateTime>(
    'start_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endAtMeta = const VerificationMeta('endAt');
  @override
  late final GeneratedColumn<DateTime> endAt = GeneratedColumn<DateTime>(
    'end_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _breakMinutesMeta = const VerificationMeta(
    'breakMinutes',
  );
  @override
  late final GeneratedColumn<int> breakMinutes = GeneratedColumn<int>(
    'break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _workedMinutesMeta = const VerificationMeta(
    'workedMinutes',
  );
  @override
  late final GeneratedColumn<int> workedMinutes = GeneratedColumn<int>(
    'worked_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appliedRateMeta = const VerificationMeta(
    'appliedRate',
  );
  @override
  late final GeneratedColumn<double> appliedRate = GeneratedColumn<double>(
    'applied_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('open'),
  );
  static const VerificationMeta _isBillableMeta = const VerificationMeta(
    'isBillable',
  );
  @override
  late final GeneratedColumn<bool> isBillable = GeneratedColumn<bool>(
    'is_billable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_billable" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isPaidMeta = const VerificationMeta('isPaid');
  @override
  late final GeneratedColumn<bool> isPaid = GeneratedColumn<bool>(
    'is_paid',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_paid" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _taskDescriptionMeta = const VerificationMeta(
    'taskDescription',
  );
  @override
  late final GeneratedColumn<String> taskDescription = GeneratedColumn<String>(
    'task_description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    clientId,
    startAt,
    endAt,
    breakMinutes,
    workedMinutes,
    appliedRate,
    amount,
    status,
    isBillable,
    isPaid,
    taskDescription,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'time_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimeEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    }
    if (data.containsKey('start_at')) {
      context.handle(
        _startAtMeta,
        startAt.isAcceptableOrUnknown(data['start_at']!, _startAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startAtMeta);
    }
    if (data.containsKey('end_at')) {
      context.handle(
        _endAtMeta,
        endAt.isAcceptableOrUnknown(data['end_at']!, _endAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endAtMeta);
    }
    if (data.containsKey('break_minutes')) {
      context.handle(
        _breakMinutesMeta,
        breakMinutes.isAcceptableOrUnknown(
          data['break_minutes']!,
          _breakMinutesMeta,
        ),
      );
    }
    if (data.containsKey('worked_minutes')) {
      context.handle(
        _workedMinutesMeta,
        workedMinutes.isAcceptableOrUnknown(
          data['worked_minutes']!,
          _workedMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workedMinutesMeta);
    }
    if (data.containsKey('applied_rate')) {
      context.handle(
        _appliedRateMeta,
        appliedRate.isAcceptableOrUnknown(
          data['applied_rate']!,
          _appliedRateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_appliedRateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_billable')) {
      context.handle(
        _isBillableMeta,
        isBillable.isAcceptableOrUnknown(data['is_billable']!, _isBillableMeta),
      );
    }
    if (data.containsKey('is_paid')) {
      context.handle(
        _isPaidMeta,
        isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta),
      );
    }
    if (data.containsKey('task_description')) {
      context.handle(
        _taskDescriptionMeta,
        taskDescription.isAcceptableOrUnknown(
          data['task_description']!,
          _taskDescriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimeEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimeEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}client_id'],
      ),
      startAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_at'],
      )!,
      endAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_at'],
      )!,
      breakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}break_minutes'],
      )!,
      workedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}worked_minutes'],
      )!,
      appliedRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}applied_rate'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isBillable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_billable'],
      )!,
      isPaid: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_paid'],
      )!,
      taskDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TimeEntriesTable createAlias(String alias) {
    return $TimeEntriesTable(attachedDatabase, alias);
  }
}

class TimeEntry extends DataClass implements Insertable<TimeEntry> {
  final int id;
  final int projectId;
  final int? clientId;
  final DateTime startAt;
  final DateTime endAt;
  final int breakMinutes;
  final int workedMinutes;
  final double appliedRate;
  final double amount;
  final String status;
  final bool isBillable;
  final bool isPaid;
  final String? taskDescription;
  final DateTime createdAt;
  const TimeEntry({
    required this.id,
    required this.projectId,
    this.clientId,
    required this.startAt,
    required this.endAt,
    required this.breakMinutes,
    required this.workedMinutes,
    required this.appliedRate,
    required this.amount,
    required this.status,
    required this.isBillable,
    required this.isPaid,
    this.taskDescription,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<int>(projectId);
    if (!nullToAbsent || clientId != null) {
      map['client_id'] = Variable<int>(clientId);
    }
    map['start_at'] = Variable<DateTime>(startAt);
    map['end_at'] = Variable<DateTime>(endAt);
    map['break_minutes'] = Variable<int>(breakMinutes);
    map['worked_minutes'] = Variable<int>(workedMinutes);
    map['applied_rate'] = Variable<double>(appliedRate);
    map['amount'] = Variable<double>(amount);
    map['status'] = Variable<String>(status);
    map['is_billable'] = Variable<bool>(isBillable);
    map['is_paid'] = Variable<bool>(isPaid);
    if (!nullToAbsent || taskDescription != null) {
      map['task_description'] = Variable<String>(taskDescription);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TimeEntriesCompanion toCompanion(bool nullToAbsent) {
    return TimeEntriesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      clientId: clientId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientId),
      startAt: Value(startAt),
      endAt: Value(endAt),
      breakMinutes: Value(breakMinutes),
      workedMinutes: Value(workedMinutes),
      appliedRate: Value(appliedRate),
      amount: Value(amount),
      status: Value(status),
      isBillable: Value(isBillable),
      isPaid: Value(isPaid),
      taskDescription: taskDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(taskDescription),
      createdAt: Value(createdAt),
    );
  }

  factory TimeEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimeEntry(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      clientId: serializer.fromJson<int?>(json['clientId']),
      startAt: serializer.fromJson<DateTime>(json['startAt']),
      endAt: serializer.fromJson<DateTime>(json['endAt']),
      breakMinutes: serializer.fromJson<int>(json['breakMinutes']),
      workedMinutes: serializer.fromJson<int>(json['workedMinutes']),
      appliedRate: serializer.fromJson<double>(json['appliedRate']),
      amount: serializer.fromJson<double>(json['amount']),
      status: serializer.fromJson<String>(json['status']),
      isBillable: serializer.fromJson<bool>(json['isBillable']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
      taskDescription: serializer.fromJson<String?>(json['taskDescription']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'clientId': serializer.toJson<int?>(clientId),
      'startAt': serializer.toJson<DateTime>(startAt),
      'endAt': serializer.toJson<DateTime>(endAt),
      'breakMinutes': serializer.toJson<int>(breakMinutes),
      'workedMinutes': serializer.toJson<int>(workedMinutes),
      'appliedRate': serializer.toJson<double>(appliedRate),
      'amount': serializer.toJson<double>(amount),
      'status': serializer.toJson<String>(status),
      'isBillable': serializer.toJson<bool>(isBillable),
      'isPaid': serializer.toJson<bool>(isPaid),
      'taskDescription': serializer.toJson<String?>(taskDescription),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TimeEntry copyWith({
    int? id,
    int? projectId,
    Value<int?> clientId = const Value.absent(),
    DateTime? startAt,
    DateTime? endAt,
    int? breakMinutes,
    int? workedMinutes,
    double? appliedRate,
    double? amount,
    String? status,
    bool? isBillable,
    bool? isPaid,
    Value<String?> taskDescription = const Value.absent(),
    DateTime? createdAt,
  }) => TimeEntry(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    clientId: clientId.present ? clientId.value : this.clientId,
    startAt: startAt ?? this.startAt,
    endAt: endAt ?? this.endAt,
    breakMinutes: breakMinutes ?? this.breakMinutes,
    workedMinutes: workedMinutes ?? this.workedMinutes,
    appliedRate: appliedRate ?? this.appliedRate,
    amount: amount ?? this.amount,
    status: status ?? this.status,
    isBillable: isBillable ?? this.isBillable,
    isPaid: isPaid ?? this.isPaid,
    taskDescription: taskDescription.present
        ? taskDescription.value
        : this.taskDescription,
    createdAt: createdAt ?? this.createdAt,
  );
  TimeEntry copyWithCompanion(TimeEntriesCompanion data) {
    return TimeEntry(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      startAt: data.startAt.present ? data.startAt.value : this.startAt,
      endAt: data.endAt.present ? data.endAt.value : this.endAt,
      breakMinutes: data.breakMinutes.present
          ? data.breakMinutes.value
          : this.breakMinutes,
      workedMinutes: data.workedMinutes.present
          ? data.workedMinutes.value
          : this.workedMinutes,
      appliedRate: data.appliedRate.present
          ? data.appliedRate.value
          : this.appliedRate,
      amount: data.amount.present ? data.amount.value : this.amount,
      status: data.status.present ? data.status.value : this.status,
      isBillable: data.isBillable.present
          ? data.isBillable.value
          : this.isBillable,
      isPaid: data.isPaid.present ? data.isPaid.value : this.isPaid,
      taskDescription: data.taskDescription.present
          ? data.taskDescription.value
          : this.taskDescription,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimeEntry(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('clientId: $clientId, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('breakMinutes: $breakMinutes, ')
          ..write('workedMinutes: $workedMinutes, ')
          ..write('appliedRate: $appliedRate, ')
          ..write('amount: $amount, ')
          ..write('status: $status, ')
          ..write('isBillable: $isBillable, ')
          ..write('isPaid: $isPaid, ')
          ..write('taskDescription: $taskDescription, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    clientId,
    startAt,
    endAt,
    breakMinutes,
    workedMinutes,
    appliedRate,
    amount,
    status,
    isBillable,
    isPaid,
    taskDescription,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimeEntry &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.clientId == this.clientId &&
          other.startAt == this.startAt &&
          other.endAt == this.endAt &&
          other.breakMinutes == this.breakMinutes &&
          other.workedMinutes == this.workedMinutes &&
          other.appliedRate == this.appliedRate &&
          other.amount == this.amount &&
          other.status == this.status &&
          other.isBillable == this.isBillable &&
          other.isPaid == this.isPaid &&
          other.taskDescription == this.taskDescription &&
          other.createdAt == this.createdAt);
}

class TimeEntriesCompanion extends UpdateCompanion<TimeEntry> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<int?> clientId;
  final Value<DateTime> startAt;
  final Value<DateTime> endAt;
  final Value<int> breakMinutes;
  final Value<int> workedMinutes;
  final Value<double> appliedRate;
  final Value<double> amount;
  final Value<String> status;
  final Value<bool> isBillable;
  final Value<bool> isPaid;
  final Value<String?> taskDescription;
  final Value<DateTime> createdAt;
  const TimeEntriesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.startAt = const Value.absent(),
    this.endAt = const Value.absent(),
    this.breakMinutes = const Value.absent(),
    this.workedMinutes = const Value.absent(),
    this.appliedRate = const Value.absent(),
    this.amount = const Value.absent(),
    this.status = const Value.absent(),
    this.isBillable = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.taskDescription = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TimeEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int projectId,
    this.clientId = const Value.absent(),
    required DateTime startAt,
    required DateTime endAt,
    this.breakMinutes = const Value.absent(),
    required int workedMinutes,
    required double appliedRate,
    required double amount,
    this.status = const Value.absent(),
    this.isBillable = const Value.absent(),
    this.isPaid = const Value.absent(),
    this.taskDescription = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : projectId = Value(projectId),
       startAt = Value(startAt),
       endAt = Value(endAt),
       workedMinutes = Value(workedMinutes),
       appliedRate = Value(appliedRate),
       amount = Value(amount);
  static Insertable<TimeEntry> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<int>? clientId,
    Expression<DateTime>? startAt,
    Expression<DateTime>? endAt,
    Expression<int>? breakMinutes,
    Expression<int>? workedMinutes,
    Expression<double>? appliedRate,
    Expression<double>? amount,
    Expression<String>? status,
    Expression<bool>? isBillable,
    Expression<bool>? isPaid,
    Expression<String>? taskDescription,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (clientId != null) 'client_id': clientId,
      if (startAt != null) 'start_at': startAt,
      if (endAt != null) 'end_at': endAt,
      if (breakMinutes != null) 'break_minutes': breakMinutes,
      if (workedMinutes != null) 'worked_minutes': workedMinutes,
      if (appliedRate != null) 'applied_rate': appliedRate,
      if (amount != null) 'amount': amount,
      if (status != null) 'status': status,
      if (isBillable != null) 'is_billable': isBillable,
      if (isPaid != null) 'is_paid': isPaid,
      if (taskDescription != null) 'task_description': taskDescription,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TimeEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? projectId,
    Value<int?>? clientId,
    Value<DateTime>? startAt,
    Value<DateTime>? endAt,
    Value<int>? breakMinutes,
    Value<int>? workedMinutes,
    Value<double>? appliedRate,
    Value<double>? amount,
    Value<String>? status,
    Value<bool>? isBillable,
    Value<bool>? isPaid,
    Value<String?>? taskDescription,
    Value<DateTime>? createdAt,
  }) {
    return TimeEntriesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      clientId: clientId ?? this.clientId,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      workedMinutes: workedMinutes ?? this.workedMinutes,
      appliedRate: appliedRate ?? this.appliedRate,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      isBillable: isBillable ?? this.isBillable,
      isPaid: isPaid ?? this.isPaid,
      taskDescription: taskDescription ?? this.taskDescription,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<int>(clientId.value);
    }
    if (startAt.present) {
      map['start_at'] = Variable<DateTime>(startAt.value);
    }
    if (endAt.present) {
      map['end_at'] = Variable<DateTime>(endAt.value);
    }
    if (breakMinutes.present) {
      map['break_minutes'] = Variable<int>(breakMinutes.value);
    }
    if (workedMinutes.present) {
      map['worked_minutes'] = Variable<int>(workedMinutes.value);
    }
    if (appliedRate.present) {
      map['applied_rate'] = Variable<double>(appliedRate.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isBillable.present) {
      map['is_billable'] = Variable<bool>(isBillable.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    if (taskDescription.present) {
      map['task_description'] = Variable<String>(taskDescription.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimeEntriesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('clientId: $clientId, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('breakMinutes: $breakMinutes, ')
          ..write('workedMinutes: $workedMinutes, ')
          ..write('appliedRate: $appliedRate, ')
          ..write('amount: $amount, ')
          ..write('status: $status, ')
          ..write('isBillable: $isBillable, ')
          ..write('isPaid: $isPaid, ')
          ..write('taskDescription: $taskDescription, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    occurredAt,
    amount,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final DateTime occurredAt;
  final double amount;
  final String? note;
  final DateTime createdAt;
  const Expense({
    required this.id,
    required this.occurredAt,
    required this.amount,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      occurredAt: Value(occurredAt),
      amount: Value(amount),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      amount: serializer.fromJson<double>(json['amount']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'amount': serializer.toJson<double>(amount),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Expense copyWith({
    int? id,
    DateTime? occurredAt,
    double? amount,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => Expense(
    id: id ?? this.id,
    occurredAt: occurredAt ?? this.occurredAt,
    amount: amount ?? this.amount,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      amount: data.amount.present ? data.amount.value : this.amount,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, occurredAt, amount, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.occurredAt == this.occurredAt &&
          other.amount == this.amount &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<DateTime> occurredAt;
  final Value<double> amount;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.amount = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime occurredAt,
    required double amount,
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : occurredAt = Value(occurredAt),
       amount = Value(amount);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<DateTime>? occurredAt,
    Expression<double>? amount,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (amount != null) 'amount': amount,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? occurredAt,
    Value<double>? amount,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      occurredAt: occurredAt ?? this.occurredAt,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MileagesTable extends Mileages with TableInfo<$MileagesTable, Mileage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MileagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _distanceMeta = const VerificationMeta(
    'distance',
  );
  @override
  late final GeneratedColumn<double> distance = GeneratedColumn<double>(
    'distance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    occurredAt,
    distance,
    amount,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mileages';
  @override
  VerificationContext validateIntegrity(
    Insertable<Mileage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('distance')) {
      context.handle(
        _distanceMeta,
        distance.isAcceptableOrUnknown(data['distance']!, _distanceMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Mileage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Mileage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      distance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MileagesTable createAlias(String alias) {
    return $MileagesTable(attachedDatabase, alias);
  }
}

class Mileage extends DataClass implements Insertable<Mileage> {
  final int id;
  final DateTime occurredAt;
  final double distance;
  final double amount;
  final String? note;
  final DateTime createdAt;
  const Mileage({
    required this.id,
    required this.occurredAt,
    required this.distance,
    required this.amount,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    map['distance'] = Variable<double>(distance);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MileagesCompanion toCompanion(bool nullToAbsent) {
    return MileagesCompanion(
      id: Value(id),
      occurredAt: Value(occurredAt),
      distance: Value(distance),
      amount: Value(amount),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory Mileage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Mileage(
      id: serializer.fromJson<int>(json['id']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
      distance: serializer.fromJson<double>(json['distance']),
      amount: serializer.fromJson<double>(json['amount']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
      'distance': serializer.toJson<double>(distance),
      'amount': serializer.toJson<double>(amount),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Mileage copyWith({
    int? id,
    DateTime? occurredAt,
    double? distance,
    double? amount,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => Mileage(
    id: id ?? this.id,
    occurredAt: occurredAt ?? this.occurredAt,
    distance: distance ?? this.distance,
    amount: amount ?? this.amount,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  Mileage copyWithCompanion(MileagesCompanion data) {
    return Mileage(
      id: data.id.present ? data.id.value : this.id,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      distance: data.distance.present ? data.distance.value : this.distance,
      amount: data.amount.present ? data.amount.value : this.amount,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Mileage(')
          ..write('id: $id, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('distance: $distance, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, occurredAt, distance, amount, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Mileage &&
          other.id == this.id &&
          other.occurredAt == this.occurredAt &&
          other.distance == this.distance &&
          other.amount == this.amount &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class MileagesCompanion extends UpdateCompanion<Mileage> {
  final Value<int> id;
  final Value<DateTime> occurredAt;
  final Value<double> distance;
  final Value<double> amount;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  const MileagesCompanion({
    this.id = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.distance = const Value.absent(),
    this.amount = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MileagesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime occurredAt,
    this.distance = const Value.absent(),
    this.amount = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : occurredAt = Value(occurredAt);
  static Insertable<Mileage> custom({
    Expression<int>? id,
    Expression<DateTime>? occurredAt,
    Expression<double>? distance,
    Expression<double>? amount,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (distance != null) 'distance': distance,
      if (amount != null) 'amount': amount,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MileagesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? occurredAt,
    Value<double>? distance,
    Value<double>? amount,
    Value<String?>? note,
    Value<DateTime>? createdAt,
  }) {
    return MileagesCompanion(
      id: id ?? this.id,
      occurredAt: occurredAt ?? this.occurredAt,
      distance: distance ?? this.distance,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (distance.present) {
      map['distance'] = Variable<double>(distance.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MileagesCompanion(')
          ..write('id: $id, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('distance: $distance, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String? value;
  final DateTime updatedAt;
  const AppSetting({required this.key, this.value, required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSetting copyWith({
    String? key,
    Value<String?> value = const Value.absent(),
    DateTime? updatedAt,
  }) => AppSetting(
    key: key ?? this.key,
    value: value.present ? value.value : this.value,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String?> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String?>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientsTable clients = $ClientsTable(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $TimeEntriesTable timeEntries = $TimeEntriesTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $MileagesTable mileages = $MileagesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    clients,
    projects,
    timeEntries,
    expenses,
    mileages,
    appSettings,
  ];
}

typedef $$ClientsTableCreateCompanionBuilder =
    ClientsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> address,
      Value<String?> geolocation,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> description,
      Value<bool> isDefaultClient,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });
typedef $$ClientsTableUpdateCompanionBuilder =
    ClientsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> address,
      Value<String?> geolocation,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> description,
      Value<bool> isDefaultClient,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });

final class $$ClientsTableReferences
    extends BaseReferences<_$AppDatabase, $ClientsTable, Client> {
  $$ClientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProjectsTable, List<Project>> _projectsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.projects,
    aliasName: $_aliasNameGenerator(db.clients.id, db.projects.clientId),
  );

  $$ProjectsTableProcessedTableManager get projectsRefs {
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.clientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_projectsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TimeEntriesTable, List<TimeEntry>>
  _timeEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timeEntries,
    aliasName: $_aliasNameGenerator(db.clients.id, db.timeEntries.clientId),
  );

  $$TimeEntriesTableProcessedTableManager get timeEntriesRefs {
    final manager = $$TimeEntriesTableTableManager(
      $_db,
      $_db.timeEntries,
    ).filter((f) => f.clientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_timeEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClientsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get geolocation => $composableBuilder(
    column: $table.geolocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefaultClient => $composableBuilder(
    column: $table.isDefaultClient,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> projectsRefs(
    Expression<bool> Function($$ProjectsTableFilterComposer f) f,
  ) {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> timeEntriesRefs(
    Expression<bool> Function($$TimeEntriesTableFilterComposer f) f,
  ) {
    final $$TimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get geolocation => $composableBuilder(
    column: $table.geolocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefaultClient => $composableBuilder(
    column: $table.isDefaultClient,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get geolocation => $composableBuilder(
    column: $table.geolocation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDefaultClient => $composableBuilder(
    column: $table.isDefaultClient,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> projectsRefs<T extends Object>(
    Expression<T> Function($$ProjectsTableAnnotationComposer a) f,
  ) {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> timeEntriesRefs<T extends Object>(
    Expression<T> Function($$TimeEntriesTableAnnotationComposer a) f,
  ) {
    final $$TimeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientsTable,
          Client,
          $$ClientsTableFilterComposer,
          $$ClientsTableOrderingComposer,
          $$ClientsTableAnnotationComposer,
          $$ClientsTableCreateCompanionBuilder,
          $$ClientsTableUpdateCompanionBuilder,
          (Client, $$ClientsTableReferences),
          Client,
          PrefetchHooks Function({bool projectsRefs, bool timeEntriesRefs})
        > {
  $$ClientsTableTableManager(_$AppDatabase db, $ClientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> geolocation = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isDefaultClient = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ClientsCompanion(
                id: id,
                name: name,
                address: address,
                geolocation: geolocation,
                phone: phone,
                email: email,
                description: description,
                isDefaultClient: isDefaultClient,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> address = const Value.absent(),
                Value<String?> geolocation = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> isDefaultClient = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ClientsCompanion.insert(
                id: id,
                name: name,
                address: address,
                geolocation: geolocation,
                phone: phone,
                email: email,
                description: description,
                isDefaultClient: isDefaultClient,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({projectsRefs = false, timeEntriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (projectsRefs) db.projects,
                    if (timeEntriesRefs) db.timeEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (projectsRefs)
                        await $_getPrefetchedData<
                          Client,
                          $ClientsTable,
                          Project
                        >(
                          currentTable: table,
                          referencedTable: $$ClientsTableReferences
                              ._projectsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientsTableReferences(
                                db,
                                table,
                                p0,
                              ).projectsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (timeEntriesRefs)
                        await $_getPrefetchedData<
                          Client,
                          $ClientsTable,
                          TimeEntry
                        >(
                          currentTable: table,
                          referencedTable: $$ClientsTableReferences
                              ._timeEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientsTableReferences(
                                db,
                                table,
                                p0,
                              ).timeEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clientId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ClientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientsTable,
      Client,
      $$ClientsTableFilterComposer,
      $$ClientsTableOrderingComposer,
      $$ClientsTableAnnotationComposer,
      $$ClientsTableCreateCompanionBuilder,
      $$ClientsTableUpdateCompanionBuilder,
      (Client, $$ClientsTableReferences),
      Client,
      PrefetchHooks Function({bool projectsRefs, bool timeEntriesRefs})
    >;
typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      Value<int> id,
      Value<int?> clientId,
      required String name,
      Value<String> billingType,
      Value<double> hourlyRate,
      Value<double> fixedRate,
      Value<int> defaultBreakMinutes,
      Value<bool> overtimeEnabled,
      Value<int> overtimeAfterMinutes,
      Value<double> overtimeMultiplier,
      Value<bool> nightEnabled,
      Value<int> nightStartMinute,
      Value<int> nightEndMinute,
      Value<double> nightMultiplier,
      Value<bool> holidayEnabled,
      Value<double> holidayMultiplier,
      Value<bool> isBillableDefault,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<int> id,
      Value<int?> clientId,
      Value<String> name,
      Value<String> billingType,
      Value<double> hourlyRate,
      Value<double> fixedRate,
      Value<int> defaultBreakMinutes,
      Value<bool> overtimeEnabled,
      Value<int> overtimeAfterMinutes,
      Value<double> overtimeMultiplier,
      Value<bool> nightEnabled,
      Value<int> nightStartMinute,
      Value<int> nightEndMinute,
      Value<double> nightMultiplier,
      Value<bool> holidayEnabled,
      Value<double> holidayMultiplier,
      Value<bool> isBillableDefault,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, Project> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientsTable _clientIdTable(_$AppDatabase db) => db.clients
      .createAlias($_aliasNameGenerator(db.projects.clientId, db.clients.id));

  $$ClientsTableProcessedTableManager? get clientId {
    final $_column = $_itemColumn<int>('client_id');
    if ($_column == null) return null;
    final manager = $$ClientsTableTableManager(
      $_db,
      $_db.clients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TimeEntriesTable, List<TimeEntry>>
  _timeEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timeEntries,
    aliasName: $_aliasNameGenerator(db.projects.id, db.timeEntries.projectId),
  );

  $$TimeEntriesTableProcessedTableManager get timeEntriesRefs {
    final manager = $$TimeEntriesTableTableManager(
      $_db,
      $_db.timeEntries,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_timeEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get billingType => $composableBuilder(
    column: $table.billingType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fixedRate => $composableBuilder(
    column: $table.fixedRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get defaultBreakMinutes => $composableBuilder(
    column: $table.defaultBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get overtimeEnabled => $composableBuilder(
    column: $table.overtimeEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get overtimeAfterMinutes => $composableBuilder(
    column: $table.overtimeAfterMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get overtimeMultiplier => $composableBuilder(
    column: $table.overtimeMultiplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get nightEnabled => $composableBuilder(
    column: $table.nightEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nightStartMinute => $composableBuilder(
    column: $table.nightStartMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nightEndMinute => $composableBuilder(
    column: $table.nightEndMinute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get nightMultiplier => $composableBuilder(
    column: $table.nightMultiplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get holidayEnabled => $composableBuilder(
    column: $table.holidayEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get holidayMultiplier => $composableBuilder(
    column: $table.holidayMultiplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBillableDefault => $composableBuilder(
    column: $table.isBillableDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientsTableFilterComposer get clientId {
    final $$ClientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableFilterComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> timeEntriesRefs(
    Expression<bool> Function($$TimeEntriesTableFilterComposer f) f,
  ) {
    final $$TimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get billingType => $composableBuilder(
    column: $table.billingType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fixedRate => $composableBuilder(
    column: $table.fixedRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get defaultBreakMinutes => $composableBuilder(
    column: $table.defaultBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get overtimeEnabled => $composableBuilder(
    column: $table.overtimeEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get overtimeAfterMinutes => $composableBuilder(
    column: $table.overtimeAfterMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get overtimeMultiplier => $composableBuilder(
    column: $table.overtimeMultiplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get nightEnabled => $composableBuilder(
    column: $table.nightEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nightStartMinute => $composableBuilder(
    column: $table.nightStartMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nightEndMinute => $composableBuilder(
    column: $table.nightEndMinute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get nightMultiplier => $composableBuilder(
    column: $table.nightMultiplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get holidayEnabled => $composableBuilder(
    column: $table.holidayEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get holidayMultiplier => $composableBuilder(
    column: $table.holidayMultiplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBillableDefault => $composableBuilder(
    column: $table.isBillableDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientsTableOrderingComposer get clientId {
    final $$ClientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableOrderingComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get billingType => $composableBuilder(
    column: $table.billingType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fixedRate =>
      $composableBuilder(column: $table.fixedRate, builder: (column) => column);

  GeneratedColumn<int> get defaultBreakMinutes => $composableBuilder(
    column: $table.defaultBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get overtimeEnabled => $composableBuilder(
    column: $table.overtimeEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get overtimeAfterMinutes => $composableBuilder(
    column: $table.overtimeAfterMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get overtimeMultiplier => $composableBuilder(
    column: $table.overtimeMultiplier,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get nightEnabled => $composableBuilder(
    column: $table.nightEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nightStartMinute => $composableBuilder(
    column: $table.nightStartMinute,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nightEndMinute => $composableBuilder(
    column: $table.nightEndMinute,
    builder: (column) => column,
  );

  GeneratedColumn<double> get nightMultiplier => $composableBuilder(
    column: $table.nightMultiplier,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get holidayEnabled => $composableBuilder(
    column: $table.holidayEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<double> get holidayMultiplier => $composableBuilder(
    column: $table.holidayMultiplier,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isBillableDefault => $composableBuilder(
    column: $table.isBillableDefault,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ClientsTableAnnotationComposer get clientId {
    final $$ClientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableAnnotationComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> timeEntriesRefs<T extends Object>(
    Expression<T> Function($$TimeEntriesTableAnnotationComposer a) f,
  ) {
    final $$TimeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          Project,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (Project, $$ProjectsTableReferences),
          Project,
          PrefetchHooks Function({bool clientId, bool timeEntriesRefs})
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> clientId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> billingType = const Value.absent(),
                Value<double> hourlyRate = const Value.absent(),
                Value<double> fixedRate = const Value.absent(),
                Value<int> defaultBreakMinutes = const Value.absent(),
                Value<bool> overtimeEnabled = const Value.absent(),
                Value<int> overtimeAfterMinutes = const Value.absent(),
                Value<double> overtimeMultiplier = const Value.absent(),
                Value<bool> nightEnabled = const Value.absent(),
                Value<int> nightStartMinute = const Value.absent(),
                Value<int> nightEndMinute = const Value.absent(),
                Value<double> nightMultiplier = const Value.absent(),
                Value<bool> holidayEnabled = const Value.absent(),
                Value<double> holidayMultiplier = const Value.absent(),
                Value<bool> isBillableDefault = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                clientId: clientId,
                name: name,
                billingType: billingType,
                hourlyRate: hourlyRate,
                fixedRate: fixedRate,
                defaultBreakMinutes: defaultBreakMinutes,
                overtimeEnabled: overtimeEnabled,
                overtimeAfterMinutes: overtimeAfterMinutes,
                overtimeMultiplier: overtimeMultiplier,
                nightEnabled: nightEnabled,
                nightStartMinute: nightStartMinute,
                nightEndMinute: nightEndMinute,
                nightMultiplier: nightMultiplier,
                holidayEnabled: holidayEnabled,
                holidayMultiplier: holidayMultiplier,
                isBillableDefault: isBillableDefault,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> clientId = const Value.absent(),
                required String name,
                Value<String> billingType = const Value.absent(),
                Value<double> hourlyRate = const Value.absent(),
                Value<double> fixedRate = const Value.absent(),
                Value<int> defaultBreakMinutes = const Value.absent(),
                Value<bool> overtimeEnabled = const Value.absent(),
                Value<int> overtimeAfterMinutes = const Value.absent(),
                Value<double> overtimeMultiplier = const Value.absent(),
                Value<bool> nightEnabled = const Value.absent(),
                Value<int> nightStartMinute = const Value.absent(),
                Value<int> nightEndMinute = const Value.absent(),
                Value<double> nightMultiplier = const Value.absent(),
                Value<bool> holidayEnabled = const Value.absent(),
                Value<double> holidayMultiplier = const Value.absent(),
                Value<bool> isBillableDefault = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                clientId: clientId,
                name: name,
                billingType: billingType,
                hourlyRate: hourlyRate,
                fixedRate: fixedRate,
                defaultBreakMinutes: defaultBreakMinutes,
                overtimeEnabled: overtimeEnabled,
                overtimeAfterMinutes: overtimeAfterMinutes,
                overtimeMultiplier: overtimeMultiplier,
                nightEnabled: nightEnabled,
                nightStartMinute: nightStartMinute,
                nightEndMinute: nightEndMinute,
                nightMultiplier: nightMultiplier,
                holidayEnabled: holidayEnabled,
                holidayMultiplier: holidayMultiplier,
                isBillableDefault: isBillableDefault,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clientId = false, timeEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (timeEntriesRefs) db.timeEntries],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.clientId,
                                referencedTable: $$ProjectsTableReferences
                                    ._clientIdTable(db),
                                referencedColumn: $$ProjectsTableReferences
                                    ._clientIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (timeEntriesRefs)
                    await $_getPrefetchedData<
                      Project,
                      $ProjectsTable,
                      TimeEntry
                    >(
                      currentTable: table,
                      referencedTable: $$ProjectsTableReferences
                          ._timeEntriesRefsTable(db),
                      managerFromTypedResult: (p0) => $$ProjectsTableReferences(
                        db,
                        table,
                        p0,
                      ).timeEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.projectId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      Project,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (Project, $$ProjectsTableReferences),
      Project,
      PrefetchHooks Function({bool clientId, bool timeEntriesRefs})
    >;
typedef $$TimeEntriesTableCreateCompanionBuilder =
    TimeEntriesCompanion Function({
      Value<int> id,
      required int projectId,
      Value<int?> clientId,
      required DateTime startAt,
      required DateTime endAt,
      Value<int> breakMinutes,
      required int workedMinutes,
      required double appliedRate,
      required double amount,
      Value<String> status,
      Value<bool> isBillable,
      Value<bool> isPaid,
      Value<String?> taskDescription,
      Value<DateTime> createdAt,
    });
typedef $$TimeEntriesTableUpdateCompanionBuilder =
    TimeEntriesCompanion Function({
      Value<int> id,
      Value<int> projectId,
      Value<int?> clientId,
      Value<DateTime> startAt,
      Value<DateTime> endAt,
      Value<int> breakMinutes,
      Value<int> workedMinutes,
      Value<double> appliedRate,
      Value<double> amount,
      Value<String> status,
      Value<bool> isBillable,
      Value<bool> isPaid,
      Value<String?> taskDescription,
      Value<DateTime> createdAt,
    });

final class $$TimeEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $TimeEntriesTable, TimeEntry> {
  $$TimeEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
        $_aliasNameGenerator(db.timeEntries.projectId, db.projects.id),
      );

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ClientsTable _clientIdTable(_$AppDatabase db) =>
      db.clients.createAlias(
        $_aliasNameGenerator(db.timeEntries.clientId, db.clients.id),
      );

  $$ClientsTableProcessedTableManager? get clientId {
    final $_column = $_itemColumn<int>('client_id');
    if ($_column == null) return null;
    final manager = $$ClientsTableTableManager(
      $_db,
      $_db.clients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TimeEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $TimeEntriesTable> {
  $$TimeEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endAt => $composableBuilder(
    column: $table.endAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get workedMinutes => $composableBuilder(
    column: $table.workedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get appliedRate => $composableBuilder(
    column: $table.appliedRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBillable => $composableBuilder(
    column: $table.isBillable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPaid => $composableBuilder(
    column: $table.isPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskDescription => $composableBuilder(
    column: $table.taskDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClientsTableFilterComposer get clientId {
    final $$ClientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableFilterComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TimeEntriesTable> {
  $$TimeEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endAt => $composableBuilder(
    column: $table.endAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workedMinutes => $composableBuilder(
    column: $table.workedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get appliedRate => $composableBuilder(
    column: $table.appliedRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBillable => $composableBuilder(
    column: $table.isBillable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPaid => $composableBuilder(
    column: $table.isPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskDescription => $composableBuilder(
    column: $table.taskDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClientsTableOrderingComposer get clientId {
    final $$ClientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableOrderingComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimeEntriesTable> {
  $$TimeEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startAt =>
      $composableBuilder(column: $table.startAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endAt =>
      $composableBuilder(column: $table.endAt, builder: (column) => column);

  GeneratedColumn<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get workedMinutes => $composableBuilder(
    column: $table.workedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get appliedRate => $composableBuilder(
    column: $table.appliedRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isBillable => $composableBuilder(
    column: $table.isBillable,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPaid =>
      $composableBuilder(column: $table.isPaid, builder: (column) => column);

  GeneratedColumn<String> get taskDescription => $composableBuilder(
    column: $table.taskDescription,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClientsTableAnnotationComposer get clientId {
    final $$ClientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableAnnotationComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimeEntriesTable,
          TimeEntry,
          $$TimeEntriesTableFilterComposer,
          $$TimeEntriesTableOrderingComposer,
          $$TimeEntriesTableAnnotationComposer,
          $$TimeEntriesTableCreateCompanionBuilder,
          $$TimeEntriesTableUpdateCompanionBuilder,
          (TimeEntry, $$TimeEntriesTableReferences),
          TimeEntry,
          PrefetchHooks Function({bool projectId, bool clientId})
        > {
  $$TimeEntriesTableTableManager(_$AppDatabase db, $TimeEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimeEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimeEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimeEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<int?> clientId = const Value.absent(),
                Value<DateTime> startAt = const Value.absent(),
                Value<DateTime> endAt = const Value.absent(),
                Value<int> breakMinutes = const Value.absent(),
                Value<int> workedMinutes = const Value.absent(),
                Value<double> appliedRate = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isBillable = const Value.absent(),
                Value<bool> isPaid = const Value.absent(),
                Value<String?> taskDescription = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TimeEntriesCompanion(
                id: id,
                projectId: projectId,
                clientId: clientId,
                startAt: startAt,
                endAt: endAt,
                breakMinutes: breakMinutes,
                workedMinutes: workedMinutes,
                appliedRate: appliedRate,
                amount: amount,
                status: status,
                isBillable: isBillable,
                isPaid: isPaid,
                taskDescription: taskDescription,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int projectId,
                Value<int?> clientId = const Value.absent(),
                required DateTime startAt,
                required DateTime endAt,
                Value<int> breakMinutes = const Value.absent(),
                required int workedMinutes,
                required double appliedRate,
                required double amount,
                Value<String> status = const Value.absent(),
                Value<bool> isBillable = const Value.absent(),
                Value<bool> isPaid = const Value.absent(),
                Value<String?> taskDescription = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TimeEntriesCompanion.insert(
                id: id,
                projectId: projectId,
                clientId: clientId,
                startAt: startAt,
                endAt: endAt,
                breakMinutes: breakMinutes,
                workedMinutes: workedMinutes,
                appliedRate: appliedRate,
                amount: amount,
                status: status,
                isBillable: isBillable,
                isPaid: isPaid,
                taskDescription: taskDescription,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TimeEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false, clientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.projectId,
                                referencedTable: $$TimeEntriesTableReferences
                                    ._projectIdTable(db),
                                referencedColumn: $$TimeEntriesTableReferences
                                    ._projectIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (clientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.clientId,
                                referencedTable: $$TimeEntriesTableReferences
                                    ._clientIdTable(db),
                                referencedColumn: $$TimeEntriesTableReferences
                                    ._clientIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TimeEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimeEntriesTable,
      TimeEntry,
      $$TimeEntriesTableFilterComposer,
      $$TimeEntriesTableOrderingComposer,
      $$TimeEntriesTableAnnotationComposer,
      $$TimeEntriesTableCreateCompanionBuilder,
      $$TimeEntriesTableUpdateCompanionBuilder,
      (TimeEntry, $$TimeEntriesTableReferences),
      TimeEntry,
      PrefetchHooks Function({bool projectId, bool clientId})
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      required DateTime occurredAt,
      required double amount,
      Value<String?> note,
      Value<DateTime> createdAt,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      Value<DateTime> occurredAt,
      Value<double> amount,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
          Expense,
          PrefetchHooks Function()
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                occurredAt: occurredAt,
                amount: amount,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime occurredAt,
                required double amount,
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                occurredAt: occurredAt,
                amount: amount,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
      Expense,
      PrefetchHooks Function()
    >;
typedef $$MileagesTableCreateCompanionBuilder =
    MileagesCompanion Function({
      Value<int> id,
      required DateTime occurredAt,
      Value<double> distance,
      Value<double> amount,
      Value<String?> note,
      Value<DateTime> createdAt,
    });
typedef $$MileagesTableUpdateCompanionBuilder =
    MileagesCompanion Function({
      Value<int> id,
      Value<DateTime> occurredAt,
      Value<double> distance,
      Value<double> amount,
      Value<String?> note,
      Value<DateTime> createdAt,
    });

class $$MileagesTableFilterComposer
    extends Composer<_$AppDatabase, $MileagesTable> {
  $$MileagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distance => $composableBuilder(
    column: $table.distance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MileagesTableOrderingComposer
    extends Composer<_$AppDatabase, $MileagesTable> {
  $$MileagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distance => $composableBuilder(
    column: $table.distance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MileagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MileagesTable> {
  $$MileagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distance =>
      $composableBuilder(column: $table.distance, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MileagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MileagesTable,
          Mileage,
          $$MileagesTableFilterComposer,
          $$MileagesTableOrderingComposer,
          $$MileagesTableAnnotationComposer,
          $$MileagesTableCreateCompanionBuilder,
          $$MileagesTableUpdateCompanionBuilder,
          (Mileage, BaseReferences<_$AppDatabase, $MileagesTable, Mileage>),
          Mileage,
          PrefetchHooks Function()
        > {
  $$MileagesTableTableManager(_$AppDatabase db, $MileagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MileagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MileagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MileagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<double> distance = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MileagesCompanion(
                id: id,
                occurredAt: occurredAt,
                distance: distance,
                amount: amount,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime occurredAt,
                Value<double> distance = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MileagesCompanion.insert(
                id: id,
                occurredAt: occurredAt,
                distance: distance,
                amount: amount,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MileagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MileagesTable,
      Mileage,
      $$MileagesTableFilterComposer,
      $$MileagesTableOrderingComposer,
      $$MileagesTableAnnotationComposer,
      $$MileagesTableCreateCompanionBuilder,
      $$MileagesTableUpdateCompanionBuilder,
      (Mileage, BaseReferences<_$AppDatabase, $MileagesTable, Mileage>),
      Mileage,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      Value<String?> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String?> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String?> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                Value<String?> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db, _db.clients);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$TimeEntriesTableTableManager get timeEntries =>
      $$TimeEntriesTableTableManager(_db, _db.timeEntries);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$MileagesTableTableManager get mileages =>
      $$MileagesTableTableManager(_db, _db.mileages);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
