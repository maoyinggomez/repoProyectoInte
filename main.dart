import 'package:flutter/material.dart';

void main() {
  runApp(const MiApp());
}

/// Widget raiz de la aplicacion
/// Convertido a StatefulWidget para manejar el estado del tema
class MiApp extends StatefulWidget {
  const MiApp({super.key});

  @override
  State<MiApp> createState() => _MiAppState();
}

/// Estado de MiApp: gestiona el cambio de tema claro/oscuro
class _MiAppState extends State<MiApp> {
  /// Variable que almacena el modo de tema actual (claro u oscuro)
  ThemeMode _themeMode = ThemeMode.light;

  /// Metodo para cambiar el tema
  /// Recibe un booleano: true para tema oscuro, false para tema claro
  void _cambiarTema(bool esOscuro) {
    setState(() {
      _themeMode = esOscuro ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Version1',

      /// themeMode: Controla que tema se aplica (light, dark o system)
      themeMode: _themeMode,

      /// theme: Define el tema claro de la aplicacion
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),

      /// darkTheme: Define el tema oscuro de la aplicacion
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),

      /// Pasamos el metodo _cambiarTema como callback a PantallaPrincipal
      home: PantallaPrincipal(onThemeChanged: _cambiarTema),
    );
  }
}

/// Pantalla principal: convertida a StatefulWidget para manejar el switch del tema
class PantallaPrincipal extends StatefulWidget {
  /// Callback que se ejecuta cuando el usuario cambia el tema
  final Function(bool) onThemeChanged;

  const PantallaPrincipal({super.key, required this.onThemeChanged});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

/// Estado de PantallaPrincipal
class _PantallaPrincipalState extends State<PantallaPrincipal> {
  /// Variable que rastrea si el tema oscuro esta activo
  bool _esTemaOscuro = false;

  void mostrarMensaje(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hola, este es un SnackBar personalizado'),
        backgroundColor: Colors.indigo,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void navegar(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SegundaPantalla()),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Obtener los colores del tema actual
    /// isDark sera true si el tema oscuro esta activo, false si es tema claro
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      /// backgroundColor: Usa el color de fondo del tema actual
      /// En tema claro: gris claro (Colors.grey[100])
      /// En tema oscuro: gris muy oscuro (Colors.grey[900])
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],

      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,

        /// El AppBar se adapta automáticamente al tema seleccionado
        /// Material 3 proporciona colores automáticos basados en el colorSchemeSeed
        elevation: 4,

        leading: const Icon(Icons.menu),

        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'Mostrar mensaje',
            onPressed: () {
              mostrarMensaje(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Ir a otra pantalla',
            onPressed: () {
              navegar(context);
            },
          ),
        ],
      ),

      /// body: Ahora usa Center en lugar de const Center para que sea Stateful
      body: Center(
        child: Text(
          'Estas en la pagina de Login',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,

            /// El color del texto se adapta dinámicamente al tema
            /// Usa colorScheme.primary que cambia con ThemeMode
            /// En tema claro: color indigo
            /// En tema oscuro: color indigo claro
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),

      /// BottomAppBar: Barra inferior con el switch para cambiar tema
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Etiqueta del switch
              /// Ahora NO es const para permitir que use Theme.of(context)
              Text(
                'Tema Oscuro',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,

                  /// El color del texto se adapta al tema actual
                  /// Usa textTheme.bodyLarge?.color para mantener consistencia
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),

              /// Switch que alterna entre tema claro y oscuro
              Switch(
                /// El valor del switch es verdadero cuando esta el tema oscuro
                value: _esTemaOscuro,

                /// Callback que se ejecuta al cambiar el switch
                onChanged: (valor) {
                  setState(() {
                    /// Actualiza el estado local del switch
                    _esTemaOscuro = valor;
                  });

                  /// Llama el callback para cambiar el tema en toda la app (_cambiarTema en MiApp)
                  /// Esto reconstruye el MaterialApp con el nuevo themeMode
                  widget.onThemeChanged(valor);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SegundaPantalla extends StatelessWidget {
  const SegundaPantalla({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,

      appBar: AppBar(
        title: const Text('Inicio'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: const Center(
        child: Text(
          'Has navegado a la página de Inicio',
          style: TextStyle(
            fontSize: 22,
            color: Colors.indigo,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
