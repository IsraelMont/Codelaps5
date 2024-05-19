// Ejercicio 2: Practique el manejo de errores

// La siguiente función se proporciona para simular
// una operación asincrónica que podría llevar un tiempo y
// potencialmente lanzar una excepción.
Future<String> changeUsername() async {
  try {
    return await fetchNewUsername(); // Intenta obtener el nuevo nombre de usuario
  } catch (err) { // Captura cualquier excepción que ocurra durante la obtención del nombre de usuario
    return err.toString(); // Devuelve la descripción de la excepción como una cadena
  }
}

// Función asincrónica que simula una operación de obtener un nuevo nombre de usuario.
Future<String> fetchNewUsername() =>
    Future.delayed(const Duration(milliseconds: 500), () => throw UserError());

// Clase que define un tipo específico de error que puede ocurrir al obtener un nuevo nombre de usuario.
class UserError implements Exception {
  @override
  String toString() => 'New username is invalid'; // Devuelve un mensaje de error específico para este tipo de error.
}

// El siguiente código se utiliza para probar y proporcionar retroalimentación sobre tu solución.
// No es necesario leerlo ni modificarlo.

void main() async {
  final List<String> messages = []; // Lista para almacenar los mensajes de prueba
  const typoMessage = 'Test failed! Check for typos in your return value'; // Mensaje de error tipográfico

  print('Testing...'); // Imprime un mensaje para indicar que se están realizando las pruebas.
  try {
    messages
      ..add(_makeReadable(
          testLabel: '',
          testResult: await _asyncDidCatchException(changeUsername), // Verifica si se capturó la excepción correctamente
          readableErrors: {
            typoMessage: typoMessage,
            _noCatch:
                'Did you remember to call fetchNewUsername within a try/catch block?',
          }))
      ..add(_makeReadable(
          testLabel: '',
          testResult: await _asyncErrorEquals(changeUsername), // Verifica si se manejó correctamente el error y se devolvió como se esperaba
          readableErrors: {
            typoMessage: typoMessage,
            _noCatch:
                'Did you remember to call fetchNewUsername within a try/catch block?',
          }))
      ..removeWhere((m) => m.contains(_passed)) // Elimina los mensajes de prueba que pasaron
      ..toList();

    if (messages.isEmpty) {
      print('Exito. All tests passed!'); // Si no hay mensajes de error, todas las pruebas pasaron
    } else {
      messages.forEach(print); // Imprime los mensajes de error
    }
  } catch (e) {
    print('Tried to run solution, but received an exception: $e'); // Si ocurre una excepción al ejecutar las pruebas, imprime el mensaje de error.
  }
}

// Ayudantes de prueba.

// Función que convierte el resultado de la prueba en un mensaje legible.
String _makeReadable({
  required String testResult,
  required Map<String, String> readableErrors,
  required String testLabel,
}) {
  if (readableErrors.containsKey(testResult)) {
    final readable = readableErrors[testResult];
    return '$testLabel $readable';
  } else {
    return '$testLabel $testResult';
  }
}

// Función que comprueba si la excepción lanzada es del tipo esperado.
Future<String> _asyncErrorEquals(Function fn) async {
  final result = await fn(); // Ejecuta la función y espera su resultado
  if (result == UserError().toString()) { // Comprueba si el resultado es la descripción del error esperado
    return _passed; // Si es así, la prueba pasa
  } else {
    return 'Test failed! Did you stringify and return the caught error?'; // De lo contrario, la prueba falla
  }
}

// Función que comprueba si se capturó la excepción correctamente.
Future<String> _asyncDidCatchException(Function fn) async {
  var caught = true;
  try {
    await fn(); // Ejecuta la función y espera si se lanza una excepción
  } on UserError catch (_) { // Captura solo las excepciones del tipo UserError
    caught = false; // Si se captura una excepción, indica que no se capturó correctamente
  }

  if (caught == false) {
    return _noCatch; // Si no se capturó la excepción, la prueba falla
  } else {
    return _passed; // De lo contrario, la prueba pasa
  }
}

// Constantes utilizadas para etiquetar los resultados de las pruebas.
const _passed = 'PASSED';
const _noCatch = 'NO_CATCH';