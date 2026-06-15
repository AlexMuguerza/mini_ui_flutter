import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../theme/tokens.dart';

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

/// Tipo semántico del campo de entrada.
///
/// Controla el teclado virtual, la acción predeterminada y si el texto
/// se muestra oculto (contraseña).
enum MinInputType {
  /// Texto genérico. Teclado alfanumérico, acción "done".
  text,

  /// Correo electrónico. Teclado con "@" visible, acción "done".
  email,

  /// Contraseña. Oscurece el texto, usa [TextInputType.visiblePassword].
  password,

  /// Número decimal. Teclado numérico con punto decimal.
  number,

  /// Teléfono. Teclado telefónico, acción "done".
  phone,

  /// URL. Teclado con "/" y "." visibles, acción "done".
  url,

  /// Multilínea. Teclado con tecla "Enter", acción "newline".
  multiline,
}

/// Variante visual del campo de entrada.
///
/// Se puede combinar con [MinInput.errorText] para mostrar tanto el estado
/// de error como el mensaje descriptivo.
enum MinInputVariant {
  /// Estado normal (sin error).
  normal,

  /// Estado de error: decoración de error y cursor rojo.
  error,
}

// ---------------------------------------------------------------------------
// Sistema de estilos
// ---------------------------------------------------------------------------

/// Descripción completa de la apariencia visual de un [MinInput] por estado.
///
/// Cada estado (reposo, foco, error, deshabilitado) recibe su propia
/// [BoxDecoration]. El widget anima la transición entre ellas usando
/// [DecorationTween].
///
/// ### Uso con variante predefinida
/// ```dart
/// MinInput(style: MinInputStyle.filled(context))
/// ```
///
/// ### Uso con estilo completamente personalizado
/// ```dart
/// MinInput(
///   style: MinInputStyle(
///     idle: BoxDecoration(
///       color: Colors.blue.shade50,
///       borderRadius: BorderRadius.circular(24),
///       border: Border.all(color: Colors.blue.shade200),
///     ),
///     focused: BoxDecoration(
///       color: Colors.blue.shade50,
///       borderRadius: BorderRadius.circular(24),
///       border: Border.all(color: Colors.blue),
///       boxShadow: [BoxShadow(color: Colors.blue.withAlpha(60), blurRadius: 0, spreadRadius: 3)],
///     ),
///     error: BoxDecoration(...),
///     disabled: BoxDecoration(...),
///   ),
/// )
/// ```
class MinInputStyle {
  const MinInputStyle({
    required this.idle,
    required this.focused,
    required this.error,
    required this.disabled,
    this.foregroundColor,
    this.disabledForegroundColor,
    this.placeholderColor,
    this.contentPadding,
  });

  /// Decoración en estado de reposo (sin foco, sin error).
  final BoxDecoration idle;

  /// Decoración cuando el campo tiene el foco.
  ///
  /// Normalmente incluye un borde más prominente y/o un ring (box-shadow spread).
  final BoxDecoration focused;

  /// Decoración cuando hay un error activo ([MinInputVariant.error] o [MinInput.errorText]).
  final BoxDecoration error;

  /// Decoración cuando el campo está deshabilitado o es readOnly.
  final BoxDecoration disabled;

  /// Color del texto y de los widgets [MinInput.leading]/[MinInput.trailing].
  ///
  /// Si es `null`, se usa [MinThemeColors.foreground] del tema.
  final Color? foregroundColor;

  /// Color del texto cuando el campo está deshabilitado.
  ///
  /// Si es `null`, se usa [MinThemeColors.mutedForeground] del tema.
  final Color? disabledForegroundColor;

  /// Color del texto placeholder.
  ///
  /// Si es `null`, se usa [MinThemeColors.mutedForeground] del tema.
  final Color? placeholderColor;

  /// Padding interno del campo para este estilo.
  ///
  /// Sobreescribe [MinInput.contentPadding] cuando se especifica.
  /// Útil para variantes como [underline] que no necesitan padding horizontal.
  final EdgeInsets? contentPadding;

  // -------------------------------------------------------------------------
  // Variantes predefinidas
  // -------------------------------------------------------------------------

