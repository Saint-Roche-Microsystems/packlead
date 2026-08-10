import 'package:flutter_test/flutter_test.dart';
import 'package:packlead/core/validators/common_validators.dart';
import 'package:packlead/core/validators/dispatcher_form_validators.dart';
import 'package:packlead/core/validators/email_validators.dart';

void main() {
  group('CommonValidators.required', () {
    test('Debe retornar error si el valor es null', () {
      expect(CommonValidators.required(null), 'Este campo es requerido');
    });

    test('Debe retornar error si el valor está vacío o son solo espacios', () {
      expect(CommonValidators.required('   '), 'Este campo es requerido');
    });

    test('Debe usar el nombre de campo provisto en el mensaje', () {
      expect(
        CommonValidators.required('', 'El correo'),
        'El correo es requerido',
      );
    });

    test('Debe retornar null si el valor es válido', () {
      expect(CommonValidators.required('Carlos'), isNull);
    });
  });

  group('CommonValidators.minLength', () {
    test('Debe retornar error si el valor es null', () {
      expect(CommonValidators.minLength(null, 3), 'Este campo es requerido');
    });

    test('Debe retornar error si el valor no alcanza la longitud mínima', () {
      expect(
        CommonValidators.minLength('Al', 3, 'El nombre'),
        'El nombre debe tener al menos 3 caracteres',
      );
    });

    test('Debe retornar null si el valor cumple la longitud mínima', () {
      expect(CommonValidators.minLength('Carlos', 3), isNull);
    });
  });

  group('CommonValidators.notBlank', () {
    test('Debe retornar error si el valor está vacío', () {
      expect(
        CommonValidators.notBlank('', 'El vehículo'),
        'El vehículo no puede estar vacío',
      );
    });

    test('Debe retornar null si el valor no está vacío', () {
      expect(CommonValidators.notBlank('Moto'), isNull);
    });
  });

  group('EmailValidators.validateFormat', () {
    test('Debe retornar error si el valor es null', () {
      expect(EmailValidators.validateFormat(null), 'El correo es requerido');
    });

    test('Debe retornar error si el correo está vacío', () {
      expect(EmailValidators.validateFormat('   '), 'El correo es requerido');
    });

    test('Debe retornar error si el formato es inválido', () {
      expect(
        EmailValidators.validateFormat('correo-invalido'),
        'Ingrese un correo válido',
      );
    });

    test('Debe retornar null si el correo tiene formato válido', () {
      expect(EmailValidators.validateFormat('admin@packlead.com'), isNull);
    });
  });

  group('DispatcherFormValidators.validateName', () {
    test('Debe retornar error si el nombre es null', () {
      expect(
        DispatcherFormValidators.validateName(null),
        'El nombre es requerido',
      );
    });

    test('Debe retornar error si el nombre no alcanza la longitud mínima', () {
      expect(
        DispatcherFormValidators.validateName('Al'),
        'El nombre debe tener al menos 3 caracteres',
      );
    });

    test('Debe retornar null si el nombre es válido', () {
      expect(DispatcherFormValidators.validateName('Carlos'), isNull);
    });
  });

  group('DispatcherFormValidators.validateVehicle', () {
    test('Debe retornar error si el vehículo está vacío', () {
      expect(
        DispatcherFormValidators.validateVehicle(''),
        'El vehículo no puede estar vacío',
      );
    });

    test('Debe retornar null si el vehículo es válido', () {
      expect(DispatcherFormValidators.validateVehicle('Moto'), isNull);
    });
  });

  group('DispatcherFormValidators.validateLicensePlate', () {
    test('Debe retornar error si la placa es null', () {
      expect(
        DispatcherFormValidators.validateLicensePlate(null),
        'La placa es requerida',
      );
    });

    test('Debe retornar error si la placa está vacía', () {
      expect(
        DispatcherFormValidators.validateLicensePlate('   '),
        'La placa es requerida',
      );
    });

    test('Debe retornar error si el formato no coincide con ABC-1234', () {
      expect(
        DispatcherFormValidators.validateLicensePlate('ABC123'),
        'Formato inválido. Ej: ABC-1234',
      );
    });

    test('Debe retornar null con placa de 3 dígitos válida', () {
      expect(DispatcherFormValidators.validateLicensePlate('ABC-123'), isNull);
    });

    test('Debe retornar null con placa de 4 dígitos válida', () {
      expect(DispatcherFormValidators.validateLicensePlate('ABC-1234'), isNull);
    });
  });
}
