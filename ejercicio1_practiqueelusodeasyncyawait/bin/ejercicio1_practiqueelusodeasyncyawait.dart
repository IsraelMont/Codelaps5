// --Ejercicio: practique el uso de async y await

// Part 1
// Llama a la función asíncrona proporcionada fetchRole()
// para devolver el rol del usuario.
  Future<String> reportUserRole() async {
  final username = await fetchRole();
  return 'User role: $username';
}

// Part 2
// Llama a la función asíncrona proporcionada fetchLoginAmount()
// para devolver el número de veces que el usuario ha iniciado sesión.
Future<String> reportLogins() async {
  final logins = await fetchLoginAmount();
  return 'Total number of logins: $logins';
}

// Las siguientes funciones simulan operaciones asíncronas que podrían llevar un tiempo.
Future<String> fetchRole() => Future.delayed(_halfSecond, () => _role);
Future<int> fetchLoginAmount() => Future.delayed(_halfSecond, () => _logins);

// El siguiente código se utiliza para probar y proporcionar comentarios sobre tu solución.
// No es necesario leerlo ni modificarlo.
void main() async { //Función principal que se declara como asíncrona (async) 
  // Imprime un mensaje para indicar que se están realizando pruebas.
  print('Probando...');
  List<String> messages = []; //// Lista para almacenar los mensajes de las pruebas.
  const passed = 'PASSED'; // Una constante para indicar que una prueba pasó exitosamente.
  const testFailedMessage = 'Prueba fallida para la función:';  // Un mensaje base para indicar que una prueba falló.
  // Un mensaje para indicar que la falla puede ser causada por un error tipográfico.
  const typoMessage = '¡Prueba fallida! Verifica errores tipográficos en el valor de retorno';
  try {
    messages
      ..add(_makeReadable(
          testLabel: 'Part 1',
          testResult: await _asyncEquals(
            expected: 'User role: administrator',
            actual: await reportUserRole(),
            typoKeyword: _role,
          ),
          readableErrors: {
            typoMessage: typoMessage,
            'null':
                'Test failed! Did you forget to implement or return from reportUserRole?',
            'User role: Instance of \'Future<String>\'':
                '$testFailedMessage reportUserRole. Did you use the await keyword?',
            'User role: Instance of \'_Future<String>\'':
                '$testFailedMessage reportUserRole. Did you use the await keyword?',
            'User role:':
                '$testFailedMessage reportUserRole. Did you return a user role?',
            'User role: ':
                '$testFailedMessage reportUserRole. Did you return a user role?',
            'User role: tester':
                '$testFailedMessage reportUserRole. Did you invoke fetchRole to fetch the user\'s role?',
          }))
      ..add(_makeReadable(
          testLabel: 'Part 2',
          testResult: await _asyncEquals(
            expected: 'Total number of logins: 42',
            actual: await reportLogins(),
            typoKeyword: _logins.toString(),
          ),
          readableErrors: {
            typoMessage: typoMessage,
            'null':
                'Test failed! Did you forget to implement or return from reportLogins?',
            'Total number of logins: Instance of \'Future<int>\'':
                '$testFailedMessage reportLogins. Did you use the await keyword?',
            'Total number of logins: Instance of \'_Future<int>\'':
                '$testFailedMessage reportLogins. Did you use the await keyword?',
            'Total number of logins: ':
                '$testFailedMessage reportLogins. Did you return the number of logins?',
            'Total number of logins:':
                '$testFailedMessage reportLogins. Did you return the number of logins?',
            'Total number of logins: 57':
                '$testFailedMessage reportLogins. Did you invoke fetchLoginAmount to fetch the number of user logins?',
          }))
      ..removeWhere((m) => m.contains(passed))
      ..toList();

    if (messages.isEmpty) {
      print('¡Éxito! ¡Todas las pruebas pasaron!');
      // Si no hay mensajes de pruebas fallidas, imprime un mensaje de éxito.
    } else {
      messages.forEach(print);
      // Si hay mensajes de pruebas fallidas, imprime cada mensaje.
    }
  } on UnimplementedError {
    print('Test failed! Did you forget to implement or return from reportUserRole?');
    // Captura si una prueba falla debido a una función no implementada.
  } catch (e) {
    print('Tried to run solution, but received an exception: $e');
    // Captura cualquier otra excepción que pueda ocurrir durante las pruebas.
  }
}

const _role = 'administrator';
const _logins = 42;
const _halfSecond = Duration(milliseconds: 500);

// Test helpers.
String _makeReadable({
  required String testResult,
  required Map<String, String> readableErrors,
  required String testLabel,
}) {
  if (readableErrors.containsKey(testResult)) {
    var readable = readableErrors[testResult];
    return '$testLabel $readable';
  } else {
    return '$testLabel $testResult';
  }
}

// Assertions used in tests.
Future<String> _asyncEquals({
  required String expected,
  required dynamic actual,
  required String typoKeyword,
}) async {
  var strActual = actual is String ? actual : actual.toString();
  try {
    if (expected == actual) {
      return 'PASSED';
    } else if (strActual.contains(typoKeyword)) {
      return 'Test failed! Check for typos in your return value';
    } else {
      return strActual;
    }
  } catch (e) {
    return e.toString();
  }
}