  /// Variante por defecto. Borde sutil en reposo, ring animado al enfocar.
  ///
  /// Replica el estilo `<Input>` de shadcn/ui.
  static MinInputStyle outline(MinThemeData theme) {
    final colors = theme.colors;
    return MinInputStyle(
      idle: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(theme.radius.md),
        border: Border.all(color: colors.border),
      ),
      focused: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(theme.radius.md),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.ring.withAlpha(50),
            blurRadius: 0,
            spreadRadius: 3,
          ),
        ],
      ),
      error: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(theme.radius.md),
        border: Border.all(color: colors.destructive),
        boxShadow: [
          BoxShadow(
            color: colors.destructive.withAlpha(30),
            blurRadius: 0,
            spreadRadius: 3,
          ),
        ],
      ),
      disabled: BoxDecoration(
        color: colors.muted,
        borderRadius: BorderRadius.circular(theme.radius.md),
        border: Border.all(color: colors.input),
      ),
    );
  }

  /// Fondo sólido con borde invisible en reposo. Al enfocar aparece el borde
  /// y el ring. Útil para formularios con mucho contraste.
  static MinInputStyle filled(MinThemeData theme) {
    final colors = theme.colors;
    return MinInputStyle(
      idle: BoxDecoration(
        color: colors.muted,
        borderRadius: BorderRadius.circular(theme.radius.md),
        border: Border.all(color: colors.muted),
      ),
      focused: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(theme.radius.md),
        border: Border.all(color: colors.ring),
        boxShadow: [
          BoxShadow(
            color: colors.ring.withAlpha(50),
            blurRadius: 0,
            spreadRadius: 3,
          ),
        ],
      ),
      error: BoxDecoration(
        color: colors.destructive.withAlpha(12),
        borderRadius: BorderRadius.circular(theme.radius.md),
        border: Border.all(color: colors.destructive),
        boxShadow: [
          BoxShadow(
            color: colors.destructive.withAlpha(30),
            blurRadius: 0,
            spreadRadius: 3,
          ),
        ],
      ),
      disabled: BoxDecoration(
        color: colors.muted,
        borderRadius: BorderRadius.circular(theme.radius.md),
        border: Border.all(color: colors.muted),
      ),
      foregroundColor: colors.foreground,
      disabledForegroundColor: colors.mutedForeground,
    );
  }

  /// Sin fondo ni borde visible en reposo. Solo el texto y el cursor.
  /// Al enfocar aparece un borde inferior sutil. Ideal para barras de búsqueda
  /// o campos integrados en superficies con diseño propio.
  static MinInputStyle ghost(MinThemeData theme) {
    final colors = theme.colors;
    return MinInputStyle(
      idle: const BoxDecoration(
        color: Color(0x00000000), // transparente
      ),
      focused: BoxDecoration(
        color: colors.border,
        borderRadius: BorderRadius.circular(theme.radius.md),
      ),
      error: BoxDecoration(
        color: colors.destructive.withAlpha(12),
        borderRadius: BorderRadius.circular(theme.radius.md),
      ),
      disabled: const BoxDecoration(color: Color(0x00000000)),
      placeholderColor: colors.mutedForeground,
    );
  }

  /// Solo un borde inferior. Sin fondo ni bordes laterales/superior.
  ///
  /// El padding horizontal se elimina para que el texto arranque al filo.
  /// Al enfocar, el borde inferior se engruesa y aparece un degradado sutil
  /// como ring. Evoca los inputs de Material Design clásico.
  static MinInputStyle underline(MinThemeData theme) {
    final colors = theme.colors;

    Border bottom(Color color, {double width = 1}) => Border(
      bottom: BorderSide(color: color, width: width),
    );

    return MinInputStyle(
      idle: BoxDecoration(border: bottom(colors.border)),
      focused: BoxDecoration(border: bottom(colors.ring, width: 2)),
      error: BoxDecoration(border: bottom(colors.destructive, width: 2)),
      disabled: BoxDecoration(border: bottom(colors.input)),
      // Sin padding horizontal: el texto arranca al filo del borde.
      // Se conserva el padding vertical para mantener la altura táctil mínima.
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      disabledForegroundColor: colors.mutedForeground,
    );
  }
}

// ---------------------------------------------------------------------------
// Widget principal
// ---------------------------------------------------------------------------

