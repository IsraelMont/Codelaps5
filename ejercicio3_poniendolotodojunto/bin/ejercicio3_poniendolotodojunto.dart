// -- Ejercicio 3: Poniedno todo junto

// Parte 1: Función para agregar un saludo al nombre de usuario
addHello(String user){
  return 'Hello $user'; // Devuelve un saludo concatenando "Hello" con el nombre de usuario recibido como argumento
}

// Parte 2: Función para saludar al usuario obteniendo su nombre de usuario y agregando un saludo
greetUser() async {
  final username = await fetchUsername(); // Espera a que se resuelva la función asincrónica fetchUsername() para obtener el nombre de usuario
  return addHello(username); // Retorna el saludo con el nombre de usuario
}

// Parte 3: Función para despedirse del usuario intentando cerrar sesión y dando un mensaje de despedida
Future<String> sayGoodbye() async {
  try {
    final result = await logoutUser(); // Intenta cerrar sesión y espera a que se resuelva la función asincrónica logoutUser()
    return '$result Thanks, see you next time'; // Devuelve un mensaje de despedida con el resultado del cierre de sesión
  } catch (e) {
    return 'Logout failed. Thanks, see you next time'; // Devuelve un mensaje de despedida indicando que el cierre de sesión falló
  }
}

// Funciones de utilidad para simular operaciones asíncronas y realizar pruebas

// Función asincrónica para obtener el nombre de usuario
Future<String> fetchUsername() => Future.delayed(_halfSecond, () => 'Jean');

// Función asincrónica para cerrar sesión del usuario
Future<String> logoutUser() => Future.delayed(_halfSecond, _failOnce);

// Función principal que realiza pruebas y proporciona feedback sobre la solución
void main() async {
  // Constante para almacenar un mensaje de error común
  const didNotImplement =
      'Test failed! Did you forget to implement or return from';

  // Lista de mensajes para almacenar los resultados de las pruebas
  final List<String> messages = [];

  // Imprimir inicio del proceso de pruebas
  print('Testing...');
  try {
    // Ejecutar y almacenar resultados de las pruebas
    messages
      // Parte 1: Prueba la función addHello con un nombre de usuario
      ..add(_makeReadable(
          testLabel: 'Part 1',
          testResult: await _asyncEquals(
              expected: 'Hello Jerry',
              actual: addHello('Jerry'),
              typoKeyword: 'Jerry'),
          readableErrors: {
            _typoMessage: _typoMessage,
            'null': '$didNotImplement addHello?',
            'Hello Instance of \'Future<String>\'':
                'Looks like you forgot to use the \'await\' keyword!',
            'Hello Instance of \'_Future<String>\'':
                'Looks like you forgot to use the \'await\' keyword!',
          }))
      // Parte 2: Prueba la función greetUser para saludar al usuario
      ..add(_makeReadable(
          testLabel: 'Part 2',
          testResult: await _asyncEquals(
              expected: 'Hello Jean',
              actual: await greetUser(),
              typoKeyword: 'Jean'),
          readableErrors: {
            _typoMessage: _typoMessage,
            'null': '$didNotImplement greetUser?',
            'HelloJean':
                'Looks like you forgot the space between \'Hello\' and \'Jean\'',
            'Hello Instance of \'Future<String>\'':
                'Looks like you forgot to use the \'await\' keyword!',
            'Hello Instance of \'_Future<String>\'':
                'Looks like you forgot to use the \'await\' keyword!',
            '{Closure: (String) => dynamic from Function \'addHello\': static.(await fetchUsername())}':
                'Did you place the \'\$\' character correctly?',
            '{Closure \'addHello\'(await fetchUsername())}':
                'Did you place the \'\$\' character correctly?',
          }))
      // Parte 3: Prueba la función sayGoodbye para despedirse del usuario
      ..add(_makeReadable(
          testLabel: 'Part 3',
          testResult: await _asyncDidCatchException(sayGoodbye),
          readableErrors: {
            _typoMessage:
                '$_typoMessage. Did you add the text \'Thanks, see you next time\'?',
            'null': '$didNotImplement sayGoodbye?',
            _noCatch:
                'Did you remember to call logoutUser within a try/catch block?',
            'Instance of \'Future<String>\' Thanks, see you next time':
                'Did you remember to use the \'await\' keyword in the sayGoodbye function?',
            'Instance of \'_Future<String>\' Thanks, see you next time':
                'Did you remember to use the \'await\' keyword in the sayGoodbye function?',
          }))
      // Prueba adicional para validar el mensaje de despedida
      ..add(_makeReadable(
          testLabel: 'Part 3',
          testResult: await _asyncEquals(
              expected: 'Success! Thanks, see you next time',
              actual: await sayGoodbye(),
              typoKeyword: 'Success'),
          readableErrors: {
            _typoMessage:
                '$_typoMessage. Did you add the text \'Thanks, see you next time\'?',
            'null': '$didNotImplement sayGoodbye?',
            _noCatch:
                'Did you remember to call logoutUser within a try/catch block?',
            'Instance of \'Future<String>\' Thanks, see you next time':
                'Did you remember to use the \'await\' keyword in the sayGoodbye function?',
            'Instance of \'_Future<String>\' Thanks, see you next time':
                'Did you remember to use the \'await\' keyword in the sayGoodbye function?',
            'Instance of \'_Exception\'':
                'CAUGHT Did you remember to return a string?',
          }))
      // Elimina mensajes que indican que las pruebas han sido superadas
      ..removeWhere((m) => m.contains(_passed))
      // Convierte la lista de mensajes en una lista
      ..toList();

    // Imprime resultado de las pruebas
    if (messages.isEmpty) {
      print('Success. All tests passed!');
    } else {
      messages.forEach(print);
    }
  } catch (e) {
    // Maneja excepciones si hay errores durante las pruebas
    print('Tried to run solution, but received an exception: $e');
  }
}