/// Campo de entrada de texto personalizado del sistema de diseño Min.
///
/// Admite distintos tipos semánticos ([MinInputType]), variantes de error
/// ([MinInputVariant]), íconos/widgets laterales, altura fija o dinámica,
/// un mensaje de error debajo del campo y **estilos visuales intercambiables**
/// mediante [MinInputStyle].
///
/// ### Variantes de estilo predefinidas
/// ```dart
/// MinInput(style: MinInputStyle.outline(context.theme))  // defecto
/// MinInput(style: MinInputStyle.filled(context.theme))
/// MinInput(style: MinInputStyle.ghost(context.theme))
/// MinInput(style: MinInputStyle.underline(context.theme))
/// ```
///
/// ### Estilo completamente personalizado
/// ```dart
/// MinInput(
///   style: MinInputStyle(
///     idle: BoxDecoration(color: Colors.blue.shade50, ...),
///     focused: BoxDecoration(...),
///     error: BoxDecoration(...),
///     disabled: BoxDecoration(...),
///   ),
/// )
/// ```
///
/// ### Ejemplo básico
/// ```dart
/// MinInput(
///   placeholder: 'Correo electrónico',
///   type: MinInputType.email,
///   onChanged: (value) => print(value),
/// )
/// ```
class MinInput extends StatefulWidget {
  const MinInput({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.leading,
    this.trailing,
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.type = MinInputType.text,
    this.variant = MinInputVariant.normal,
    this.style,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.obscureText,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.inputFormatters,
    this.autocorrect,
    this.enableSuggestions = true,
    this.height,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ),
    this.showCounter = false,
    this.semanticLabel,
  }) : // La altura fija, si se especifica, debe ser positiva.
       assert(height == null || height > 0, 'height debe ser > 0'),

       // maxLines debe ser positivo si se especifica.
       assert(maxLines == null || maxLines > 0, 'maxLines debe ser > 0'),

       // minLines debe ser positivo si se especifica.
       assert(minLines == null || minLines > 0, 'minLines debe ser > 0'),

       // minLines no puede superar a maxLines cuando ambos se especifican.
       assert(
         minLines == null || maxLines == null || minLines <= maxLines,
         'minLines ($minLines) no puede ser mayor que maxLines ($maxLines)',
       ),

       // maxLength, si se especifica, debe ser al menos 1.
       assert(maxLength == null || maxLength > 0, 'maxLength debe ser > 0'),

       // Un campo multiline no debería tener maxLines = 1 explícitamente,
       // ya que eso contradice la semántica del tipo.
       assert(
         !(type == MinInputType.multiline && maxLines == 1),
         'Un campo de tipo multiline no puede tener maxLines = 1',
       ),

       // Un campo de contraseña no debería ser multiline.
       assert(
         !(type == MinInputType.password && maxLines != null && maxLines > 1),
         'Un campo de tipo password no puede tener maxLines > 1',
       );

  // -------------------------------------------------------------------------
  // Controladores externos (opcionales)
  // -------------------------------------------------------------------------

  /// Controlador del texto. Si es `null` se crea uno interno.
  ///
  /// Si se proporciona un controlador externo, el llamador es responsable
  /// de hacer `dispose()` sobre él.
  final TextEditingController? controller;

  /// Nodo de foco. Si es `null` se crea uno interno.
  ///
  /// Igual que con [controller], el llamador debe liberar el nodo externo.
  final FocusNode? focusNode;

  // -------------------------------------------------------------------------
  // Contenido
  // -------------------------------------------------------------------------

  /// Texto de marcador de posición que se muestra cuando el campo está vacío.
  final String? placeholder;

  /// Widget que se ubica al inicio (izquierda) del campo, **dentro** del borde.
  ///
  /// Típicamente un [Icon] o un prefijo de texto. El color del icono se hereda
  /// automáticamente del estado del campo (deshabilitado, foco, error).
  ///
  /// Ejemplo: ícono de búsqueda, prefijo de moneda, etc.
  final Widget? leading;

  /// Widget que se ubica al final (derecha) del campo, **dentro** del borde.
  ///
  /// Se renderiza dentro del mismo contenedor decorado que el texto, por lo que
  /// comparte el fondo y respeta el borde del campo.
  ///
  /// Útil para botones de acción como "mostrar/ocultar contraseña", "limpiar"
  /// o indicadores de estado. El color del icono se hereda del estado del campo.
  ///
  /// Ejemplo:
  /// ```dart
  /// trailing: GestureDetector(
  ///   onTap: () => setState(() => _obscure = !_obscure),
  ///   child: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
  /// )
  /// ```
  final Widget? trailing;

  /// Mensaje de error que aparece debajo del campo cuando hay un problema.
  ///
  /// Automáticamente activa el estilo visual de error (borde y cursor rojos)
  /// sin necesidad de cambiar [variant] a [MinInputVariant.error].
  final String? errorText;

  // -------------------------------------------------------------------------
  // Estado del campo
  // -------------------------------------------------------------------------

  /// Si `false`, el campo queda visualmente atenuado y no acepta entrada.
  final bool enabled;

  /// Si `true`, el campo muestra el texto pero no permite editarlo.
  ///
  /// A diferencia de [enabled], el campo conserva su apariencia normal
  /// y puede recibir foco para copiar texto.
  final bool readOnly;

  /// Si `true`, el campo solicita el foco automáticamente al insertarse.
  final bool autofocus;

  // -------------------------------------------------------------------------
  // Tipo y variante
  // -------------------------------------------------------------------------

  /// Tipo semántico que configura teclado, acción y comportamiento por defecto.
  final MinInputType type;

  /// Variante visual. Use [MinInputVariant.error] para forzar el estado
  /// de error sin necesidad de un [errorText].
  final MinInputVariant variant;

  /// Estilo visual del campo. Controla la [BoxDecoration] de cada estado
  /// (reposo, foco, error, deshabilitado).
  ///
  /// Si es `null`, se usa [MinInputStyle.outline] con el tema actual.
  ///
  /// Usa las variantes predefinidas o construye un [MinInputStyle] propio:
  /// ```dart
  /// style: MinInputStyle.filled(context.theme)
  /// style: MinInputStyle.ghost(context.theme)
  /// style: MinInputStyle.underline(context.theme)
  /// ```
  final MinInputStyle? style;

  // -------------------------------------------------------------------------
  // Configuración del teclado
  // -------------------------------------------------------------------------

  /// Tipo de teclado. Sobreescribe el valor derivado de [type] si se especifica.
  final TextInputType? keyboardType;

  /// Acción del botón de acción del teclado. Sobreescribe el valor de [type].
  final TextInputAction? textInputAction;

  /// Capitalización automática del texto introducido.
  final TextCapitalization textCapitalization;

  // -------------------------------------------------------------------------
  // Restricciones de líneas y longitud
  // -------------------------------------------------------------------------

  /// Número máximo de líneas visibles.
  ///
  /// - `null` con [type] = [MinInputType.multiline]: crece sin límite.
  /// - `1` (defecto para tipos no multiline): campo de una sola línea.
  final int? maxLines;

  /// Número mínimo de líneas visibles (solo relevante en multilínea).
  final int? minLines;

  /// Longitud máxima de caracteres permitida.
  ///
  /// No muestra contador; solo restringe la entrada. Si se necesita
  /// un contador visible, combinar con un widget externo.
  final int? maxLength;

  // -------------------------------------------------------------------------
  // Comportamiento del texto
  // -------------------------------------------------------------------------

  /// Si `true`, oculta el texto (modo contraseña).
  ///
  /// Sobreescribe el valor derivado de [type]. Útil para implementar
  /// un botón "mostrar/ocultar contraseña" en [trailing].
  final bool? obscureText;

  // -------------------------------------------------------------------------
  // Callbacks
  // -------------------------------------------------------------------------

  /// Llamado cada vez que el texto cambia.
  final ValueChanged<String>? onChanged;

  /// Llamado cuando el usuario presiona la acción del teclado (e.g. "done").
  final ValueChanged<String>? onSubmitted;

  /// Llamado cuando la edición finaliza (antes de [onSubmitted]).
  ///
  /// Útil para sincronizar el estado sin depender del valor del texto.
  final VoidCallback? onEditingComplete;

  /// Formateadores que procesan la entrada antes de que se aplique al texto.
  ///
  /// Ejemplos: [FilteringTextInputFormatter], [LengthLimitingTextInputFormatter].
  final List<TextInputFormatter>? inputFormatters;

  // -------------------------------------------------------------------------
  // Autocorrección y sugerencias
  // -------------------------------------------------------------------------

  /// Si `null`, usa el valor por defecto de Flutter (`true` en texto, `false`
  /// en contraseña/email). Sobreescribir para control explícito.
  final bool? autocorrect;

  /// Habilita las sugerencias de palabras del teclado.
  ///
  /// Se recomienda desactivar en campos sensibles (contraseñas, códigos).
  final bool enableSuggestions;

  // -------------------------------------------------------------------------
  // Dimensiones y espaciado
  // -------------------------------------------------------------------------

  /// Altura fija del área de entrada (en píxeles lógicos).
  ///
  /// - `null` (defecto): la altura se adapta dinámicamente a [minLines]/[maxLines].
  /// - Valor positivo: fuerza una altura constante independiente del contenido.
  ///
  /// Útil para alinear campos en formularios o en barras de búsqueda.
  final double? height;

  /// Espaciado interno entre el borde y el contenido editable.
  ///
  /// También influye en el cálculo de altura dinámica cuando [height] es `null`.
  final EdgeInsets contentPadding;

  /// Si es `true` y se especifica [maxLength], muestra un contador
  /// de caracteres debajo del campo, alineado a la derecha.
  /// No tapa el texto escrito.
  final bool showCounter;

  /// Etiqueta de accesibilidad del campo.
  ///
  /// Describe el propósito del campo para lectores de pantalla
  /// (e.g. "Correo electrónico", "Contraseña").
  final String? semanticLabel;

  @override
  State<MinInput> createState() => _MinInputState();
}

// ---------------------------------------------------------------------------
// Estado interno
// ---------------------------------------------------------------------------

class _MinInputState extends State<MinInput> {
  // Controlador y nodo de foco propios (creados solo cuando el widget
  // no recibe uno externo).
  TextEditingController? _ownedController;
  FocusNode? _ownedFocusNode;

  /// Clave global del [EditableText] para poder invocar [requestKeyboard].
  final GlobalKey<EditableTextState> _editableKey =
      GlobalKey<EditableTextState>();

  /// Posición del último PointerDown sobre el campo.
  ///
  /// Se usa para calcular el desplazamiento entre down y up y distinguir
  /// un tap de un scroll. Se limpia en up y en cancel.
  Offset? _pointerDownPosition;

  // -------------------------------------------------------------------------
  // Accesores con lazy-init
  // -------------------------------------------------------------------------

  /// Devuelve el controlador externo o crea/reutiliza el propio.
  TextEditingController get _controller =>
      widget.controller ?? (_ownedController ??= TextEditingController());

  /// Devuelve el nodo de foco externo o crea/reutiliza el propio.
  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownedFocusNode ??= FocusNode());

  // -------------------------------------------------------------------------
  // Helpers de configuración
  // -------------------------------------------------------------------------

  /// `true` cuando el campo se comporta como una sola línea.
  bool get _isSingleLine => _resolvedMaxLines == 1;

  /// Resuelve el número máximo de líneas según el tipo del campo.
  ///
  /// - Para [MinInputType.multiline] sin [maxLines] explícito → `null` (ilimitado).
  /// - Para el resto sin [maxLines] explícito → `1`.
  int? get _resolvedMaxLines {
    if (widget.maxLines != null) return widget.maxLines;
    return widget.type == MinInputType.multiline ? null : 1;
  }

  /// Resuelve el número mínimo de líneas.
  ///
  /// Siempre al menos `1` para evitar un campo de altura cero.
  int get _resolvedMinLines => widget.minLines ?? 1;

  /// Altura de una línea de texto en píxeles lógicos.
  ///
  /// Se usa únicamente para calcular el `minHeight` del campo de una sola
  /// línea (garantizar al menos 40 px de área táctil). Para multilínea,
  /// [EditableText] controla la altura directamente via [maxLines]/[minLines]
  /// sin que nosotros impongamos un [BoxConstraints.maxHeight].
  double get _lineHeightPx => 16 * 1.5; // fontSize × lineHeight

  /// Calcula la altura mínima para [lines] líneas más el padding vertical.
  double _heightForLines(int lines) =>
      widget.contentPadding.vertical + (_lineHeightPx * lines);

  /// Resuelve las restricciones de tamaño del contenedor exterior del campo.
  ///
  /// Estrategia:
  /// - Altura fija ([widget.height] no nulo) → [BoxConstraints.tight].
  /// - Una sola línea → solo `minHeight` de 40 px (área táctil mínima).
  /// - Multilínea sin límite ([maxLines] = null) → solo `minHeight` según
  ///   [minLines]; el campo crece libremente con el contenido.
  /// - Multilínea con [maxLines] explícito → solo `minHeight`; [EditableText]
  ///   se encarga de detener el crecimiento en [maxLines] líneas sin que
  ///   nosotros calculemos un `maxHeight` aproximado que puede no coincidir
  ///   con la métrica real de la fuente.
  BoxConstraints? get _resolvedFieldConstraints {
    if (widget.height != null) {
      return BoxConstraints.tight(Size.fromHeight(widget.height!));
    }

    // Para campos de una línea garantizamos al menos 40 px de área táctil.
    if (_isSingleLine) {
      return const BoxConstraints(minHeight: 40);
    }

    // Para multilínea (con o sin maxLines) dejamos que EditableText controle
    // la altura máxima; solo imponemos la mínima según minLines.
    final computedMin = _heightForLines(_resolvedMinLines);
    final effectiveMinHeight = computedMin < 40.0 ? 40.0 : computedMin;
    return BoxConstraints(minHeight: effectiveMinHeight);
  }

  /// Resuelve si el texto debe mostrarse oculto.
  ///
  /// [widget.obscureText] tiene prioridad; si no se especifica, solo el
  /// tipo [MinInputType.password] activa el modo oculto.
  bool get _resolvedObscureText =>
      widget.obscureText ?? (widget.type == MinInputType.password);

  /// Resuelve el tipo de teclado según el tipo semántico del campo.
  ///
  /// [widget.keyboardType] tiene prioridad sobre la deducción automática.
  TextInputType get _resolvedKeyboardType {
    if (widget.keyboardType != null) return widget.keyboardType!;

    return switch (widget.type) {
      MinInputType.email => TextInputType.emailAddress,
      MinInputType.password => TextInputType.visiblePassword,
      MinInputType.number => const TextInputType.numberWithOptions(
        decimal: true,
        signed: false,
      ),
      MinInputType.phone => TextInputType.phone,
      MinInputType.url => TextInputType.url,
      MinInputType.multiline => TextInputType.multiline,
      MinInputType.text => TextInputType.text,
    };
  }

  /// Resuelve la acción del botón principal del teclado.
  ///
  /// [widget.textInputAction] tiene prioridad. Por defecto:
  /// - [MinInputType.multiline] → [TextInputAction.newline]
  /// - Resto → [TextInputAction.done]
  TextInputAction get _resolvedAction {
    if (widget.textInputAction != null) return widget.textInputAction!;
    return widget.type == MinInputType.multiline
        ? TextInputAction.newline
        : TextInputAction.done;
  }

  /// Resuelve si la autocorrección debe estar activa.
  ///
  /// Si [widget.autocorrect] es `null`:
  /// - Desactivada para contraseñas y email (comportamiento esperado por el usuario).
  /// - Activada para el resto.
  bool get _resolvedAutocorrect {
    if (widget.autocorrect != null) return widget.autocorrect!;
    return widget.type != MinInputType.password &&
        widget.type != MinInputType.email;
  }

  /// Resuelve si las sugerencias de teclado deben activarse.
  ///
  /// Para contraseñas siempre se desactivan, independientemente de
  /// [widget.enableSuggestions], por razones de seguridad.
  bool get _resolvedEnableSuggestions {
    if (widget.type == MinInputType.password) return false;
    return widget.enableSuggestions;
  }

  // -------------------------------------------------------------------------
  // Ciclo de vida
  // -------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    // Suscribirse a los cambios del controlador y del foco para
    // forzar un rebuild que actualice colores y placeholder.
    _controller.addListener(_handleControllerChanged);
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant MinInput oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Si el controlador externo cambió, migrar los listeners al nuevo.
    if (oldWidget.controller != widget.controller) {
      final oldController = oldWidget.controller ?? _ownedController;
      oldController?.removeListener(_handleControllerChanged);
      _controller.addListener(_handleControllerChanged);
    }

    // Si el nodo de foco externo cambió, migrar los listeners al nuevo.
    if (oldWidget.focusNode != widget.focusNode) {
      final oldFocusNode = oldWidget.focusNode ?? _ownedFocusNode;
      oldFocusNode?.removeListener(_handleFocusChanged);
      _focusNode.addListener(_handleFocusChanged);
    }
  }

  @override
  void dispose() {
    // Quitar siempre los listeners antes de liberar recursos para evitar
    // llamadas a setState después del dispose.
    _controller.removeListener(_handleControllerChanged);
    _focusNode.removeListener(_handleFocusChanged);

    // Solo liberar los recursos que este widget creó; nunca los externos.
    _ownedController?.dispose();
    _ownedFocusNode?.dispose();

    super.dispose();
  }

  // -------------------------------------------------------------------------
  // Listeners
  // -------------------------------------------------------------------------

  /// Callback del controlador de texto: fuerza rebuild para sincronizar
  /// la visibilidad del placeholder.
  void _handleControllerChanged() {
    if (mounted) setState(() {});
  }

  /// Callback del nodo de foco: fuerza rebuild para actualizar colores
  /// de borde, fondo y sombra.
  void _handleFocusChanged() {
    if (mounted) setState(() {});
  }

  // -------------------------------------------------------------------------
  // Interacción
  // -------------------------------------------------------------------------

  /// Maneja el tap sobre el área del campo.
  ///
  /// - Si el campo está deshabilitado o es readOnly, no hace nada.
  /// - Si el campo no tiene foco, lo solicita (requestFocus ya abre el teclado).
  /// - Si ya tiene foco, llama [requestKeyboard] directamente para reabrirlo
  ///   en caso de que el usuario lo haya ocultado manualmente. No se consulta
  ///   [viewInsets.bottom] porque puede estar desfasado un frame durante la
  ///   animación de cierre del teclado, causando que la condición falle.
  void _handleFieldTap() {
    if (!widget.enabled || widget.readOnly) return;

    if (!_focusNode.hasFocus) {
      // Sin foco: pedirlo. requestFocus() abre el teclado automáticamente
      // en la mayoría de plataformas.
      _focusNode.requestFocus();
    } else {
      // Ya tiene foco: el teclado puede haber sido ocultado manualmente.
      // requestKeyboard() lo reabre sin importar el estado de viewInsets.
      _editableKey.currentState?.requestKeyboard();
    }
  }

  /// Maneja el tap fuera del campo para quitar el foco.
  ///
  /// Gracias a [TapRegion] con [_tapRegionGroupId], este callback solo se
  /// invoca cuando el tap ocurre **fuera** del área total del campo (borde,
  /// padding, leading y trailing incluidos). Los taps sobre el trailing o el
  /// padding interno nunca llegan aquí.
  ///
  /// Se usa [FocusScope.of(context).unfocus()] en lugar de
  /// [FocusNode.unfocus()] para respetar la política de foco del árbol y
  /// evitar saltos inesperados entre campos.
  void _handleTapOutside(PointerDownEvent _) {
    if (_focusNode.hasFocus) {
      FocusScope.of(context).unfocus();
    }
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    // El campo muestra error si la variante es error O si hay un errorText.
    final hasError =
        widget.variant == MinInputVariant.error ||
        (widget.errorText?.isNotEmpty ?? false);

    final isFocused = _focusNode.hasFocus;

    // Un campo readOnly también se considera "deshabilitado" visualmente
    // en cuanto a colores de borde y fondo.
    final isDisabled = !widget.enabled || widget.readOnly;

    // -----------------------------------------------------------------------
    // Resolución del estilo
    // -----------------------------------------------------------------------

    // Si el usuario no pasó un style, se usa outline como defecto.
    final inputStyle = widget.style ?? MinInputStyle.outline(theme);

    // Seleccionar la decoración correcta según el estado del campo.
    // El orden de prioridad es: disabled > error > focused > idle.
    final BoxDecoration decoration;
    if (isDisabled) {
      decoration = inputStyle.disabled;
    } else if (hasError) {
      decoration = inputStyle.error;
    } else if (isFocused) {
      decoration = inputStyle.focused;
    } else {
      decoration = inputStyle.idle;
    }

    // Color del texto e iconos: usa el del style si se proporcionó,
    // si no cae al token del tema según el estado del campo.
    final foregroundColor = isDisabled
        ? (inputStyle.disabledForegroundColor ?? theme.colors.mutedForeground)
        : (inputStyle.foregroundColor ?? theme.colors.foreground);

    // Color del placeholder: usa el del style si se proporcionó.
    final placeholderColor =
        inputStyle.placeholderColor ?? theme.colors.mutedForeground;

    // Color del cursor y la selección: se derivan del borde de la decoración
    // activa (focused/error) para mantener coherencia visual con el estilo
    // personalizado. Si el borde no tiene color definido, se usa el token ring.
    final activeBorderColor = hasError
        ? (inputStyle.error.border as Border?)?.bottom.color ??
              theme.colors.destructive
        : (inputStyle.focused.border as Border?)?.bottom.color ??
              theme.colors.ring;

    // Padding efectivo: el del style tiene prioridad sobre el del widget,
    // permitiendo que variantes como underline eliminen el padding horizontal.
    final effectivePadding = inputStyle.contentPadding ?? widget.contentPadding;

    // -----------------------------------------------------------------------
    // Texto editable
    // -----------------------------------------------------------------------

    /// [EditableText] es el núcleo del campo; GestureDetector y Container
    /// envuelven solo el aspecto visual y la interacción de tap.
    final editable = EditableText(
      key: _editableKey,
      controller: _controller,
      focusNode: _focusNode,
      keyboardType: _resolvedKeyboardType,
      textInputAction: _resolvedAction,
      textCapitalization: widget.textCapitalization,
      maxLines: _resolvedMaxLines,
      minLines: _resolvedMinLines,
      readOnly: widget.readOnly || !widget.enabled,
      autofocus: widget.autofocus,
      obscureText: _resolvedObscureText,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onEditingComplete: widget.onEditingComplete,
      inputFormatters: [
        if (widget.maxLength != null)
          LengthLimitingTextInputFormatter(widget.maxLength),
        ...?widget.inputFormatters,
      ],
      autocorrect: _resolvedAutocorrect,
      enableSuggestions: _resolvedEnableSuggestions,
      style: theme.typography.body.copyWith(
        color: foregroundColor,
        height: 1.5,
      ),
      cursorColor: activeBorderColor,
      backgroundCursorColor: theme.colors.mutedForeground,
      //selectionColor: cursorColor.withValues(alpha: 0.25),
      onTapOutside: _handleTapOutside,
    );

    // -----------------------------------------------------------------------
    // Área del campo: placeholder + editable apilados
    // -----------------------------------------------------------------------

    // El placeholder se superpone al editable usando un [Stack].
    // Se oculta con [IgnorePointer] para no interferir con los gestos.
    //
    // [TextFieldTapRegion] usa groupId = EditableText (el mismo que usa
    // internamente [EditableText]), por lo que cualquier tap dentro de
    // cualquier [TextFieldTapRegion] del árbol se considera "interior".
    // Esto evita que trailing, leading y padding disparen [onTapOutside].
    Widget field = Stack(
      alignment: _isSingleLine ? Alignment.centerLeft : Alignment.topLeft,
      children: [
        TextFieldTapRegion(child: editable),
        if (_controller.text.isEmpty && widget.placeholder != null)
          IgnorePointer(
            child: Text(
              widget.placeholder!,
              style: theme.typography.body.copyWith(
                color: placeholderColor,
                height: 1.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );

    // -----------------------------------------------------------------------
    // Contenedor con borde y decoración
    // -----------------------------------------------------------------------

    Widget inputArea = TextFieldTapRegion(
      // Se usa un par Listener onPointerDown/onPointerUp en lugar de
      // GestureDetector.onTap (que el EditableText consume) o Listener.onPointerDown
      // (que se dispara también al iniciar un scroll).
      //
      // La lógica: guardar la posición del down y en el up verificar que el
      // desplazamiento sea menor a un umbral (10px). Si es mayor, el usuario
      // estaba haciendo scroll y no se toca el foco/teclado.
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (event) {
          _pointerDownPosition = event.position;
        },
        onPointerUp: (event) {
          final down = _pointerDownPosition;
          if (down == null) return;
          final delta = (event.position - down).distance;
          _pointerDownPosition = null;
          // Umbral de 10px: por debajo es tap, por encima es scroll/drag.
          if (delta < 10) _handleFieldTap();
        },
        onPointerCancel: (_) {
          // El gesto fue cancelado (scroll ganó la arena): limpiar sin actuar.
          _pointerDownPosition = null;
        },
        child: Container(
          constraints: _resolvedFieldConstraints,
          // TweenAnimationBuilder anima la decoración (borde, fondo, sombra).
          // El padding va DENTRO del DecoratedBox para que el borde se pinte
          // por fuera del contenido y no quede solapado por el padding.
          child: TweenAnimationBuilder<Decoration>(
            tween: DecorationTween(end: decoration),
            duration: theme.motion.fast,
            curve: theme.motion.curve,
            builder: (context, animatedDecoration, child) => DecoratedBox(
              decoration: animatedDecoration,
              // Padding aplicado después de la decoración → borde siempre externo.
              child: Padding(padding: effectivePadding, child: child),
            ),
            child: Row(
              // En campo de una línea: centrar verticalmente.
              // En multilínea: alinear al tope para que el texto fluya hacia abajo.
              crossAxisAlignment: _isSingleLine
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                // ---------------------------------------------------------------
                // Leading (izquierda, dentro del borde)
                // ---------------------------------------------------------------
                if (widget.leading != null) ...[
                  // Propaga el color de estado del campo al ícono/widget del leading.
                  IconTheme(
                    data: IconThemeData(color: foregroundColor, size: 16),
                    child: widget.leading!,
                  ),
                  const SizedBox(width: 8),
                ],

                // ---------------------------------------------------------------
                // Área de texto (ocupa todo el espacio disponible)
                // ---------------------------------------------------------------
                Expanded(child: field),

                // ---------------------------------------------------------------
                // Trailing (derecha, dentro del borde)
                // ---------------------------------------------------------------
                // Al estar dentro del TextFieldTapRegion y del contenedor decorado,
                // el trailing comparte región de tap con el EditableText. Un tap
                // sobre el trailing NO cierra el teclado.
                if (widget.trailing != null) ...[
                  const SizedBox(width: 8),
                  // Propaga el color de estado del campo al ícono/widget del trailing.
                  IconTheme(
                    data: IconThemeData(color: foregroundColor, size: 16),
                    child: widget.trailing!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    // inputArea ya contiene leading + texto + trailing dentro del borde,
    // por lo que se devuelve directamente como content sin Row extra.
    Widget content = inputArea;

    // -----------------------------------------------------------------------
    // Contador de caracteres (opcional)
    // -----------------------------------------------------------------------

    final showCounterWidget = widget.showCounter &&
        widget.maxLength != null &&
        widget.maxLength! > 0;

    if (showCounterWidget) {
      final currentLength = _controller.text.length;
      final maxLength = widget.maxLength!;
      final counterColor = currentLength >= maxLength
          ? theme.colors.destructive
          : theme.colors.mutedForeground;

      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          content,
          SizedBox(height: theme.spacing.s1),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$currentLength / $maxLength',
              style: theme.typography.small.copyWith(color: counterColor),
            ),
          ),
        ],
      );
    }

    // -----------------------------------------------------------------------
    // Mensaje de error (opcional)
    // -----------------------------------------------------------------------

    if (hasError) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          content,
          if (widget.errorText?.isNotEmpty ?? false) ...[
            const SizedBox(height: 4),
            Text(
              widget.errorText!,
              style: theme.typography.small.copyWith(
                color: theme.colors.destructive,
              ),
            ),
          ],
        ],
      );
    }

    // -----------------------------------------------------------------------
    // Semantics wrapper (accessibility)
    // -----------------------------------------------------------------------

    return Semantics(
      label: widget.semanticLabel,
      enabled: widget.enabled,
      textField: true,
      child: content,
    );
  }
}