// Funciones auxiliares para realizar pruebas y proporcionar feedback

// Función para convertir el resultado de las pruebas en un mensaje legible
String _makeReadable({
  required String testResult,
  required Map<String, String> readableErrors,
  required String testLabel,
}) {
  String? readable;
  if (readableErrors.containsKey(testResult)) {
    readable = readableErrors[testResult];
    return '$testLabel $readable';
  } else if ((testResult != _passed) && (testResult.length < 18)) {
    readable = _typoMessage;
    return '$testLabel $readable';
  } else {
    return '$testLabel $testResult';
  }
}

// Función para comparar el resultado esperado con el resultado real de las pruebas
Future<String> _asyncEquals({
  required String expected,
  required dynamic actual,
  required String typoKeyword,
}) async {
  final strActual = actual is String ? actual : actual.toString();
  try {
    if (expected == actual) {
      return _passed;
    } else if (strActual.contains(typoKeyword)) {
      return _typoMessage;
    } else {
      return strActual;
    }
  } catch (e) {
    return e.toString();
  }
}

// Función para comprobar si se capturó una excepción durante las pruebas
Future<String> _asyncDidCatchException(Function fn) async {
  var caught = true;
  try {
    await fn();
  } on Exception catch (_) {
    caught = false;
  }

  if (caught == true) {
    return _passed;
  } else {
    return _noCatch;
  }
}

// Constantes para mensajes y duración utilizadas en las pruebas

// Mensaje para indicar que hay un error tipográfico en la solución
const _typoMessage = 'Test failed! Check for typos in your return value';

// Marca para indicar que una prueba ha sido superada
const _passed = 'PASSED';

// Marca para indicar que una prueba no capturó una excepción
const _noCatch = 'NO_CATCH';

// Duración de medio segundo utilizada en las simulaciones de operaciones asincrónicas
const _halfSecond = Duration(milliseconds: 500);

// Función auxiliar para simular un fallo una vez al intentar cerrar sesión del usuario
String _failOnce() {
  if (_logoutSucceeds) {
    return 'Success!'; // Si ya ha tenido éxito antes, devuelve "Success!"
  } else {
    _logoutSucceeds = true; // Marca que el próximo intento de cierre de sesión será exitoso
    throw Exception('Logout failed'); // Lanza una excepción para simular un fallo en el cierre de sesión
  }
}

// Variable booleana para controlar el éxito o fracaso del cierre de sesión
bool _logoutSucceeds = false;